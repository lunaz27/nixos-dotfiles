#include "hello.h"
#include <gtest/gtest.h>
#include <stdexcept>
#include <string>

TEST(HelloTest, sayHelloFunc) {
  testing::internal::CaptureStdout();
  sayHello();
  std::string stdOut = testing::internal::GetCapturedStdout();
  EXPECT_EQ(stdOut, "hello, world\n");
}

TEST(HelloTest, sayFunc) {
  std::string msg = "hello from say() func";
  EXPECT_THROW(say(""), std::invalid_argument);

  testing::internal::CaptureStdout();
  say(msg);
  std::string stdOut = testing::internal::GetCapturedStdout();
  EXPECT_EQ(stdOut, msg + '\n');
}
