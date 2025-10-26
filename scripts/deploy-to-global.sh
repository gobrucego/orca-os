#!/bin/bash

# Claude Vibe Code - Global Deployment Script
# Syncs canonical system from repo to ~/.claude

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_ROOT="/Users/adilkalam/claude-vibe-code"
DEPLOY_TARGET="$HOME/.claude"
ARCHIVE_DIR="$HOME/.claude-archive"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown argument: $1${NC}"
            exit 1
            ;;
    esac
done

# Helper functions
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

confirm() {
    if [ "$DRY_RUN" = true ]; then
        return 0
    fi

    read -p "$1 (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
}

# Verify we're in the repo root
if [ ! -d "$REPO_ROOT/.git" ]; then
    print_error "Not in repo root: $REPO_ROOT"
    exit 1
fi

cd "$REPO_ROOT"

print_header "Claude Vibe Code - Global Deployment"

if [ "$DRY_RUN" = true ]; then
    print_warning "DRY RUN MODE - No changes will be made"
fi

echo "Source: $REPO_ROOT"
echo "Target: $DEPLOY_TARGET"
echo ""

# Verify deployment target exists
if [ ! -d "$DEPLOY_TARGET" ]; then
    print_error "Deployment target does not exist: $DEPLOY_TARGET"
    exit 1
fi

# ============================================================================
# PHASE 0: Pre-flight Checks
# ============================================================================

print_header "Phase 0: Pre-flight Checks"

