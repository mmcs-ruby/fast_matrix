# frozen_string_literal: true
require 'test_helper'

module FastMatrixTest
  # noinspection RubyInstanceMethodNamingConvention
  class MatrixTest < Minitest::Test
    include FastMatrix

    def test_same
      m = Matrix[[1, 2]]
      assert_same m, m
    end

    def test_not_same
      refute_same Matrix[[1, 2]], Matrix[[1, 2]]
    end

    def test_eql
      m1 = Matrix[[1, 2, 3], [4, 5, 6]]
      m2 = Matrix[[1, 2, 3], [4, 5, 6]]
      assert m1.eql? m2
    end

    def test_not_eql_value
      m1 = Matrix[[1, 2, 3], [4, 5, 6]]
      m2 = Matrix[[1, 2, 3], [5, 5, 6]]
      refute m1.eql? m2
    end

    def test_not_eql_sizes
      m1 = Matrix[[1, 2, 3], [4, 5, 6]]
      m2 = Matrix[[1, 2, 3]]
      refute m1.eql? m2
    end

    def test_equal_by_value
      m1 = Matrix[[1, 2], [3, 4]]
      m2 = Matrix[[1, 2], [3, 4]]
      assert_equal m1, m2
    end

    def test_not_equal_by_value
      m1 = Matrix[[1, 2], [3, 4]]
      m2 = Matrix[[3, 4], [1, 2]]
      refute_equal m1, m2
    end

    def test_clone
      original = Matrix[[1, 2], [3, 4], [7, 0]]
      clone = original.clone

      assert_equal original, clone
      refute_same original, clone
    end

    def test_to_s
      m1 = Matrix[[1, 2], [3, 4]]
      assert_equal "FastMatrix::Matrix[[1.0, 2.0], [3.0, 4.0]]", m1.to_s
    end

    def test_inspect
      m1 = Matrix[[1, 2], [3, 4]]
      assert_equal "FastMatrix::Matrix[[1.0, 2.0], [3.0, 4.0]]", m1.inspect
    end

    def test_to_str
      m1 = Matrix[[1, 2], [3, 4]]
      assert_equal "FastMatrix::Matrix[[1.0, 2.0], [3.0, 4.0]]", m1.to_str
    end

    def test_symmetric
      m1 = Matrix[[1, 2, 1], [2, 4, 5], [1, 5, 3]]
      assert m1.symmetric?
    end

    def test_not_symmetric
      m1 = Matrix[[1, 2, 1], [3, 4, 5], [1, 5, 3]]
      refute m1.symmetric?
    end

    def test_symmetric_error
      m1 = Matrix[[1, 2], [3, 4], [1, 5]]
      assert_raises (IndexError) { m1.symmetric? }
    end

    def test_antisymmetric
      m1 = Matrix[[0, 2, 1], [-2, 0, 5], [-1, -5, 0]]
      assert m1.antisymmetric?
    end

    def test_not_antisymmetric
      m1 = Matrix[[0, 2, 1], [2, 0, 5], [-1, -5, 0]]
      refute m1.antisymmetric?
    end

    def test_antisymmetric_error
      m1 = Matrix[[1, 2], [3, 4], [1, 5]]
      assert_raises (IndexError) { m1.antisymmetric? }
    end
    
    def test_plus
      m1 = Matrix[[1, 2], [-3, 4], [0, 5]]
      m2 = Matrix[[1, 2], [-3, 4], [0, 5]]
      assert_equal m2, +m1
    end
    
    def test_minus
      m1 = Matrix[[1, 2], [-3, 4], [0, 5]]
      m2 = Matrix[[-1, -2], [3, -4], [0, -5]]
      assert_equal m2, -m1
    end

    def test_column
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      v = Vector[3, 6, 9]
      assert_equal v, m.column(2)
    end

    def test_column_neg_idx
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      v = Vector[2, 5, 8]
      assert_equal v, m.column(-2)
    end

    def test_column_overflow
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      assert_nil m.column(4)
    end

    def test_row
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      v = Vector[7, 8, 9]
      assert_equal v, m.row(2)
    end

    def test_row_neg_idx
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      v = Vector[4, 5, 6]
      assert_equal v, m.row(-2)
    end

    def test_row_overflow
      m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      assert_nil m.row(4)
    end

    def test_zero
      m = Matrix[[0, 0, 0], [0, 0, 0]]
      assert m.zero?
    end

    def test_not_zero
      m = Matrix[[0, 0, 1], [0, 0, 0]]
      refute m.zero?
    end
    
    def test_each_all_sq
      m = Matrix[[1, 2], [3, 4]]
     assert_equal [1, 2, 3, 4], m.each(:all).to_a
    end

    def test_each_all_rec1
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal [1, 2, 3, 4, 5, 6], m.each(:all).to_a
    end

    def test_each_all_rec2
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_equal [1, 2, 3, 4, 5, 6], m.each(:all).to_a
    end

    def test_each_diagonal_sq
      m = Matrix[[1, 2], [3, 4]]
      assert_equal [1, 4], m.each(:diagonal).to_a
    end

    def test_each_diagonal_rec1
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal [1, 4], m.each(:diagonal).to_a
    end

    def test_each_diagonal_rec2
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_equal [1, 5], m.each(:diagonal).to_a
    end

    def test_each_off_diagonal_sq
      m = Matrix[[1, 2], [3, 4]]
      assert_equal [2, 3], m.each(:off_diagonal).to_a
    end

    def test_each_off_diagonal_rec1
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal [2, 3, 5, 6], m.each(:off_diagonal).to_a
    end

    def test_each_off_diagonal_rec2
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_equal [2, 3, 4, 6], m.each(:off_diagonal).to_a
    end

    def test_each_lower_sq
      m = Matrix[[1, 2], [3, 4]]
      assert_equal [1, 3, 4], m.each(:lower).to_a
    end

    def test_each_lower_rec1
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal [1, 3, 4, 5 ,6], m.each(:lower).to_a
    end

    def test_each_lower_rec2
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_equal [1, 4, 5], m.each(:lower).to_a
    end

    def test_each_strict_lower_sq
      m = Matrix[[1, 2], [3, 4]]
      assert_equal [3], m.each(:strict_lower).to_a
    end

    def test_each_strict_lower_rec1
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal [3, 5, 6], m.each(:strict_lower).to_a
    end

    def test_each_strict_lower_rec2
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_equal [4], m.each(:strict_lower).to_a
    end

    def test_each_upper_sq
      m = Matrix[[1, 2], [3, 4]]
      assert_equal [1, 2, 4], m.each(:upper).to_a
    end

    def test_each_upper_rec1
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal [1, 2, 4], m.each(:upper).to_a
    end

    def test_each_upper_rec2
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_equal [1, 2, 3, 5, 6], m.each(:upper).to_a
    end

    def test_each_strict_upper_sq
      m = Matrix[[1, 2], [3, 4]]
      assert_equal [2], m.each(:strict_upper).to_a
    end

    def test_each_strict_upper_rec1
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal [2], m.each(:strict_upper).to_a
    end

    def test_each_strict_upper_rec2
      m = Matrix[[1, 2, 3], [4, 5, 6]]
      assert_equal [2, 3, 6], m.each(:strict_upper).to_a 
    end
    
    def test_greater
      m1 = Matrix[[1, 2, 3], [3, 2, 1]]
      m2 = Matrix[[2, 3, 6], [4, 4, 4]]
      assert m2 > m1
    end
    
    def test_not_greater
      m1 = Matrix[[1, 2, 3], [3, 2, 1]]
      m2 = Matrix[[2, 3, 3], [4, 4, 4]]
      refute m2 > m1
    end
    
    def test_less
      m1 = Matrix[[1, 2, 3], [-3, 2, 1]]
      m2 = Matrix[[0, 1, 0], [-5, 1, -1]]
      assert m2 < m1
    end

    def test_not_less
      m1 = Matrix[[1, 2, 3], [-3, 2, 1]]
      m2 = Matrix[[1, 2, 3], [-3, 2, 1]]
      refute m2 < m1
    end

    def test_greater_or_equal
      m1 = Matrix[[1, 2, 3], [-3, 2, 1]]
      m2 = Matrix[[1, 2, 3], [-3, 2, 1]]
      assert m2 >= m1
    end

    def test_not_greater_or_equal
      m1 = Matrix[[1, 2, 3], [3, 2, 1]]
      m2 = Matrix[[3, 3, 3], [-3, 3, 3]]
      refute m2 >= m1
    end

    def test_less_or_equal
      m1 = Matrix[[1, 2, 3], [3, 2, 1]]
      m2 = Matrix[[1, 1, 1], [1, 1, 1]]
      assert m2 <= m1
    end

    def test_not_less_or_equal
      m1 = Matrix[[1, 2, 3], [3, 2, 1]]
      m2 = Matrix[[3, 3, 3], [-3, 3, 3]]
      refute m2 <= m1
    end

    def test_empty?
      m = Matrix[[1]]
      refute m.empty?
    end

    def test_freeze_index
      m = Matrix[[1, 2], [3, 4]]
      m.freeze
      assert_raises (FrozenError) { m[1, 1] = 1 }  
    end

    def test_freeze_fill
      m = Matrix[[1, 2], [3, 4]]
      m.freeze
      assert_raises (FrozenError) { m.fill!(1) }  
    end

    def test_freeze_add
      m = Matrix[[1, 2], [3, 4]]
      m.freeze
      assert_raises (FrozenError) { m.add!(Matrix[[1, 2], [3, 4]]) }  
    end
  end
end
