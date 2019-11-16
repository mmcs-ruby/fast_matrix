require 'fast_matrix/fast_matrix'
require 'errors'

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
        [Scalar.new(other), self]
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
        [Scalar.new(other), self]
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end
  end

  class Scalar < Numeric # :nodoc:
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def +(other)
      case other
      when Vector, Matrix
        raise OperationNotDefinedError, "#{@value.class}+#{other.class}"
      else
        Scalar.new(@value + other)
      end
    end

    def -(other)
      case other
      when Vector, Matrix
        raise OperationNotDefinedError, "#{@value.class}+#{other.class}"
      else
        Scalar.new(@value - other)
      end
    end

    def *(other)
      case other
      when Vector, Matrix
        other * @value
      else
        Scalar.new(@value * other)
      end
    end

    def /(other)
      case other
      when Vector
        raise OperationNotDefinedError, "#{@value.class}/#{other.class}"
      when Matrix
        self * other.inverse
      else
        Scalar.new(@value / other)
      end
    end

    def **(other)
      case other
      when Vector, Matrix
        raise OperationNotDefinedError, "#{@value.class}**#{other.class}"
      else
        Scalar.new(@value**other)
      end
    end

    def ==(other)
      case other
      when Scalar
        other.value == @value
      else
        @value == other
      end
    end

    def coerce(other)
      @value.coerce(other)
    end
  end
end
