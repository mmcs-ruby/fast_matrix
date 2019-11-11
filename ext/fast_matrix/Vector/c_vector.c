#include "Vector/c_vector.h"
#include "Matrix/c_matrix.h"

double c_vector_magnitude(int n, const double* A)
{
    double sum = 0;
    for(int i = 0; i < n; ++i)
        sum += A[i] * A[i];
    return sqrt(sum);
}

void c_vector_normalize(int n, const double* A, double* B)
{
    double m = c_vector_magnitude(n, A);
    for(int i = 0; i < n; ++i)
        B[i] = A[i] / m;
}

void c_vector_normalize_self(int n, double* A)
{
    double m = c_vector_magnitude(n, A);
    for(int i = 0; i < n; ++i)
        A[i] = A[i] / m;
}

void c_vector_hstack(int m, int n, struct vector** vcts, double* C)
{
    for(int i = 0; i < n; ++i)
    {
        struct vector* V = vcts[i];
        copy_d_array(m, V->data, C);
        C += n;
    }
}

bool c_vector_equal_by_size(int argc, struct vector** vcts, int size)
{
    for(int i = 0; i < argc; ++i)
        if(size != vcts[i]->n)
            return false;
    return true;
}

double c_vector_inner_product(int n, double* A, double* B)
{
    double sum = 0;
    for(int i = 0; i < n; ++i)
        sum += A[i] * B[i];
    return sum;
}

void c_vector_cross_product(int argc, struct vector** vcts, double* R)
{
    int n = argc + 1;
    double* rows = malloc(argc * n * sizeof(double));
    double* M = malloc(argc * argc * sizeof(double));

    for(int i = 0; i < argc; ++i)
        for(int j = 0; j < n; ++j)
            rows[i + j * argc] = vcts[i]->data[j];
    
    copy_d_array(argc * argc, rows + argc, M);

    double* colM = M;
    double* colR = rows;
    int sign = (argc % 2 == 0) ? 1 : -1;
    for(int i = 0; ; ++i)
    {
        R[i] = c_matrix_determinant(argc, M) * sign;
        sign = - sign;
        if(i == n - 1)
            break;
        copy_d_array(argc, colR, colM);
        colM += argc;
        colR += argc;
    }

    free(rows);
    free(M);
}

// V - vector n
// M - matrix m x 1
// R - matrix m x n
void c_vector_matrix_multiply(int n, int m, const double* V, const double* M, double* R)
{
    fill_d_array(m * n, R, 0);

    for(int j = 0; j < n; ++j)
    {
        double* p_r = R + m * j;
        double d_v = V[j];
        
        for(int i = 0; i < m; ++i)
            p_r[i] += d_v * M[i];
    }
}