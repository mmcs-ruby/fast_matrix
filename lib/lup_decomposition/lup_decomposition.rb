require 'fast_matrix/fast_matrix'

module FastMatrix

    class Matrix
        #   LUP decomposition for Matrix
        class LUPDecomposition
            # 
            # Returns L, U, P in an array
            #             
            def to_ary
                [l, u, p]
            end
            # 
            # alias for determinant method
            #             
            alias determinant det
            # 
            # alias for to_ary method 
            # 
            alias to_a to_ary
        end
    end
end