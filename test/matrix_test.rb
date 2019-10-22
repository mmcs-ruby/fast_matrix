# frozen_string_literal: true
require 'test_helper'
require 'fast_matrix'
require 'matrix'

class FastMatrixTest < Minitest::Test
  def test_init
    m = FastMatrix::Matrix.new(2, 4)
    assert_equal 2, m.row_count
    assert_equal 4, m.column_count
  end

  def test_init_from_brackets
    m = FastMatrix::Matrix[[1, 2], [3, 4]]
    assert_equal 1, m[0, 0]
    assert_equal 2, m[0, 1]
    assert_equal 3, m[1, 0]
    assert_equal 4, m[1, 1]
  end

  def test_equal_by_value
    m1 = FastMatrix::Matrix[[1, 2], [3, 4]]
    m2 = FastMatrix::Matrix[[1, 2], [3, 4]]
    assert m1 == m2 && m2 == m1, 'Equals fast matrices'
    m3 = ::Matrix[[1, 2], [3, 4]]
    assert m1 == m3 #&& m3 == m1, 'Equals fast matrix and standard matrix'
    m4 = FastMatrix::Matrix[[3, 4], [1, 2]]
    assert m1 != m4 && m4 != m1, 'Different fast matrices'
  end

  def test_convert
    fast = FastMatrix::Matrix[[1, 2], [3, 4]]
    standard = ::Matrix[[1, 2], [3, 4]]
    assert_equal standard, fast.convert
    assert_equal fast, FastMatrix::Matrix.convert(standard)
  end

  def test_init_column_vector
    m = FastMatrix::Matrix.column_vector([0, 1, 2, 3, 4])
    (0..4).each { |i| assert_equal i, m[i, 0] }
  end

  def test_get
    m = FastMatrix::Matrix.new(2, 4)
    m[1, 2] = 3.5
    assert_equal 3.5, m[1, 2]
  end

  def test_get_out_of_range
    m = FastMatrix::Matrix.new(2, 4)
    assert_raises(FastMatrix::Matrix::IndexError) { m[3, 5] }
  end

  def test_set_out_of_range
    m = FastMatrix::Matrix.new(2, 4)
    assert_raises(FastMatrix::Matrix::IndexError) { m[3, 5] = 0 }
  end

  def test_set_nan
    m = FastMatrix::Matrix.new(2, 4)
    assert_raises(FastMatrix::Matrix::TypeError) { m[1, 1] = 'not a number' }
  end

  def test_multiply_mm
    m1 = FastMatrix::Matrix[[1, 2], [3, 4], [7, 0], [-3, 1]]
    m2 = FastMatrix::Matrix[[1, 0, 3], [4, 5, -2]]
    m = FastMatrix::Matrix[[9, 10, -1], [19, 20, 1], [7, 0, 21], [1, 5, -11]]

    assert m == m1 * m2
  end

  def test_multiply_mn
    m1 = FastMatrix::Matrix[[1, 2], [3, 4], [7, 0], [-3, 1]]
    m2 = FastMatrix::Matrix[[5, 10], [15, 20], [35, 0], [-15, 5]]

    assert_equal m2, m1 * 5
  end

  def test_copy
    m1 = FastMatrix::Matrix[[1, 2], [3, 4], [7, 0]]
    m2 = m1.copy

    assert_equal m1, m2
  end

  def test_transpose
    m1 = FastMatrix::Matrix[[1, 2], [3, 4], [7, 0]]
    m2 = FastMatrix::Matrix[[1, 3, 7], [2, 4, 0]]

    assert_equal m1, m2.transpose
  end
end
