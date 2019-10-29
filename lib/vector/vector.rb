require 'vector/constructors'

module FastMatrix
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

    # FIXME: for compare with standard matrix
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
  end
end
