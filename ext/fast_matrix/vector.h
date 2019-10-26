#ifndef FAST_MATRIX_VECTOR_H
#define FAST_MATRIX_VECTOR_H 1

#include "ruby.h"

extern VALUE cVector;
extern const rb_data_type_t vector_type;

// vector
struct vector
{
    int n;
    double* data;
};

void c_vector_init(struct vector* vect, int n);

void init_fm_vector();

#endif /* FAST_MATRIX_VECTOR_H */
