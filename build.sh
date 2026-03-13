#!/bin/bash
set -e

mkdir -p bin/output
mkdir -p bin/system/hardware/CPU/amd
mkdir -p bin/system/hardware/CPU/intel
mkdir -p bin/utils

gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/output/cpu_info.c -o bin/output/cpu_info.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/amd/microarch.c -o bin/system/hardware/CPU/amd/microarch.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/amd/processors.c -o bin/system/hardware/CPU/amd/processors.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/intel/mircoarch.c -o bin/system/hardware/CPU/intel/mircoarch.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/intel/processors.c -o bin/system/hardware/CPU/intel/processors.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/affinity.c -o bin/system/hardware/CPU/affinity.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/cpu.c -o bin/system/hardware/CPU/cpu.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/cpuid.c -o bin/system/hardware/CPU/cpuid.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/features.c -o bin/system/hardware/CPU/features.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/system/hardware/CPU/virtualisation.c -o bin/system/hardware/CPU/virtualisation.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/utils/arguments.c -o bin/utils/arguments.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/utils/common.c -o bin/utils/common.o
gcc $PROGRAM_COMPAT_COMPILER_FLAGS -Iinclude src/main.c -o bin/main.o

ld -r \
bin/output/cpu_info.o \
bin/system/hardware/CPU/amd/microarch.o \
bin/system/hardware/CPU/amd/processors.o \
bin/system/hardware/CPU/intel/mircoarch.o \
bin/system/hardware/CPU/intel/processors.o \
bin/system/hardware/CPU/affinity.o \
bin/system/hardware/CPU/cpu.o \
bin/system/hardware/CPU/cpuid.o \
bin/system/hardware/CPU/features.o \
bin/system/hardware/CPU/virtualisation.o \
bin/utils/arguments.o \
bin/utils/common.o \
bin/main.o \
-o bin/final.o

nm bin/final.o > bin/specseek.sym

ld $PROGRAM_COMPAT_LINKER_FLAGS bin/final.o -o bin/specseek.nxe
