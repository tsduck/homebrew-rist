#!/bin/bash
#
# This script automatically updates the rist formula for the most recent version.
#

SCRIPT=$(basename $0 .sh)
SCRIPTDIR=$(cd $(dirname $0); pwd)

info() { echo >&2 "$SCRIPT: $*"; }
error() { echo >&2 "$SCRIPT: $*"; exit 1; }

# Get the formula file.
FORMULA="$SCRIPTDIR/rist.rb"
[[ -s "$FORMULA" ]] || error "formula file not found: $FORMULA"

# Get the description of the most recent release in the rist repository.
RELEASE=$(curl -s https://code.videolan.org/api/v4/projects/816/releases | jq '.[0]')
TAG=$(jq <<<$RELEASE -r '.tag_name')
URL=$(jq <<<$RELEASE -r '.assets.sources[] | select(.format | index("tar.gz")) | .url')

# Check that the tag value looks good.
[[ -n "$TAG" ]] || error "no tag found for latest rist release"
[[ $TAG = v* ]] || errro "suspect tag '$TAG', should be 'vX.Y.Z'"

# Extract the version number from the tag.
VERSION=${TAG/v/}
info "version: $VERSION"
info "tarball: $URL"

# Get checksum of source tarball.
SHA256=$(curl -L -s "$URL" | shasum -a 256 | awk '{print $1}')
info "sha256: $SHA256"

# Update formula for latest release.
gsed -i \
    -e "s|version *\".*\"|version \"$VERSION\"|" \
    -e "s|url *\".*\"|url \"$URL\"|" \
    -e "s|sha256 *\".*\"|sha256 \"$SHA256\"|" \
    "$FORMULA"
