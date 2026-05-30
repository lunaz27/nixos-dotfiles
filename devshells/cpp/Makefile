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

EXE = $(BUILD_DIR)/main
TEST_EXE = $(BUILD_DIR)/testRunner
ARGS ?=

all: $(EXE)

release:
	@$(MAKE) --no-print-directory BUILD_TYPE=release all

debug:
	@$(MAKE) --no-print-directory BUILD_TYPE=debug all

asan:
	@$(MAKE) --no-print-directory BUILD_TYPE=asan all

$(EXE): $(OBJ)
	@echo "  LD      $@"
	@$(CXX) -o $@ $^ $(LDFLAGS)

$(BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p $(BUILD_DIR)
	@echo "  CXX     $@"
	@$(CXX) $(CXX_FLAGS) -c -o $@ $<

run: $(EXE)
	@echo "  RUN     ${EXE}"
	@echo "=== RESULT ==="
	@./$(EXE) $(ARGS)
	@echo "=> Returned $$?."

asan-run:
	@$(MAKE) --no-print-directory BUILD_TYPE=asan run

$(TEST_EXE): $(OBJ_NO_MAIN) $(TEST_SRC)
	@mkdir -p $(BUILD_DIR)
	@echo "  CXX     $@"
	@$(CXX) $(CXX_FLAGS) $^ $(GTEST_FLAGS) $(LDFLAGS) -o $@

pytest: debug
	@echo "  PYTEST  tests/"
	@pytest

gtest: $(TEST_EXE)
	@echo "  GTEST   tests/"
	@./$(TEST_EXE)

report: debug
	@echo "  REPORT  tests/"
	@pytest -vvv --md-report --md-report-verbose=2 --md-report-show-duration --md-report-output=REPORT.md

valgrind: debug
	@echo "  PREP      $@"
	@echo "  VALGRIND  build/debug/$(notdir $(EXE))"
	@echo "=== RESULT ==="
	@valgrind --leak-check=full \
		--show-leak-kinds=all \
		--track-origins=yes \
		--verbose \
		--log-file=build/valgrind-out.txt \
		./build/debug/$(notdir $(EXE)) $(ARGS)
	@echo "=> Valgrind finished. Check valgrind-out.txt for the report."

clean:
	@echo "  CLEAN   build/"
	@rm -rf build

bear:
	@echo "  BEAR    compile_commands.json"
	@$(MAKE) --no-print-directory clean
	@bear -- $(MAKE) --no-print-directory all $(TEST_EXE)

-include $(DEP)

.PHONY: all release debug asan run asan-run pytest gtest report valgrind clean bear
