#ifndef EXPLODING_FAKE_INCLUDED
#define EXPLODING_FAKE_INCLUDED

#include "CppUTest/TestHarness_c.h"

#define EXPLODING_FAKE_FOR(f) void f() { FAIL_TEXT_C("go write a proper stub for " #f); }

#endif
