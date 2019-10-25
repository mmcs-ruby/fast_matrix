require 'test_helper'

class FastVectorTest < Minitest::Test
  def test_sum
    v1 = FastMatrix::Vector.new(2)
    v2 = FastMatrix::Vector.new(2)
    v  = FastMatrix::Vector.new(2)
    
    v1[0] = 1
    v1[1] = 3
    v2[0] = 4
    v2[1] = 3
    v[0] = 5
    v[1] = 6

    assert_equal v, v1 + v2
    v1 += v2
    assert_equal v, v1
  end
end