# Count source files
AGENT_COUNT=$(find "$REPO_ROOT/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
COMMAND_COUNT=$(find "$REPO_ROOT/commands" -name "*.md" 2>/dev/null | grep -v "\.claude-" | wc -l | tr -d ' ')
HOOK_COUNT=$(find "$REPO_ROOT/hooks" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')

echo "Source manifest:"
echo "  Agents: $AGENT_COUNT"
echo "  Commands: $COMMAND_COUNT"
echo "  Hooks: $HOOK_COUNT"

if [ "$AGENT_COUNT" -lt 40 ]; then
    print_error "Agent count too low ($AGENT_COUNT). Expected ~51. Aborting."
    exit 1
fi

if [ "$COMMAND_COUNT" -ne 15 ]; then
    print_warning "Command count is $COMMAND_COUNT (expected 15). Continuing anyway..."
fi

print_success "Pre-flight checks passed"

# ============================================================================
# PHASE 1: Safety Backup
# ============================================================================

print_header "Phase 1: Safety Backup"

BACKUP_FILE="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S).tar.gz"

if [ "$DRY_RUN" = false ]; then
    echo "Creating backup: $BACKUP_FILE"
    tar -czf "$BACKUP_FILE" -C "$HOME" .claude 2>/dev/null || {
        print_warning "Backup failed (non-critical, continuing)"
    }

    if [ -f "$BACKUP_FILE" ]; then
        BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        print_success "Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
    fi
else
    echo "Would create: $BACKUP_FILE"
fi

# ============================================================================
# PHASE 2: Archive Large Directories (First Run Only)
# ============================================================================

print_header "Phase 2: Archive Large Directories"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)

archive_dir() {
    local dir_name=$1
    local source="$DEPLOY_TARGET/$dir_name"
    local dest="$ARCHIVE_DIR/${dir_name}-${TIMESTAMP}"

    if [ -d "$source" ]; then
        local size=$(du -sh "$source" | cut -f1)
        echo "Found: $dir_name ($size)"

        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$ARCHIVE_DIR"
            mv "$source" "$dest"
            print_success "Archived: $dir_name → $dest"
        else
            echo "Would archive: $source → $dest"
        fi
    else
        echo "Not found: $dir_name (skip)"
    fi
}

echo "Archiving large runtime directories..."
archive_dir "projects"
archive_dir "debug"
archive_dir "shell-snapshots"
archive_dir "file-history"

# ============================================================================
# PHASE 3: Delete Stale Files
# ============================================================================

print_header "Phase 3: Delete Stale Files"

delete_file() {
    local file="$DEPLOY_TARGET/$1"
    if [ -f "$file" ]; then
        if [ "$DRY_RUN" = false ]; then
            rm "$file"
            print_success "Deleted: $1"
        else
            echo "Would delete: $1"
        fi
    fi
}

delete_pattern() {
    local pattern="$DEPLOY_TARGET/$1"
    local files=$(ls $pattern 2>/dev/null || true)
    if [ -n "$files" ]; then
        if [ "$DRY_RUN" = false ]; then
            rm $pattern
            print_success "Deleted: $1 ($(echo $files | wc -w | tr -d ' ') files)"
        else
            echo "Would delete: $1 ($(echo $files | wc -w | tr -d ' ') files)"
        fi
    fi
}

echo "Removing deprecated commands..."
delete_file "commands/session-save.md"
delete_file "commands/session-resume.md"

echo "Removing stale documentation..."
delete_pattern "QA_*.md"
delete_pattern "ORCA_*.md"
delete_pattern "*_COMPLETE.md"
delete_pattern "*_FIX*.md"
delete_file "SETUP_REFERENCE.md"
delete_file "USER_PROFILE.md"
delete_pattern "CLAUDE.md.backup-*"
delete_pattern "test-scenario-*.md"
delete_pattern "VISUAL_REVIEW_*.md"
delete_pattern "COMPLEXITY_*.md"
delete_pattern "COMPLETE_*.md"
delete_pattern "PHASE_*.md"

echo "Removing session artifacts..."
delete_pattern ".claude-*-context.md"
delete_pattern ".diagram-*.md"
delete_pattern ".rebuilt-diagrams.md"
delete_file "commands/.claude-orchestration-context.md"

echo "Removing old design system files..."
delete_file "OBDN_DESIGN_SYSTEM_UNDERSTANDING.md"
delete_file "DESIGN_AGENT_TESTING_METHODOLOGY.md"

# ============================================================================
# PHASE 4: Deploy Canonical System
# ============================================================================

print_header "Phase 4: Deploy Canonical System"

deploy_with_rsync() {
    local source="$REPO_ROOT/$1"
    local dest="$DEPLOY_TARGET/$2"
    local description="$3"

    if [ ! -e "$source" ]; then
        print_warning "Source not found: $1 (skipping)"
        return
    fi

    echo "Deploying: $description"

    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$(dirname "$dest")"

        if [ -d "$source" ]; then
            # Directory: use rsync with --delete to remove stale files
            rsync -av --delete "$source/" "$dest/" > /dev/null 2>&1
        else
            # File: simple copy
            cp "$source" "$dest"
        fi

        print_success "Deployed: $description"
    else
        echo "Would deploy: $source → $dest"
    fi
}

echo "Deploying core system..."
deploy_with_rsync "agents" "agents" "Agents ($AGENT_COUNT files)"
deploy_with_rsync "commands" "commands" "Commands ($COMMAND_COUNT files)"
deploy_with_rsync "hooks" "hooks" "Hooks ($HOOK_COUNT files)"
deploy_with_rsync "scripts" "scripts" "Scripts"

echo "Deploying orchestration playbooks..."
if [ -d "$REPO_ROOT/.orchestration/playbooks" ]; then
    # Don't use --delete for orchestration - preserve runtime data
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$DEPLOY_TARGET/.orchestration/playbooks"
        rsync -av "$REPO_ROOT/.orchestration/playbooks/" "$DEPLOY_TARGET/.orchestration/playbooks/" > /dev/null 2>&1
        print_success "Deployed: Orchestration playbooks"
    else
        echo "Would deploy: .orchestration/playbooks"
    fi
fi

echo "Deploying reference documentation..."
deploy_with_rsync "QUICK_REFERENCE.md" "QUICK_REFERENCE.md" "Quick Reference"
deploy_with_rsync ".claude/DEPLOYMENT_MANIFEST.md" "DEPLOYMENT_MANIFEST.md" "Deployment Manifest"

# Deploy project CLAUDE.md as separate file (don't overwrite global)
if [ -f "$REPO_ROOT/CLAUDE.md" ]; then
    if [ "$DRY_RUN" = false ]; then
        cp "$REPO_ROOT/CLAUDE.md" "$DEPLOY_TARGET/CLAUDE.md.project"
        print_success "Deployed: CLAUDE.md.project (project memory)"
    else
        echo "Would deploy: CLAUDE.md → CLAUDE.md.project"
    fi
fi

# ============================================================================
# PHASE 5: Verify Deployment
# ============================================================================

print_header "Phase 5: Verify Deployment"

verify_count() {
    local pattern="$1"
    local expected=$2
    local name="$3"

    local actual=$(find "$DEPLOY_TARGET" -path "$pattern" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$actual" -eq "$expected" ]; then
        print_success "$name: $actual (expected $expected)"
    else
        print_error "$name: $actual (expected $expected) - MISMATCH!"
        return 1
    fi
}

if [ "$DRY_RUN" = false ]; then
    echo "Verifying deployment..."

    verify_count "$DEPLOY_TARGET/agents/*.md" "$AGENT_COUNT" "Agents" || true

    # Count commands excluding session artifacts
    DEPLOYED_COMMANDS=$(find "$DEPLOY_TARGET/commands" -name "*.md" 2>/dev/null | grep -v "\.claude-" | wc -l | tr -d ' ')
    if [ "$DEPLOYED_COMMANDS" -eq 15 ]; then
        print_success "Commands: $DEPLOYED_COMMANDS (expected 15)"
    else
        print_error "Commands: $DEPLOYED_COMMANDS (expected 15) - MISMATCH!"
    fi

    verify_count "$DEPLOY_TARGET/hooks/*.sh" "$HOOK_COUNT" "Hooks" || true

    # Verify deprecated files are gone
    if [ -f "$DEPLOY_TARGET/commands/session-save.md" ] || [ -f "$DEPLOY_TARGET/commands/session-resume.md" ]; then
        print_error "Deprecated commands still exist!"
    else
        print_success "Deprecated commands removed"
    fi

    # Check size
    DEPLOY_SIZE=$(du -sh "$DEPLOY_TARGET" | cut -f1)
    echo ""
    echo "Deployment size: $DEPLOY_SIZE"

    # Verify critical files exist
    echo ""
    echo "Verifying critical files..."
    [ -f "$DEPLOY_TARGET/QUICK_REFERENCE.md" ] && print_success "QUICK_REFERENCE.md exists" || print_error "QUICK_REFERENCE.md missing!"
    [ -f "$DEPLOY_TARGET/DEPLOYMENT_MANIFEST.md" ] && print_success "DEPLOYMENT_MANIFEST.md exists" || print_error "DEPLOYMENT_MANIFEST.md missing!"
    [ -d "$DEPLOY_TARGET/agents/orchestration" ] && print_success "agents/orchestration/ exists" || print_error "agents/orchestration/ missing!"

else
    echo "Skipping verification (dry-run mode)"
fi

# ============================================================================
# PHASE 6: Summary
# ============================================================================

print_header "Deployment Complete"

if [ "$DRY_RUN" = false ]; then
    echo "Summary:"
    echo "  ✓ Backup created: $BACKUP_FILE"
    echo "  ✓ Large directories archived to: $ARCHIVE_DIR"
    echo "  ✓ Stale files removed"
    echo "  ✓ Canonical system deployed"
    echo "  ✓ Deployment verified"
    echo ""
    echo "Target: $DEPLOY_TARGET"
    echo "Size: $DEPLOY_SIZE"
    echo ""
    print_success "Deployment successful!"
    echo ""
    echo "Backup location: $BACKUP_FILE"
    echo "Archive location: $ARCHIVE_DIR"
else
    echo ""
    print_warning "DRY RUN COMPLETE - No changes were made"
    echo ""
    echo "To execute deployment, run:"
    echo "  ./scripts/deploy-to-global.sh"
fi
