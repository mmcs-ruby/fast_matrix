require 'test_helper'

module FastVectorTest
  class VectorTest < Minitest::Test
    include FastMatrix

    def test_get
      expected = 974.34
      v = Vector[1, expected, 3, 4]
      assert_equal expected, v[1]
    end

    def test_get_neg
      skip 'Issue#8'
      expected = 974.34
      v = Vector[1, expected, 3, 4]
      assert_equal expected, v[-3]
    end

    def test_get_out_of_range
      skip 'Issue#8'
      v = Vector.new(2)
      assert_nil v[2]
    end

    def test_get_out_of_range_neg
      skip 'Issue#8'
      v = Vector.new(2)
      assert_nil v[-3]
    end

    def test_set
      v = Vector.new(4)
      expected = 974.34
      v[1] = expected
      assert_equal expected, v[1]
    end

    def test_set_neg
      skip 'Issue#8'
      v = Vector.new(4)
      expected = 974.34
      v[-3] = expected
      assert_equal v[1], v[-3]
    end

    def test_set_out_of_range
      v = Vector.new(2)
      assert_raises(IndexError) { v[2] = 666 }
    end

    def test_set_out_of_range_neg
      v = Vector.new(2)
      assert_raises(IndexError) { v[-3] = 666 }
    end

    def test_set_nan
      v = Vector.new(2)
      assert_raises(TypeError) { v[1] = 'not a number' }
    end
  end
end
