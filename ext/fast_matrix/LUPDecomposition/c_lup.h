#ifndef FAST_MATRIX_MATRIX_C_LUPDECOMPOSITION_H
#define FAST_MATRIX_MATRIX_C_LUPDECOMPOSITION_H 1

struct lupdecomposition
{
    int n;
    double* data;
    int* permutation;
    int pivot_sign;
};

double c_lup_determinant(int n, double* LUP, int sign);

void c_lup_l(int n, const double* LUP, double* L);
void c_lup_u(int n, const double* LUP, double* U);
void c_lup_p(int n, const int* prm, double* P);

#endif /* FAST_MATRIX_MATRIX_C_LUPDECOMPOSITION_H */