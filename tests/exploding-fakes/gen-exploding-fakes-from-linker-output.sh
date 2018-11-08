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
echo '//#include "explodingfake.hpp"' >> $EXPLODING_FAKES_FILE
echo "" >> $EXPLODING_FAKES_FILE
echo "/*" >> $EXPLODING_FAKES_FILE
echo " For use with C++ linkage unresolved external references:" >> $EXPLODING_FAKES_FILE
echo "    * Remove 'explodingfake.h' and uncomment 'explodingfake.hpp'." >> $EXPLODING_FAKES_FILE
echo "    * Add header files for the referenced C++ functions in your generated exploding-fakes.cpp file." >> $EXPLODING_FAKES_FILE
echo "    * For functions with return types, use the EXPLODING_VALUE_FAKE_FOR macro." >> $EXPLODING_FAKES_FILE
echo "" >> $EXPLODING_FAKES_FILE
echo " For use with C linkage unresolved external references:" >> $EXPLODING_FAKES_FILE
echo "    * You should be good to add the generated file to your test build." >> $EXPLODING_FAKES_FILE
echo "    * Do not include the header files for the referenced functions. The linker does not care." >> $EXPLODING_FAKES_FILE
echo "" >> $EXPLODING_FAKES_FILE
echo " Note: a EXPLODING_FAKE_FOR() is generated for global variable too." >> $EXPLODING_FAKES_FILE
echo "    * They will explode upong write :-)" >> $EXPLODING_FAKES_FILE
echo "" >> $EXPLODING_FAKES_FILE
echo " If you need both C and C++ linkage" >> $EXPLODING_FAKES_FILE
echo "    * Put all the C linkage files in a .c file." >> $EXPLODING_FAKES_FILE
echo "    * Put all the C++ linkage files in a .cpp file." >> $EXPLODING_FAKES_FILE
echo "" >> $EXPLODING_FAKES_FILE
echo "*/" >> $EXPLODING_FAKES_FILE
grep reference $LINKER_ERROR_FILE | \
    sed -e's/^.*"_/EXPLODING_FAKE_FOR(/' \
    -e's/".*/)/' \
    -e's/^.*`/EXPLODING_FAKE_FOR(/' -e"s/'/)/" \
    | sort | uniq \
    >> $EXPLODING_FAKES_FILE
