# frozen_string_literal: true
require 'test_helper'

module FastMatrixTest
  # noinspection RubyInstanceMethodNamingConvention
  class AlgebraTest < Minitest::Test
    include FastMatrix

    def test_multiply_mm
      m1 = Matrix[[1, 2],
                              [3, 4],
                              [7, 0],
                              [-3, 1]]

      m2 = Matrix[[1, 0, 3],
                              [4, 5, -2]]

      expected = Matrix[[9, 10, -1],
                                    [19, 20, 1],
                                    [7, 0, 21],
                                    [1, 5, -11]]
      assert_equal expected, m1 * m2
    end

    def test_multiply_mn
      m = Matrix[[1, 2], [3, 4], [7, 0], [-3, 1]]
      expected = Matrix[[5, 10], [15, 20], [35, 0], [-15, 5]]

      assert_equal expected, m * 5
    end

    def test_multiply_mn_commutative
      m = Matrix[[1, 2], [3, 4], [7, 0], [-3, 1]]
      assert_equal m * 5, 5 * m
    end

    def test_multiply_mv
      m = Matrix[[1, 2], [3, 4], [7, 0], [-3, 1]]
      v = Vector[5, 10]
      expected = Vector[25, 55, 35, -5]

      assert_equal expected, m * v
    end

    def test_transpose
      m = Matrix[[1, 2], [3, 4], [7, 0]]
      expected = Matrix[[1, 3, 7], [2, 4, 0]]

      assert_equal expected, m.transpose
    end

    def test_sum
      m1 = Matrix[[1, -2], [3, 4], [7, 0]]
      m2 = Matrix[[4, 0], [-3, 4], [2, 2]]
      expected = Matrix[[5, -2], [0, 8], [9, 2]]

      assert_equal expected, m1 + m2
    end

    def test_sum_error
      m = Matrix[[1, -2], [3, 4], [7, 0]]
      assert_raises(TypeError) { m + 'not a matrix' }
    end

    def test_sum_with_assigment
      m = Matrix[[1, -2], [3, 4], [7, 0]]
      m += Matrix[[4, 0], [-3, 4], [2, 2]]
      expected = Matrix[[5, -2], [0, 8], [9, 2]]

      assert_equal expected, m
    end

    def test_sub_error
      m = Matrix[[1, -2], [3, 4], [7, 0]]
      assert_raises(TypeError) { m - 'not a matrix' }
    end

    def test_determinant_1x1
      m = FastMatrix::Matrix[[5]]
      assert_equal 5, m.determinant
    end

    def test_determinant_2x2
      m = FastMatrix::Matrix[[1, 2], [3, 4]]
      assert_equal -2, m.determinant
    end

    def test_determinant_4x4
      m = FastMatrix::Matrix[
        [1, 2, 6, 1], 
        [3, 4, 5, 0],
        [0, 1,-6, 1], 
        [-5,4, -5, 10]]
      assert_equal -84, m.determinant
    end
    
    def test_eql_equal
      m = FastMatrix::Matrix[[1, 2, 5], [3, 4, 1]]
      n = FastMatrix::Matrix[[1, 2, 5], [3, 4, 1]]
      assert m.eql?(n)
    end

    def test_eql_not_equal
      m = FastMatrix::Matrix[[1, 2, 5], [3, 4, 1]]
      n = FastMatrix::Matrix[[1, 2, 5], [3, 3, 1]]
      refute m.eql?(n)
    end

    def test_diagonal
      m = FastMatrix::Matrix[[1, 0, 0], [0, 4, 0], [0, 0, 7]]
      assert m.diagonal?
    end

    def test_not_diagonal
      m = FastMatrix::Matrix[[1, 0, 0], [0, 4, 5], [0, 0, 7]]
      refute m.diagonal?
    end

    def test_diagonal_error
      m = FastMatrix::Matrix[[1, 0, 0], [0, 4, 0], [0, 0, 7], [0, 0, 0]]
      assert_raises(IndexError) { m.diagonal?}
    end

    def test_hadamard_product
      m1 = Matrix[[1, 3, 0], [-2, 2, 1]]
      m2 = Matrix[[1, 2, 1], [0, 4, 010]]
      m = Matrix[[1, 6, 0, 0, 8, 8]]
      assert m, m1.hadamard_product(m2)
    end

    def test_hadamard_product_error
      m1 = Matrix[[1, 3, 0], [-2, 2, 1]]
      m2 = Matrix[[1, 2], [0, 4]]
      assert_raises(IndexError) { m1.hadamard_product(m2)}
    end

    def test_trace
      m = Matrix[[1, 2, 3], [5, 6, 7], [7, 8, 9]]
      assert_equal 16, m.trace
    end

    def test_trace_error
      m = Matrix[[1, 2, 3], [5, 6, 7]]
      assert_raises(IndexError) { m.trace}
    end

  end
end
