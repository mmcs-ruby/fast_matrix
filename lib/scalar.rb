require 'fast_matrix/fast_matrix'

module FastMatrix

  class Matrix
    #
    # The coerce method provides support for Ruby type coercion.
    # This coercion mechanism is used by Ruby to handle mixed-type
    # numeric operations: it is intended to find a compatible common
    # type between the two operands of the operator.
    # See also Numeric#coerce.
    #
    def coerce(other)
      case other
      when Numeric
        return Scalar.new(other), self
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end
  end

  class Vector
    #
    # The coerce method provides support for Ruby type coercion.
    # This coercion mechanism is used by Ruby to handle mixed-type
    # numeric operations: it is intended to find a compatible common
    # type between the two operands of the operator.
    # See also Numeric#coerce.
    #
    def coerce(other)
      case other
      when Numeric
        return Scalar.new(other), self
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end
  end

  private

  class Scalar < Numeric # :nodoc:

    def initialize(value)
      @value = value
    end

    def *(other)
      case other
      when Vector, Matrix
        other * @value
      else
        Scalar.new(@value * other)
      end
    end
  end
end
