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

EXE = $(BUILD_DIR)/main
TEST_EXE = $(BUILD_DIR)/test_runner
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
	@$(CC) -o $@ $^ $(LD_FLAGS)

$(BUILD_DIR)/%.o: src/%.c
	@mkdir -p $(BUILD_DIR)
	@echo "  CC      $@"
	@$(CC) $(C_FLAGS) -c -o $@ $<

run: $(EXE)
	@echo "  RUN     ${EXE}"
	@echo "=== RESULT ==="
	@./$(EXE) $(ARGS)
	@echo "=> Returned $$?."

asan-run:
	@$(MAKE) --no-print-directory BUILD_TYPE=asan run

$(TEST_EXE): $(OBJ_NO_MAIN) $(TEST_SRC)
	@mkdir -p $(BUILD_DIR)
	@echo "  CC      $@"
	@$(CC) $(C_FLAGS) $^ $(CRITERION_FLAGS) $(LD_FLAGS) -o $@

ctest: $(TEST_EXE)
	@echo "  CTEST   tests/"
	@./$(TEST_EXE)

pytest: debug
	@echo "  PYTEST  tests/"
	@pytest

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

.PHONY: all release debug asan run asan-run ctest valgrind pytest report clean bear
