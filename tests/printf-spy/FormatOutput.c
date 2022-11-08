//- Copyright (c) 2008-2020 James Grenning --- All rights reserved
//- For exclusive use by participants in Wingman Software training courses.
//- Cannot be used by attendees to train others without written permission.
//- www.wingman-sw.com james@wingman-sw.com

#include "FormatOutput.h"
#include <stdio.h>

int (*FormatOutput)(const char * format, ...) = printf;
