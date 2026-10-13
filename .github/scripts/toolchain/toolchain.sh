#!/bin/bash

# To activate the toolchain
# source <path>/toolchain.sh --activate

TOOLCHAIN_PATH=$(realpath $(dirname ${BASH_SOURCE[0]}))

if [[ " $* " == *" --activate "* ]]; then
  export PATH="$TOOLCHAIN_PATH/bin:$PATH"
fi
