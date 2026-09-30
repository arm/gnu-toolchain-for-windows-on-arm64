#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

version=$(date -u '+%Y.%m.%d')
tag=v$version
MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_NAME=aarch64-w64-mingw32-$version-aarch64-unknown-linux-gnu-host.tar.gz
MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_NAME=aarch64-w64-mingw32-$version-arm64-apple-darwin-host.tar.gz

gh release create $tag \
  --title $tag \
  --prerelease \
  --draft

if [[ -f "$ARTIFACT_PATH/aarch64-w64-mingw32-aarch64-unknown-linux-gnu.tar.gz" ]]; then
  mv $ARTIFACT_PATH/aarch64-w64-mingw32-aarch64-unknown-linux-gnu.tar.gz \
    $ARTIFACT_PATH/$MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_NAME
  gh release upload $tag \
    $ARTIFACT_PATH/$MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_NAME
  MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_LINK="[$MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_NAME](https://github.com/$GITHUB_REPOSITORY/releases/download/$tag/$MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_NAME)"
else
  MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_LINK="FAILED"
fi

if [[ -f "$ARTIFACT_PATH/aarch64-w64-mingw32-arm64-apple-darwin.tar.gz" ]]; then
  mv $ARTIFACT_PATH/aarch64-w64-mingw32-arm64-apple-darwin.tar.gz \
    $ARTIFACT_PATH/$MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_NAME
  gh release upload $tag \
    $ARTIFACT_PATH/$MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_NAME
  MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_LINK="[$MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_NAME](https://github.com/$GITHUB_REPOSITORY/releases/download/$tag/$MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_NAME)"
else
  MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_LINK="FAILED"
fi

cat > release-notes.txt <<EOF
GNU Toolchain weekly build from upstream repositories for aarch64-w64-mingw32 target.
|Repository|Last commit|
|:-|:-|
|Binutils|[$BINUTILS_HEAD](https://sourceware.org/git/?p=binutils-gdb.git;a=log;h=$BINUTILS_HEAD)|
|GCC|[$GCC_HEAD](https://gcc.gnu.org/git/?p=gcc.git;a=log;h=$GCC_HEAD)|
|MinGW|[$MINGW_HEAD](https://sourceforge.net/p/mingw-w64/mingw-w64/ci/$MINGW_HEAD/log/)|

### Cross-Toolchains
|Target|Host|Package|
|:-|:-|:-|
|aarch64-w64-mingw32|aarch64-unknown-linux-gnu|$MINGW_FOR_LINUX_HOST_RELEASE_PACKAGE_LINK|
|aarch64-w64-mingw32|arm64-apple-darwin|$MINGW_FOR_MACOS_HOST_RELEASE_PACKAGE_LINK|
EOF

gh release edit $tag \
  --notes-file release-notes.txt \
  --draft=false
