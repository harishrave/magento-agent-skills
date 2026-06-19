# REST, GraphQL, and Service Contracts

Headless and integration surfaces must go through `Api/` interfaces — never expose `Model` or
`ResourceModel` classes directly. Design the contract first, bind implementations in `di.xml`,
then add `webapi.xml` and/or `schema.graphqls`.

## Data + repository interfaces

```php
// Api/Data/LocationInterface.php
namespace RaveDigital\StoreLocator\Api\Data;

interface LocationInterface
{
    public const NAME = 'name';
    public const STORE_CODE = 'store_code';
    public const HOURS_JSON = 'hours_json';
    public const LATITUDE = 'latitude';
    public const LONGITUDE = 'longitude';
    public const STATUS = 'status';

    public function getLocationId(): ?int;
    public function getName(): string;
    public function setName(string $name): self;
    public function getStoreCode(): string;
    public function setStoreCode(string $code): self;
    public function getHoursJson(): ?string;
    public function setHoursJson(?string $json): self;
    public function getLatitude(): ?float;
    public function setLatitude(?float $latitude): self;
    public function getLongitude(): ?float;
    public function setLongitude(?float $longitude): self;
}
```

```php
// Api/LocationRepositoryInterface.php
namespace RaveDigital\StoreLocator\Api;

use RaveDigital\StoreLocator\Api\Data\LocationInterface;
use Magento\Framework\Api\SearchCriteriaInterface;
use RaveDigital\StoreLocator\Api\Data\LocationSearchResultsInterface;

interface LocationRepositoryInterface
{
    public function get(int $locationId): LocationInterface;
    public function save(LocationInterface $location): LocationInterface;
    public function deleteById(int $locationId): bool;
    public function getList(SearchCriteriaInterface $criteria): LocationSearchResultsInterface;
}
```

```xml
<preference for="RaveDigital\StoreLocator\Api\LocationRepositoryInterface"
            type="RaveDigital\StoreLocator\Model\LocationRepository"/>
<preference for="RaveDigital\StoreLocator\Api\Data\LocationInterface"
            type="RaveDigital\StoreLocator\Model\Data\StoreLocation"/>
<preference for="RaveDigital\StoreLocator\Api\Data\LocationSearchResultsInterface"
            type="Magento\Framework\Api\SearchResults"/>
```

DocBlock every parameter and return on interface methods — REST serialization reads them.
Native PHP return types on interface methods are encouraged **except** on `SearchResults::getItems()`.

## SearchResults trap

`Magento\Framework\Api\SearchResults::getItems()` has **no** PHP return type. Do not add
`: array` on your extension — PHP fatals with incompatible declaration errors.

```php
interface LocationSearchResultsInterface extends \Magento\Framework\Api\SearchResultsInterface
{
    /**
     * @return \RaveDigital\StoreLocator\Api\Data\LocationInterface[]
     */
    public function getItems();

    /**
     * @param \RaveDigital\StoreLocator\Api\Data\LocationInterface[] $items
     * @return $this
     */
    public function setItems(array $items);
}
```

`getList()` implementation pattern:

```php
public function getList(SearchCriteriaInterface $criteria): LocationSearchResultsInterface
{
    $collection = $this->collectionFactory->create();
    $this->collectionProcessor->process($criteria, $collection);

    $results = $this->searchResultsFactory->create();
    $results->setSearchCriteria($criteria);
    $results->setItems($collection->getItems());
    $results->setTotalCount($collection->getSize());
    return $results;
}
```

Inject `Magento\Framework\Api\SearchCriteria\CollectionProcessorInterface` (watch the namespace).

## REST — webapi.xml

```xml
<route url="/V1/ravedigital-store-locations/:locationId" method="GET">
    <service class="RaveDigital\StoreLocator\Api\LocationRepositoryInterface" method="get"/>
    <resources>
        <resource ref="RaveDigital_StoreLocator::locations"/>
    </resources>
</route>
<route url="/V1/ravedigital-store-locations" method="POST">
    <service class="RaveDigital\StoreLocator\Api\LocationRepositoryInterface" method="save"/>
    <resources>
        <resource ref="RaveDigital_StoreLocator::locations"/>
    </resources>
</route>
<route url="/V1/ravedigital-store-locations/mine" method="GET">
    <service class="RaveDigital\StoreLocator\Api\LocationRepositoryInterface" method="getListForCustomer"/>
    <resources>
        <resource ref="self"/>
    </resources>
</route>
```

Notes:

- `<resources>` is mandatory — `anonymous`, `self`, or an admin ACL id.
- URL placeholders must match method parameter names (`:locationId` → `$locationId`).
- No custom controllers or manual `json_encode` for standard CRUD — the framework maps types.
- Auth: integration tokens, admin tokens, or customer tokens — you declare access, not implement it.

## GraphQL

Separate from REST — define `etc/schema.graphqls` + resolver classes.

```graphql
type Query {
    storeLocation(locationId: Int!): StoreLocation
        @resolver(class: "RaveDigital\\StoreLocator\\Model\\Resolver\\Location")
        @doc(description: "Load a store location")
}

type StoreLocation {
    location_id: Int
    store_code: String
    hours_json: String
    latitude: Float
    longitude: Float
    status: String
}

type Mutation {
    assignStoreLocation(input: AssignLocationInput!): AssignLocationOutput
        @resolver(class: "RaveDigital\\StoreLocator\\Model\\Resolver\\AssignLocation")
}
```

```php
namespace RaveDigital\StoreLocator\Model\Resolver;

use Magento\Framework\GraphQl\Exception\GraphQlInputException;
use Magento\Framework\GraphQl\Query\ResolverInterface;

class Location implements ResolverInterface
{
    public function __construct(
        private readonly \RaveDigital\StoreLocator\Api\LocationRepositoryInterface $repository
    ) {}

    public function resolve($field, $context, $info, ?array $value = null, ?array $args = null)
    {
        if (empty($args['locationId'])) {
            throw new GraphQlInputException(__('locationId is required'));
        }
        $dto = $this->repository->get((int) $args['locationId']);
        return [
            'location_id' => $dto->getLocationId(),
            'store_code' => $dto->getStoreCode(),
            'hours_json' => $dto->getHoursJson(),
            'latitude' => $dto->getLatitude(),
            'longitude' => $dto->getLongitude(),
            'status' => $dto->getStatus(),
        ];
    }
}
```

- Return plain arrays matching GraphQL field names.
- Throw `GraphQlInputException`, `GraphQlAuthorizationException`, `GraphQlNoSuchEntityException`.
- Add fields to core types by redeclaring the type with only your new fields — schemas merge.
- List fields: use `BatchResolverInterface` to avoid N+1 queries.

## Verify

```bash
bin/magento setup:upgrade && bin/magento setup:di:compile && bin/magento cache:flush
```

REST 404 or missing GraphQL fields → typo in webapi/schema, missing compile, or stale config cache.
