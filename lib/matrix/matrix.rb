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
     def each(which = :all)
        return to_enum :each, which unless block_given?
        last = column_count - 1
        case which
        when :all
          block = Proc.new
          rows.each do |row|
            row.each(&block)
          end
        when :diagonal
          rows.each_with_index do |row, row_index|
            yield row.fetch(row_index){return self}
          end
        when :off_diagonal
          rows.each_with_index do |row, row_index|
            column_count.times do |col_index|
              yield row[col_index] unless row_index == col_index
            end
          end
        when :lower
          rows.each_with_index do |row, row_index|
            0.upto([row_index, last].min) do |col_index|
              yield row[col_index]
            end
          end
        when :strict_lower
          rows.each_with_index do |row, row_index|
            [row_index, column_count].min.times do |col_index|
              yield row[col_index]
            end
          end
        when :strict_upper
          rows.each_with_index do |row, row_index|
            (row_index+1).upto(last) do |col_index|
              yield row[col_index]
            end
          end
        when :upper
          rows.each_with_index do |row, row_index|
            row_index.upto(last) do |col_index|
              yield row[col_index]
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
