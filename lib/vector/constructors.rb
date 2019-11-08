require 'fast_matrix/fast_matrix'
require 'errors'

module FastMatrix
  class Vector
    #
    # Creates a Vector from a list of elements.
    #   Vector[7, 4, ...]
    #
    def self.[](*elems)
      vector = new(elems.size)
      vector.each_with_index! { |_, idx| elems[idx] }
      vector
    end

    #
    # Creates a vector from an Array.
    # The optional argument +copy+ exists only for compatibility with standard.
    # The optional argument +copy+ cannot be false, unlike standard.
    #
    def self.elements(array, copy = true)
      check_flag_copy(copy)
      self[*array]
    end

    #
    # Returns a standard basis +n+-vector, where k is the index.
    #
    #    Vector.basis(size, index) # => Vector[0, 1, 0]
    #
    def self.basis(size, index)
      result = zero(size)
      result[index] = 1
      result
    end

    #
    # Return a zero vector.
    #
    #    Vector.zero(3) => Vector[0, 0, 0]
    #
    def self.zero(size)
      result = new(size)
      result.fill!(0)
    end

    class << Vector
      private

      def check_flag_copy(copy)
        unless copy
          raise NotSupportedError, "Can't create vector without copy elements"
        end
      end
    end
  end
end
