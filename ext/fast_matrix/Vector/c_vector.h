#ifndef FAST_MATRIX_VECTOR_C_VECTOR_H
#define FAST_MATRIX_VECTOR_C_VECTOR_H 1

#include <stdbool.h>

// vector
struct vector
{
    int n;
    double* data;
    
    bool frozen;
};

double c_vector_magnitude(int n, const double* A);
double c_vector_inner_product(int n, double* A, double* B);

void c_vector_matrix_multiply(int n, int m, const double* V, const double* M, double* R);
void c_vector_normalize(int n, const double* A, double* B);
void c_vector_normalize_self(int n, double* A);
void c_vector_hstack(int m, int n, struct vector** vcts, double* C);
void c_vector_cross_product(int argc, struct vector** vcts, double* R);

bool c_vector_equal_by_size(int argc, struct vector** vcts, int size);

#endif /* FAST_MATRIX_VECTOR_C_VECTOR_H */