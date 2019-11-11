#ifndef FAST_MATRIX_MATRIX_H
#define FAST_MATRIX_MATRIX_H 1

#include "ruby.h"
#include "c_matrix.h"

extern VALUE cMatrix;
extern const rb_data_type_t matrix_type;
void init_fm_matrix();

#endif /* FAST_MATRIX_MATRIX_H */
