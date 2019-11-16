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

    def test_sub_error
      v = Vector[1, 3]
      assert_raises(TypeError) { v - 'not a vector' }
    end

    def test_multiply_vn
      v = Vector[3, 5, 10, -2, 0]
      expected = Vector[15, 25, 50, -10, 0]

      assert_equal expected, v * 5
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

    def test_independent
      v1 = Vector[1, 2];
      v2 = Vector[2, 2];
      assert Vector.independent?(v1, v2)
    end

    def test_not_independent
      v1 = Vector[1, 2];
      v2 = Vector[2, 4];
      refute Vector.independent?(v1, v2)
    end

    def test_independent_error
      v1 = Vector[1, 2];
      v2 = Vector[2, 4, 6];
      assert_raises(IndexError) { Vector.independent?(v1, v2) }
    end

    def test_self_independent
      v1 = Vector[1, 2];
      v2 = Vector[2, 2];
      assert v1.independent?(v2)
    end

    def test_not_self_independent
      v1 = Vector[1, 2];
      v2 = Vector[2, 4];
      refute v1.independent?(v2)
    end

    def test_self_independent_error
      v1 = Vector[1, 2];
      v2 = Vector[2, 4, 6];
      assert_raises(IndexError) { v1.independent?(v2) }
    end

    def test_to_matrix3
      v = Vector[1, 2, 3]
      m = Matrix[[1], [2], [3]]
      assert_equal m, v.to_matrix
    end

    def test_to_matrix1
      v = Vector[4]
      m = Matrix[[4]]
      assert_equal m, v.to_matrix
    end

    def test_covector3
      v = Vector[1, 2, 3]
      m = Matrix[[1, 2, 3]]
      assert_equal m, v.covector
    end

    def test_covector1
      v = Vector[4]
      m = Matrix[[4]]
      assert_equal m, v.covector
    end

    def test_zero?
      v = Vector[0, 0, 0, 0]
      assert v.zero?
    end

    def test_not_zero?
      v = Vector[0, 0, 1, 0]
      refute v.zero?
    end

    def test_fill!
      v1 = Vector.new(5)
      v1.fill!(3)
      v2 = Vector[3, 3, 3, 3, 3]
      assert_equal v2, v1
    end

    def test_round
      v1 = Vector[0.5, 0.55, 0.41, 4, 11.11]
      v2 = Vector[1, 1, 0, 4, 11]
      assert_equal v2, v1.round
    end
    
    def test_round_1
      v1 = Vector[0.5, 0.55, 0.41, 4, 11.11]
      v2 = Vector[0.5, 0.6, 0.4, 4, 11.1]
      assert_equal v2, v1.round(1)
    end

    def test_round_not_1
      v1 = Vector[0.5, 0.55, 0.41, 4, 11.11]
      v2 = Vector[0, 0, 0, 0, 10]
      assert_equal v2, v1.round(-1)
    end

    def test_inner_product2
      v1 = Vector[2, 5]
      v2 = Vector[4, 7]
      assert_equal 43, v1.inner_product(v2)
    end

    def test_inner_product3
      v1 = Vector[2, 1, -1]
      v2 = Vector[0, 4, 3]
      assert_equal 1, v1.inner_product(v2)
    end

    def test_angle_with_90
      v1 = Vector[1, 0]
      v2 = Vector[0, 1]
      assert_in_delta Math::PI / 2, v1.angle_with(v2), 1e-7
    end

    def test_angle_with_45
      v1 = Vector[10, 0]
      v2 = Vector[1, 1]
      assert_in_delta Math::PI / 4, v1.angle_with(v2), 1e-7
    end

    def test_cross_product2
      v1 = Vector[1, 2]
      v2 = Vector[-2, 1]
      assert_equal v2, Vector.cross_product(v1)
    end

    def test_cross_product3
      v1 = Vector[1, 0, 0]
      v2 = Vector[0, 1, 0]
      v3 = Vector[0, 0, 1]
      assert_equal v3, Vector.cross_product(v1, v2)
    end

    def test_cross_product4
      v1 = Vector[1, 0, 0, 0]
      v2 = Vector[0, 1, 0, 0]
      v3 = Vector[0, 0, 1, 0]
      v4 = Vector[0, 0, 0, 1]
      assert_equal v4, Vector.cross_product(v1, v2, v3)
    end

    def test_cross_product44
      v1 = Vector[2, 1, 4, -2]
      v2 = Vector[4, 1, 8, 0]
      v3 = Vector[5, 5, 5, 5]
      vv1 = v1.cross_product(v2, v3)

      v1 = ::Vector[2, 1, 4, -2]
      v2 = ::Vector[4, 1, 8, 0]
      v3 = ::Vector[5, 5, 5, 5]
      vv2 = v1.cross_product(v2, v3)
      assert_equal vv2, vv1.convert
    end
  end
end
