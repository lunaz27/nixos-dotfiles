#include "hello.h"
#include <print>
#include <string>

void sayHello() { std::println("hello, world"); }

void say(std::string message) {
  if (message.empty()) {
    throw std::invalid_argument("Empty message");
  }

  std::println("{}", message);
}
