# frozen_string_literal: true
require 'test_helper'

module FastMatrixTest
  # noinspection RubyInstanceMethodNamingConvention
  class MatrixTest < Minitest::Test
    def test_equal_by_value
      m1 = FastMatrix::Matrix[[1, 2], [3, 4]]
      m2 = FastMatrix::Matrix[[1, 2], [3, 4]]
      assert_equal m1, m2
    end

    def test_not_equal_by_value
      m1 = FastMatrix::Matrix[[1, 2], [3, 4]]
      m2 = FastMatrix::Matrix[[3, 4], [1, 2]]
      refute_equal m1, m2
    end

    def test_clone
      original = FastMatrix::Matrix[[1, 2], [3, 4], [7, 0]]
      clone = original.clone

      assert_equal original, clone
      refute_same original, clone
    end
  end
end
