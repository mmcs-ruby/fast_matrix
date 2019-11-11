#ifndef FAST_MATRIX_VECTOR_HELPER_H
#define FAST_MATRIX_VECTOR_HELPER_H 1

#include "ruby.h"
#include "Vector/c_vector.h"

inline struct vector* get_vector_from_rb_value(VALUE m)
{
	struct vector* data;
	TypedData_Get_Struct(m, struct vector, &vector_type, data);
    return data;
}

inline void c_vector_init(struct vector* vect, int n)
{
    vect->n = n;
    vect->data = malloc(n * sizeof(double));
}

#define MAKE_VECTOR_AND_RB_VALUE(vector_name, rb_value_name, n)\
struct vector* vector_name;								\
VALUE rb_value_name = TypedData_Make_Struct(			\
	cVector, struct vector, &vector_type, vector_name);	\
c_vector_init(vector_name, n)

#endif /* FAST_MATRIX_VECTOR_HELPER_H */