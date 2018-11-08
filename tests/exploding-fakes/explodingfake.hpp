#ifndef EXPLODING_FAKE_HPP_INCLUDED
#define EXPLODING_FAKE_HPP_INCLUDED

#include "CppUTest/TestHarness.h"

#define EXPLODING_FAKE_FOR(f) void f() { FAIL("go write a proper stub for " #f); }
#define EXPLODING_VALUE_FAKE_FOR(return_type, f, return_value) return_type f() { FAIL("go write a proper stub for " #f); return return_value; }
#define SIMPLE_VOID_FAKE_FOR(f) void f() {}
#define SIMPLE_VALUE_FAKE_FOR(return_type, f, return_value) return_type f() { return return_value; }

#endif
