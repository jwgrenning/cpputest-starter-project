#include "FormatOutput.h"
#include <stdio.h>

int (*FormatOutput)(const char * format, ...) = printf;
