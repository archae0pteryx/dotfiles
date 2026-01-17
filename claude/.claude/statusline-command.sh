#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')

# Context size (prioritized - this is what the user cares about most)
context_used=$(echo "$input" | jq -r '.context.used // 0')
context_max=$(echo "$input" | jq -r '.context.max // 0')

# Format token counts (use K for thousands, M for millions)
format_tokens() {
    local count=$1
    if [ "$count" -ge 1000000 ]; then
        printf "%.1fM" "$(echo "scale=1; $count / 1000000" | bc)"
    elif [ "$count" -ge 1000 ]; then
        printf "%.1fK" "$(echo "scale=1; $count / 1000" | bc)"
    else
        printf "%d" "$count"
    fi
}

context_info=""
if [ "$context_used" != "0" ] && [ "$context_used" != "null" ]; then
    formatted_used=$(format_tokens "$context_used")
    formatted_max=$(format_tokens "$context_max")
    # Calculate percentage
    if [ "$context_max" -gt 0 ]; then
        pct=$(echo "scale=0; $context_used * 100 / $context_max" | bc)
        context_info="📊 ${formatted_used}/${formatted_max} (${pct}%)"
    else
        context_info="📊 ${formatted_used}"
    fi
fi

# Directory component (truncate path)
dir_path="$cwd"
# Truncate to last 3 components
truncated_path=$(echo "$dir_path" | awk -F'/' '{
    n = NF;
    if (n > 3) {
        printf "…/%s/%s/%s", $(n-2), $(n-1), $n
    } else {
        print $0
    }
}')

# Git branch (skip optional locks)
git_branch=""
git_status=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch="  $branch"
    fi

    # Git status
    if [ -n "$(git -C "$cwd" -c core.useBuiltinFSMonitor=false status --porcelain 2>/dev/null)" ]; then
        git_status=" 💩"
    else
        git_status=" 🌈"
    fi
fi

# Node.js version (if available)
nodejs=""
if command -v node >/dev/null 2>&1 && [ -f "$cwd/package.json" ]; then
    node_version=$(node --version 2>/dev/null | sed 's/v//')
    if [ -n "$node_version" ]; then
        nodejs="  $node_version"
    fi
fi

# Rust version (if available)
rust=""
if command -v rustc >/dev/null 2>&1 && [ -f "$cwd/Cargo.toml" ]; then
    rust_version=$(rustc --version 2>/dev/null | awk '{print $2}')
    if [ -n "$rust_version" ]; then
        rust="  $rust_version"
    fi
fi

# Docker context (if available)
docker_ctx=""
if command -v docker >/dev/null 2>&1; then
    ctx=$(docker context show 2>/dev/null)
    if [ -n "$ctx" ] && [ "$ctx" != "default" ]; then
        docker_ctx="  $ctx"
    fi
fi

# Kubernetes context (if available)
k8s=""
if command -v kubectl >/dev/null 2>&1; then
    context=$(kubectl config current-context 2>/dev/null)
    namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [ -n "$context" ]; then
        # Determine symbol based on context pattern
        k8s_symbol="⚓︎"
        if [[ "$context" == kind* ]]; then
            k8s_symbol="💻"
        elif [[ "$context" == *staging* ]]; then
            k8s_symbol="⚓️"
        elif [[ "$context" == *prod* ]]; then
            k8s_symbol="⚡️"
        fi
        k8s=" $k8s_symbol $context"
        if [ -n "$namespace" ]; then
            k8s="$k8s:$namespace"
        fi
    fi
fi

# Nix shell indicator (if in nix shell)
nix_shell=""
if [ -n "$IN_NIX_SHELL" ]; then
    nix_shell=" 👻"
fi

# Build the status line
# Left side: context info (priority!), directory, git info
left_side="$context_info $truncated_path$git_branch$git_status$nodejs$rust$docker_ctx"

# Right side: nix shell, kubernetes, model info
right_side="$nix_shell$k8s $model_name"

# Output the status line
printf "%s  %s" "$left_side" "$right_side"
