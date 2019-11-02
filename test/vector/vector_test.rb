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

    def test_same
      v = Vector[1, 2]
      assert_same v, v
    end

    def test_not_same
      refute_same Vector[1, 2], Vector[1, 2]
    end

    def test_eql
      v1 = Vector[1, 2, 3, 4, 5, 6]
      v2 = Vector[1, 2, 3, 4, 5, 6]
      assert v1.eql? v2
    end

    def test_not_eql_value
      v1 = Vector[1, 2, 3, 4, 5, 6]
      v2 = Vector[1, 2, 3, 5, 5, 6]
      refute v1.eql? v2
    end

    def test_not_eql_sizes
      v1 = Vector[1, 2, 3, 4, 5, 6]
      v2 = Vector[1, 2, 3]
      refute v1.eql? v2
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

    def test_to_s
      v1 = Vector[1, 2, 3]
      assert_equal "FastMatrix::Vector[1.0, 2.0, 3.0]", v1.to_s
    end

    def test_to_str
      v1 = Vector[1, 2, 3]
      assert_equal "FastMatrix::Vector[1.0, 2.0, 3.0]", v1.to_str
    end

    def test_inspect
      v1 = Vector[1, 2, 3]
      assert_equal "FastMatrix::Vector[1.0, 2.0, 3.0]", v1.inspect
    end
  end
end
