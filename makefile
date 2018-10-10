#Set this to @ to keep the makefile quiet
SILENCE = @

#---- Outputs ----#
COMPONENT_NAME = example

#--- Inputs ----#
PROJECT_HOME_DIR = .
ifeq "$(CPPUTEST_HOME)" ""
    CPPUTEST_HOME = ~/tools/cpputest
endif

# --- SRC_FILES ---
# Use SRC_FILES to specifiy individual production
# code files.
# These files are compiled and put into the
# a library and links with the test runner.
# This is so that test code can override production code at link time.
SRC_FILES += example-src/Example.c

# --- SRC_DIRS ---
# Use SRC_DIRS to specifiy production directories
# code files.
# These files are compiled and put into a the
# ProductionCode library and links with the test runner
SRC_DIRS += example-platform

# --- TEST_SRC_FILES ---
# TEST_SRC_FILES specifies individual test files to build.  Test
# files are always included in the build and they
# pull in production code from the library
TEST_SRC_FILES +=

# --- TEST_SRC_DIRS ---
# Like TEST_SRC_FILES, but biulds everyting in the directory
TEST_SRC_DIRS += tests
TEST_SRC_DIRS += tests/io-cppumock
TEST_SRC_DIRS += tests/exploding-fakes
TEST_SRC_DIRS += tests/exploding-fakes

#	tests/example-fff \
#	tests/fff \
# --- MOCKS_SRC_DIRS ---
# MOCKS_SRC_DIRS specifies a directories where you can put your
# mocks, stubs and fakes.  You can also just put them
# in TEST_SRC_DIRS
MOCKS_SRC_DIRS +=

# Turn on CppUMock
CPPUTEST_USE_EXTENSIONS = Y

INCLUDE_DIRS += $(CPPUTEST_HOME)/include
INCLUDE_DIRS += $(CPPUTEST_HOME)/include/Platforms/Gcc
INCLUDE_DIRS += example-include
INCLUDE_DIRS += example-fff
INCLUDE_DIRS += tests/exploding-fakes
INCLUDE_DIRS += tests/fff


# --- CPPUTEST_OBJS_DIR ---
# if you have to use "../" to get to your source path
# the makefile will put the .o and .d files in surprising
# places.
# To make up for each level of "../", add place holder
# sub directories in CPPUTEST_OBJS_DIR
# each "../".  It is kind of a kludge, but it causes the
# .o and .d files to be put under objs.
# e.g. if you have "../../src", set to "test-objs/1/2"
# This is set no "../" in the source path.
CPPUTEST_OBJS_DIR = test-obj

CPPUTEST_LIB_DIR = test-lib

# You may have to tweak these compiler flags
#    CPPUTEST_WARNINGFLAGS - apply to C and C++
#    CPPUTEST_CFLAGS - apply to C files only
#    CPPUTEST_CXXFLAGS - apply to C++ files on;y
#    CPPUTEST_CPPFLAGS - apply to C and C++ Pre-Processor
#
# If you get an error like this
#     TestPlugin.h:93:59: error: 'override' keyword is incompatible
#        with C++98 [-Werror,-Wc++98-compat] ...
# The compiler is basically telling you how to fix the
# build problem.  You would add this flag setting
#     CPPUTEST_CXXFLAGS += -Wno-c++14-compat




ifeq ($(shell $(CC) -v 2>&1 | grep -c "clang"), 1)
CPPUTEST_WARNINGFLAGS += -Wno-unknown-warning-option
CPPUTEST_WARNINGFLAGS += -Wno-covered-switch-default
CPPUTEST_WARNINGFLAGS += -Wno-reserved-id-macro
CPPUTEST_WARNINGFLAGS += -Wno-keyword-macro
CPPUTEST_WARNINGFLAGS += -Wno-documentation
CPPUTEST_WARNINGFLAGS += -Wno-missing-noreturn
endif

CPPUTEST_WARNINGFLAGS += -Wall
CPPUTEST_WARNINGFLAGS += -Werror
CPPUTEST_WARNINGFLAGS += -Wfatal-errors
CPPUTEST_WARNINGFLAGS += -Wswitch-default
CPPUTEST_WARNINGFLAGS += -Wno-format-nonliteral
CPPUTEST_WARNINGFLAGS += -Wno-sign-conversion
CPPUTEST_WARNINGFLAGS += -Wno-pedantic
CPPUTEST_WARNINGFLAGS += -Wno-shadow
CPPUTEST_WARNINGFLAGS += -Wno-missing-field-initializers
CPPUTEST_WARNINGFLAGS += -Wno-unused-parameter
CPPUTEST_CFLAGS += -Wall
CPPUTEST_CFLAGS += -pedantic
CPPUTEST_CFLAGS += -Wno-missing-prototypes
CPPUTEST_CFLAGS += -Wno-strict-prototypes
CPPUTEST_CXXFLAGS += -Wno-c++14-compat
CPPUTEST_CXXFLAGS += --std=c++11
CPPUTEST_CXXFLAGS += -Wno-c++98-compat-pedantic
CPPUTEST_CXXFLAGS += -Wno-c++98-compat

# --- LD_LIBRARIES -- Additional needed libraries can be added here.
# commented out example specifies math library
#LD_LIBRARIES += -lm

# Look at $(CPPUTEST_HOME)/build/MakefileWorker.mk for more controls

include $(CPPUTEST_HOME)/build/MakefileWorker.mk
