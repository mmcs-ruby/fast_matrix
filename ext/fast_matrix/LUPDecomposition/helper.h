#ifndef FAST_MATRIX_LUPDECOMPOSITION_HELPER_H
#define FAST_MATRIX_LUPDECOMPOSITION_HELPER_H 1

#include "ruby.h"
#include "Matrix/c_matrix.h"

inline struct lupdecomposition* get_lup_from_rb_value(VALUE lp)
{
	struct lupdecomposition* data;
	TypedData_Get_Struct(lp, struct lupdecomposition, &lup_type, data);
    return data;
}

#endif /* FAST_MATRIX_LUPDECOMPOSITION_HELPER_H */
