#!/bin/bash
#
# Script for packaging artefacts into gzipped archive.
# Build scripts should handle platform-specific differences, so this
# script works off the assumption that everything at $DESTINATION is
# intended to be part of the archive.
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE="./git"
DESTINATION="/tmp/build/git"
BUILD="$TRAVIS_BUILD_NUMBER"

cd $SOURCE
VERSION=$(git describe --exact-match HEAD)
EXIT_CODE=$?

if [ "$EXIT_CODE" == "128" ]; then
  echo "Git commit does not have tag, cannot use version to build from"
  exit 1
fi
cd -

if ! [ -d "$DESTINATION" ]; then
  echo "No output found, exiting..."
  exit 1
fi

if [ "$PLATFORM" == "ubuntu" ]; then
  FILE="dugite-native-$VERSION-ubuntu-$BUILD.tar.gz"
elif [ "$PLATFORM" == "macOS" ]; then
  FILE="dugite-native-$VERSION-macOS-$BUILD.tar.gz"
elif [ "$PLATFORM" == "win32" ]; then
  FILE="dugite-native-$VERSION-win32-$BUILD.tar.gz"
else
  echo "Unable to package Git for platform $PLATFORM"
  exit 1
fi

tar -cvzf $FILE -C $DESTINATION .
CHECKSUM=$(shasum -a 256 $FILE | awk '{print $1;}')

tar -tzf $FILE

echo "Package created: ${FILE}"
echo "SHA256: ${CHECKSUM}"
