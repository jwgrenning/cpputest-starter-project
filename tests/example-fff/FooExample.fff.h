#include "FooExample.h"
#include "fff.h"
/*
 * Specify the fake functions you want in a header file like this one.
 *
 * Using this form of header, the file will be included once in the test case file, and
 */

FAKE_VOID_FUNCTION(voidfoo0);
FAKE_VOID_FUNCTION(voidfoo1, int);
FAKE_VOID_FUNCTION(voidfoo2, int, double);
FAKE_VOID_FUNCTION(voidfoo3, int, double, const char *);
//...
FAKE_VOID_FUNCTION(voidfoo9, int, int, int, int, int, int, int, int, mytype *);

FAKE_VALUE_FUNCTION(int, intfoo0);
FAKE_VALUE_FUNCTION(int, intfoo1, int);
FAKE_VALUE_FUNCTION(int, intfoo2, int, int);
FAKE_VALUE_FUNCTION(int, intfoo3, int, int, int);
//...
FAKE_VALUE_FUNCTION(int, intfoo9, int, int, int, int, int, int, int, int, mytype *);
