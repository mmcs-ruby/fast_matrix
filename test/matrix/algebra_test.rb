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
      skip 'Issue#7'
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

    def test_sum_with_assigment
      m = Matrix[[1, -2], [3, 4], [7, 0]]
      m += Matrix[[4, 0], [-3, 4], [2, 2]]
      expected = Matrix[[5, -2], [0, 8], [9, 2]]

      assert_equal expected, m
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
  end
end
