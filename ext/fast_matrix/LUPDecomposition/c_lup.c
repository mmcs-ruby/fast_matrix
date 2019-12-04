#include "LUPDecomposition/c_lup.h"
#include "Helper/c_array_operations.h"

void c_lup_l(int n, const double* LUP, double* L)
{
    for(int i = 0; i < n; ++i)
    {
        double* l_line = L + n * i;
        const double* lup_line = LUP + n * i;
        for(int j = 0; j < n; ++j)
        {
            if(i < j)
                l_line[j] = 0;
            else if(i == j)
                l_line[j] = 1;
            else
                l_line[j] = lup_line[j];
        }
    }
}

void c_lup_u(int n, const double* LUP, double* U)
{
    for(int i = 0; i < n; ++i)
    {
        double* u_line = U + n * i;
        const double* lup_line = LUP + n * i;
        for(int j = 0; j < n; ++j)
        {
            if(i > j)
                u_line[j] = 0;
            else
                u_line[j] = lup_line[j];
        }
    }
}

void c_lup_p(int n, const int* prm, double* P)
{
    for(int i = 0; i < n; ++i)
    {
        double* p_line = P + n * i;
        int current = prm[i];
        for(int j = 0; j < current; ++j)
            p_line[j] = 0;
        p_line[current] = 1;
        for(int j = current + 1; j < n; ++j)
            p_line[j] = 0;
    }
}

double c_lup_determinant(int n, double* LUP, int sign)
{
    double res = sign;
    for(int i = 0; i < n; ++i)
        res *= LUP[i + i * n];
    return res;
}

void c_lup_apply_permutation(int m, int n, const double* A, const int* permutation, double* R)
{
    for(int i = 0; i < n; ++i)
        copy_d_array(m, A + m * permutation[i], R + m * i);
}

void c_lup_solve(int m, int n, const double* lp, const double* B, const int* permutation, double* R)
{
    c_lup_apply_permutation(m, n, B, permutation, R);

    for(int k = 0; k < n; ++k)
        for(int i = k + 1; i < n; ++i)
        {
            double* line = R + i * m;
            int mul = lp[i * n + k];

            for(int j = 0; j < m; ++j)
                line[j] -= line[j] * mul;
        }
    
    for(int k = n - 1; k >= 0; --k)
    {
        double* line = R + k * m;
        int div = lp[k * n + k];

        for(int j = 0; j < m; ++j)
            line[j] /= div;
        
        for(int i = 0; i < k; ++i)
        {
            double* line_out = R + i * m;
            int mul = lp[i * n + k];
            
            for(int j = 0; j < m; ++j)
                line_out[j] -= line[j] * mul;
        }
    }
}
