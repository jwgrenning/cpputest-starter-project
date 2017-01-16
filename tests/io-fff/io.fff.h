#include "io.h"
#include "fff.h"

FAKE_VALUE_FUNCTION(IOData, IORead, IOAddress);
FAKE_VOID_FUNCTION(IOWrite, IOAddress, IOData);
