# NOTE: Cheatsheet: https://devhints.io/makefile

CC = gcc
C_FLAGS= -Iinclude -MMD -Wall -Wextra -Wshadow
# C_FLAGS=--std=<here> -Iinclude -MMD -Wall -Wextra -pedantic -Wshadow
LDFLAGS =
CRITERION_FLAGS = -I$(CRITERION_INCLUDE) -L$(CRITERION_LIB) -lcriterion

SRC = $(wildcard src/*.c)
OBJ = $(patsubst src/%.c, build/%.o, $(SRC))
DEP = $(OBJ:%.o=%.d)
OBJ_NO_MAIN = $(filter-out build/main.o, $(OBJ))
TEST_SRC = $(wildcard tests/*.c)

EXE = build/main
TEST_EXE = build/test_runner
ARGS ?=

all: $(EXE)

debug: C_FLAGS += -g
debug: all

asan: C_FLAGS += -g -O0 -fsanitize=address -fno-omit-frame-pointer -fno-common
asan: LDFLAGS += -fsanitize=address
asan: all

$(EXE): $(OBJ)
	@echo "  LD      $@"
	@$(CC) -o $@ $^ $(LDFLAGS)

build/%.o: src/%.c
	@mkdir -p build
	@echo "  CC      $@"
	@$(CC) $(C_FLAGS) -c -o $@ $<

asan-run:
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory asan
	@$(MAKE) --no-print-directory run

run: $(EXE)
	@echo "  RUN     ${EXE}"
	@echo "=== RESULT ==="
	@./$(EXE) $(ARGS)
	@echo "=> Returned $$?."

$(TEST_EXE): $(OBJ_NO_MAIN) $(TEST_SRC)
	@mkdir -p build
	@echo "  CC      $@"
	@$(CC) $(C_FLAGS) $^ $(CRITERION_FLAGS) $(LDFLAGS) -o $@

ctest: $(TEST_EXE)
	@echo "  CTEST   tests/"
	@./$(TEST_EXE)

pytest: $(EXE)
	@echo "  PYTEST  tests/"
	@pytest

report: $(EXE)
	@echo "  REPORT  tests/"
	@pytest -vvv --md-report --md-report-verbose=2 --md-report-show-duration --md-report-output=REPORT.md

valgrind:
	@echo "  PREP      $@"
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory debug
	@echo "  VALGRIND  ${EXE}"
	@echo "=== RESULT ==="
	@valgrind --leak-check=full \
		--show-leak-kinds=all \
		--track-origins=yes \
		--verbose \
		--log-file=build/valgrind-out.txt \
		./$(EXE) $(ARGS)
	@echo "=> Valgrind finished. Check valgrind-out.txt for the report."

clean:
	@echo "  CLEAN   build/"
	@rm -rf build

bear:
	@echo "  BEAR    compile_commands.json"
	@$(MAKE) --no-print-directory clean
	@bear -- $(MAKE) --no-print-directory all $(TEST_EXE)

-include $(DEP)

.PHONY: all debug asan run asan-run ctest valgrind pytest report clean bear
