#include "vector.h"
#include "c_array_operations.h"
#include "errors.h"

void vector_free(void* data)
{
	free(((*(struct vector*)data)).data);
    free(data);
}

size_t vector_size(const void* data)
{
	return sizeof(struct vector);
}

VALUE vector_alloc(VALUE self)
{
	struct vector* mtx = malloc(sizeof(struct vector));

	return TypedData_Wrap_Struct(self, &vector_type, mtx);
}

void c_vector_init(struct vector* vect, int n)
{
    vect->n = n;
    vect->data = malloc(n * sizeof(double));
}

VALUE vector_initialize(VALUE self, VALUE size)
{
	struct vector* data;
    int n = raise_rb_value_to_int(size);

    if(n <= 0)
        rb_raise(fm_eIndexError, "Size cannot be negative or zero");

	TypedData_Get_Struct(self, struct vector, &vector_type, data);

    c_vector_init(data, n);

	return self;
}

//  []=
VALUE vector_set(VALUE self, VALUE idx, VALUE v)
{
    int i = raise_rb_value_to_int(idx);
    double x = raise_rb_value_to_double(v);

	struct vector* data;
	TypedData_Get_Struct(self, struct vector, &vector_type, data);

    raise_check_range(i, 0, data->n);

    data->data[i] = x;
    return v;
}

//  []
VALUE vector_get(VALUE self, VALUE idx)
{
    int i = raise_rb_value_to_int(idx);

	struct vector* data;
	TypedData_Get_Struct(self, struct vector, &vector_type, data);

    raise_check_range(i, 0, data->n);

    return DBL2NUM(data->data[i]);
}

VALUE c_vector_size(VALUE self)
{
	struct vector* data;
	TypedData_Get_Struct(self, struct vector, &vector_type, data);
    return INT2NUM(data->n);
}


VALUE vector_add_with(VALUE self, VALUE value)
{
	struct vector* A;
    struct vector* B;
	TypedData_Get_Struct(self, struct vector, &vector_type, A);
	TypedData_Get_Struct(value, struct vector, &vector_type, B);

    if(A->n != B->n)
        rb_raise(fm_eIndexError, "Different sizes matrices");

    int n = A->n;

    struct vector* C;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, C);

    c_vector_init(C, n);
    add_d_arrays_to_result(n, A->data, B->data, C->data);

    return result;
}


VALUE vector_add_from(VALUE self, VALUE value)
{
	struct vector* A;
    struct vector* B;
	TypedData_Get_Struct(self, struct vector, &vector_type, A);
	TypedData_Get_Struct(value, struct vector, &vector_type, B);

    if(A->n != B->n)
        rb_raise(fm_eIndexError, "Different sizes matrices");

    int n = A->n;

    add_d_arrays_to_first(n, A->data, B->data);

    return self;
}

VALUE vector_equal(VALUE self, VALUE value)
{
	struct vector* A;
    struct vector* B;
	TypedData_Get_Struct(self, struct vector, &vector_type, A);
	TypedData_Get_Struct(value, struct vector, &vector_type, B);

    if(A->n != B->n)
		return Qfalse;

    int n = A->n;

    if(equal_d_arrays(n, A->data, B->data))
		return Qtrue;
	return Qfalse;
}

void init_fm_vector()
{
    VALUE  mod = rb_define_module("FastMatrix");
	cVector = rb_define_class_under(mod, "Vector", rb_cData);

	rb_define_alloc_func(cVector, vector_alloc);

	rb_define_method(cVector, "initialize", vector_initialize, 1);
	rb_define_method(cVector, "[]", vector_get, 1);
	rb_define_method(cVector, "[]=", vector_set, 2);
	rb_define_method(cVector, "size", c_vector_size, 0);
	rb_define_method(cVector, "+", vector_add_with, 1);
	rb_define_method(cVector, "+=", vector_add_from, 1);
	rb_define_method(cVector, "==", vector_equal, 1);
}