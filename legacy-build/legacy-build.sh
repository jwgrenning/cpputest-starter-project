#!/bin/bash

LEGACY_SUGGEST=$(dirname $0)/legacy-suggest.sh
if [[ ! -e "${LEGACY_SUGGEST}" ]]; then
    echo "error: missing ${LEGACY_SUGGEST}"
    exit 1
fi

source $LEGACY_SUGGEST

GEN_XFAKES=$(dirname $0)/gen-xfakes.sh
if [[ ! -e "${GEN_XFAKES}" ]]; then
    echo "error: missing ${GEN_XFAKES}"
    exit 1
fi

source $GEN_XFAKES

legacy_build_main()
{
    BUILD_COMMAND=$1
    BUILD_DIR=$2
    INCLUDE_ROOT=$3
    echo "legacy-build: BUILD_COMMAND=$BUILD_COMMAND, from BUILD_DIR=$BUILD_DIR, with INCLUDE_ROOT=${INCLUDE_ROOT}"
    start_dir=${PWD}
    cd $BUILD_DIR
    rm -r tmp-*.*
    $BUILD_COMMAND 2>$ERROR_FILE
    cat $ERROR_FILE
    legacy_build_suggestion $ERROR_FILE
    generate_fakes $SORTED_UNDEFINES

    cd $start_dir
}

usage_exit()
{
    echo "usage: legacy-build command dir1 dir2"
    echo "    command: to run, e.g. 'make'"
    echo "    dir1: cd to dir1 to run command"
    echo "    dir2: search for missing include files in dir2"
    [[ $1 != "" ]] && echo "    **** $1 ****"
    echo
    exit 1
}

verify_params()
{
    [[ $1 == "" ]] && usage_exit ""
    [[ $2 == "" ]] && usage_exit ""
    [[ $3 == "" ]] && usage_exit ""
    [[ ! -d "$2" ]] && usage_exit "'$2' is not a directory"
    [[ ! -d "$3" ]] && usage_exit "'$3' is not a directory"
}

if [[ "$0" = "$BASH_SOURCE" ]]; then
    verify_params $1 $2 $3
    legacy_build_main $1 $2 $3
fi
