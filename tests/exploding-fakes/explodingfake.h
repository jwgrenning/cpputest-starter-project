#ifndef EXPLODING_FAKE_INCLUDED
#define EXPLODING_FAKE_INCLUDED

#include "CppUTest/TestHarness_c.h"

#define EXPLODING_FAKE_FOR(f) void f() { FAIL_TEXT_C("go write a proper stub for " #f); }
#define SIMPLE_VOID_FAKE_FOR(f) void f() {}
#define SIMPLE_VALUE_FAKE_FOR(return_type, f, return_value) return_type f() { return return_value; }

#endif
