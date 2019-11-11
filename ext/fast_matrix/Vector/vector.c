#include "Vector/vector.h"
#include "Helper/c_array_operations.h"
#include "Helper/errors.h"
#include "Matrix/c_matrix.h"
#include "Matrix/helper.h"
#include "Vector/errors.h"
#include "Vector/helper.h"

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
    int n = raise_rb_value_to_int(size);

    if(n <= 0)
        rb_raise(fm_eIndexError, "Size cannot be negative or zero");

	struct vector* data = get_vector_from_rb_value(self);
    c_vector_init(data, n);

	return self;
}

//  []=
VALUE vector_set(VALUE self, VALUE idx, VALUE v)
{
    int i = raise_rb_value_to_int(idx);
    double x = raise_rb_value_to_double(v);
	struct vector* data = get_vector_from_rb_value(self);

    i = (i < 0) ? data->n + i : i;
    raise_check_range(i, 0, data->n);

    data->data[i] = x;
    return v;
}

//  []
VALUE vector_get(VALUE self, VALUE idx)
{
    int i = raise_rb_value_to_int(idx);
	struct vector* data = get_vector_from_rb_value(self);

    i = (i < 0) ? data->n + i : i;
    
    if(i < 0 || i >= data->n)
        return Qnil;

    return DBL2NUM(data->data[i]);
}

VALUE c_vector_size(VALUE self)
{
	struct vector* data = get_vector_from_rb_value(self);
    return INT2NUM(data->n);
}


VALUE vector_add_with(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cVector, "vector");
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);
    raise_check_equal_size_vectors(A, B);

    int n = A->n;

    struct vector* C;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, C);

    c_vector_init(C, n);
    add_d_arrays_to_result(n, A->data, B->data, C->data);

    return result;
}


VALUE vector_add_from(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cVector, "vector");
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);
    raise_check_equal_size_vectors(A, B);

    int n = A->n;

    add_d_arrays_to_first(n, A->data, B->data);

    return self;
}

VALUE vector_sub_with(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cVector, "vector");
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);
    raise_check_equal_size_vectors(A, B);

    int n = A->n;

    struct vector* C;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, C);

    c_vector_init(C, n);
    sub_d_arrays_to_result(n, A->data, B->data, C->data);

    return result;
}


VALUE vector_sub_from(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cVector, "vector");
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);
    raise_check_equal_size_vectors(A, B);

    int n = A->n;

    sub_d_arrays_to_first(n, A->data, B->data);

    return self;
}

VALUE vector_equal(VALUE self, VALUE other)
{
    if(RBASIC_CLASS(other) != cVector)
        return Qfalse;
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);

    if(A->n != B->n)
		return Qfalse;

    int n = A->n;

    if(equal_d_arrays(n, A->data, B->data))
		return Qtrue;
	return Qfalse;
}

VALUE vector_copy(VALUE self)
{
	struct vector* V = get_vector_from_rb_value(self);

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
	struct vector* V = get_vector_from_rb_value(self);
	struct matrix* M = get_matrix_from_rb_value(other);

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
	struct vector* A = get_vector_from_rb_value(self);
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
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);
    
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
	struct vector* A = get_vector_from_rb_value(self);
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
	struct vector* A = get_vector_from_rb_value(self);

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);
    c_vector_init(R, A->n);
    vector_normalize(A->n, A->data, R->data);

    return result;
}

VALUE normalize_self(VALUE self)
{
	struct vector* A = get_vector_from_rb_value(self);
    vector_normalize_self(A->n, A->data);
    return self;
}

