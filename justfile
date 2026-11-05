set shell := ["bash", "-euo", "pipefail", "-c"]

codemirror := "platform/mv3/extension/lib/codemirror/codemirror-ubol"

_default:
    @just --list --unsorted --list-heading '' --list-prefix='- '

# merge upstream/master into master and push to origin
pull:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ $(git branch --show-current) == master ]] || { echo "✗ checkout master first" >&2; exit 1; }
    echo "→ fetching upstream"
    git fetch upstream
    echo "→ merging upstream/master"
    git merge --no-edit upstream/master
    echo "→ pushing to origin"
    git push origin master
    echo "✓ pull complete"

# sync submodules and install locked npm dependencies
setup:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "→ updating submodules"
    git submodule update --init
    echo "→ installing npm dependencies"
    npm ci --silent
    echo "→ installing codemirror dependencies"
    npm --prefix {{ codemirror }} ci --silent
    echo "✓ setup complete"

# build MV2 or MV3 into _build/ for loading unpacked
install:
    make release

# remove dependencies and build outputs
uninstall:
    #!/usr/bin/env bash
    set -euo pipefail
    found=()
    for t in node_modules {{ codemirror }}/node_modules dist/build _build; do
        [[ -e $t ]] && found+=("$t")
    done
    [[ ${#found[@]} -eq 0 ]] && { echo "✓ nothing to remove"; exit 0; }
    printf '  %s\n' "${found[@]}"
    read -r -p "remove these? extensions loaded from _build/ will stop working [y/N] " ans
    [[ $ans == [yY] ]] || { echo "✗ aborted"; exit 1; }
    rm -rf "${found[@]}"
    echo "✓ removed"
