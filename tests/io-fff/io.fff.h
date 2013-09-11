#include "io.h"
#include "fff.h"

FAKE_VOID_FUNCTION(IOWrite, IOAddress, IOData);
FAKE_VALUE_FUNCTION(IOData, IORead, IOAddress);
