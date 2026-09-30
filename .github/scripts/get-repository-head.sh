#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

echo "binutils-head=$(git ls-remote $BINUTILS_REPO HEAD \
  | awk '{print $1}')" >> $GITHUB_OUTPUT
echo "gcc-head=$(git ls-remote $GCC_REPO HEAD \
  | awk '{print $1}')" >> $GITHUB_OUTPUT
echo "mingw-head=$(git ls-remote $MINGW_REPO HEAD \
  | awk '{print $1}')" >> $GITHUB_OUTPUT
