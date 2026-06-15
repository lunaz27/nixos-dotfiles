# NOTE: Cheatsheet: https://devhints.io/makefile

CXX = g++
CXX_FLAGS= -Iinclude -MMD -Wall -Wextra -pedantic -Wshadow
# CXX_FLAGS=--std=<here>  -Iinclude -MMD -Wall -Wextra -pedantic -Wshadow
LDFLAGS =
GTEST_FLAGS = -I$(GTEST_INCLUDE) -L$(GTEST_LIB) -lgtest_main -lgtest -pthread

BUILD_TYPE ?= release
BUILD_DIR = build/$(BUILD_TYPE)
ifeq ($(BUILD_TYPE), asan)
	CXX_FLAGS += -g -O0 -fsanitize=address -fno-omit-frame-pointer
	LDFLAGS += -fsanitize=address
else ifeq ($(BUILD_TYPE), debug)
	CXX_FLAGS += -g
else # release
	# CXX_FLAGS += -O<?>
endif

SRC = $(wildcard src/*.cpp)
OBJ = $(patsubst src/%.cpp, $(BUILD_DIR)/%.o, $(SRC))
DEP = $(OBJ:%.o=%.d)
OBJ_NO_MAIN = $(filter-out $(BUILD_DIR)/main.o, $(OBJ))
TEST_SRC = $(wildcard tests/test*.cpp)

BIN = $(BUILD_DIR)/main
TEST_BIN = $(BUILD_DIR)/testRunner

all: $(BIN)

$(BIN): $(OBJ)
	@echo "  LD      $@"
	@$(CXX) -o $@ $^ $(LDFLAGS)

$(BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p $(BUILD_DIR)
	@echo "  CXX     $@"
	@$(CXX) $(CXX_FLAGS) -c -o $@ $<

$(TEST_BIN): $(OBJ_NO_MAIN) $(TEST_SRC)
	@mkdir -p $(BUILD_DIR)
	@echo "  CXX     $@"
	@$(CXX) $(CXX_FLAGS) $^ $(GTEST_FLAGS) $(LDFLAGS) -o $@

clean:
	@echo "  CLEAN   build/"
	@rm -rf build

-include $(DEP)

.PHONY: all clean
