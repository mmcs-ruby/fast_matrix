#include "vector.h"
#include "c_array_operations.h"
#include "errors.h"
#include "matrix.h"

VALUE cVector;

void vector_free(void* data);
size_t vector_size(const void* data);

const rb_data_type_t vector_type =
{
    .wrap_struct_name = "vector",
    .function =
    {
                .dmark = NULL,
                .dfree = vector_free,
                .dsize = vector_size,
        },
        .data = NULL,
        .flags = RUBY_TYPED_FREE_IMMEDIATELY,
};

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
	struct vector* vct = malloc(sizeof(struct vector));
    vct->data = NULL;
	return TypedData_Wrap_Struct(self, &vector_type, vct);
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

    i = (i < 0) ? data->n + i : i;
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

    i = (i < 0) ? data->n + i : i;
    
    if(i < 0 || i >= data->n)
        return Qnil;

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
    raise_check_rbasic(value, cVector, "vector");
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
    raise_check_rbasic(value, cVector, "vector");
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

VALUE vector_sub_with(VALUE self, VALUE value)
{
    raise_check_rbasic(value, cVector, "vector");
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
    sub_d_arrays_to_result(n, A->data, B->data, C->data);

    return result;
}


VALUE vector_sub_from(VALUE self, VALUE value)
{
    raise_check_rbasic(value, cVector, "vector");
	struct vector* A;
    struct vector* B;
	TypedData_Get_Struct(self, struct vector, &vector_type, A);
	TypedData_Get_Struct(value, struct vector, &vector_type, B);

    if(A->n != B->n)
        rb_raise(fm_eIndexError, "Different sizes matrices");

    int n = A->n;

    sub_d_arrays_to_first(n, A->data, B->data);

    return self;
}

VALUE vector_equal(VALUE self, VALUE value)
{
    if(RBASIC_CLASS(value) != cVector)
        return Qfalse;
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

VALUE vector_copy(VALUE v)
{
	struct vector* V;
	TypedData_Get_Struct(v, struct vector, &vector_type, V);

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);

    c_vector_init(R, V->n);
    copy_d_array(R->n, V->data, R->data);

    return result;
}

// V - vector n
// M - matrix m x 1
// R - matrix m x n
void c_vector_matrix_multiply(int n, int m, const double* V, const double* M, double* R)
{
    fill_d_array(m * n, R, 0);

    for(int j = 0; j < n; ++j)
    {
        double* p_r = R + m * j;
        double d_v = V[j];
        
        for(int i = 0; i < m; ++i)
            p_r[i] += d_v * M[i];
    }
}

VALUE vector_multiply_vm(VALUE self, VALUE other)
{
	struct vector* V;
    struct matrix* M;
	TypedData_Get_Struct(self, struct vector, &vector_type, V);
	TypedData_Get_Struct(other, struct matrix, &matrix_type, M);

    if(M->n != 1)
        rb_raise(fm_eIndexError, "Number of rows must be 1");

    int m = M->m;
    int n = V->n;

    struct matrix* R;
    VALUE result = TypedData_Make_Struct(cMatrix, struct matrix, &matrix_type, R);

    c_matrix_init(R, m, n);
    c_vector_matrix_multiply(n, m, V->data, M->data, R->data);

    return result;
}

VALUE vector_multiply_vn(VALUE self, VALUE value)
{
	struct vector* A;
	TypedData_Get_Struct(self, struct vector, &vector_type, A);

    double d = NUM2DBL(value);

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);

    c_vector_init(R, A->n);
    copy_d_array(R->n, A->data, R->data);
    multiply_d_array(R->n, R->data, d);

    return result;
}

VALUE vector_multiply_vv(VALUE self, VALUE other)
{
    struct vector* A;
    struct vector* B;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);
    TypedData_Get_Struct(other, struct vector, &vector_type, B);
    
    if(B->n != 1)
        rb_raise(fm_eIndexError, "Length of vector must be equal to 1");

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);

    c_vector_init(R, A->n);
    copy_d_array(A->n, A->data, R->data);
    multiply_d_array(R->n, R->data, B->data[0]);

    return result;
}

VALUE vector_multiply(VALUE self, VALUE v)
{
    if(RB_FLOAT_TYPE_P(v) || FIXNUM_P(v)
        || RB_TYPE_P(v, T_BIGNUM))
        return vector_multiply_vn(self, v);
    if(RBASIC_CLASS(v) == cMatrix)
        return vector_multiply_vm(self, v);
    if(RBASIC_CLASS(v) == cVector)
        return vector_multiply_vv(self, v);
    rb_raise(fm_eTypeError, "Invalid klass for multiply");
}

