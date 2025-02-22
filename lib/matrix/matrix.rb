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
    # Returns the inverse of the matrix.
    # 
    alias inv inverse
    alias entrywise_product hadamard_product
    #
    # Returns element (+i+,+j+) of the matrix.  That is: row +i+, column +j+.
    #
    alias element []
    alias component []

    alias lup_decomposition lup
    alias t transpose
    alias tr trace

    alias skew_symmetric? antisymmetric?
    # 
    # In real numbers is equivalent to checking for symmetry
    #     
    alias hermitian? symmetric?

    #
    # Explicit conversion to a Matrix. Returns self
    #
    def to_matrix
      self
    end

    def empty?
      row_count * column_count == 0
    end

    #     
    # Returns true if this is a singular matrix.
    #     
    def singular?
      determinant == 0
    end
    
    # 
    # Returns true if this is a regular (i.e. non-singular) matrix.
    #     
    def regular?
      not singular?
    end

    # 
    # Returns true if this is a square matrix.
    #     
    def square?
      column_count == row_count
    end

    # 
    # Returns the imaginary part of the matrix.
    # Always returns a zero matrix
    #     
    def imaginary()
      Matrix.zero(row_count, column_count)
    end

    alias imag imaginary

    # 
    # Laplace expansion is equal to the determinant in the real numbers
    # 
    def laplace_expansion(row: nil, column: nil) 
      determinant
    end
    alias cofactor_expansion laplace_expansion

    # 
    # Returns an array containing matrices corresponding to the real and imaginary parts of the matrix
    #     
    def rect
      [real, imag]
    end

    alias rectangular rect

    # 
    # Conjugate real matrix is equal to this matrix
    #     
    alias conjugate to_matrix
    alias conj conjugate
    # 
    # Real method in real matrix is equal to this matrix
    #     
    alias real to_matrix

    def real?
      true
    end

    def collect
      collected_rows = []
      rows.each do |i|
        collected_rows.push(yield i)
      end
      collected_rows
    end

    #
    # Overrides Object#to_s
    #
    def to_s
      "#{self.class}[#{collect do |row|
        '[' + row.join(', ') + ']'
      end.join(', ')}]"
    end

    alias to_str to_s
    alias inspect to_str

    def to_a
      rows.collect(&:dup)
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

    #
    # Yields all elements of the matrix, starting with those of the first row
    #
    #   Matrix[ [1,2], [3,4] ].each { |e| puts e }
    #     # => prints the numbers 1 to 4
     def each(which = :all) # :yield: e
        return to_enum :each, which unless block_given?
        case which
        when :all
          (0...row_count).each do |i|
            (0...column_count).each do |j|
              yield self[i, j]
            end
          end
        when :diagonal
          (0...[row_count, column_count].min).each do |i|
                yield self[i, i]
          end
        when :off_diagonal
          (0...row_count).each do |i|
            (0...column_count).each do |j|
              if i != j
                yield self[i, j]
              end
            end
          end
        when :lower
          (0...row_count).each do |i|
            (0..[i,column_count-1].min).each do |j|
              yield self[i, j]
            end
          end
        when :strict_lower
          (1...row_count).each do |i|
            (0...[i,column_count].min).each do |j|
                yield self[i, j]
            end
          end
        when :strict_upper
          (0...row_count).each do |i|
            (i+1...column_count).each do |j|
              yield self[i, j]
            end
          end
        when :upper
          (0...row_count).each do |i|
            (i...column_count).each do |j|
              yield self[i, j]
            end
          end
        else
          raise ArgumentError, "expected #{which.inspect} to be one of :all, :diagonal, :off_diagonal, :lower, :strict_lower, :strict_upper or :upper"
        end
        self
      end
    #
    # Same as #each, but the row index and column index in addition to the element
    #
    #   Matrix[ [1,2], [3,4] ].each_with_index do |e, row, col|
    #     puts "#{e} at #{row}, #{col}"
    #   end
    #     # => Prints:
    #     #    1 at 0, 0
    #     #    2 at 0, 1
    #     #    3 at 1, 0
    #     #    4 at 1, 1
    #
    def each_with_index
      raise NotSupportedError unless block_given?

      (0...row_count).each do |i|
        (0...column_count).each do |j|
          yield self[i, j], i, j
        end
      end
      self
    end

    # don't use (Issue#1)
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
