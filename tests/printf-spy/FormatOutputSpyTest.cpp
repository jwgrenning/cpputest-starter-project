#include "CppUTest/TestHarness.h"

extern "C"
{
#include "FormatOutputSpy.h"
}

TEST_GROUP(FormatOutputSpy)
{
    void setup()
    {
        UT_PTR_SET(FormatOutput, FormatOutputSpy);
    }

    void teardown()
    {
        FormatOutputSpy_Destroy();
    }
};

TEST(FormatOutputSpy, Uninitialized)
{
    FormatOutput("hey, this is ignored");
    STRCMP_EQUAL("FormatOutputSpy is not initialized", FormatOutputSpy_GetOutput());
}

TEST(FormatOutputSpy, HelloWorld)
{
    FormatOutputSpy_Create(50);
    FormatOutput("Hello, %s\n", "World");
    FormatOutput("Hello, %s\n", "World");
    STRCMP_EQUAL(
        "Hello, World\n"
        "Hello, World\n"
        , FormatOutputSpy_GetOutput());
}

TEST(FormatOutputSpy, LimitTheOutputBufferSize)
{
    FormatOutputSpy_Create(4);
    FormatOutput("Hello, World\n");
    STRCMP_EQUAL("Hell", FormatOutputSpy_GetOutput());
}

TEST(FormatOutputSpy, PrintMultipleTimes)
{
    FormatOutputSpy_Create(25);
    FormatOutput("Hello");
    FormatOutput(", World\n");
    STRCMP_EQUAL("Hello, World\n", FormatOutputSpy_GetOutput());
}

TEST(FormatOutputSpy, PrintMultipleOutputsPastFull)
{
    FormatOutputSpy_Create(12);
    FormatOutput("%d", 12345);
    FormatOutput("%d", 67890);
    FormatOutput("ABCDEF");
    STRCMP_EQUAL("1234567890AB", FormatOutputSpy_GetOutput());
}



