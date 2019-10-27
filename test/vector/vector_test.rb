require 'test_helper'

class FastVectorTest < Minitest::Test
  def test_sum
    v1 = FastMatrix::Vector.new(2)
    v2 = FastMatrix::Vector.new(2)
    v = FastMatrix::Vector.new(2)

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

  def test_clone
    m1 = FastMatrix::Vector[1, 3, -5, 6, 6, 7]
    m2 = m1.clone

    assert_equal m1, m2
  end

  def test_multiply_vm
    v = FastMatrix::Vector[3, -1]
    m = FastMatrix::Matrix[[2, 3, 1]]
    r = FastMatrix::Matrix[[6, 9, 3], [-2, -3, -1]]

    assert_equal r, v * m
  end

  def test_multiply_vn
    m1 = FastMatrix::Vector[3, 5, 10, -2, 0]
    m2 = FastMatrix::Vector[15, 25, 50, -10, 0]

    assert_equal m2, m1 * 5
  end

  def test_multiply_vv
    v1 = FastMatrix::Vector[2, 3, -1, 4, 7]
    v2 = FastMatrix::Vector[2]
    r = FastMatrix::Vector[4, 6, -2, 8, 14]

    assert_equal r, v1 * v2
  end
end
