require 'test_helper'
require 'matrix'

# noinspection RubyInstanceMethodNamingConvention
class CompatibilityWithStandardTest < Minitest::Test
  def test_equal_by_value
    m1 = FastMatrix::Matrix[[1, 2], [3, 4]]
    m2 = ::Matrix[[1, 2], [3, 4]]
    assert m1 == m2, 'Equals fast matrix and standard matrix'
    skip 'Standard matrix does not recognizes fast matrix'
    assert m2 == m1, 'Equals standard matrix and fast matrix'
  end

  def test_no_equal_by_value
    m1 = FastMatrix::Matrix[[1, 2], [3, 4]]
    m2 = ::Matrix[[1, 2], [3, 4]]
    assert m1 == m2, 'Equals fast matrix and standard matrix'
    skip 'Standard matrix does not recognizes fast matrix'
    assert m2 == m1, 'Equals standard matrix and fast matrix'
  end

  def test_convert_from_fast_to_standard
    fast = FastMatrix::Matrix[[1, 2], [3, 4], [-5, -3]]
    standard = ::Matrix[[1, 2], [3, 4], [-5, -3]]
    assert_equal standard, fast.convert
  end

  def test_convert_from_standard_to_fast
    standard = ::Matrix[[1, 2], [-3, 4], [1, 2]]
    fast = FastMatrix::Matrix[[1, 2], [-3, 4], [1, 2]]
    assert_equal fast, FastMatrix::Matrix.convert(standard)
  end

  def test_sizes
    standard = ::Matrix.build(20, 40){ 0 }
    fast = FastMatrix::Matrix.build(20, 40) { 0 }
    assert_equal standard.row_count, fast.row_count
    assert_equal standard.row_size, fast.row_size
    assert_equal standard.column_count, fast.column_count
    assert_equal standard.column_size, fast.column_size
  end
end