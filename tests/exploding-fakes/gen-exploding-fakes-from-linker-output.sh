#!/bin/bash
# This has been tested with gcc v4.8, and Apple LLVM version 6.0 (clang-600.0.57) 
#
# This script will add an EXPLODING_FAKE_FOR each unresolved external reference
# reported by the linker. This includes global variables.  Accessing the generated
# fake for global variables is undefined behavior.  I expect you will get nothing 
# on a read and a crash on a write.
#
# User beware

LINKER_ERROR_FILE=$1
EXPLODING_FAKES_FILE=$2

usage()
{
    if [ $# != 2 ] ; then 
        echo "usage: $0 linker_error_file output_file"
        exit 1
    fi
}

failWhenTargetExists()
{
    if [ -f $1 ] ; then 
        echo "Cannot continue $1 already exists"
        exit 1
    fi
}

usage $@
failWhenTargetExists $EXPLODING_FAKES_FILE

echo '#include "explodingfake.h"' > $EXPLODING_FAKES_FILE
echo "" >> $EXPLODING_FAKES_FILE
grep reference $LINKER_ERROR_FILE | \
	sed -e's/^.*"_/EXPLODING_FAKE_FOR(/' \
	-e's/".*/)/' \
	-e's/^.*`/EXPLODING_FAKE_FOR(/' -e"s/'/)/" \
	| sort | uniq \
	>> $EXPLODING_FAKES_FILE
