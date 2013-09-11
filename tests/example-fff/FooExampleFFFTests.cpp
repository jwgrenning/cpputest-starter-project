#include "CppUTest/TestHarness.h"

extern "C"
{
#include "FooExample.fff.h"
}

TEST_GROUP(fff_foo)
{
    void setup()
    {
        FFF_RESET;
    }

    void teardown()
    {
    }
};

TEST(fff_foo, function_call_count_is_zero_after_init)
{
    LONGS_EQUAL(0, voidfoo0_fake.call_count);
}

TEST(fff_foo, fake_a_void_function_with_no_parameters)
{
    voidfoo0();
    voidfoo0();
    LONGS_EQUAL(2, voidfoo0_fake.call_count);
}

TEST(fff_foo, fake_a_void_function_with_parameters)
{
    voidfoo3(42, 3.1415926, "hello world");
    LONGS_EQUAL(1, voidfoo3_fake.call_count);
    LONGS_EQUAL(42, voidfoo3_fake.arg0_val);
    DOUBLES_EQUAL(3.1415926, voidfoo3_fake.arg1_val, 0.00000001);
    STRCMP_EQUAL("hello world", voidfoo3_fake.arg2_val);
}

TEST(fff_foo, fake_a_void_function_with_parameter_history)
{
    voidfoo3(42, 3.1415926, "hello world");
    voidfoo3(43, 2.17, "goodbye world");
    LONGS_EQUAL(2, voidfoo3_fake.call_count);
    LONGS_EQUAL(42, voidfoo3_fake.arg0_history[0]);
    DOUBLES_EQUAL(3.1415926, voidfoo3_fake.arg1_history[0], 0.00000001);
    STRCMP_EQUAL("hello world", voidfoo3_fake.arg2_history[0]);
    LONGS_EQUAL(43, voidfoo3_fake.arg0_history[1]);
    DOUBLES_EQUAL(2.17, voidfoo3_fake.arg1_history[1], 0.00000001);
    STRCMP_EQUAL("goodbye world", voidfoo3_fake.arg2_history[1]);
}

TEST(fff_foo, look_at_a_functions_call_history)
{
    voidfoo1(42);
    voidfoo1(43);
    voidfoo1(44);
    LONGS_EQUAL(42, voidfoo1_fake.arg0_history[0]);
    LONGS_EQUAL(43, voidfoo1_fake.arg0_history[1]);
    LONGS_EQUAL(44, voidfoo1_fake.arg0_history[2]);
    LONGS_EQUAL( 0, voidfoo1_fake.arg0_history[3]);
}

TEST(fff_foo, global_call_history_is_empty_after_init)
{
    POINTERS_EQUAL(0, fff.call_history[0]);
    LONGS_EQUAL(0, fff.call_history_idx);
}

TEST(fff_foo, look_at_the_global_call_history)
{
    voidfoo1(42);
    voidfoo2(43, 3.14159265);
    voidfoo3(43, 3.14159265, "hey");
    POINTERS_EQUAL(voidfoo1, fff.call_history[0]);
    POINTERS_EQUAL(voidfoo2, fff.call_history[1]);
    POINTERS_EQUAL(voidfoo3, fff.call_history[2]);
    POINTERS_EQUAL(       0, fff.call_history[3]);
}

TEST(fff_foo, value_returning_function)
{
    LONGS_EQUAL(0, intfoo0());
    intfoo0_fake.return_val = 999;
    LONGS_EQUAL(999, intfoo0());
    LONGS_EQUAL(2, intfoo0_fake.call_count);
}

TEST(fff_foo, specify_a_sequence_of_return_values)
{
    int return_value_sequence[] = {0,1,2,3};
    int return_value_sequence_length = sizeof(return_value_sequence)/sizeof(int);
    SET_RETURN_SEQ(intfoo0, return_value_sequence, return_value_sequence_length);
    LONGS_EQUAL(0, intfoo0());
    LONGS_EQUAL(1, intfoo0());
    LONGS_EQUAL(2, intfoo0());
    LONGS_EQUAL(3, intfoo0());
    LONGS_EQUAL(3, intfoo0());
    LONGS_EQUAL(3, intfoo0());
    LONGS_EQUAL(6, intfoo0_fake.call_count);
}


TEST(fff_foo, specify_a_sequence_of_return_values_but_keep_calling)
{
    int return_value_sequence[] = {0,99};
    int return_value_sequence_length = sizeof(return_value_sequence)/sizeof(int);
    SET_RETURN_SEQ(intfoo0, return_value_sequence, return_value_sequence_length);
    LONGS_EQUAL(0, intfoo0());
    LONGS_EQUAL(99, intfoo0());
    LONGS_EQUAL(99, intfoo0());
    LONGS_EQUAL(3, intfoo0_fake.call_count);
}

static int myFakeCalled;
int my_intfoo0(void)
{

    myFakeCalled++;
    return 42;
}

TEST(fff_foo, provide_a_custom_fake_that_i)
{
    myFakeCalled = 0;
    intfoo0_fake.return_val = -9999;
    intfoo0_fake.custom_fake = my_intfoo0;
    LONGS_EQUAL(42, intfoo0());
    LONGS_EQUAL(1, intfoo0_fake.call_count);
    LONGS_EQUAL(1, myFakeCalled);
}

