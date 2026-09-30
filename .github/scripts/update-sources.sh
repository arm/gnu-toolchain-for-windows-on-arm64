#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

PROJECT=$1

function update_repository() {
    DIRECTORY=$1
    REPOSITORY=$2
    BRANCH=$3
    BRANCH_HEAD=$4

    if [[ ! $REPOSITORY =~ ^(http://|https://|git://) ]]; then
        REPOSITORY="https://github.com/$REPOSITORY.git"
    fi

    if [[ ! -d $DIRECTORY ]]; then
        if [[ "$FLAT_CLONE" = 1 ]]; then
            git clone $REPOSITORY -b $BRANCH --single-branch --depth 100 $DIRECTORY
        else
            git clone $REPOSITORY -b $BRANCH $DIRECTORY
        fi
        if [[ -n $BRANCH_HEAD ]]; then
            git -C $DIRECTORY checkout $BRANCH_HEAD
        fi
    fi
}

echo "::group::Update source code repositories"
    mkdir -p "$SOURCE_PATH"

    cd "$SOURCE_PATH"

    if [[ -n "$PROJECT" ]]; then
        REPO=${PROJECT^^}_REPO
        BRANCH=${PROJECT^^}_BRANCH
        update_repository $PROJECT ${!REPO} ${!BRANCH}
    else
        update_repository binutils $BINUTILS_REPO $BINUTILS_BRANCH $BINUTILS_HEAD
        update_repository gcc $GCC_REPO $GCC_BRANCH $GCC_HEAD
        update_repository mingw $MINGW_REPO $MINGW_BRANCH $MINGW_HEAD
        if [[ "$PLATFORM" =~ cygwin ]]; then 
            update_repository cygwin $CYGWIN_REPO $CYGWIN_BRANCH $CYGWIN_HEAD
            update_repository cocom $COCOM_REPO $COCOM_BRANCH $COCOM_HEAD
        fi
    fi
echo "::endgroup::"

echo 'Success!'
