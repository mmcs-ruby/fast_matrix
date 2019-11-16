require 'compatibility/compatibility_helper'

module CompatibilityTest
  class CompatibilityScalarTest < Minitest::Test
    include CompatibilityHelper
    include FastMatrix

    def test_matrix_coerce
      matrix = Matrix.zero(1)
      assert_equal [Scalar.new(1), matrix], matrix.coerce(1)
    end

    def test_vector_coerce
      vector = Vector.zero(1)
      assert_equal [Scalar.new(1), vector], vector.coerce(1)
    end

    def test_matrix_coerce_error
      assert_raises(TypeError) { Matrix.zero(1).coerce('NaN') }
    end

    def test_vector_coerce_error
      assert_raises(TypeError) { Vector.zero(1).coerce('NaN') }
    end

    def test_add
      scalar = make_scalar(1)
      assert_equal make_scalar(5), scalar + 4
      assert_equal 5, 4 + scalar
    end

    def test_sub
      scalar = make_scalar(1)
      assert_equal(make_scalar(0), scalar - 1)
      assert_equal(-1, 0 - scalar)
    end

    def test_add_error
      assert_raises(OperationNotDefinedError) { 5 + Vector[0] }
      assert_raises(OperationNotDefinedError) { 10 + Matrix[[0]] }
    end

    def test_sub_error
      assert_raises(OperationNotDefinedError) { 5 - Vector[0] }
      assert_raises(OperationNotDefinedError) { 10 - Matrix[[0]] }
    end

    def test_multiply_mn_commutative
      m = Matrix[[1, 2], [3, 4], [7, 0], [-3, 1]]
      assert_equal m * 5, 5 * m
    end

    def test_multiply_vn_commutative
      v = Vector[3, 5, 10, -2, 0]
      assert_equal v * 5, 5 * v
    end

    def test_mul
      scalar = make_scalar(2)
      assert_equal make_scalar(42), scalar * 21
      assert_equal 42, 21 * scalar
    end

    def test_div
      scalar = make_scalar(6)
      assert_equal make_scalar(2), scalar / 3
      assert_equal 2, 12 / scalar
    end

    def test_div_nm
      assert_equal(Matrix[[0.5]], 1 / Matrix[[2]])
    end

    def test_div_error
      assert_raises(OperationNotDefinedError) { 5 / Vector[1, 2] }
    end

    def test_pow
      scalar = make_scalar(6)
      assert_equal(36, scalar**2)
    end

    def test_pow_error
      assert_raises(OperationNotDefinedError) { 1**Vector[0] }
      assert_raises(OperationNotDefinedError) { 2**Matrix[[1]] }
    end
  end
end
