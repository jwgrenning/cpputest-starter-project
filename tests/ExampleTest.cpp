#include "CppUTest/TestHarness.h"

extern "C"
{
#include "Example.h"
}

TEST_GROUP(Example)
{
    void setup()
    {
    }

    void teardown()
    {
    }
};

TEST(Example, returns_1)
{
    LONGS_EQUAL(1, example());
}

