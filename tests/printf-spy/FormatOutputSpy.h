//- Copyright (c) 2008-2020 James Grenning --- All rights reserved
//- For exclusive use by participants in Wingman Software training courses.
//- Cannot be used by attendees to train others without written permission.
//- www.wingman-sw.com james@wingman-sw.com

#ifndef FORMAT_OUTPUT_SPY_INCLUDED
#define FORMAT_OUTPUT_SPY_INCLUDED

#include "FormatOutput.h"

int FormatOutputSpy(const char * format, ...);
void FormatOutputSpy_Create(unsigned int size);
void FormatOutputSpy_Destroy(void);
const char * FormatOutputSpy_GetOutput(void);

#endif
