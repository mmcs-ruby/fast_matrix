require "fast_matrix/version"
require "fast_matrix/fast_matrix"
require "constructors"

module FastMatrix
  class Error < StandardError; end

  # Matrix with fast implementations of + - * determinate in C
  class Matrix

    # Aliases just for compatibility with standard matrix
    #
    # Returns the number of rows.
    #
    alias_method :row_size, :row_count
    #
    # Returns the number of columns.
    #
    alias_method :column_size, :column_count

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


    # FIXME for compare with standard matrix
    def ==(other)
      # TODO check class and use fast compare from C if possibly
      return false unless %i[row_size column_size \[\]].all? { |x| other.respond_to? x }
      return false unless self.row_size == other.row_size && self.column_size == other.column_size

      result = true
      each_with_index do |elem, i, j|
        result &&= elem == other[i, j].to_f
      end
      result
    end
  end
  
  class Vector

    def each_with_index
      (0...size).each do |i|
        yield self[i], i
      end
    end

    def each_with_index!
      (0...size).each do |i|
        self[i] = yield self[i], i
      end
      self
    end

  end
end
