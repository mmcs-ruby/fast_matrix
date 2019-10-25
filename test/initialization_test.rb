require 'test_helper'

# noinspection RubyInstanceMethodNamingConvention
class InitializationTest < Minitest::Test
  def test_init
    m = FastMatrix::Matrix.new(2, 4)
    assert_equal 2, m.row_count
    assert_equal 4, m.column_count
  end

  def test_init_from_brackets
    m = FastMatrix::Matrix[[1, 2], [3, 4], [5, 6]]
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
    m = FastMatrix::Matrix.column_vector([0, 1, 2, 3, 4])
    (0..4).each { |i| assert_equal i, m[i, 0] }
  end

  def test_init_row_vector
    m = FastMatrix::Matrix.row_vector([0, 1, 2, 3, 4])
    (0..4).each { |j| assert_equal j, m[0, j] }
  end

  def test_build
    actual = FastMatrix::Matrix.build(2, 4) {|row, col| col - row }
    expected = FastMatrix::Matrix[[0, 1, 2, 3], [-1, 0, 1, 2]]
    assert_equal expected, actual
  end

  def test_vector_init
    v = FastMatrix::Vector.new(5)
    v[3] = 7
    assert 7, v[3]
    assert 5, v.size
  end

  def test_vector_init_from_brackets
    v = FastMatrix::Vector[2, 3, 5, 1, -1]
    assert_equal 5, v.size
    
    assert_equal 2, v[0]
    assert_equal 3, v[1]
    assert_equal 5, v[2]
    assert_equal 1, v[3]
    assert_equal -1, v[4]
  end
end