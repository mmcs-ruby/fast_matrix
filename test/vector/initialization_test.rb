require 'test_helper'

module FastVectorTest
  # noinspection RubyInstanceMethodNamingConvention
  class InitializationTest < Minitest::Test
    include FastMatrix

    def test_init
      v = Vector.new(5)
      assert_equal 5, v.size
    end

    def test_init_invalid_dimension
      assert_raises(IndexError) { Vector.new(-5) }
    end

    def test_init_empty
      assert_raises(IndexError) { Vector.new(0) }
    end

    def test_init_from_brackets
      v = Vector[2, 3, 5, 1, -1]
      assert_equal 5, v.size
      assert_equal 2, v[0]
      assert_equal 3, v[1]
      assert_equal 5, v[2]
      assert_equal 1, v[3]
      assert_equal(-1, v[4])
    end

    def test_elements_copy_false
      assert_raises(NotSupportedError) { Vector.elements([1, 2], false) }
    end

    def test_basis1
      assert_equal Vector[1, 0, 0, 0], Vector.basis(4, 0)
    end

    def test_basis2
      assert_equal Vector[0, 1, 0], Vector.basis(3, 1)
    end

    def test_zero
      assert_equal Vector[0, 0, 0], Vector.zero(3)
    end
  end
end
