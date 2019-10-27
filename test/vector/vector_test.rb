require 'test_helper'

module FastVectorTest
  class VectorTest < Minitest::Test
    include FastMatrix

    def test_clone
      original = Vector[1, 3, -5, 6, 6, 7]
      clone = original.clone

      assert_equal original, clone
      refute_same original, clone
    end

    def test_equal_by_value
      v1 = Vector[1, 2, 3, 4]
      v2 = Vector[1, 2, 3, 4]
      assert_equal v1, v2
    end

    def test_not_equal_by_value
      v1 = Vector[1, 2, 3, 4]
      v2 = Vector[3, 4, 1, 2]
      refute_equal v1, v2
    end
  end
end
