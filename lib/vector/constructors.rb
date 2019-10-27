require 'fast_matrix/fast_matrix'

module FastMatrix
  class Vector

    def self.[](*elems)
      vector = Vector.new(elems.size)
      vector.each_with_index! { |_, idx| elems[idx] }
      vector
    end
  end
end
