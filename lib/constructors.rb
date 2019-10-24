require "fast_matrix/version"

module FastMatrix
  class Matrix

    #
    # Creates a matrix of size +row_count+ x +column_count+.
    # It fills the values by calling the given block,
    # passing the current row and column.
    # Returns an enumerator if no block is given.
    #
    #   m = Matrix.build(2, 4) {|row, col| col - row }
    #     => Matrix[[0, 1, 2, 3], [-1, 0, 1, 2]]
    #   m = Matrix.build(3) { rand }
    #     => a 3x3 matrix with random elements
    #
    def self.build(row_count, column_count = row_count, &block)
      matrix = self.new(row_count, column_count)
      matrix.each_with_index! { |_, i, j| block.call(i, j) }
    end
      #
    # Creates a matrix where each argument is a row.
    #   Matrix[ [25, 93], [-1, 66] ]
    #      =>  25 93
    #          -1 66
    #
    def self.[](*rows)
      columns_count = rows[0].size
      rows_count = rows.size
      matrix = Matrix.new(rows_count, columns_count)
      matrix.each_with_index! { |_, i, j| rows[i][j] }
      matrix
    end

    #
    # Creates a single-column matrix where the values of that column are as given
    # in +column+.
    #   Matrix.column_vector([4,5,6])
    #     => 4
    #        5
    #        6
    #
    def self.column_vector(column)
      matrix = Matrix.new(column.size, 1)
      column.each_with_index { |elem, i| matrix[i, 0] = elem }
      matrix
    end

    #
    # Creates a single-row matrix where the values of that row are as given in
    # +row+.
    #   Matrix.row_vector([4,5,6])
    #     => 4 5 6
    #
    def self.row_vector(row)
      matrix = Matrix.new(1, row.size)
      row.each_with_index { |elem, j| matrix[0, j] = elem }
      matrix
    end

    #
    # Creates a matrix where the diagonal elements are composed of +values+.
    #   Matrix.diagonal(9, 5, -3)
    #     =>  9  0  0
    #         0  5  0
    #         0  0 -3
    #
    def self.diagonal(*values)
      matrix = Matrix.new(values.size, values.size)
      matrix.each_with_index! { |_, i, j| i == j ? values[i] : 0 }
      matrix
    end

    #
    # Creates an +n+ by +n+ diagonal matrix where each diagonal element is
    # +value+.
    #   Matrix.scalar(2, 5)
    #     => 5 0
    #        0 5
    #
    def self.scalar(n, value)
      matrix = Matrix.new(n, n)
      matrix.each_with_index! { |_, i, j| i == j ? value : 0 }
      matrix
    end

    #
    # Creates an +n+ by +n+ identity matrix.
    #   Matrix.identity(2)
    #     => 1 0
    #        0 1
    #
    def self.identity(n)
      scalar(n, 1)
    end

    #
    # Creates a zero matrix +n+ by +n+.
    #   Matrix.zero(2)
    #     => 0 0
    #        0 0
    #
    def self.zero(n)
      matrix = Matrix.new(n, n)
      matrix.each_with_index! { |_, _, _| 0 }
      matrix
    end
  end
end
