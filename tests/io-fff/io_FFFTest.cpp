extern "C"
{
#include "io.fff.h"
}

#include "CppUTest/TestHarness.h"


TEST_GROUP(IOReadWriteFFF)
{
    void setup()
    {
            FFF_RESET;
    }

    void teardown()
    {
    }
};

TEST(IOReadWriteFFF, IOWrite)
{
    IOWrite(99, 333);

    LONGS_EQUAL(1, IOWrite_fake.call_count);
    LONGS_EQUAL(99, IOWrite_fake.arg0_val);
    LONGS_EQUAL(333, IOWrite_fake.arg1_val);
}

TEST(IOReadWriteFFF, IORead)
{
    IORead_fake.return_val = 999;

    LONGS_EQUAL(999, IORead(99));

    LONGS_EQUAL(1, IORead_fake.call_count);
    LONGS_EQUAL(99, IORead_fake.arg0_val);
}

TEST(IOReadWriteFFF, MultipleIORead)
{
    IOData return_value_sequence[] = {1,2,3,4};
    int return_value_sequence_length = sizeof(return_value_sequence)/sizeof(IOData);
    SET_RETURN_SEQ(IORead, return_value_sequence, return_value_sequence_length);

    LONGS_EQUAL(1, IORead(10));
    LONGS_EQUAL(2, IORead(11));
    LONGS_EQUAL(3, IORead(12));
    LONGS_EQUAL(4, IORead(13));

    LONGS_EQUAL(4, IORead_fake.call_count);
    LONGS_EQUAL(10, IORead_fake.arg0_history[0]);
    LONGS_EQUAL(11, IORead_fake.arg0_history[1]);
    LONGS_EQUAL(12, IORead_fake.arg0_history[2]);
    LONGS_EQUAL(13, IORead_fake.arg0_history[3]);
}

TEST(IOReadWriteFFF, global_call_history)
{
	IOWrite(0,0);
	IOWrite(0,0);
	IORead(0);
	IOWrite(0,0);

	POINTERS_EQUAL(IOWrite, fff.call_history[0]);
	POINTERS_EQUAL(IOWrite, fff.call_history[1]);
	POINTERS_EQUAL(IORead, fff.call_history[2]);
	POINTERS_EQUAL(IOWrite, fff.call_history[3]);
	LONGS_EQUAL(4, fff.call_history_idx);
}
