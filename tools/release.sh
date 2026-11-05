#!/usr/bin/env bash
set -e
source ~/.claude/shell-style.sh

BUILD_DIR="_build"

log_header "▸" "check" "prerequisites"

if command -v nvm &>/dev/null; then
    nvm use 2>/dev/null || nvm install 2>/dev/null || true
fi

if [[ ! -d node_modules ]]; then
    log_item "npm install" "$(dim 'installing dependencies...')"
    npm install --silent
fi

if [[ ! -f platform/mv3/extension/lib/codemirror/codemirror-ubol/Makefile ]]; then
    log_item "git submodule" "$(dim 'initializing...')"
    git submodule init && git submodule update
fi

mkdir -p dist/build/mv3-data

log_done

choice=$(printf "MV2  (full, for ungoogled-chromium/Firefox)\nMV3  (lite, for Chrome/Edge)" \
    | fzf --prompt="Select manifest version → " \
          --height=5 --layout=reverse --no-info \
          --pointer="→" --marker="→" \
          --color="prompt:yellow,pointer:green,hl:green")

[[ -z "$choice" ]] && die "no selection made"

case "$choice" in
    MV2*) variant="mv2" target="chromium"    artifact="uBlock0.chromium" ;;
    MV3*) variant="mv3" target="mv3-chromium" artifact="uBOLite.chromium" ;;
esac

log_header "▸" "build" "${variant^^} chromium"
rm -rf "dist/build/$artifact"
make "$target"
mkdir -p "$BUILD_DIR/$variant"
rm -rf "$BUILD_DIR/$variant/$artifact"
cp -R "dist/build/$artifact" "$BUILD_DIR/$variant/"
log_done
log_header "▸" "output" "$BUILD_DIR/$variant/$artifact/"
