#!/usr/bin/env bash
# Claude Code status line: model · context % · session cost · 5h limit % · git branch
# Claude Code pipes session JSON to stdin; see https://code.claude.com/docs/en/statusline
input=$(cat)

model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // "."' <<<"$input")
ctx=$(jq -r '(.context_window.used_percentage // 0) | floor' <<<"$input")
cost=$(jq -r '(.cost.total_cost_usd // 0)' <<<"$input")
five=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$input")

branch=$(git -C "$dir" branch --show-current 2>/dev/null)

# context colour: green < 50, yellow < 80, red otherwise
if   [ "$ctx" -lt 50 ]; then c=32
elif [ "$ctx" -lt 80 ]; then c=33
else c=31; fi

out=$(printf '\033[36m%s\033[0m · ctx \033[%sm%s%%\033[0m · $%.2f' "$model" "$c" "$ctx" "$cost")
[ -n "$five" ] && out+=$(printf ' · 5h %.0f%%' "$five")
[ -n "$branch" ] && out+=$(printf ' · \033[35m%s\033[0m' "$branch")
printf '%s' "$out"
