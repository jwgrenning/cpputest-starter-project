//- Copyright (c) 2008-2020 James Grenning --- All rights reserved
//- For exclusive use by participants in Wingman Software training courses.
//- Cannot be used by attendees to train others without written permission.
//- www.wingman-sw.com james@wingman-sw.com

#include "FormatOutputSpy.h"
#include "CppUTest/TestHarness_c.h"
#include "CppUTest/PlatformSpecificFunctions_c.h"
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

static char * buffer = 0;
static unsigned int buffer_size = 0;
static unsigned int buffer_offset = 0;
static unsigned int buffer_used = 0;


void FormatOutputSpy_Create(unsigned int size)
{
    FormatOutputSpy_Destroy();
    buffer_size = size+1;
    buffer = (char *)calloc((size_t)buffer_size, sizeof(char));
    buffer_offset = 0;
    buffer_used = 0;
    buffer[0] = '\0';
}

void FormatOutputSpy_Destroy(void)
{
    if (buffer == 0)
        return;

    free(buffer);
    buffer = 0;
}

int FormatOutputSpy(const char * format, ...)
{
    int written_size;
    va_list arguments;

    if (buffer == 0)
    {
        return 0;
    }

    va_start(arguments, format);
    written_size = PlatformSpecificVSNprintf(buffer + buffer_offset,
                buffer_size - buffer_used, format, arguments);
    buffer_offset += (unsigned int)written_size;
    buffer_used += (unsigned int)written_size;
    va_end(arguments);
    return 1;
}

const char * FormatOutputSpy_GetOutput(void)
{
    if (buffer == 0)
        return "FormatOutputSpy is not initialized";
    return buffer;
}
