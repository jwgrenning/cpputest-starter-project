#include "io.h"

static IOData * ioBase = (IOData *)0xdeadbeef;

IOData IORead(IOAddress offset)
{
    return *(ioBase+offset);
}
void  IOWrite(IOAddress offset, IOData data)
{
    *(ioBase+offset) = data;
}
