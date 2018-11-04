#!/bin/bash -e
#
# Verify Git for ARM64 Linux (should be run inside a container)

if [[ -z "${DESTINATION}" ]]; then
  echo "Required environment variable DESTINATION was not set"
  exit 1
fi

echo "-- Test external Git LFS"

"$DESTINATION/libexec/git-core/git-lfs" --version

echo "-- Test clone operation with generated binary"

TEMP_CLONE_DIR=/tmp/clones
mkdir -p $TEMP_CLONE_DIR

(
cd "$DESTINATION/bin" || exit 1
./git --version
GIT_CURL_VERBOSE=1 \
  GIT_TEMPLATE_DIR="$DESTINATION/share/git-core/templates" \
  GIT_SSL_CAINFO="$DESTINATION/ssl/cacert.pem" \
  GIT_EXEC_PATH="$DESTINATION/libexec/git-core" \
  PREFIX="$DESTINATION" \
  ./git clone https://github.com/git/git.github.io "$TEMP_CLONE_DIR/git.github.io"
)
