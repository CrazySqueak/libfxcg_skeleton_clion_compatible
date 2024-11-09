
AUTOBUILD_PATH := $(abspath ../libfxcg_auto_build)
TOOL_BIN_PATH := $(AUTOBUILD_PATH)/cross/bin
LINKER_SCRIPT := $(AUTOBUILD_PATH)/build/src-libfxcg/toolchain/prizm.x  # dirty hack
GCC_PREFIX := $(TOOL_BIN_PATH)/sh3eb-elf-
LIBS_PATH := $(AUTOBUILD_PATH)/libfxcg/lib
INCLUDES_PATH := $(AUTOBUILD_PATH)/libfxcg/include

CC := $(GCC_PREFIX)gcc
CXX := $(GCC_PREFIX)g++

LIBS := -L$(LIBS_PATH) -lc -lfxcg -lgcc
INCLUDES := -I$(INCLUDES_PATH) -Icgutil

TARGET_FLAGS := -mb -m4a-nofpu -mhitachi -nostdlib
DEP_FLAGS := -MMD -MP
CFLAGS := -Os -Wall $(TARGET_FLAGS) $(INCLUDES) $(DEP_FLAGS) -ffunction-sections -fdata-sections -flto
LDFLAGS := -T$(LINKER_SCRIPT) $(TARGET_FLAGS) $(LIBS) -flto -Wl,-static -Wl,-gc-sections

APP_NAME := beep
TARGET_NAME := $(notdir $(shell pwd))

CFILES := $(wildcard src/*.c)
OBJECTS := $(patsubst %.c,%.o,$(CFILES))

all: target
target: $(TARGET_NAME).g3a
clean:
	rm -f src/*.o src/*.d
	rm -f $(TARGET_NAME).g3a $(TARGET_NAME).bin

# TODO: icon images
$(TARGET_NAME).g3a: $(TARGET_NAME).bin
	@mkdir -p $(dir $@)
	$(TOOL_BIN_PATH)/mkg3a -n basic:$(APP_NAME) $^ $@

$(TARGET_NAME).bin: $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CC) $^ $(LDFLAGS) $(LIBS) -o $@

include $(wildcard src/*.d)