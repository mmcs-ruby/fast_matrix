require 'test_helper'
require 'matrix'

module FastMatrixTest
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
  end
end
