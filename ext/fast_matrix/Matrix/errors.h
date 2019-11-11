#ifndef FAST_MATRIX_MATRIX_ERRORS_H
#define FAST_MATRIX_MATRIX_ERRORS_H 1

#include "ruby.h"
#include "Matrix/matrix.h"

//  check if the matrix is of equal size and raise an error if not
inline void raise_check_equal_size_matrix(struct matrix* A, struct matrix* B)
{
    if(A->m != B->m || A->n != B->n)
        rb_raise(fm_eIndexError, "Different sizes matrices");
}

//  check if the matrix is square and raise an error if not
inline void raise_check_square_matrix(struct matrix* A)
{
    if(A->n != A->m)
        rb_raise(fm_eIndexError, "Expected square matrix");
}

//  check if the value is zero and raise an error if not
inline void raise_check_no_arguments(int argc)
{
    if(argc == 0)
        rb_raise(fm_eIndexError, "No arguments");
}

#endif /* FAST_MATRIX_MATRIX_ERRORS_H */