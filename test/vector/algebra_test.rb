# frozen_string_literal: true
require 'test_helper'

module FastVectorTest
  # noinspection RubyInstanceMethodNamingConvention
  class AlgebraTest < Minitest::Test
    include FastMatrix

    def test_sum
      v1 = Vector[1, 3]
      v2 = Vector[4, 3]
      expected = Vector[5, 6]

      assert_equal expected, v1 + v2
    end

    def test_sum_error
      v = Vector[1, 3]
      assert_raises(TypeError) { v + 'not a vector' }
    end

    def test_sum_with_assignment
      v1 = Vector[1, 3]
      v1 += Vector[4, 3]
      expected = Vector[5, 6]

      assert_equal expected, v1
    end

    def test_multiply_vm
      v = Vector[3, -1]
      m = Matrix[[2, 3, 1]]
      expected = Matrix[[6, 9, 3], [-2, -3, -1]]

      assert_equal expected, v * m
    end

    def test_sub
      v1 = Vector[1, 3]
      v2 = Vector[4, 3]
      expected = Vector[-3, 0]

      assert_equal expected, v1 - v2
    end

    def test_sum_error
      v = Vector[1, 3]
      assert_raises(TypeError) { v - 'not a vector' }
    end

    def test_multiply_vn
      v = Vector[3, 5, 10, -2, 0]
      expected = Vector[15, 25, 50, -10, 0]

      assert_equal expected, v * 5
    end

    def test_multiply_vn_commutative
      v = Vector[3, 5, 10, -2, 0]

      assert_equal v * 5, 5 * v
    end

    def test_multiply_vv
      v1 = Vector[2, 3, -1, 4, 7]
      v2 = Vector[2]
      expected = Vector[4, 6, -2, 8, 14]

      assert_equal expected, v1 * v2
    end

    def test_eql_equal
      m = FastMatrix::Vector[1, 2, 5]
      n = FastMatrix::Vector[1, 2, 5]
      assert m.eql?(n)
    end

    def test_eql_not_equal
      m = FastMatrix::Vector[1, 2, 5]
      n = FastMatrix::Vector[1, 4, 5]
      refute m.eql?(n)
    end

    def test_magnitude5
      v = Vector[1, 2, 1, 3, 1]
      assert_equal 4, v.magnitude
    end

    def test_magnitude2
      v = Vector[3, 4]
      assert_equal 5, v.magnitude
    end

    def test_normalize5
      v1 = Vector[1, 2, 1, 3, 1]
      v2 = Vector[0.25, 0.5, 0.25, 0.75, 0.25]
      assert_equal v2, v1.normalize
    end

    def test_normalize2
      v1 = Vector[3, 4]
      v2 = Vector[0.6, 0.8]
      assert_equal v2, v1.normalize
    end

    def test_normalize5!
      v1 = Vector[1, 2, 1, 3, 1]
      v2 = Vector[0.25, 0.5, 0.25, 0.75, 0.25]
      v1.normalize!
      assert_equal v2, v1
    end

    def test_normalize2!
      v1 = Vector[3, 4]
      v2 = Vector[0.6, 0.8]
      v1.normalize!
      assert_equal v2, v1
    end

    def test_minus2
      v1 = Vector[3, 4]
      v2 = Vector[-3, -4]
      assert_equal v2, -v1
    end

    def test_minus5
      v1 = Vector[1, 2, 1, 3, 1]
      v2 = Vector[-1, -2, -1, -3, -1]
      assert_equal v2, -v1
    end

    def test_minus2
      v1 = Vector[3, 4]
      v2 = Vector[3, 4]
      assert_equal v2, +v1
    end

    def test_plus5
        v1 = Vector[1, 2, 1, 3, 1]
        v2 = Vector[1, 2, 1, 3, 1]
        assert_equal v2, +v1
    end
  end
end
