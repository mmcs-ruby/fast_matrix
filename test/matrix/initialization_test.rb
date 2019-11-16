require 'test_helper'

module FastMatrixTest
  # noinspection RubyInstanceMethodNamingConvention
  class InitializationTest < Minitest::Test
    include FastMatrix

    def test_init
      m = Matrix.new(2, 4)
      assert_equal 2, m.row_count
      assert_equal 4, m.column_count
    end

    def test_init_incorrect_dimensions
      assert_raises(IndexError) { Matrix.new(-2, 4) }
    end

    def test_init_from_brackets
      m = Matrix[[1, 2], [3, 4], [5, 6]]
      assert_equal 3, m.row_count
      assert_equal 2, m.column_count
      assert_equal 1, m[0, 0]
      assert_equal 2, m[0, 1]
      assert_equal 3, m[1, 0]
      assert_equal 4, m[1, 1]
      assert_equal 5, m[2, 0]
      assert_equal 6, m[2, 1]
    end

    def test_init_column_vector
      m = Matrix.column_vector([0, 1, 2, 3, 4])
      assert_equal Matrix[[0], [1], [2], [3], [4]], m
    end

    def test_init_column_vector_empty
      assert_raises(NotSupportedError) do
        Matrix.column_vector([])
      end
    end

    def test_init_row_vector
      m = Matrix.row_vector([0, 1, 2, 3, 4])
      assert_equal Matrix[[0, 1, 2, 3, 4]], m
    end

    def test_init_row_vector_empty
      assert_raises(NotSupportedError) do
        Matrix.row_vector([])
      end
    end

    def test_build
      actual = Matrix.build(2, 4) { |row, col| col - row }
      expected = Matrix[[0, 1, 2, 3], [-1, 0, 1, 2]]
      assert_equal expected, actual
    end

    def test_scalar_3
      m1 = Matrix.scalar(3, 5)
      m2 = Matrix[[5, 0, 0], [0, 5, 0], [0, 0, 5]]
      assert_equal m2, m1
    end

    def test_scalar_2
      m1 = Matrix.scalar(2, -2)
      m2 = Matrix[[-2, 0], [0, -2]]
      assert_equal m2, m1
    end

    def test_identity
      expected = Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]]
      actual = Matrix.identity(3)
      assert_equal expected, actual
    end

    def test_build_incorrect_dimensions
      assert_raises(IndexError) { Matrix.build(-2, 4) }
    end

    def test_build_empty
      assert_raises(NotSupportedError) { Matrix.build(0, 4) }
    end

    def test_columns
      actual = Matrix.columns([[25, 93, 34], [-1, 66, 78]])
      expected = Matrix[[25, -1], [93, 66], [34, 78]]
      assert_equal expected, actual
    end

    def test_rows
      actual = Matrix.rows([[25, 93, 34], [-1, 66, 78]])
      expected = Matrix[[25, 93, 34], [-1, 66, 78]]
      assert_equal expected, actual
    end

    def test_rows_no_copy
      assert_raises(NotSupportedError) do
        Matrix.rows([[1, 2, 3]], false)
      end
    end

    def test_empty
      assert_raises(NotSupportedError) { Matrix.empty }
    end

    def test_fill
      assert_equal Matrix[[42, 42, 42, 42], [42, 42, 42, 42]], Matrix.fill(42, 2, 4)
    end

    def test_zero
      assert_equal Matrix[[0, 0, 0], [0, 0, 0]], Matrix.zero(2, 3)
    end

    def test_diagonal
      actual = Matrix.diagonal(9, 5, -3)
      expected = Matrix[[9, 0, 0], [0, 5, 0], [0, 0, -3]]
      assert_equal expected, actual
    end

    def test_vstack_2
      x = Matrix[[1, 2], [3, 4]]
      y = Matrix[[5, 6], [7, 8]]
      assert_equal Matrix[[1, 2], [3, 4], [5, 6], [7, 8]], Matrix.vstack(x, y)
    end

    def test_vstack_3
      x = Matrix[[1, 2],
                 [3, 4]]
      y = Matrix[[5, 6],
                 [7, 8]]
      z = Matrix[[8, 7],
                 [6, 5],
                 [4, 3]]
      assert_equal Matrix[[1, 2],
                          [3, 4],
                          [5, 6],
                          [7, 8],
                          [8, 7],
                          [6, 5],
                          [4, 3]], Matrix.vstack(x, y, z)
    end

    def test_vstack_size_error
      x = Matrix[[1, 2], [3, 4]]
      y = Matrix[[1], [3]]
      assert_raises(IndexError) { Matrix.vstack(x, y) }
    end

    def test_vstack_count_error
      assert_raises(IndexError) { Matrix.vstack }
    end
    
    def test_vstack_type_error
      assert_raises(TypeError) { Matrix.vstack("s1", "s2", "s3") }
    end

    def test_hstack_2
      x = Matrix[[1, 2], [3, 4]]
      y = Matrix[[5, 6], [7, 8]]
      assert_equal Matrix[[1, 2, 5, 6], [3, 4, 7, 8]], Matrix.hstack(x, y)
    end

    def test_hstack_3
      x = Matrix[[1, 2],
                 [3, 4]]
      y = Matrix[[5, 6],
                 [7, 8]]
      z = Matrix[[8, 7, 6],
                 [5, 4, 3]]
      assert_equal Matrix[[1, 2, 5, 6, 8, 7, 6],
                          [3, 4, 7, 8, 5, 4, 3]],
                   Matrix.hstack(x, y, z)
    end

    def test_hstack_size_error
      x = Matrix[[1, 2], [3, 4]]
      y = Matrix[[5, 6], [7, 8]]
      z = Matrix[[5, 6], [7, 8], [9, 10]]
      assert_raises(IndexError) { Matrix.hstack(x, y, z) }
    end

    def test_hstack_type_error
      assert_raises(TypeError) { Matrix.hstack("s1", "s2", "s3") }
    end

    def test_combine
      x = Matrix[[6, 6], [4, 4]]
      y = Matrix[[1, 2], [3, 4]]
      z = Matrix[[5, -4], [-2, -42]]
      assert_equal Matrix[[0, 8], [3, 42]], Matrix.combine(x, y, z) {|a, b| a - b}
    end
  end
end
