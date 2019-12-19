#ifndef FAST_MATRIX_EIGENVALUE_DECOMPOSITION_H
#define FAST_MATRIX_EIGENVALUE_DECOMPOSITION_H 1

#include "ruby.h"
#include "EigenvalueDecomposition/c_eigenvalue.h"

extern VALUE cEigenvalueDecomposition;
extern const rb_data_type_t eigensystem_type;
void init_fm_eigenvalue();

#endif /* FAST_MATRIX_EIGENVALUE_DECOMPOSITION_H */
