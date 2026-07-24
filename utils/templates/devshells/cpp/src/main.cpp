#include <iostream>

static void test001() { std::cout << "hello, world\n"; }

int main(int argc, char *argv[]) {
  if (argc < 2) {
    return 0;
  }

  std::string testName = argv[1];
  if (testName == "test_000") {
    return 0;
  }

  if (testName == "test_001") {
    test001();
    return 0;
  }

  if (testName == "test_002") {
    return 0;
  }

  std::cerr << "Unknown test case (" << testName << ").\n";
  return 1;
}
