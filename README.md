cpputest-starter-project
===========================

This paper describes how to integrate CppUTest based off-target testing with your production code using the GCC tool-chain environment.

There are two basic approaches supported here.

* Using Docker (preferred)
* Using an installed tool-chain (subject to 'works on my machine' problems)

## Docker

You can run your test without any tool-chain installed locally with docker. You need to have docker and docker-compose installed. 

### Install Docker

* For Mac: start here https://docs.docker.com/desktop/mac/install/
* For Windows: start here https://docs.docker.com/desktop/windows/install/
* For Linux: search for instructions for your system.

### The First Docker Build

With docker installed, open a command prompt in the starter project root directory and run this command:

```
docker-compose run cpputest make all
```

The first time you run you'll see

* Docker images downloaded
* CppUTest cloned, configured, built, and installed
* legacy-build cloned, and tests run
* Finally, the started project is made and provides output

Like this:

```
compiling AllTests.cpp
compiling ExampleTest.cpp
compiling MyFirstTest.cpp
compiling io_CppUMock.cpp
compiling io_CppUMockTest.cpp
compiling io.c
compiling Example.c
Building archive test-lib/libmy_component.a
a - test-obj/example-platform/io.o
a - test-obj/example-src/Example.o
Linking rename_me_tests
Running rename_me_tests
..
tests/MyFirstTest.cpp:23: error: Failure in TEST(MyCode, test1)
	Your test is running! Now delete this line and watch your test pass.

..
Errors (1 failures, 4 tests, 4 ran, 10 checks, 0 ignored, 0 filtered out, 1 ms)
```

### Using your test environment via the command line

To re-run your test build, open the cpputest environment and keep a bash shell running like this:

```
% docker-compose run --rm --entrypoint /bin/bash cpputest
Creating cpputest-starter-project_cpputest_run ... done
root@a9dfe0de546f:/home/src# 
```

Your prompt will have a different container ID than `a9dfe0de546f`.

Run make and you'll see something like this

```
root@a9dfe0de546f:/home/src# make
Running rename_me_tests
..
tests/MyFirstTest.cpp:23: error: Failure in TEST(MyCode, test1)
	Your test is running! Now delete this line and watch your test pass.

..
Errors (1 failures, 4 tests, 4 ran, 10 checks, 0 ignored, 0 filtered out, 1 ms)

make: *** [/home/cpputest/build/MakefileWorker.mk:464: all] Error 1
root@a9dfe0de546f:/home/src#
```

If you exited the docker `cpputest_test_runner` container now, the status of the last command is returned.  You would see `ERROR: 2` as the exit status.

Open your favorite editor and modify `tests/MyFirstTest.cpp`, deleting the line with `FAIL`.  Hot-key back to the bash prompt and make (\<up-arrow\> \<enter\>).  You'll see something like this:

```
root@a9dfe0de546f:/home/src# make
compiling MyFirstTest.cpp
Linking rename_me_tests
Running rename_me_tests
....
OK (4 tests, 4 ran, 9 checks, 0 ignored, 0 filtered out, 1 ms)
```

If you exited the docker `cpputest_test_runner` container now, the status of the last command is returned.  You would not see an error exit status.


### Integrate off-target testing into your development environment

Drop the whole starter project into your product source directory and evolve it into what you need.  You can give the docker container access to your source and third-party header files by adding more `volumes` like `- ./:/home/src`. That maps the current directory `./` to `/home/src` in the docker container. 


## Installed toolchain

### 1) Install gcc toolchain

**Mac and Linux**

In Mac and Linux you will need gcc, make and autotools.

**Windows Cygwin**

In windows, I find cygwin (http://www.cygwin.com/) is the least trouble,  The install may take a couple hours.  Make sure to select the ‘Devel’ package in the installer.

**Windows with Linux Virtual Machine**

(consider the docker approach)

Set up a linux virtual machine on windows is by enabling the Windows Subsytem for Linux (WSL), and then downloading your preferred linux flavor from the Windows App store (WSL setup tutorial: https://docs.microsoft.com/en-us/windows/wsl/install-win10). CppUTest can then be installed from source via the WSL / linux terminal. After CppUTest is installed the starter project can be run using WSL and a linux terminal, after the following tools have been installed in the linux terminal: gcc, make, and GNU Autotools.

### 2) Download, Install and build CppUTest

Download the latest from cpputest.org.  It is best to put it into a directory near your production code so it can be checked into your source repository.  You can also make CppUTest part of your git repo using a `git submodule`.

```
git submodule add https://github.com/cpputest/cpputest.git
```

NOTE: My starter kit is not compatible with some of the install methods described on cpputest.org. You cannot ‘apt-get install cpputest’ for use with my starter kit.  Please install it as follows:

```
cd /close-to-your-production-code/cpputest
autoreconf . -i
./configure
make tdd
```

You should see CppUTest’s tests run.  If you get build errors, they are often easy to fix by looking at the error message.  Often it is a matter of disabling some warning.  You can also check with me or the cpputest google group.  Please let me know if there is a need for a change these directions.

### 3) Define CPPUTEST_HOME

Point  CPPUTEST_HOME to the root directory of CppUTest.  If you don't, the starter project makefile will not be able to find MakefileWorker.mk and the needed include and library files.

```
export CPPUTEST_HOME=/close-to-your-production-code/cpputest
```

Under cygwin, you can use a windows environment variable.

### 4) Move the starter project

Move the starter project folder so that it is in the source repository with your production code. You want to be able to conveniently access your production code files and dependencies using relative paths.  For example /close-to-your-production-code/cpputest-starter-project. You might want to rename cpputest-starter-project to something like unit-tests once you integrate it into your repo.

### 5) Build the starter project
From a terminal window, change the directory to the root of the starter project. The same directory where this file was found. The make all.
	cd /close-to-your-production-code/cpputest-starter-project
	make all

You should see output announcing each file compiling and finally running the tests like this (don't worry if the numbers don't match):

```
compiling AllTests.cpp
compiling ExampleTest.cpp
compiling MyFirstTest.cpp
compiling io_CppUMock.cpp
compiling io_CppUMockTest.cpp
compiling io.c
compiling Example.c
Building archive test-lib/libmy_component.a
a - test-obj/example-platform/io.o
a - test-obj/example-src/Example.o
Linking rename_me_tests
Running rename_me_tests
..
tests/MyFirstTest.cpp:23: error: Failure in TEST(MyCode, test1)
	Now delete this fail and watch the test pass.

..
Errors (1 failures, 4 tests, 4 ran, 10 checks, 0 ignored, 0 filtered out, 1 ms)
```

### 6) Make MyFirstTest Fail

Edit cpputest-starter-project/tests/MyFirstTest.cpp and delete the line containing the FAIL. Watch the test pass.

```
compiling MyFirstTest.cpp
Linking rename_me_tests
Running rename_me_tests
....
OK (4 tests, 4 ran, 9 checks, 0 ignored, 0 filtered out, 1 ms)
```

6) You are ready to start your first test.  The easiest way I have found is to follow this recipe:

* [Get Your Legacy C into a Test Harness](https://wingman-sw.com/articles/tdd-legacy-c)

Keep working in small verifiable steps.  It's easier to keep your code working than to fix it after you break it!

7) Linker errors to exploding fakes.

When you get to linker errors for the code under test, go get my [exploding fakes generator](https://github.com/jwgrenning/gen-xfakes).  You can save liots of time with this simple linker-error to test stub converter.

