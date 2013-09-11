#!/bin/bash

failWhenDirDoesNotExist()
{
    if [ ! -d $1 ] ; then 
        echo "Cannot continue $1 directory does not exist"
        exit 1
    fi
}

failWhenTargetExists()
{
    if [ -f $1 ] || [ -d $1 ]; then 
        echo "Cannot continue $1 already exists"
        exit 1
    fi
}

target_dir=$1

failWhenDirDoesNotExist $target_dir
failWhenTargetExists $target_dir/tests
failWhenTargetExists $target_dir/example-include
failWhenTargetExists $target_dir/example-src
failWhenTargetExists $target_dir/example-platform
failWhenTargetExists $target_dir/makefile

cp -R  tests $target_dir/tests
cp -R  example-include $target_dir/example-include
cp -R  example-src $target_dir/example-src
cp -R  example-platform $target_dir/example-platform
cp     makefile $target_dir/makefile
