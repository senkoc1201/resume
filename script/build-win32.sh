#!/bin/bash

DESTINATION=$1
mkdir -p $DESTINATION

GIT_FOR_WINDOWS_FILE=git-for-windows.zip
curl -sL -o $GIT_FOR_WINDOWS_FILE $GIT_FOR_WINDOWS_URL
COMPUTED_SHA256=$(shasum -a 256 $GIT_FOR_WINDOWS_FILE | awk '{print $1;}')
if [ "$COMPUTED_SHA256" = "$GIT_FOR_WINDOWS_CHECKSUM" ]; then
  echo "Git for Windows: checksums match"
  unzip $GIT_FOR_WINDOWS_FILE -d $DESTINATION
else
  echo "Git for Windows: expected checksum $GIT_FOR_WINDOWS_CHECKSUM but got $COMPUTED_SHA256"
  echo "aborting..."
  exit 1
fi

GIT_LFS_FILE=git-lfs.zip
curl -sL -o $GIT_LFS_FILE $GIT_LFS_URL
COMPUTED_SHA256=$(shasum -a 256 $GIT_LFS_FILE | awk '{print $1;}')
if [ "$COMPUTED_SHA256" = "$GIT_LFS_CHECKSUM" ]; then
  echo "Git LFS: checksums match"
  SUBFOLDER="$DESTINATION/mingw64/libexec/git-core/"
  unzip -j $GIT_LFS_FILE -x '*.md' -d $SUBFOLDER
else
  echo "Git LFS: expected checksum $GIT_LFS_CHECKSUM and got $COMPUTED_SHA256"
  echo "aborting..."
  exit 1
fi
