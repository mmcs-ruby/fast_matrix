require 'fast_matrix/fast_matrix'
require 'errors'

module FastMatrix
  #
  # Constructors as in the standard matrix
  #
  class Matrix
    #
    # Creates a matrix of size +row_count+ x +column_count+.
    # It fills the values by calling the given block,
    # passing the current row and column.
    # Returns random matrix if no block is given.
    #
    #   m = Matrix.build(2, 4) {|row, col| col - row }
    #     => Matrix[[0, 1, 2, 3], [-1, 0, 1, 2]]
    #   m = Matrix.build(3) { rand }
    #     => a 3x3 matrix with random elements
    #
    def self.build(row_count, column_count = row_count, &block)
      matrix = create_with_check(row_count, column_count)
      raise NotImplementedError, 'Issue#17' unless block_given?

      matrix.each_with_index! { |_, i, j| block.call(i, j) }
    end

    #
    # Creates a matrix where +rows+ is an array of arrays, each of which is a row
    # of the matrix.
    # The optional argument +copy+ exists only for compatibility with standard.
    # The optional argument +copy+ cannot be false, unlike standard.
    #   Matrix.rows([[25, 93], [-1, 66]])
    #      =>  25 93
    #          -1 66
    #
    def self.rows(rows, copy = true)
      check_flag_copy(copy)
      lines(rows, true)
    end

    #
    # Creates a matrix using +columns+ as an array of column vectors.
    #   Matrix.columns([[25, 93], [-1, 66]])
    #      =>  25 -1
    #          93 66
    #
    def self.columns(columns)
      lines(columns, false)
    end

    #
    # Creates a matrix where each argument is a row.
    #   Matrix[ [25, 93], [-1, 66] ]
    #      =>  25 93
    #          -1 66
    #
    def self.[](*rows)
      self.rows(rows)
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
      matrix = create_with_check(column.size, 1)
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
      matrix = create_with_check(1, row.size)
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
      build(values.size, values.size) { |i, j| i == j ? values[i] : 0 }
    end

    #
    # Creates an +n+ by +n+ diagonal matrix where each diagonal element is
    # +value+.
    #   Matrix.scalar(2, 5)
    #     => 5 0
    #        0 5
    #
    def self.scalar(n, value)
      build(n, n) { |i, j| i == j ? value : 0 }
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
    class << Matrix
      alias unit identity
      alias I identity
    end

    ##
    # Creates a filled matrix
    # Matrix.fill(42, 2, 4)
    #     =>  42 42 42 42
    #         42 42 42 42
    ##
    def self.fill(value, row_count, column_count = row_count)
      create_with_check(row_count, column_count).fill!(value)
    end

    #
    # Creates a zero matrix +row_count+ by +column_count+.
    #   Matrix.zero(2, 3)
    #     => 0 0 0
    #        0 0 0
    #
    def self.zero(row_count, column_count = row_count)
      fill(0, row_count, column_count)
    end

    #
    # Empty matrices does not supported
    #
    def self.empty(_ = 0, _ = 0)
      raise NotSupportedError, 'Empty matrices does not supported'
    end

    #
    # Create a matrix by stacking matrices vertically
    #
    #   x = Matrix[[1, 2], [3, 4]]
    #   y = Matrix[[5, 6], [7, 8]]
    #   Matrix.vstack(x, y) # => Matrix[[1, 2], [3, 4], [5, 6], [7, 8]]
    # TODO: optimize (maybe in C)
    def self.vstack(x, *matrices)
      column_count = x.column_count
      row_count = x.row_count
      matrices.each do |matrix|
        raise IndexError unless matrix.column_count == column_count

        row_count += matrix.row_count
      end
      result = new(row_count, column_count)
      m_i = 0
      [x, *matrices].each do |matrix|
        matrix.each_with_index do |elem, i, j|
          result[m_i + i, j] = elem
        end
        m_i += matrix.row_count
      end
      result
    end

    #
    # Create a matrix by stacking matrices horizontally
    #
    #   x = Matrix[[1, 2], [3, 4]]
    #   y = Matrix[[5, 6], [7, 8]]
    #   Matrix.hstack(x, y) # => Matrix[[1, 2, 5, 6], [3, 4, 7, 8]]
    #
    def self.hstack(x, *matrices)
      column_count = x.column_count
      row_count = x.row_count
      matrices.each do |matrix|
        raise IndexError unless matrix.row_count == row_count

        column_count += matrix.column_count
      end
      result = new(row_count, column_count)
      m_j = 0
      [x, *matrices].each do |matrix|
        matrix.each_with_index do |elem, i, j|
          result[i, m_j + j] = elem
        end
        m_j += matrix.column_count
      end
      result
    end

    #
    # Create a matrix by combining matrices entrywise, using the given block
    #
    #   x = Matrix[[6, 6], [4, 4]]
    #   y = Matrix[[1, 2], [3, 4]]
    #   Matrix.combine(x, y) {|a, b| a - b} # => Matrix[[5, 4], [1, 0]]
    # TODO: optimize in C
    def self.combine(*matrices)
      return empty if matrices.empty?

      result = convert(matrices.first)
      matrices[1..matrices.size].each do |m|
        raise IndexError unless result.row_count == m.row_count &&
                                result.column_count == m.column_count

        result.each_with_index! { |elem, i, j| yield elem, m[i, j] }
      end
      result
    end

    class << Matrix
      private

      def create_with_check(row_count, column_count)
        check_dimensions(row_count, column_count)
        new(row_count, column_count)
      end

      def check_empty_matrix(row_count, column_count)
        empty if row_count.zero? || column_count.zero?
      end

      def check_negative_sizes(row_count, column_count)
        raise IndexError if column_count.negative? || row_count.negative?
      end

      def check_dimensions(row_count, column_count)
        check_empty_matrix(row_count, column_count)
        check_negative_sizes(row_count, column_count)
      end

      def check_flag_copy(copy)
        unless copy
          raise NotSupportedError, "Can't create matrix without copy elements"
        end
      end

      # generalization between ::rows and ::columns
      def lines(lines, main_is_rows)
        sizes = [lines.size, (lines[0] || []).size]
        offset = main_is_rows ? 0 : -1
        matrix = create_with_check(sizes[offset], sizes[1 + offset])
        lines.each_with_index do |second_dim, main_index|
          raise IndexError if second_dim.size != sizes[1]

          second_dim.each_with_index do |elem, second_index|
            indices = [main_index, second_index]
            matrix[indices[offset], indices[1 + offset]] = elem
          end
        end
        matrix
      end
    end
  end
end
