require 'test_helper'

module FastMatrixTest
  class MatrixTest < Minitest::Test
    include FastMatrix
        def test_l
            m = Matrix[[1, 2], [4, 3]]
            lp = m.lup
            lm = Matrix[[1, 0], [0.25, 1]]
            assert_equal lm, lp.l
        end

        def test_u
            m = Matrix[[1, 2], [4, 3]]
            lp = m.lup
            um = Matrix[[4, 3], [0, 1.25]]
            assert_equal um, lp.u
        end

        def test_p
            m = Matrix[[1, 2], [4, 3]]
            lp = m.lup
            pm = Matrix[[0, 1], [1, 0]]
            assert_equal pm, lp.p
        end

        def test_det
            m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 11]]
            lp = m.lup
            assert_in_delta -6, lp.det, 1e10
        end

        def test_det_decomposition
            m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 11]]
            lp = m.lup_decomposition
            assert_in_delta -6, lp.det, 1e10
        end

        def test_singular
            m = Matrix[[1, 2, 3], [1, 2, 4], [2, 4, 5]]
            lp = m.lup
            assert lp.singular?
        end

        def test_not_singular
            m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 11]]
            lp = m.lup
            refute lp.singular?
        end

        def test_determinant
            m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 11]]
            lp = m.lup
            assert_in_delta -6, lp.determinant, 1e10
        end
        
        def test_to_ary
            m = Matrix[[1, 2], [4, 3]]
            lp = m.lup

            lm = Matrix[[1, 0], [0.25, 1]]
            um = Matrix[[4, 3], [0, 1.25]]
            pm = Matrix[[0, 1], [1, 0]]
            assert_equal [lm, um, pm], lp.to_ary
        end

        def test_pivots
            m = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 10]]
            lp = m.lup            
            assert_equal [2, 0, 1], lp.pivots
        end

        def test_solve
            a = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 10]]
            b = Matrix[[2, 3], [5, 6], [8, 8]]
            lp = a.lup
            m = lp.solve(b)
            assert_in_delta b, a * m, Matrix.new(3, 2).fill!(1e-10)
        end
    end
end
