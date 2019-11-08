require 'vector/constructors'

module FastMatrix
  class Vector

    #
    # Create fast vector from standard vector
    #
    def self.convert(vector)
      elements(vector)
    end

    #
    # Convert to standard ruby vector.
    #
    def convert
      ::Vector.elements(self)
    end

    def to_ary
      Array.new(size) { |i| self[i] }
    end

    def to_s
      "#{self.class}[#{to_ary.join(', ')}]"
    end
    alias to_str to_s
    alias inspect to_str

    #
    # Iterate over the elements of this vector
    #
    def each
      raise NotSupportedError unless block_given?

      (0...size).each do |i|
        yield self[i]
      end
      self
    end

    def each_with_index
      (0...size).each do |i|
        yield self[i], i
      end
      self
    end

    # don't use (Issue#1)
    def each_with_index!
      (0...size).each do |i|
        self[i] = yield self[i], i
      end
      self
    end

    # FIXME: for compare with standard vector
    def ==(other)
      return eql?(other) if other.class == Vector
      return false unless %i[size \[\]].all? { |x| other.respond_to? x }
      return false unless self.size == other.size

      result = true
      each_with_index do |elem, i|
        result &&= elem == other[i].to_f
      end
      result
    end

    def independent?(*vs)
      vs << self
      Vector.independent?(*vs)
    end
  end
end
