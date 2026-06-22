#!/bin/sh
#
# RaveDigital Magento Agent Skills Installer
# Installs all skills (magento-module, magento-admin-ui, magento-testing, magento-audit) at once.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/harishrave/magento-agent-skills/main/install.sh | sh -s cursor
#
# From a cloned repo (from your Magento project root):
#   ./magento-agent-skills/install.sh cursor
#   ./magento-agent-skills/install.sh --copy cursor
#   ./magento-agent-skills/install.sh --agents cursor
#
# Environment:
#   RAVEDIGITAL_SKILLS_REPO_URL   Repository URL (default: GitHub)
#   RAVEDIGITAL_SKILLS_BRANCH     Branch (default: main)
#   RAVEDIGITAL_SKILLS_AGENT      Default agent when omitted (e.g. cursor)
#
# Copyright (c) 2026 RaveDigital. All rights reserved.

set -e

REPO_URL="${RAVEDIGITAL_SKILLS_REPO_URL:-https://github.com/harishrave/magento-agent-skills.git}"
BRANCH="${RAVEDIGITAL_SKILLS_BRANCH:-main}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALLED_SKILLS=""
INSTALL_MODE="symlink"
USE_AGENTS_PATH=0

print_header() {
    echo ""
    echo "${BLUE}============================================${NC}"
    echo "${BLUE} RaveDigital Magento Agent Skills${NC}"
    echo "${BLUE}============================================${NC}"
    echo ""
}

print_success() { echo "${GREEN}[OK]${NC} $1"; }
print_warning() { echo "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo "${RED}[ERROR]${NC} $1"; }
print_info() { echo "${BLUE}[INFO]${NC} $1"; }

usage() {
    echo "Usage: $0 [--copy] [--agents] [agent]"
    echo ""
    echo "Installs all skills: magento-module, magento-admin-ui, magento-testing, magento-audit"
    echo ""
    echo "Agents: cursor, claude, codex, copilot, gemini, junie, opencode, windsurf"
    echo ""
    echo "Options:"
    echo "  --copy     Copy skills instead of symlinking (Docker/containers)"
    echo "  --agents   Use .agents/skills/ (Cursor Skills CLI layout)"
    echo ""
    echo "Examples:"
    echo "  curl -fsSL https://raw.githubusercontent.com/harishrave/magento-agent-skills/main/install.sh | sh -s cursor"
    echo "  ./install.sh cursor"
    echo "  ./install.sh --agents cursor"
    exit 1
}

get_skills_dir() {
    platform="$1"
    if [ "$USE_AGENTS_PATH" = "1" ]; then
        echo ".agents/skills"
        return 0
    fi
    case "$platform" in
        claude)   echo ".claude/skills" ;;
        codex)    echo ".codex/skills" ;;
        copilot)  echo ".github/skills" ;;
        cursor)   echo ".cursor/skills" ;;
        gemini)   echo ".gemini/skills" ;;
        junie)    echo ".junie/skills" ;;
        opencode) echo ".opencode/skills" ;;
        windsurf) echo ".windsurf/skills" ;;
        *)
            print_error "Unknown agent: $platform"
            usage
            ;;
    esac
}

detect_agent_dir() {
    for dot_dir in .agents .claude .codex .github .cursor .gemini .junie .opencode .windsurf; do
        if [ -d "./$dot_dir/skills" ]; then
            echo "$dot_dir"
            return 0
        fi
    done
    return 1
}

dir_to_agent() {
    case "$1" in
        .agents)   echo "cursor" ;;
        .claude)   echo "claude" ;;
        .codex)    echo "codex" ;;
        .github)   echo "copilot" ;;
        .cursor)   echo "cursor" ;;
        .gemini)   echo "gemini" ;;
        .junie)    echo "junie" ;;
        .opencode) echo "opencode" ;;
        .windsurf) echo "windsurf" ;;
        *) echo "$1" ;;
    esac
}

prompt_user() {
    if [ ! -t 0 ] && [ ! -c /dev/tty 2>/dev/null ]; then
        print_error "Specify agent: $(basename "$0") cursor"
        exit 1
    fi
    printf "%s" "$1" > /dev/tty
    read -r REPLY < /dev/tty
    echo "$REPLY"
}

check_dependencies() {
    for cmd in curl tar mkdir; do
        command -v "$cmd" >/dev/null 2>&1 || { print_error "Required: $cmd"; exit 1; }
    done
    if command -v git >/dev/null 2>&1; then
        HAS_GIT=1
    else
        HAS_GIT=0
        print_warning "git not found — will use tarball download"
    fi
}

detect_project_root() {
    current_dir="$(pwd)"
    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/app/etc/env.php" ] || [ -f "$current_dir/bin/magento" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    echo "$(pwd)"
}

install_one_skill() {
    src_path="$1"
    dest_dir="$2"
    skill="$3"
    dest_path="$dest_dir/$skill"

    if [ "$INSTALL_MODE" = "symlink" ]; then
        if [ -L "$dest_path" ]; then
            rm -f "$dest_path"
        elif [ -e "$dest_path" ]; then
            rm -rf "$dest_path"
        fi
        ln -s "$src_path" "$dest_path"
        print_success "Installed: $skill"
    else
        if [ -d "$dest_path" ]; then
            rm -rf "$dest_path"
            cp -r "$src_path" "$dest_path"
            print_success "Updated: $skill"
        else
            cp -r "$src_path" "$dest_path"
            print_success "Installed: $skill"
        fi
    fi
    INSTALLED_SKILLS="$INSTALLED_SKILLS $skill"
}

