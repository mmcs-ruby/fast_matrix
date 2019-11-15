#ifndef FAST_MATRIX_MATRIX_C_MATRIX_H
#define FAST_MATRIX_MATRIX_C_MATRIX_H 1

#include <stdbool.h>

// matrix
//     m --->
//   [ 0,    1, ..,  m-1]
// n [ m,  m+1, .., 2m-1]
// | [2m, 2m+1, .., 3m-1]
// V [ . . . . .
//         . . . .  nm-1]
struct matrix
{
    int m;
    int n;

    double* data;
};

double c_matrix_trace(int n, const double* A);
double c_matrix_determinant(int n, const double* A);

void c_matrix_transpose(int m, int n, const double* in, double* out);
void c_matrix_multiply(int n, int k, int m, const double* A, const double* B, double* C);
void c_matrix_vector_multiply(int n, int m, const double* M, const double* V, double* R);
void c_matrix_strassen(int n, int k, int m, const double* A, const double* B, double* C);
void c_matrix_hstack(int argc, struct matrix** mtrs, double* C, int m);
void c_matrix_column_vector(int m, int n, const double* M, double* V, int idx);
void c_matrix_scalar(int n, double* C, double v);
void c_matrix_minor(int m, int n, const double* A, double* B, int m_idx, int n_idx);
void c_matrix_vstack(int argc, struct matrix** mtrs, double* C);

bool c_matrix_symmetric(int n, const double* C);
bool c_matrix_antisymmetric(int n, const double* C);
bool c_matrix_diagonal(int n, const double* C);
bool c_matrix_lower_triangular(int n, const double* A);
bool c_matrix_upper_triangular(int n, const double* A);
bool c_matrix_permutation(int n, const double* A);
bool c_matrix_identity(int n, const double* A);
bool c_matrix_equal_by_m(int argc, struct matrix** mtrs);
bool c_matrix_equal_by_n(int argc, struct matrix** mtrs);
bool c_matrix_inverse(int n, const double* A, double* B);
bool c_matrix_adjugate(int n, const double* A, double* B);
bool c_matrix_exponentiation(int m, int n, const double* A, double* B, int d);

int c_matrix_sum_by_m(int argc, struct matrix** mtrs);
int c_matrix_sum_by_n(int argc, struct matrix** mtrs);
int c_matrix_rank(int m, int n, const double* C);

#endif /* FAST_MATRIX_MATRIX_C_MATRIX_H */
