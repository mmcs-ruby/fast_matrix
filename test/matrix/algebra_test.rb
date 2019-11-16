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

    def test_first_minor
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9], [0, 1, 2]]
      r = Matrix[[1, 2], [4, 5], [0, 1]]
      assert_equal r, m.first_minor(2, 2)
    end

    def test_first_minor_error
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9], [0, 1, 2]]
      assert_raises(IndexError) { m.first_minor(3, 5) }
    end

    def test_cofactor
      m = Matrix.diagonal(9, 5, -3, 4)
      assert_equal -108, m.cofactor(1, 1)
    end

    def test_cofactor_error_index
      m = Matrix.diagonal(9, 5, -3, 4)
      assert_raises(IndexError) { m.cofactor(1, 5) }
    end

    def test_cofactor_error_matrix
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_raises(IndexError) { m.cofactor(1, 1) }
    end

    def test_rank_4
      m = Matrix[
        [1, 2, 3, 4, 5],
        [1, 2, 3, 5, 5],
        [0, 0, 0, 0, 5],
        [2, 2, 2, 2, 2]
      ]
      assert_equal 4, m.rank
    end

    def test_rank_3
      m = Matrix[
        [1, 2, 3, 4, 5],
        [1, 2, 3, 5, 5],
        [0, 0, 0, 5, 0],
        [2, 2, 2, 2, 2]
      ]
      assert_equal 3, m.rank
    end

    def test_rank_2
      m = Matrix[
        [1, 2],
        [2, 1]
      ]
      assert_equal 2, m.rank
    end

    def test_rank_1
      m = Matrix[
        [ 1,  2, -1, 0,  1],
        [ 2,  4, -2, 0,  2],
        [-1, -2,  1, 0, -1]
      ]
      assert_equal 1, m.rank
    end

    def test_rank_2x5
      m = Matrix[
        [1, 2],
        [1, 2],
        [1, 2],
        [2, 1],
        [1, 1],
      ]
      assert_equal 2, m.rank
    end

    def test_round_0
      m1 = Matrix[[1, 1.5, 1.55, 1.4], [0, -10.1, -555, 555]]
      m2 = Matrix[[1, 2, 2, 1], [0, -10, -555, 555]]
      assert_equal m2, m1.round
    end

    def test_round_1
      m1 = Matrix[[1, 1.5, 1.55, 1.4], [0, -10.1, -555, 555]]
      m2 = Matrix[[1, 1.5, 1.6, 1.4], [0, -10.1, -555, 555]]
      assert m2, m1.round(1)
    end

    def test_round_neg_1
      m1 = Matrix[[1, 1.5, 1.55, 1.4], [0, -10.1, -555, 555]]
      m2 = Matrix[[0, 0, 0, 0], [0, -10, -560, 560]]
      assert m2, m1.round(-1)
    end

    def test_lower_triangular
      m = Matrix[[1, 0, 0], [2, 3, 0], [4, 5, 6]];
      assert m.lower_triangular?
    end

    def test_not_lower_triangular_1
      m = Matrix[[1, 5, 0], [2, 3, 0], [4, 5, 6]];
      refute m.lower_triangular?
    end

    def test_not_lower_triangular_2
      m = Matrix[[1, 0, 0], [2, 3, 1], [4, 5, 6]];
      refute m.lower_triangular?
    end

    def test_not_lower_triangular_3
      m = Matrix[[1, 0, 3], [2, 3, 0], [4, 5, 6]];
      refute m.lower_triangular?
    end

    def test_upper_triangular
      m = Matrix[[1, 2, 3], [0, 4, 5], [0, 0, 6]];
      assert m.upper_triangular?
    end

    def test_upper_triangular_0
      m = Matrix[[0, 0, 0], [0, 0, 0], [0, 0, 0]];
      assert m.upper_triangular?
    end

    def test_not_lower_triangular_1
      m = Matrix[[1, 2, 3], [1, 4, 5], [0, 0, 6]];
      refute m.upper_triangular?
    end

    def test_not_lower_triangular_2
      m = Matrix[[1, 2, 3], [0, 4, 5], [2, 0, 6]];
      refute m.upper_triangular?
    end

    def test_not_lower_triangular_3
      m = Matrix[[1, 2, 3], [0, 4, 5], [0, 3, 6]];
      refute m.upper_triangular?
    end

    def test_permutation_1
      m = Matrix[
        [1, 0, 0, 0],
        [0, 0, 0, 1],
        [0, 1, 0, 0],
        [0, 0, 1, 0], 
      ]
      assert m.permutation?
    end

    def test_permutation_2
      m = Matrix[
        [0, 0, 0, 1],
        [1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, 1, 0, 0], 
      ]
      assert m.permutation?
    end

    def test_not_permutation_1
      m = Matrix[
        [0, 0, 0, 1],
        [0, 0, 2, 0],
        [1, 0, 0, 0],
        [0, 1, 0, 0], 
      ]
      refute m.permutation?
    end

    def test_not_permutation_2
      m = Matrix[
        [0, 0, 0, 1],
        [0, 1, 0, 0],
        [0, 0, 0, 1],
        [0, 1, 0, 0], 
      ]
      refute m.permutation?
    end

    def test_orthogonal?
      m = Matrix[[0.96, -0.28], [0.28, 0.96]]
      assert m.orthogonal?
    end

    def test_not_orthogonal?
      m = Matrix[[1, 1], [0, 1]]
      refute m.orthogonal?
    end

    def test_orthogonal_error
      m = Matrix[[1, 1, 1], [1, 1, 1]]
      assert_raises(IndexError) { m.orthogonal? }
    end
    
    def test_inverse_2x2
      m1 = Matrix[[1, 2], [3, 4]]
      m2 = Matrix[[-2, 1], [1.5, -0.5]]
      assert_equal m2, m1.inverse
    end

    def test_inverse_3x3
      m1 = Matrix[[1, 2, 3], [1, 2, 4], [1, 3, 3]]
      m2 = Matrix[[6, -3, -2], [-1, 0, 1], [-1, 1, 0]]
      assert_equal m2, m1.inverse
    end

    def test_inverse_error_zero_det
      m = Matrix[[1, 2, 3], [1, 2, 4], [2, 4, 0]]
      assert_raises(IndexError) { m.inverse }
    end

    def test_inverse_error_not_squere
      m = Matrix[[1, 2, 3], [1, 2, 4]]
      assert_raises(IndexError) { m.inverse }
    end

    def test_adjugate
      m1 = Matrix[[7, 6], [3, 9]]
      m2 = Matrix[[9, -6], [-3, 7]]
      assert_equal m2, m1.adjugate
    end

    def test_imaginary
      m1 = Matrix[[1, 2, 0], [-3, 0, 1]]
      m2 = Matrix[[0, 0, 0], [0, 0, 0]]
      assert_equal m2, m1.imaginary
    end
    
    def test_ract
      m = Matrix[[1, 2], [0, -1]]
      m1 = Matrix[[0, 0], [0, 0]]
      m2 = Matrix[[1, 2], [0, -1]]
      assert_equal [m2, m1], m.rect
    end

    def test_division_matrix
      m1 = Matrix[[1, 2], [3, 4]]
      m2 = Matrix[[3, 3], [2, 5]]
      m = Matrix[[-1.5, 1.5], [3.5, -0.5]]
      assert_equal m, m2 / m1
    end

    def test_division_numder
      m1 = Matrix[[1, 2], [3, 4]]
      m2 = Matrix[[0.5, 1], [1.5, 2]]
      assert_equal m2, m1 / 2
    end

    def test_exponentiation_pos_10
      m1 = Matrix[[1, 2], [-1, 0]]
      m2 = Matrix[[23, -22], [11, 34]]
      assert_equal m2, m1**10
    end

    def test_exponentiation_pos_6
      m1 = Matrix[[1, 2], [-1, 0]]
      m2 = Matrix[[7, 10], [-5, 2]]
      assert_equal m2, m1**6
    end

    def test_exponentiation_neg_2
      m1 = Matrix[[1, 2], [2, 3]]
      m2 = Matrix[[13, -8], [-8, 5]]
      assert_equal m2, m1**-2
    end

    def test_exponentiation_neg_1
      m1 = Matrix[[1, 2], [2, 3]]
      m2 = Matrix[[-3, 2], [2, -1]]
      assert_equal m2, m1**-1
    end

    def test_exponentiation_zero
      m1 = Matrix[[1, 2], [2, 3]]
      m2 = Matrix[[1, 0], [0, 1]]
      assert_equal m2, m1**0
    end
    
    def test_exponentiation_one
      m1 = Matrix[[1, 2, 4], [2, 3, 4]]
      assert_equal m1, m1**1
    end
  end
end
