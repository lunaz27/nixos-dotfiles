#ifndef MATRIX_H
#define MATRIX_H

#include <cstddef>
#include <stdexcept>
#include <vector>

template <typename T> class Matrix {
public:
  Matrix(size_t rows, size_t cols);
  size_t getRows() const;
  size_t getCols() const;
  T get(size_t row, size_t col) const;
  void set(size_t row, size_t col, T value);

  Matrix operator+(const Matrix<T> &other) const;
  bool operator==(const Matrix<T> &other) const;

  ~Matrix();

private:
  size_t rows;
  size_t cols;
  std::vector<std::vector<T>> data;
};

template <typename T>
Matrix<T>::Matrix(size_t rows, size_t cols)
    : rows(rows), cols(cols), data(rows, std::vector<T>(cols, 0)) {
  if (rows == 0 || cols == 0) {
    throw std::invalid_argument("Matrix dimension must be > 0");
  }
}

template <typename T> size_t Matrix<T>::getRows() const { return this->rows; }

template <typename T> size_t Matrix<T>::getCols() const { return this->cols; }

template <typename T> T Matrix<T>::get(size_t row, size_t col) const {
  if (row >= this->rows || col >= this->cols) {
    throw std::out_of_range("Matrix indices out of bounds");
  }

  return data[row][col];
}

template <typename T> void Matrix<T>::set(size_t row, size_t col, T value) {
  if (row >= this->rows || col >= this->cols) {
    throw std::out_of_range("Matrix indices out of bounds");
  }

  data[row][col] = value;
}

template <typename T>
Matrix<T> Matrix<T>::operator+(const Matrix<T> &other) const {
  if (this->rows != other.rows || this->cols != other.cols) {
    throw std::invalid_argument("Dimension must match for addition");
  }

  Matrix<T> result(this->rows, this->cols);
  for (size_t r = 0; r < this->rows; r++) {
    for (size_t c = 0; c < this->cols; c++) {
      result.data[r][c] = this->data[r][c] + other.data[r][c];
    }
  }

  return result;
}

template <typename T> bool Matrix<T>::operator==(const Matrix<T> &other) const {
  return (this->rows == other.rows) && (this->cols == other.cols) &&
         (this->data == other.data);
}

template <typename T> Matrix<T>::~Matrix() {}

#endif // MATRIX_H
