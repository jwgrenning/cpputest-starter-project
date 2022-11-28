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


### Initial Example Product Repo Structure

```
your-project-root
    |
    |--- /cpputest (optionally in your repo)
    |--- /include
    |--- /src
    |--- /platform
    |--- makefile # for product build
    |--- /unit-test # a.k.a the cpputest-starter-project
           |
           |--- example-include
           |--- example-src
           |--- example-platform
           |--- tests
           |--- makefile # for test-build

```

With the starter kit you have a working example.  So remember, it's easier to keep a system working than to fix after you break it.  So carefully morph the starer kit to be your own.

#### Handy things included

* A failing test, ready to help bootstrap your first test.
* Legacy build script
* Exploding fakes generator
* MockIO examples
* Fake Function Framework (FFF) examples 
* A spy implementation to override `printf` and capture printed output.

### Run the starter-project tests

There are two basic approaches supported here.

* Using Docker (preferred)
* Using an installed tool-chain (subject to 'works on my machine' problems)

----

<details>
<summary>

## Run Tests in a Docker Container (preferred)

</summary>

You can run your tests without any tool-chain installed in your local machine with docker. You will need to  install docker.  With docker, you will have an `image` of a machine that can be run in a `container`.  Think of it as a lightweight and pre-configured virtual machine.

### Install Docker

* For Mac: start here https://docs.docker.com/desktop/mac/install/
* For Windows: start here https://docs.docker.com/desktop/windows/install/
* For Linux: search for instructions for your system.

### Get or build a test-runner

You can use my pre-built test-runner docker image, or you can build your own with the provided bash scripts.  Windows users, you'll need to translate the scripts for windows. All my examples here use bash.

#### Using the pre-built test-runner docker image

Pull the `jwgrenning/cpputest-runner` docker image from docker hub.

```
sudo docker pull jwgrenning/cpputest-runner
```

#### Run the image in a container

```
cd your-project-root
./unit-tests/docker/run.sh "make -C unit-test"
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

#### What can the running docker container access?

Executing `docker/run.sh` from `your-project-root/` means that the files and directories in `your-project-root/` are visible to the docker container. You will be able to reference your files from `tests/makefile`.  Any header and source file dependencies needed by the code under test should also be accessible from `your-project-root/`. 

#### Make clean

You can make clean.

```
./your-project-root/docker/run.sh "make -C unit-test clean"
```

#### Run legacy-build

You can run the `legacy-build` script.  This script is helpful when you are dragging never tested code into the test environment. See [legacy-build](https://github.com/jwgrenning/legacy-build.git) for more information.

```
./your-project-root/docker/run.sh "legacy-build make unit-test ."
```

This runs the `legacy-build` script, which
 * runs `make`
 * from the container's `unit-test` directory,
 * with the container's `.` directory as the directory to search for missing include dependencies.

#### Open a shell prompt in the container

```
./your-project-root/docker/run.sh
```

You'll see something like this
```
root@a564a6d5ee5b:/home#
```

Note that `/home` refers to `./your-project-root/`

From the prompt, you can execute commands like this:

```
make -C unit-test
```

```
legacy-build make unit-test .
```

Runs `make` from the `unit-test` directory, and uses the current directory (`.`) as the root of the tree to search for missing include files.


#### Mount Other Directories in the Container

You can mount other directories in your container by making `docker/run.sh` your own.

Given some directory holding needed dependencies, map it into the container. 

```
DIR_ON_HOST=/some/path/to/something
DIR_IN_CONTAINER=/home/something
```

Add something like this to the `docker run` command options.  Don't forget the trailing `\` to escape the newline.

```
  --volume "${DIR_ON_HOST}":"${DIR_IN_CONTAINER}" \
```

#### Make the Docker environment your own

Now that I've got you started, you may want to make this your own.  You can modify `docker/build.sh` and `docker/run.sh` scripts as needed.  You will want to change the `TAG` if you plan on pushing your image to docker hub so you can share it between machines.

We've only scratched the surface of the Docker's capabilities.

</details>

----

<details>
<summary>

## Run Tests with an Installed Tool-Chain


</summary>


### 1) Install gcc tool-chain

**Mac and Linux**

In Mac and Linux you will need gcc, make and autotools.

**Windows Cygwin**

In windows, I find cygwin (http://www.cygwin.com/) is the least trouble,  The install may take a couple hours.  Make sure to select the ‘Devel’ package in the installer.

**Windows with Linux Virtual Machine**

(consider the docker approach)

Set up a linux virtual machine on windows is by enabling the Windows Subsytem for Linux (WSL), and then downloading your preferred linux flavor from the Windows App store (WSL setup tutorial: https://docs.microsoft.com/en-us/windows/wsl/install-win10). CppUTest can then be installed from source via the WSL / linux terminal. After CppUTest is installed the starter project can be run using WSL and a linux terminal, after the following tools have been installed in the linux terminal: gcc, make, and GNU autotools.

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

Try the legacy-build script.  It is included in the docker image.  It will help track down include dependencies and also generate exploding fakes when you get to linker errors.

</details>
