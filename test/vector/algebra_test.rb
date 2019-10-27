# frozen_string_literal: true
require 'test_helper'

module FastVectorTest
  # noinspection RubyInstanceMethodNamingConvention
  class AlgebraTest < Minitest::Test
    def test_sum
      v1 = FastMatrix::Vector[1, 3]
      v2 = FastMatrix::Vector[4, 3]
      expected = FastMatrix::Vector[5, 6]

      assert_equal expected, v1 + v2
    end

    def test_sum_with_assignment
      v1 = FastMatrix::Vector[1, 3]
      v1 += FastMatrix::Vector[4, 3]
      expected = FastMatrix::Vector[5, 6]

      assert_equal expected, v1
    end

    def test_multiply_vm
      v = FastMatrix::Vector[3, -1]
      m = FastMatrix::Matrix[[2, 3, 1]]
      expected = FastMatrix::Matrix[[6, 9, 3], [-2, -3, -1]]

      assert_equal expected, v * m
    end

    def test_multiply_vn
      v = FastMatrix::Vector[3, 5, 10, -2, 0]
      expected = FastMatrix::Vector[15, 25, 50, -10, 0]

      assert_equal expected, v * 5
    end

    def test_multiply_vn_commutative
      skip 'Issue#7'
      v = FastMatrix::Vector[3, 5, 10, -2, 0]

      assert_equal v * 5, 5 * v
    end

    def test_multiply_vv
      v1 = FastMatrix::Vector[2, 3, -1, 4, 7]
      v2 = FastMatrix::Vector[2]
      expected = FastMatrix::Vector[4, 6, -2, 8, 14]

      assert_equal expected, v1 * v2
    end
  end
end