VALUE vactor_minus(VALUE self)
{
	struct vector* A = get_vector_from_rb_value(self);

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

bool vector_equal_by_size(int argc, struct vector** vcts, int size)
{
    for(int i = 0; i < argc; ++i)
        if(size != vcts[i]->n)
            return false;
    return true;
}

VALUE independent(int argc, VALUE* argv, VALUE obj)
{
    if(argc == 0)
        return Qtrue;
    
    struct vector** vcts;
    convert_vector_array(argc, argv, &vcts);

    int n = vcts[0]->n;

    if(!vector_equal_by_size(argc, vcts, n))
    {
        free(vcts);
        rb_raise(fm_eIndexError, "Rows of different size");
    }

    double* C = malloc(sizeof(double) * argc * n);
    vector_hstack(n, argc, vcts, C);
    int result = c_matrix_rank(n, argc, C);

    free(vcts);
    free(C);
    if(result == argc)
        return Qtrue;
    return Qfalse;
}

VALUE to_matrix(VALUE self)
{
	struct vector* A = get_vector_from_rb_value(self);

    struct matrix* C;
    VALUE result = TypedData_Make_Struct(cMatrix, struct matrix, &matrix_type, C);
    c_matrix_init(C, 1, A->n);
    copy_d_array(A->n, A->data, C->data);
    return result;
}
VALUE covector(VALUE self)
{
	struct vector* A = get_vector_from_rb_value(self);

    struct matrix* C;
    VALUE result = TypedData_Make_Struct(cMatrix, struct matrix, &matrix_type, C);
    c_matrix_init(C, A->n, 1);
    copy_d_array(A->n, A->data, C->data);
    return result;
}

VALUE vector_zero(VALUE self)
{
	struct vector* A = get_vector_from_rb_value(self);
    if(zero_d_array(A->n, A->data))
            return Qtrue;
    return Qfalse;
}

VALUE vector_fill(VALUE self, VALUE value)
{
    double d = raise_rb_value_to_double(value);
	struct vector* A = get_vector_from_rb_value(self);
    fill_d_array(A->n, A->data, d);
    return self;
}

VALUE vector_round(int argc, VALUE *argv, VALUE self)
{
    if(argc > 1)
        rb_raise(fm_eTypeError, "Wrong number of arguments");
    int d;
    if(argc == 1)
        d = raise_rb_value_to_int(argv[0]);
    else
        d = 0;

	struct vector* A = get_vector_from_rb_value(self);

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);
    c_vector_init(R, A->n);

    round_d_array(A->n, A->data, R->data, d);

    return result;
}

double vector_inner_product(int n, double* A, double* B)
{
    double sum = 0;
    for(int i = 0; i < n; ++i)
        sum += A[i] * B[i];
    return sum;
}

VALUE inner_product(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cVector, "vector");
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);
    raise_check_equal_size_vectors(A, B);

    double result = vector_inner_product(A->n, A->data, B->data);
    return DBL2NUM(result);
}

VALUE angle_with(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cVector, "vector");
	struct vector* A = get_vector_from_rb_value(self);
	struct vector* B = get_vector_from_rb_value(other);
    raise_check_equal_size_vectors(A, B);

    double a = vector_magnitude(A->n, A->data);
    double b = vector_magnitude(B->n, B->data);
    double d = vector_inner_product(A->n, A->data, B->data);

    return DBL2NUM(acos(d / (a * b)));
}

void vector_cross_product(int argc, struct vector** vcts, double* R)
{
    int n = argc + 1;
    double* rows = malloc(argc * n * sizeof(double));
    double* M = malloc(argc * argc * sizeof(double));

    for(int i = 0; i < argc; ++i)
        for(int j = 0; j < n; ++j)
            rows[i + j * argc] = vcts[i]->data[j];
    
    copy_d_array(argc * argc, rows + argc, M);

    double* colM = M;
    double* colR = rows;
    int sign = (argc % 2 == 0) ? 1 : -1;
    for(int i = 0; ; ++i)
    {
        R[i] = c_matrix_determinant(argc, M) * sign;
        sign = - sign;
        if(i == n - 1)
            break;
        copy_d_array(argc, colR, colM);
        colM += argc;
        colR += argc;
    }

    free(rows);
    free(M);
}

VALUE cross_product(int argc, VALUE* argv, VALUE obj)
{
    struct vector** vcts;
    convert_vector_array(argc, argv, &vcts);

    int n = argc + 1;

    if(!vector_equal_by_size(argc, vcts, n))
    {
        free(vcts);
        rb_raise(fm_eIndexError, "Rows of different size");
    }

    struct vector* R;
    VALUE result = TypedData_Make_Struct(cVector, struct vector, &vector_type, R);
    c_vector_init(R, n);

    vector_cross_product(argc, vcts, R->data);

    return result;
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
	rb_define_method(cVector, "fill!", vector_fill, 1);
	rb_define_method(cVector, "round", vector_round, -1);
	rb_define_method(cVector, "inner_product", inner_product, 1);
	rb_define_method(cVector, "angle_with", angle_with, 1);
	rb_define_module_function(cVector, "independent?", independent, -1);
	rb_define_module_function(cVector, "cross_product", cross_product, -1);
}
