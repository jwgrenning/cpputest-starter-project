#!/bin/bash

# gcc settings, -fatal-errors
ERROR_FILE=tmp-build-errors.txt
FAKES_BASENAME=tmp-xfakes
SORTED_UNDEFINES=tmp-undefined-sorted.txt
INCLUDE_ROOT=${INCLUDE_ROOT:-.}
MAKEFILE_INCLUDE_STR=${MAKEFILE_INCLUDE_STR:-"INCLUDE_DIRS += "}
MAKEFILE_WARNING_STR=${MAKEFILE_WARNING_STR:-"CPPUTEST_WARNINGFLAGS += "}

# GEN_XFAKES=$(dirname $0)/gen-xfakes.sh
# if [ ! -e "${GEN_XFAKES}" ]; then
#     echo "error: missing ${GEN_XFAKES}"
#     exit 1
# fi
# source $GEN_XFAKES

looks_like()
{
    echo "Looks like you $1"
}


declare -a not_declared=(
    "not\ declared\ in\ this\ scope"
    "unknown\ type\ name"
    )

declare -a include_head=(
    ".*\ error:\ '"
    ".*\ error:\ "
    )
declare -a include_tail=(
    ":\ No\ such\ file\ or\ directory"
    "'\ file\ not\ found"
    )
declare -a linker_error_in_file=(
    "error:\ ld"
    "clang:\ error:\ linker"
    "LNK2019"
    )

show_not_declared()
{
    for text in "${not_declared[@]}"; do
        out=$(grep "${text}" $1)
        if [ "$?" = "0" ]; then
            echo $out
            looks_like "have a missing #include (${text})"
            return 0
        fi
    done
    return 1
}

show_missing_include_path()
{
    for text in "${include_tail[@]}"; do
        out=$(grep "${text}" $1)
        if [ "$?" = "0" ]; then
            echo $out
            looks_like "a missing include path in your makefile (${text})"
            grep "#include" $1
            file=$(isolate_missing_file "${out}")
            echo "Missing include path to ${file}"
            suggest_include_path $file
            return 0
        fi
    done
    return 1
}

isolate_missing_file()
{
    line="$@"
    for text in "${include_head[@]}" ]; do
        line=$(echo $line | sed -e"s/${text}//")
    done
    for text in "${include_tail[@]}" ]; do
        line=$(echo $line | sed -e"s/${text}//")
    done
    echo $line
}

suggest_include_path()
{
    cd $INCLUDE_ROOT
    target=$(basename $1)
    partial_path=$(dirname $1)

    echo "$ cd ${INCLUDE_ROOT}"
    echo "$ find . -name ${target}"
    cd ${INCLUDE_ROOT}
    filepath=$(find . -name ${target})
    if [ "${filepath}" == "" ]; then
        echo "${target} not found under ${INCLUDE_ROOT}"
    else
        echo "Path to $1 under ${INCLUDE_ROOT}"
        echo $filepath
        if [ "${partial_path}" == "." ]; then
            dir=$(dirname $filepath)
            include_path="\$(INCLUDE_ROOT)${dir#?}"
            echo "Add this to your makefile:"
            echo "${MAKEFILE_INCLUDE_STR}${include_path}"
        fi
    fi
}

show_noise_reduced_heading()
{
    echo "-----------------------------------------------------"
    echo "--------- Noise reduced build error output ----------"
    echo "-----------------------------------------------------"
}

show_warnings()
{
    grep "\[\-W" $1
    test "$?" = "1" && return 1
    echo "You could [temporarily] turn off the warning with"
    echo "${MAKEFILE_WARNING_STR}-Wno-<warning-spec>"
    return 0
}

link_errors_exist()
{
    rm -f $SORTED_UNDEFINES
    for text in "${linker_error_in_file[@]}"; do
        grep "${text}" $1 >/dev/null
        if [ "$?" == "0" ]; then
            return 0
        fi
    done
    return 1
}

show_other_compile_errors()
{
    link_errors_exist $1 && return 1
    grep ": error: " $1
    [ "$?" = "1" ] && return 1
    echo "Sorry, I can't help with this error."
    return 0
}

linkErrorClang()
{
    grep ", referenced from:"
}

isolateUndefinedSymbolsClang()
{
    linkErrorClang | sed -e's/^ *"//' -e's/".*//' -e's/^_//'
}

linkErrorGcc()
{
    grep ": undefined reference to "
}

isolateUndefinedSymbolsGcc()
{
    linkErrorGcc | sed -e's/.*`//' -e"s/'$//"
}

linkErrorVS_C()
{
    grep "LNK2019.*symbol _"
}

linkErrorVS_Cpp()
{
    grep "LNK2019\|LNK2001" | grep ".*symbol \""
}

isolateUndefinedSymbolsVS_C()
{
    linkErrorVS_C | sed -e's/^.*symbol _/__C__/'   -e's/ referenced.*//' -e's/__C__//'
}

isolateUndefinedSymbolsVS_Cpp()
{
    linkErrorVS_Cpp | sed -e's/^.*symbol "/__CPP__/'  -e's/" .*//' -e's/__CPP__//'
}

isolate_linker_errors()
{
    input_file=$1
    must_exist $input_file
    undefines=$(mktemp)

    isolateUndefinedSymbolsGcc <$input_file >$undefines
    isolateUndefinedSymbolsClang <$input_file >>$undefines
    isolateUndefinedSymbolsVS_C <$input_file >>$undefines
    isolateUndefinedSymbolsVS_Cpp <$input_file >>$undefines
    LC_ALL=C sort $undefines | uniq >$SORTED_UNDEFINES
    echo "You have linker errors.  See '${SORTED_UNDEFINES}' for a sorted list."
    rm $undefines
}

file_empty()
{
    [ ! -s $1 ]
}

legacy_suggest()
{
    file_empty $1 && return 0
    show_noise_reduced_heading
    show_not_declared $1 && return 1
    show_missing_include_path $1 && return 1
    show_warnings $1 && return 1
    show_other_compile_errors $1 && return 1
    link_errors_exist $1 && isolate_linker_errors $1
    return 1
}

check_input()
{
	if [ "$#" == "0" ]; then
		echo "usage: $0 compiler-output-error-file"
		exit 1
	fi

	if [[ ! -e "$1" ]]; then
		echo "Error file does not exist: $1"
		exit 1
	fi
}

legacy_build_suggestion()
{
    check_input $1 && legacy_suggest $1
}

if [[ "$0" = "$BASH_SOURCE" ]]; then
    legacy_build_suggestion $1
fi
