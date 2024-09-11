#ifndef FORMAT_OUTPUT_SPY_INCLUDED
#define FORMAT_OUTPUT_SPY_INCLUDED

#include "FormatOutput.h"

int FormatOutputSpy(const char * format, ...);
void FormatOutputSpy_Create(unsigned int size);
void FormatOutputSpy_Destroy(void);
const char * FormatOutputSpy_GetOutput(void);

#endif
