#
# Target Output Details
#
ELF_TARGET_32 = specseek_32
ELF_TARGET_64 = specseek_64
WINDOWS_TARGET_32 = specseek_32.exe
WINDOWS_TARGET_64 = specseek_64.exe

#
# Compilers for Differing Targets
#
CC ?= gcc

MINGW_32 = i686-w64-mingw32-gcc
MINGW_64 = x86_64-w64-mingw32-gcc

#
# Flag Options for Compilers
#
CFLAGS ?=
COMMON_CFLAGS = -static -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-but-set-parameter -Wno-unused-parameter -O2 -I include

#
# Runtime arguments
#
RUN_ARGS ?= --verbose 2

#
# Output directories as variables
#
ELF_BIN_DIR_32 = bin/elf/32
ELF_BIN_DIR_64 = bin/elf/64
ELF_OBJ_DIR_32 = $(ELF_BIN_DIR_32)/obj
ELF_OBJ_DIR_64 = $(ELF_BIN_DIR_64)/obj

WIN_BIN_DIR_32 = bin/win/32
WIN_BIN_DIR_64 = bin/win/64
WIN_OBJ_DIR_32 = $(WIN_BIN_DIR_32)/obj
WIN_OBJ_DIR_64 = $(WIN_BIN_DIR_64)/obj

#
# Detect Source files in Code, this is very broad
# and will just compile anything it finds
#
SRCS = $(shell find src -name '*.c')

#
# Object files per arch
#
ELF_OBJS_32 = $(patsubst src/%.c, $(ELF_OBJ_DIR_32)/%.gcc.o, $(SRCS))
ELF_OBJS_64 = $(patsubst src/%.c, $(ELF_OBJ_DIR_64)/%.gcc.o, $(SRCS))

WIN_OBJS_32 = $(patsubst src/%.c, $(WIN_OBJ_DIR_32)/%.win.o, $(SRCS))
WIN_OBJS_64 = $(patsubst src/%.c, $(WIN_OBJ_DIR_64)/%.win.o, $(SRCS))

#
# Default Command (no args) Build all 4 binaries
#
all: $(ELF_TARGET_32) $(ELF_TARGET_64) $(WINDOWS_TARGET_32) $(WINDOWS_TARGET_64)

#
# Linux 32-bit build
#
$(ELF_TARGET_32): $(ELF_OBJS_32)
	@mkdir -p $(ELF_BIN_DIR_32)
	$(CC) $(COMMON_CFLAGS) $(CFLAGS) -m32 -o $(ELF_BIN_DIR_32)/$(ELF_TARGET_32) $^

#
# Linux 64-bit build
#
$(ELF_TARGET_64): $(ELF_OBJS_64)
	@mkdir -p $(ELF_BIN_DIR_64)
	$(CC) $(COMMON_CFLAGS) $(CFLAGS) -m64 -o $(ELF_BIN_DIR_64)/$(ELF_TARGET_64) $^

#
# Windows 32-bit build
#
$(WINDOWS_TARGET_32): $(WIN_OBJS_32)
	@mkdir -p $(WIN_BIN_DIR_32)
	$(MINGW_32) $(COMMON_CFLAGS) $(CFLAGS) -o $(WIN_BIN_DIR_32)/$(WINDOWS_TARGET_32) $^

#
# Windows 64-bit build
#
$(WINDOWS_TARGET_64): $(WIN_OBJS_64)
	@mkdir -p $(WIN_BIN_DIR_64)
	$(MINGW_64) $(COMMON_CFLAGS) $(CFLAGS) -o $(WIN_BIN_DIR_64)/$(WINDOWS_TARGET_64) $^

#
# Object build rules per architecture
#
$(ELF_OBJ_DIR_32)/%.gcc.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) $(COMMON_CFLAGS) $(CFLAGS) -m32 -c $< -o $@

$(ELF_OBJ_DIR_64)/%.gcc.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) $(COMMON_CFLAGS) $(CFLAGS) -m64 -c $< -o $@

$(WIN_OBJ_DIR_32)/%.win.o: src/%.c
	@mkdir -p $(dir $@)
	$(MINGW_32) $(COMMON_CFLAGS) $(CFLAGS) -c $< -o $@

$(WIN_OBJ_DIR_64)/%.win.o: src/%.c
	@mkdir -p $(dir $@)
	$(MINGW_64) $(COMMON_CFLAGS) $(CFLAGS) -c $< -o $@


run: $(ELF_TARGET_64)
	@./$(ELF_BIN_DIR_64)/$(ELF_TARGET_64) $(RUN_ARGS)

#
# Clean
#
clean:
	rm -rf bin
	rm -rf .vscode

.PHONY: all clean run debug
