# frozen_string_literal: true
require 'test_helper'

module FastMatrixTest
  # noinspection RubyInstanceMethodNamingConvention
  class MatrixTest < Minitest::Test
    include FastMatrix

    def test_same
      m = Matrix[[1, 2]]
      assert_same m, m
    end

    def test_not_same
      refute_same Matrix[[1, 2]], Matrix[[1, 2]]
    end

    def test_eql
      m1 = Matrix[[1, 2, 3], [4, 5, 6]]
      m2 = Matrix[[1, 2, 3], [4, 5, 6]]
      assert m1.eql? m2
    end

    def test_not_eql_value
      m1 = Matrix[[1, 2, 3], [4, 5, 6]]
      m2 = Matrix[[1, 2, 3], [5, 5, 6]]
      refute m1.eql? m2
    end

    def test_not_eql_sizes
      m1 = Matrix[[1, 2, 3], [4, 5, 6]]
      m2 = Matrix[[1, 2, 3]]
      refute m1.eql? m2
    end

    def test_equal_by_value
      m1 = Matrix[[1, 2], [3, 4]]
      m2 = Matrix[[1, 2], [3, 4]]
      assert_equal m1, m2
    end

    def test_not_equal_by_value
      m1 = Matrix[[1, 2], [3, 4]]
      m2 = Matrix[[3, 4], [1, 2]]
      refute_equal m1, m2
    end

    def test_clone
      original = Matrix[[1, 2], [3, 4], [7, 0]]
      clone = original.clone

      assert_equal original, clone
      refute_same original, clone
    end
  end
end
