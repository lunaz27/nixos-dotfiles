#include "matrix.h"
#include <gtest/gtest.h>
#include <stdexcept>

template <typename T> class MatrixTest : public testing::Test {
protected:
  Matrix<T> matrix3x3{3, 3};

  void SetUp() override {
    /*
     * [ 1, 2, 3 ]
     * [ 4, 5, 6 ]
     * [ 7, 9, 9 ]
     */
    T value = 1;
    for (size_t r = 0; r < this->matrix3x3.getRows(); r++) {
      for (size_t c = 0; c < this->matrix3x3.getCols(); c++) {
        matrix3x3.set(r, c, value++);
      }
    }
  }
};

using MatrixTypes = ::testing::Types<int, float, double>;
TYPED_TEST_SUITE(MatrixTest, MatrixTypes, );

TYPED_TEST(MatrixTest, MatrixGetter) {
  EXPECT_EQ(this->matrix3x3.getRows(), 3);
  EXPECT_EQ(this->matrix3x3.getCols(), 3);

  int value = 1;
  for (size_t r = 0; r < this->matrix3x3.getRows(); r++) {
    for (size_t c = 0; c < this->matrix3x3.getCols(); c++) {
      EXPECT_EQ(this->matrix3x3.get(r, c), value++);
    }
  }
}

TYPED_TEST(MatrixTest, OutOfRangeThrowing) {
  EXPECT_THROW(this->matrix3x3.get(3, 3), std::out_of_range);
  EXPECT_THROW(this->matrix3x3.get(-1, 0), std::out_of_range);
  EXPECT_THROW(this->matrix3x3.get(0, -1), std::out_of_range);
}

TYPED_TEST(MatrixTest, MatrixAdditionSuccess) {
  Matrix<TypeParam> other(3, 3);
  for (size_t r = 0; r < 3; r++) {
    for (size_t c = 0; c < 3; c++) {
      other.set(r, c, static_cast<TypeParam>(10));
    }
  }

  Matrix<TypeParam> result = this->matrix3x3 + other;
  EXPECT_EQ(result.get(0, 0), static_cast<TypeParam>(11));
  EXPECT_EQ(result.get(2, 2), static_cast<TypeParam>(19));
}

TYPED_TEST(MatrixTest, MatrixAdditionDimensionMismatchThrows) {
  Matrix<TypeParam> invalidSize(2, 2);
  EXPECT_THROW(this->matrix3x3 + invalidSize, std::invalid_argument);
}

TYPED_TEST(MatrixTest, MatrixEquality) {
  Matrix<TypeParam> clone(3, 3);
  TypeParam value = 1;
  for (size_t r = 0; r < 3; r++) {
    for (size_t c = 0; c < 3; c++) {
      clone.set(r, c, value++);
    }
  }

  EXPECT_TRUE(this->matrix3x3 == clone);

  clone.set(2, 2, static_cast<TypeParam>(99));
  EXPECT_FALSE(this->matrix3x3 == clone);

  Matrix<TypeParam> diffSize(2, 2);
  EXPECT_FALSE(this->matrix3x3 == diffSize);
}
