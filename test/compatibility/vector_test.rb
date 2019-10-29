require 'compatibility/compatibility_helper'

module CompatibilityTest
  # noinspection RubyInstanceMethodNamingConvention
  class CompatibilityVectorsTest < Minitest::Test
    include CompatibilityHelper

    def test_equal_by_value_fast_with_standard
      standard, fast = create_vectors(1, 2, 3, 4, -5, -3)
      assert fast == standard, 'Equals fast vector and standard vector'
    end

    def test_equal_by_value_standard_with_fast
      standard, fast = create_vectors(1, 2, 3, 4, -5, -3)
      skip 'Issue#9'
      assert standard == fast, 'Equals standard vector and fast vector'
    end

    def test_no_equal_by_value_fast_with_standard
      standard, fast = create_vectors(1, 2, 3, 4, -5, -3)
      fast[2] = 666
      assert fast != standard, 'Not equals fast vector and standard vector'
    end

    def test_no_equal_by_value_standard_with_fast
      standard, fast = create_vectors(1, 2, 3, 4, -5, -3)
      fast[2] = 666
      assert standard != fast, 'Not equals standard vector and fast vector'
    end

    def test_convert_from_fast_to_standard
      standard, fast = create_vectors(1, 2, 3, 4, -5, -3)
      assert_equal standard, fast.convert
    end

    def test_convert_from_standard_to_fast
      standard, fast = create_vectors(1, 2, 3, 4, -5, -3)
      assert_equal fast, FastMatrix::Vector.convert(standard)
    end

    def test_size
      standard, fast = zero_vectors(10)
      assert_equal standard.size, fast.size
    end
  end
end
