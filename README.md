# Windows-Native and Linux/macOS-Hosted GNU Toolchain for Windows Arm64 (MinGW/Cygwin) targets

[![Weekly Build](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/actions/workflows/weekly-build.yml/badge.svg)](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/actions/workflows/weekly-build.yml)

[Experimental weekly builds](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/releases) and the scripts to build
Windows-native and Linux/macOS-hosted GNU Toolchain for Windows Arm64, targeting
MinGW (`aarch64-w64-mingw32`) and Cygwin (`aarch64-pc-cygwin`), built on hosts
such as (`aarch64-w64-mingw32`, `x86_64-pc-linux-gnu`, `aarch64-pc-linux-gnu`,
`arm64-apple-darwin*` or others). The resulting toolchain produces binaries
that can be run on Windows Arm64. It is a **work in progress**.

# Toolchain status

|Target|Host|Status|
|:-|:-|:-|
|aarch64-w64-mingw32|aarch64-unknown-linux-gnu|[Available](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/releases)|
|aarch64-w64-mingw32|arm64-apple-darwin|[Available](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/releases)|
|aarch64-w64-mingw32|native|Work in progress|
|aarch64-pc-cygwin|aarch64-unknown-linux-gnu|Work in progress|
|aarch64-pc-cygwin|arm64-apple-darwin|Work in progress|
|aarch64-pc-cygwin|native|Work in progress|

# Issues

Please report issues [here](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/issues),
including those specific to Binutils/GCC/MinGW/Cygwin.

# Building the Cross-Toolchain

To build the cross-toolchain and install it into a
`~/install/toolchains/<host name>/aarch64-w64-mingw32-msvcrt` folder, run the
build script:

```bash
./build.sh
```

The toolchain uses the `aarch64-w64-mingw32` target by default. The `PLATFORM`
variable should be specified to change the target to `aarch64-pc-cygwin`.
```bash
PLATFORM=pc-cygwin ./build.sh
```

To install the toolchain into a different folder `TOOLCHAIN_PATH` environment
variable should be used:
```bash
TOOLCHAIN_PATH=/opt/aarch64-w64-mingw32 ./build.sh
```

To skip the dependencies bootstrapping process and fetching source code
repositories for consecutive builds `RUN_BOOTSTRAP` and `UPDATE_SOURCES`
environment variables should be used:
```bash
RUN_BOOTSTRAP=0 UPDATE_SOURCES=0 ./build.sh
```

The build script does multiple things:

- Installs the dependency Ubuntu packages.
- Clones several dependency source code repositories:
  - Binutils from [upstream](https://sourceware.org/git/?p=binutils-gdb.git;a=shortlog;h=refs/heads/master),
  - GCC from [upstream](https://gcc.gnu.org/git/?p=gcc.git;a=shortlog;h=refs/heads/master),
  - MinGW from [upstream](https://sourceforge.net/p/mingw-w64/mingw-w64/ci/master/log/?path).
  - Cygwin from [upstream](https://cygwin.com/cgit/newlib-cygwin/log/?h=master).
- Bootstraps the binutils and GCC sources with `gmp`, `mpfr`, `isl`, etc.
  dependencies.
- Builds and installs binutils, stage 1 GCC, MinGW runtimes, GCC with libgcc,
  and then the entire MinGW.

# Using the Cross-Compiler

After building the toolchain, to build a simple C source code file run:
```bash
source ~/install/toolchains/<host name>/aarch64-w64-mingw32-msvcrt/toolchain.sh --activate
aarch64-w64-mingw32-gcc hello.c -o hello.exe
```

To build a set of basic AArch64-specific tests:
```bash
.github/scripts/tests/build.sh
```

The test script requires a working CMake executable in the environment and will
place the resulting binaries into the `tests/build/bin` folder.

# Installing Build Dependencies

The [main build script](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/blob/master/build.sh)
installs its dependencies automatically when the `RUN_BOOTSTRAP=1` environment
variable is defined, which is the default. To see what will be installed refer
to
[`.github/scripts/install-dependencies.sh`](https://github.com/arm/gnu-toolchain-for-windows-on-arm64/blob/master/.github/scripts/install-dependencies.sh).

# Building the Native GNU Toolchain for Windows Arm64

**Work in progress**
