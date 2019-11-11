#ifndef FAST_MATRIX_MATRIX_HELPER_H
#define FAST_MATRIX_MATRIX_HELPER_H 1

#include "ruby.h"
#include "Matrix/matrix.h"

inline struct matrix* get_matrix_from_rb_value(VALUE m)
{
	struct matrix* data;
	TypedData_Get_Struct(m, struct matrix, &matrix_type, data);
    return data;
}

#define MAKE_MATRIX_AND_RB_VALUE(matrix_name, rb_value_name, m, n)\
struct matrix* matrix_name;								\
VALUE rb_value_name = TypedData_Make_Struct(			\
	cMatrix, struct matrix, &matrix_type, matrix_name);	\
c_matrix_init(matrix_name, m, n)

#endif /* FAST_MATRIX_MATRIX_HELPER_H */