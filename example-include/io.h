//- Copyright (c) 2008-20012 James Grenning
//- All rights reserved
//- For use by participants in James' training courses.

#ifndef IO_READ_WRITE_INCLUDED
#define IO_READ_WRITE_INCLUDED

#include <stdint.h>

typedef uint32_t  IOAddress;
typedef uint16_t IOData;

IOData IORead(IOAddress offset);
void  IOWrite(IOAddress offset, IOData data);

#endif

//Original code thanks to STMicroelectronics.

