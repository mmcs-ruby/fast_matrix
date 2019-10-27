require 'test_helper'

# noinspection RubyInstanceMethodNamingConvention
class InitializationTest < Minitest::Test
  def test_init
    v = FastMatrix::Vector.new(5)
    v[3] = 7
    assert 7, v[3]
    assert 5, v.size
  end

  def test_init_from_brackets
    v = FastMatrix::Vector[2, 3, 5, 1, -1]
    assert_equal 5, v.size
    assert_equal 2, v[0]
    assert_equal 3, v[1]
    assert_equal 5, v[2]
    assert_equal 1, v[3]
    assert_equal(-1, v[4])
  end
end