install_all_skills_from_repo() {
    repo_dir="$1"
    dest_dir="$2"
    skills_src="$repo_dir/skills"

    if [ ! -d "$skills_src" ]; then
        print_error "Skills directory not found"
        return 1
    fi

    found=0
    for skill_path in "$skills_src"/*; do
        [ -d "$skill_path" ] || continue
        skill=$(basename "$skill_path")
        case "$skill" in _template) continue ;; esac
        [ -f "$skill_path/SKILL.md" ] || continue
        install_one_skill "$skill_path" "$dest_dir" "$skill"
        found=1
    done

    [ "$found" = "1" ] || print_warning "No skills found"
    return 0
}

force_copy_for_remote_install() {
    if [ "$INSTALL_MODE" = "symlink" ]; then
        INSTALL_MODE="copy"
    fi
}

install_via_git() {
    dest_dir="$1"
    force_copy_for_remote_install
    # mktemp -d creates a new unique dir (e.g. /tmp/tmp.Ab12Cd) — only this run's clone is removed
    tmp_dir=$(mktemp -d)
    print_info "Cloning repository..."
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$tmp_dir" 2>/dev/null || {
        print_error "Failed to clone"
        rm -rf "$tmp_dir"
        return 1
    }
    install_all_skills_from_repo "$tmp_dir" "$dest_dir"
    result=$?
    rm -rf "$tmp_dir"
    return $result
}

install_via_tarball() {
    dest_dir="$1"
    force_copy_for_remote_install
    # mktemp -d creates a new unique dir — only this run's download is removed
    tmp_dir=$(mktemp -d)
    tarball_url="https://github.com/harishrave/magento-agent-skills/archive/refs/heads/${BRANCH}.tar.gz"
    print_info "Downloading archive..."
    curl -fsSL "$tarball_url" -o "$tmp_dir/skills.tar.gz" || {
        print_error "Download failed"
        rm -rf "$tmp_dir"
        return 1
    }
    tar -xzf "$tmp_dir/skills.tar.gz" -C "$tmp_dir"
    extracted_dir=$(find "$tmp_dir" -maxdepth 1 -type d -name "magento-agent-skills-*" | head -1)
    [ -n "$extracted_dir" ] || { print_error "Extract failed"; rm -rf "$tmp_dir"; return 1; }
    install_all_skills_from_repo "$extracted_dir" "$dest_dir"
    result=$?
    rm -rf "$tmp_dir"
    return $result
}

install_from_local_repo() {
    dest_dir="$1"
    script_dir="$(cd "$(dirname "$0")" && pwd -P)"
    install_all_skills_from_repo "$script_dir" "$dest_dir"
}

resolve_platform() {
    if [ -n "$1" ]; then
        PLATFORM="$1"
        return 0
    fi
    if [ -n "${RAVEDIGITAL_SKILLS_AGENT:-}" ]; then
        PLATFORM="$RAVEDIGITAL_SKILLS_AGENT"
        print_info "Using agent from RAVEDIGITAL_SKILLS_AGENT: $PLATFORM"
        return 0
    fi
    detected_dir="$(detect_agent_dir || true)"
    if [ -n "$detected_dir" ]; then
        PLATFORM="$(dir_to_agent "$detected_dir")"
        [ "$detected_dir" = ".agents" ] && USE_AGENTS_PATH=1
        print_info "Detected agent: $PLATFORM ($detected_dir/skills)"
        return 0
    fi
    PLATFORM="$(prompt_user "Enter agent (cursor/claude/codex/copilot/gemini/junie/opencode/windsurf): ")"
    [ -z "$PLATFORM" ] && { print_error "Agent required"; usage; }
}

# --- main ---
print_header

while [ $# -gt 0 ]; do
    case "$1" in
        --copy) INSTALL_MODE="copy"; shift ;;
        --symlink) INSTALL_MODE="symlink"; shift ;;
        --agents) USE_AGENTS_PATH=1; shift ;;
        -h|--help) usage ;;
        *) break ;;
    esac
done

resolve_platform "${1:-}"

skills_dir_name=$(get_skills_dir "$PLATFORM")
print_info "Installing all skills for: $PLATFORM"
print_info "Mode: $INSTALL_MODE"

check_dependencies

project_root=$(detect_project_root)
print_info "Project root: $project_root"
cd "$project_root"

skills_dir="$project_root/$skills_dir_name"
mkdir -p "$skills_dir"

if [ -f "$(dirname "$0")/skills/magento-module/SKILL.md" ]; then
    print_info "Using local repository"
    install_from_local_repo "$skills_dir" || exit 1
elif [ "$HAS_GIT" = "1" ]; then
    install_via_git "$skills_dir" || install_via_tarball "$skills_dir"
else
    install_via_tarball "$skills_dir"
fi

echo ""
echo "${GREEN}============================================${NC}"
echo "${GREEN} Installation complete!${NC}"
echo "${GREEN}============================================${NC}"
echo ""
echo "Skills directory: $skills_dir"
echo ""
echo "Installed:"
for skill in magento-module magento-admin-ui magento-testing magento-audit; do
    if [ -e "$skills_dir/$skill" ]; then
        echo "  - $skill"
    fi
done
echo ""
if [ "$INSTALL_MODE" = "symlink" ]; then
    print_info "Symlinked skills update when you git pull in the cloned skills repo."
else
    print_info "Copied skills — re-run install.sh or the curl one-liner to update after repo changes."
fi
echo ""
echo "Start a new Agent chat, then try:"
echo "  \"Create RaveDigital_StoreLocator in app/code per module-scaffold.md\""
echo ""
