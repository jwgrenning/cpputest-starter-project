cpputest-starter-project
===========================

The cpputest-starter-project can help you integrate CppUTest based off-target testing with your production code.

### Integrate off-target testing into your development environment

Drop the whole starter project into your product source directory and evolve it into what you need.  You can clone or download this repo into your production code directory structure.  You will need to access your files from the `makefile` in the starter-kit directory using relative directory paths.

Clone the starter-kit like this:

```
cd <production-code-dir-root>
git clone https://github.com/jwgrenning/cpputest-starter-project unit-tests
```
Once you have a test running, check this into your repo.

You will find a some helpful examples in the starter kit.  Eventually, you'll probably toss the starter-kit examples because you'll have your own.

#### Handy things included

* A failing test, ready to help bootstrap your first test.
* Legacy build script
* Exploding fakes generator
* MockIO examples
* Fake Function Framework (FFF) examples 
* A spy implementation to override `printf` and capture printed output.

### Run your tests off-target

There are two basic approaches supported here.

* Using Docker (preferred)
* Using an installed tool-chain (subject to 'works on my machine' problems)

  You can give the docker container access to your source and third-party header files by adding more `volumes` like `- ./:/home/src`. That maps the current directory `./` to `/home/src` in the docker container. 

----

<details>
<summary>

## Docker (preferred)

</summary>

You can run your tests without any tool-chain installed in your local machine with docker. You need to have docker installed.

With docker, you will have an `image` of a machine that can be run in a `container`.

### Install Docker

* For Mac: start here https://docs.docker.com/desktop/mac/install/
* For Windows: start here https://docs.docker.com/desktop/windows/install/
* For Linux: search for instructions for your system.

### Get or build a test-runner

You can use my pre-built test-runner docker image, or you can build your own with the provided bash scripts.  Windows users, you'll need to translate the scripts for windows. All my examples here use bash.

#### Using the pre-built test-runner docker image

Pull the docker image from docker hub.

```
sudo docker pull jwgrenning/cpputest-runner
```

#### Run the image in a container

```
./docker.run.sh make
```

You'll see something like this

```
compiling AllTests.cpp
compiling ExampleTest.cpp
compiling MyFirstTest.cpp
compiling io_CppUMock.cpp
compiling io_CppUMockTest.cpp
compiling FormatOutputSpyTest.cpp
compiling FormatOutput.c
compiling FormatOutputSpy.c
compiling io.c
compiling Example.c
Building archive test-lib/libyour.a
a - test-obj/example-platform/io.o
a - test-obj/example-src/Example.o
Linking your_tests
Running your_tests
.......
tests/MyFirstTest.cpp:23: error: Failure in TEST(MyCode, test1)
	Your test is running! Now delete this line and watch your test pass.

..
Errors (1 failures, 9 tests, 9 ran, 15 checks, 0 ignored, 0 filtered out, 1 ms)

make: *** [/home/cpputest/build/MakefileWorker.mk:458: all] Error 1
```

You are ready to write your first test!

#### Other test runner options

You can make clean, note the quotes for multiple word commands.

```
./docker/run.sh "make clean"
```

You can run [legacy-build](https://github.com/jwgrenning/legacy-build.git).  This script is helpful when you are dragging never tested code into the test environment.

```
./docker/run.sh legacy-build
```

You can run without parameters to get to the command line.  The current directory is mounted in the container.

```
./docker/run.sh legacy-build
```

You can mount other directories in your container by editing `docker/run.sh`.

Given some directory holding needed dependencies, map it into the containter.

```
DIR_ON_HOST=/some/path/to/something
DIR_IN_CONTAINER=/something
```

Add something like this to the `docker run` command options.  Don't forget the trailing `\` to escape the newline.

```
  --volume "${DIR_ON_HOST}":"${DIR_IN_CONTAINER}" \
```

#### Build your own docker image

Now that I've got you started, you may want to make this your own.  You can modify `docker/build.sh` and `docker/run.sh` scripts as needed.  You will probably want to change the `TAG` if you plan on pushing your image to docker hub so you can share it between machines.

</details>

----

<details>
<summary>

## Use an Installed toolchain


</summary>


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

### 4) Build the starter project

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
compiling FormatOutputSpyTest.cpp
compiling FormatOutput.c
compiling FormatOutputSpy.c
compiling io.c
compiling Example.c
Building archive test-lib/libyour.a
a - test-obj/example-platform/io.o
a - test-obj/example-src/Example.o
Linking your_tests
Running your_tests
.......
tests/MyFirstTest.cpp:23: error: Failure in TEST(MyCode, test1)
	Your test is running! Now delete this line and watch your test pass.

..
Errors (1 failures, 9 tests, 9 ran, 15 checks, 0 ignored, 0 filtered out, 1 ms)

make: *** [/home/cpputest/build/MakefileWorker.mk:458: all] Error 1
```

</details>

----

<details>
<summary>

## Make MyFirstTest Pass

</summary>

Edit cpputest-starter-project/tests/MyFirstTest.cpp and delete the line containing the FAIL. Watch the test pass.

```
compiling MyFirstTest.cpp
Linking your_tests
Running your_tests
.........
OK (9 tests, 9 ran, 14 checks, 0 ignored, 0 filtered out, 0 ms)
```

You are ready to start your first test.  The easiest way I have found is to follow this recipe:

* [Get Your Legacy C into a Test Harness](https://wingman-sw.com/articles/tdd-legacy-c)

On that page you'll find the recipe and a number of articles of specific problems you may run into.

Keep working in small verifiable steps.  **It's easier to keep your code working than to fix it after you break it!**

Try the legacy-build script.  It is included in the docker image.  It will help track down r=dependencies and also generate exploding fakes when you get to linker errors.

</details>