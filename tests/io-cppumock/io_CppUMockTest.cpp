
#include "CppUTest/TestHarness.h"
#include "CppUTestExt/MockSupport.h"

extern "C"
{
#include "io.h"
}

TEST_GROUP(IOReadWrite_CppUMockTest)
{
    void setup()
    {
    }

    void teardown()
    {
        mock("IO").checkExpectations();
        mock().clear();
    }
};

TEST(IOReadWrite_CppUMockTest, IOWrite)
{
    mock("IO")
        .expectOneCall("IOWrite")
        .withParameter("addr", 0x1000)
        .withParameter("data", 0xa000);

    IOWrite(0x1000, 0xa000);
}

TEST(IOReadWrite_CppUMockTest, IORead)
{
    mock("IO")
        .expectOneCall("IORead")
        .withParameter("addr", 1000)
        .andReturnValue(55);

    LONGS_EQUAL(55, IORead(1000));
}
