/*
 * The purpose of this file is to:
 * 1) Show that fff can generate a .c fake
 * 2) Demonstrate how to have the fake function
 *    specs in a single fff file and use them to
 *    generate both the C declarations and
 *    definitions.
 *
 * FakeBar is included twice in the implementation file.
 * First to do the default behavior of declaring the fakes.
 * Second to define the implementations for the c file
 *
 * Note the defining of GENERATE_FAKES, and the disabling
 * of the include guards.
 *
 */
#include "FooExample.fff.h"
#define GENERATE_FAKES
#include "FooExample.fff.h"

