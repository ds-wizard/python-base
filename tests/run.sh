#!/usr/bin/env bash
#
# Run smoke tests for one image
#
# Usage: tests/run.sh <tag> [image]
#
# Without an image, builds <tag>/Dockerfile locally first. Expected
# versions are read from the Dockerfile, so they stay in one place.

set -euo pipefail

cd "$(dirname "$0")/.."

tag="${1:?usage: tests/run.sh <tag> [image]}"
image="${2:-}"
dockerfile="$tag/Dockerfile"

if [ ! -f "$dockerfile" ] || [ ! -f "tests/$tag.sh" ]; then
    echo "Unknown tag: $tag" >&2
    exit 2
fi

if [ -z "$image" ]; then
    image="python-base-test:$tag"
    docker build -f "$dockerfile" -t "$image" .
fi

# Alpine images pin the full version in FROM, the Lambda one the minor in dnf
python_version="$(sed -n 's/^FROM python:\([0-9.]*\)-.*/\1/p' "$dockerfile")"
if [ -z "$python_version" ]; then
    python_version="$(sed -n 's/.* python\(3\.[0-9]*\) .*/\1/p' "$dockerfile" | head -n 1)"
fi
pandoc_version="$(sed -n 's|.*pandoc/releases/download/\([0-9.]*\)/.*|\1|p' "$dockerfile" | head -n 1)"

docker run --rm \
    --entrypoint /bin/sh \
    -v "$PWD/tests:/tests:ro" \
    -e EXPECTED_PYTHON="$python_version" \
    -e EXPECTED_PANDOC="$pandoc_version" \
    "$image" "/tests/$tag.sh"
