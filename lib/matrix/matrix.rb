require 'matrix/constructors'

module FastMatrix
  # Matrix with fast implementations of + - * determinate in C
  class Matrix

    # Aliases just for compatibility with standard matrix
    #
    # Returns the number of rows.
    #
    alias row_size row_count
    #
    # Returns the number of columns.
    #
    alias column_size column_count
    #
    # Returns element (+i+,+j+) of the matrix.  That is: row +i+, column +j+.
    #
    alias element []
    alias component []

    def collect
      collected_rows = []
      rows.each do |i|
        collected_rows.push(yield i)
      end
      collected_rows
    end

    def to_s
      "#{self.class}[" + collect{|row|
        "[" + row.join(", ") +"]"
      }.join(", ")+"]"
    end

    def to_str
      to_s
    end

    def inspect
      to_s
    end

    #
    # Create fast matrix from standard matrix
    #
    def self.convert(matrix)
      fast_matrix = Matrix.new(matrix.row_count, matrix.column_count)
      (0...matrix.row_count).each do |i|
        (0...matrix.column_count).each do |j|
          fast_matrix[i, j] = matrix[i, j]
        end
      end
      fast_matrix
    end

    def each_with_index
      (0...row_count).each do |i|
        (0...column_count).each do |j|
          yield self[i, j], i, j
        end
      end
    end

    def each_with_index!
      (0...row_count).each do |i|
        (0...column_count).each do |j|
          self[i, j] = yield self[i, j], i, j
        end
      end
      self
    end

    #
    # Convert to standard ruby matrix.
    #
    def convert
      ::Matrix.build(row_size, column_size) { |i, j| self[i, j] }
    end

    # FIXME: for compare with standard matrix
    def ==(other)
      return eql?(other) if other.class == Matrix
      return false unless %i[row_size column_size \[\]].all? { |x| other.respond_to? x }
      return false unless self.row_size == other.row_size && self.column_size == other.column_size

      result = true
      each_with_index do |elem, i, j|
        result &&= elem == other[i, j].to_f
      end
      result
    end

    private

    def rows
      rows = []
      (0...row_count).each do |i|
        row = []
        (0...column_count).each do |j|
          row.push(element(i, j))
        end
        rows.push(row)
      end
      rows
    end
  end
end
