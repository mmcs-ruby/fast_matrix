#ifndef FAST_MATRIX_VECTOR_ERRORS_H
#define FAST_MATRIX_VECTOR_ERRORS_H 1

#include "ruby.h"
#include "Vector/vector.h"

//  check if the vectors is of equal size and raise an error if not
inline void raise_check_equal_size_vectors(struct vector* A, struct vector* B)
{
    if(A->n != B->n)
        rb_raise(fm_eIndexError, "Different sizes vectors");
}

//  check if the vector is frozen and raise an error if not
inline void raise_check_frozen_vector(struct vector* A)
{
    if(A->frozen)
        rb_raise(fm_eFrozenError, "Can't modify frozen Vector");
}

#endif /* FAST_MATRIX_VECTOR_ERRORS_H */