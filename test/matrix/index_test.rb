# frozen_string_literal: true
require 'test_helper'

module FastMatrixTest
  # noinspection RubyInstanceMethodNamingConvention
  class IndexTest < Minitest::Test
    def test_get
      m = FastMatrix::Matrix[[11, 12, 13], [21, 22, 23]]
      assert_equal 23, m[1, 2]
    end

    def test_get_out_of_range_row
      skip 'Issue#8'
      m = FastMatrix::Matrix[[11, 12, 13], [21, 22, 23]]
      assert_nil m[2, 0]
    end

    def test_get_out_of_range_column
      skip 'Issue#8'
      m = FastMatrix::Matrix[[11, 12, 13], [21, 22, 23]]
      assert_nil m[0, 3]
    end

    def test_get_neg
      skip 'Issue#8'
      m = FastMatrix::Matrix[[11, 12, 13], [21, 22, 23]]
      assert_equal 13, m[-2, -1]
    end

    def test_get_out_of_range_row_neg
      skip 'Issue#8'
      m = FastMatrix::Matrix[[11, 12, 13], [21, 22, 23]]
      assert_nil m[-3, 0]
    end

    def test_get_out_of_range_column_neg
      skip 'Issue#8'
      m = FastMatrix::Matrix[[11, 12, 13], [21, 22, 23]]
      assert_nil m[0, -2]
    end

    def test_set
      m = FastMatrix::Matrix.zero(2)
      expected = 555
      m[1, 1] = expected
      assert_equal expected, m[1, 1]
    end

    def test_set_neg
      skip 'Issue#8'
      m = FastMatrix::Matrix.zero(2)
      expected = 555
      m[-2, -2] = expected
      assert_equal expected, m[0, 0]
    end

    def test_set_out_of_range
      m = FastMatrix::Matrix.new(2, 4)
      assert_raises(FastMatrix::IndexError) { m[3, 5] = 0 }
    end

    def test_set_out_of_range_neg
      m = FastMatrix::Matrix.new(2, 4)
      assert_raises(FastMatrix::IndexError) { m[-3, -10] = 0 }
    end

    def test_set_nan
      m = FastMatrix::Matrix.new(2, 4)
      assert_raises(FastMatrix::TypeError) { m[1, 1] = 'not a number' }
    end
  end
end
