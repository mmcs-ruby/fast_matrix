require 'matrix/compatibility_helper'

module FastMatrixTest
  # noinspection RubyInstanceMethodNamingConvention
  class CompatibilityWithStandardTest < Minitest::Test
    include CompatibilityHelper

    def test_equal_by_value_fast_with_standard
      standard, fast = create_matrices([1, 2], [3, 4], [-5, -3])
      assert fast == standard, 'Equals fast matrix and standard matrix'
    end

    def test_equal_by_value_standard_with_fast
      standard, fast = create_matrices([1, 2], [3, 4], [-5, -3])
      skip 'Standard matrix does not recognizes fast matrix'
      assert standard == fast, 'Equals standard matrix and fast matrix'
    end

    def test_no_equal_by_value_fast_with_standard
      standard, fast = create_matrices([1, 2], [3, 4], [-5, -3])
      fast[2, 1] = 666
      assert fast != standard, 'Not equals fast matrix and standard matrix'
    end

    def test_no_equal_by_value_standard_with_fast
      standard, fast = create_matrices([1, 2], [3, 4], [-5, -3])
      fast[2, 1] = 666
      assert standard != fast, 'Not equals standard matrix and fast matrix'
    end

    def test_convert_from_fast_to_standard
      standard, fast = create_matrices([1, 2], [3, 4], [-5, -3])
      assert_equal standard, fast.convert
    end

    def test_convert_from_standard_to_fast
      standard, fast = create_matrices([1, 2], [3, 4], [-5, -3])
      assert_equal fast, FastMatrix::Matrix.convert(standard)
    end

    def test_row_count
      standard, fast = build_matrices(10, 20) { 0 }
      assert_equal standard.row_count, fast.row_count
    end

    def test_row_size
      standard, fast = build_matrices(10, 20) { 0 }
      assert_equal standard.row_size, fast.row_size
    end

    def test_column_count
      standard, fast = build_matrices(10, 20) { 0 }
      assert_equal standard.column_count, fast.column_count
    end

    def test_column_size
      standard, fast = build_matrices(10, 20) { 0 }
      assert_equal standard.column_size, fast.column_size
    end
  end
end
