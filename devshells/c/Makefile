# NOTE: Cheatsheet: https://devhints.io/makefile

CC = gcc
C_FLAGS= -Iinclude -MMD -Wall -Wextra -Wshadow
# C_FLAGS=--std=<here> -Iinclude -MMD -Wall -Wextra -pedantic -Wshadow
LD_FLAGS =
CRITERION_FLAGS = -I$(CRITERION_INCLUDE) -L$(CRITERION_LIB) -lcriterion

BUILD_TYPE ?= release
BUILD_DIR = build/$(BUILD_TYPE)
ifeq ($(BUILD_TYPE), asan)
	C_FLAGS += -g -O0 -fsanitize=address -fno-omit-frame-pointer -fno-common
	LD_FLAGS += -fsanitize=address
else ifeq ($(BUILD_TYPE), debug)
	C_FLAGS += -g
else # release
	# C_FLAGS += -O<?>
endif

SRC = $(wildcard src/*.c)
OBJ = $(patsubst src/%.c, $(BUILD_DIR)/%.o, $(SRC))
DEP = $(OBJ:%.o=%.d)
OBJ_NO_MAIN = $(filter-out $(BUILD_DIR)/main.o, $(OBJ))
TEST_SRC = $(wildcard tests/test_*.c)

BIN = $(BUILD_DIR)/main
TEST_BIN = $(BUILD_DIR)/test_runner

all: $(BIN)

$(BIN): $(OBJ)
	@echo "  LD      $@"
	@$(CC) -o $@ $^ $(LD_FLAGS)

$(BUILD_DIR)/%.o: src/%.c
	@mkdir -p $(BUILD_DIR)
	@echo "  CC      $@"
	@$(CC) $(C_FLAGS) -c -o $@ $<

$(TEST_BIN): $(OBJ_NO_MAIN) $(TEST_SRC)
	@mkdir -p $(BUILD_DIR)
	@echo "  CC      $@"
	@$(CC) $(C_FLAGS) $^ $(CRITERION_FLAGS) $(LD_FLAGS) -o $@

clean:
	@echo "  CLEAN   build/"
	@rm -rf build

-include $(DEP)

.PHONY: all clean
