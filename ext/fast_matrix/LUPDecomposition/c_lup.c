#include "LUPDecomposition/c_lup.h"

void c_lup_l(int n, const double* LUP, double* L)
{
    for(int i = 0; i < n; ++i)
    {
        double* l_line = L + n * i;
        double* lup_line = LUP + n * i;
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
        double* lup_line = LUP + n * i;
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