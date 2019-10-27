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
  end
end