double vector_magnitude(int n, const double* A)
{
    double sum = 0;
    for(int i = 0; i < n; ++i)
        sum += A[i] * A[i];
    return sqrt(sum);
}

VALUE magnitude(VALUE self)
{
    struct vector* A;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);
    return DBL2NUM(vector_magnitude(A->n, A->data));
}

void vector_normalize(int n, const double* A, double* B)
{
    double m = vector_magnitude(n, A);
    for(int i = 0; i < n; ++i)
        B[i] = A[i] / m;
}

void vector_normalize_self(int n, double* A)
{
    double m = vector_magnitude(n, A);
    for(int i = 0; i < n; ++i)
        A[i] = A[i] / m;
}

VALUE normalize(VALUE self)
{
    struct vector* A;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);
    c_vector_init(R, A->n);
    vector_normalize(A->n, A->data, R->data);

    return result;
}

VALUE normalize_self(VALUE self)
{
    struct vector* A;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);
    vector_normalize_self(A->n, A->data);
    return self;
}

VALUE vactor_minus(VALUE self)
{
    struct vector* A;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);
    c_vector_init(R, A->n);

    multiply_d_array_to_result(A->n, A->data, -1, R->data);

    return result;
}

VALUE vector_plus(VALUE self)
{
    return self;
}

struct vector** convert_vector_array(int argc, VALUE *argv, struct vector*** vcts)
{
    for(int i = 0; i < argc; ++i)
        raise_check_rbasic(argv[i], cVector, "vector");
    
    *vcts = (struct vector**)malloc(argc * sizeof(struct vector*));

    for(int i = 0; i < argc; ++i)
	    TypedData_Get_Struct(argv[i], struct vector, &vector_type, (*vcts)[i]);
}

void vector_hstack(int m, int n, struct vector** vcts, double* C)
{
    for(int i = 0; i < n; ++i)
    {
        struct vector* V = vcts[i];
        copy_d_array(m, V->data, C);
        C += n;
    }
}

bool vector_equal_by_size(int argc, struct vector** vcts)
{
    int n = vcts[0]->n;
    for(int i = 1; i < argc; ++i)
        if(n != vcts[i]->n)
            return false;
    return true;
}

VALUE independent(int argc, VALUE* argv, VALUE obj)
{
    if(argc == 0)
        return Qtrue;
    
    struct vector** vcts;
    convert_vector_array(argc, argv, &vcts);

    if(!vector_equal_by_size(argc, vcts))
    {
        free(vcts);
        rb_raise(fm_eIndexError, "Rows of different size");
    }

    int n = vcts[0]->n;

    double* C = malloc(sizeof(double) * argc * n);
    vector_hstack(n, argc, vcts, C);
    int result = matrix_rank(n, argc, C);

    free(vcts);
    free(C);
    if(result == argc)
        return Qtrue;
    return Qfalse;
}

VALUE to_matrix(VALUE self)
{
    struct vector* A;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);

    struct matrix* C;
    VALUE result = TypedData_Make_Struct(cMatrix, struct matrix, &matrix_type, C);
    c_matrix_init(C, 1, A->n);
    copy_d_array(A->n, A->data, C->data);
    return result;
}
VALUE covector(VALUE self)
{
    struct vector* A;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);

    struct matrix* C;
    VALUE result = TypedData_Make_Struct(cMatrix, struct matrix, &matrix_type, C);
    c_matrix_init(C, A->n, 1);
    copy_d_array(A->n, A->data, C->data);
    return result;
}

VALUE vector_zero(VALUE self)
{
    struct vector* A;
    TypedData_Get_Struct(self, struct vector, &vector_type, A);
    if(zero_d_array(A->n, A->data))
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
	rb_define_method(cVector, "-", vector_sub_with, 1);
	rb_define_method(cVector, "-=", vector_sub_from, 1);
	rb_define_method(cVector, "eql?", vector_equal, 1);
	rb_define_method(cVector, "clone", vector_copy, 0);
	rb_define_method(cVector, "magnitude", magnitude, 0);
	rb_define_method(cVector, "normalize", normalize, 0);
	rb_define_method(cVector, "normalize!", normalize_self, 0);
    rb_define_method(cVector, "-@", vactor_minus, 0);
    rb_define_method(cVector, "+@", vector_plus, 0);
	rb_define_method(cVector, "*", vector_multiply, 1);
    rb_define_method(cVector, "to_matrix", to_matrix, 0);
    rb_define_method(cVector, "covector", covector, 0);
	rb_define_method(cVector, "zero?", vector_zero, 0);
	rb_define_module_function(cVector, "independent?", independent, -1);
}
