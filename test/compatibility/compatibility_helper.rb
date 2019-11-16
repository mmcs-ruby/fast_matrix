require 'test_helper'
require 'matrix'

module CompatibilityTest
  module CompatibilityHelper
    def create_matrices(*rows)
      standard = ::Matrix[*rows]
      fast = FastMatrix::Matrix[*rows]
      [standard, fast]
    end

    def build_matrices(row_count, column_count, &block)
      standard = ::Matrix.build(row_count, column_count, &block)
      fast = FastMatrix::Matrix.build(row_count, column_count, &block)
      [standard, fast]
    end

    def zero_matrices(row_count, column_count = row_count)
      standard = ::Matrix.zero(row_count, column_count)
      fast = FastMatrix::Matrix.zero(row_count, column_count)
      [standard, fast]
    end

    def create_vectors(*array)
      standard = ::Vector[*array]
      fast = FastMatrix::Vector[*array]
      [standard, fast]
    end

    def zero_vectors(size)
      standard = ::Vector.zero(size)
      fast = FastMatrix::Vector.zero(size)
      [standard, fast]
    end

    def make_scalar(int)
      FastMatrix::Matrix.zero(2).coerce(int).first
    end
  end
end
