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

  end
end
