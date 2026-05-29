# NOTE: Cheatsheet: https://devhints.io/makefile

CXX = g++
CXX_FLAGS= -Iinclude -MMD -Wall -Wextra -pedantic -Wshadow
# CXX_FLAGS=--std=<here>  -Iinclude -MMD -Wall -Wextra -pedantic -Wshadow
LDFLAGS =
GTEST_FLAGS = -I$(GTEST_INCLUDE) -L$(GTEST_LIB) -lgtest_main -lgtest -pthread

SRC = $(wildcard src/*.cpp)
OBJ = $(patsubst src/%.cpp, build/%.o, $(SRC))
DEP = $(OBJ:%.o=%.d)
OBJ_NO_MAIN = $(filter-out build/main.o, $(OBJ))
TEST_SRC = $(wildcard tests/*.cpp)

EXE = build/main
TEST_EXE = build/testRunner
ARGS ?=

all: $(EXE)

debug: CXX_FLAGS += -g
debug: all

asan: CXX_FLAGS += -g -O0 -fsanitize=address -fno-omit-frame-pointer
asan: LDFLAGS += -fsanitize=address
asan: all

$(EXE): $(OBJ)
	@echo "  LD      $@"
	@$(CXX) -o $@ $^ $(LDFLAGS)

build/%.o: src/%.cpp
	@mkdir -p build
	@echo "  CXX     $@"
	@$(CXX) $(CXX_FLAGS) -c -o $@ $<

run: $(EXE)
	@echo "  RUN     ${EXE}"
	@echo "=== RESULT ==="
	@./$(EXE) $(ARGS)
	@echo "=> Returned $$?."

asan-run:
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory asan
	@$(MAKE) --no-print-directory run

$(TEST_EXE): $(OBJ_NO_MAIN) $(TEST_SRC)
	@mkdir -p build
	@echo "  CXX     $@"
	@$(CXX) $(CXX_FLAGS) $^ $(GTEST_FLAGS) $(LDFLAGS) -o $@

pytest: $(EXE)
	@echo "  PYTEST  tests/"
	@pytest

gtest: $(TEST_EXE)
	@echo "  GTEST   tests/"
	@./$(TEST_EXE)

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

.PHONY: all debug asan run asan-run pytest gtest report valgrind clean bear
