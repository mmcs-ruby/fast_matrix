#include "Matrix/matrix.h"
#include "Helper/c_array_operations.h"
#include "Helper/errors.h"
#include "Vector/vector.h"
#include "Matrix/errors.h"
#include "Matrix/helper.h"
#include "Vector/helper.h"

VALUE cMatrix;

void matrix_free(void* data);
size_t matrix_size(const void* data);

const rb_data_type_t matrix_type =
{
    .wrap_struct_name = "matrix",
    .function =
    {
        .dmark = NULL,
        .dfree = matrix_free,
        .dsize = matrix_size,
    },
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
};

void matrix_free(void* data)
{
    free(((*(struct matrix*)data)).data);
    free(data);
}

size_t matrix_size(const void* data)
{
	return sizeof(struct matrix);
}

VALUE matrix_alloc(VALUE self)
{
	struct matrix* mtx = malloc(sizeof(struct matrix));
    mtx->data = NULL;
    mtx->frozen = false;
	return TypedData_Wrap_Struct(self, &matrix_type, mtx);
}

VALUE matrix_initialize(VALUE self, VALUE rows_count, VALUE columns_count)
{
    int m = raise_rb_value_to_int(columns_count);
    int n = raise_rb_value_to_int(rows_count);
    
    if(m <= 0 || n <= 0)
        rb_raise(fm_eIndexError, "Size cannot be negative or zero");

	struct matrix* data = get_matrix_from_rb_value(self);
    c_matrix_init(data, m, n);
	return self;
}

//  []=
VALUE matrix_set(VALUE self, VALUE row, VALUE column, VALUE v)
{
	struct matrix* data = get_matrix_from_rb_value(self);
    raise_check_frozen_matrix(data);

    int m = raise_rb_value_to_int(column);
    int n = raise_rb_value_to_int(row);
    double x = raise_rb_value_to_double(v);

    m = (m < 0) ? data->m + m : m;
    n = (n < 0) ? data->n + n : n;

    raise_check_range(m, 0, data->m);
    raise_check_range(n, 0, data->n);

    data->data[m + data->m * n] = x;
    return v;
}

//  []
VALUE matrix_get(VALUE self, VALUE row, VALUE column)
{
    int m = raise_rb_value_to_int(column);
    int n = raise_rb_value_to_int(row);
	struct matrix* data = get_matrix_from_rb_value(self);
    
    m = (m < 0) ? data->m + m : m;
    n = (n < 0) ? data->n + n : n;
    
    if(m < 0 || n < 0 || n >= data->n || m >= data->m)
        return Qnil;

    return DBL2NUM(data->data[m + data->m * n]);
}

VALUE matrix_multiply_mv(VALUE self, VALUE other)
{
	struct matrix* M = get_matrix_from_rb_value(self);
	struct vector* V = get_vector_from_rb_value(other);

    if(M->m != V->n)
        rb_raise(fm_eIndexError, "Matrix columns differs from vector size");

    MAKE_VECTOR_AND_RB_VALUE(R, result, M->n);
    c_matrix_vector_multiply(M->n, M->m, M->data, V->data, R->data);
    return result;
}

VALUE matrix_strassen(VALUE self, VALUE other)
{
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    if(A->m != B->n)
        rb_raise(fm_eIndexError, "First columns differs from second rows");

    int m = B->m;
    int k = A->m;
    int n = A->n;

    MAKE_MATRIX_AND_RB_VALUE(C, result, m, n);
    fill_d_array(m * n, C->data, 0);

    c_matrix_strassen(n, k, m, A->data, B->data, C->data);
    return result;
}

VALUE matrix_multiply_mm(VALUE self, VALUE other)
{
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    if(A->m != B->n)
        rb_raise(fm_eIndexError, "First columns differs from second rows");

    int m = B->m;
    int k = A->m;
    int n = A->n;

    MAKE_MATRIX_AND_RB_VALUE(C, result, m, n);
    c_matrix_multiply(n, k, m, A->data, B->data, C->data);

    return result;
}

VALUE matrix_multiply_mn(VALUE self, VALUE value)
{
    double d = NUM2DBL(value);
	struct matrix* A = get_matrix_from_rb_value(self);

    MAKE_MATRIX_AND_RB_VALUE(R, result, A->m, A->n);
    copy_d_array(A->m * A->n, A->data, R->data);
    multiply_d_array(R->m * R->n, R->data, d);

    return result;
}

VALUE matrix_multiply(VALUE self, VALUE v)
{
    if(RB_FLOAT_TYPE_P(v) || FIXNUM_P(v)
        || RB_TYPE_P(v, T_BIGNUM))
        return matrix_multiply_mn(self, v);
    if(RBASIC_CLASS(v) == cMatrix)
        return matrix_strassen(self, v);
    if(RBASIC_CLASS(v) == cVector)
        return matrix_multiply_mv(self, v);
    rb_raise(fm_eTypeError, "Invalid klass for multiply");
}

VALUE matrix_division_mn(VALUE self, VALUE value)
{
    double d = NUM2DBL(value);
	struct matrix* A = get_matrix_from_rb_value(self);

    MAKE_MATRIX_AND_RB_VALUE(R, result, A->m, A->n);
    copy_d_array(A->m * A->n, A->data, R->data);
    multiply_d_array(R->m * R->n, R->data, 1 / d);

    return result;
}

VALUE matrix_division_mm(VALUE self, VALUE other)
{
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    if(A->m != B->n)
        rb_raise(fm_eIndexError, "First columns differs from second rows");
    raise_check_square_matrix(B);

    int n = B->n;
    double* M = malloc(n * n * sizeof(double));
    c_matrix_inverse(n, B->data, M);

    MAKE_MATRIX_AND_RB_VALUE(C, result, n, n);
    c_matrix_strassen(n, n, n, A->data, M, C->data);

    free(M);
    return result;
}

VALUE matrix_division(VALUE self, VALUE v)
{
    if(RB_FLOAT_TYPE_P(v) || FIXNUM_P(v)
        || RB_TYPE_P(v, T_BIGNUM))
        return matrix_division_mn(self, v);
    if(RBASIC_CLASS(v) == cMatrix)
        return matrix_division_mm(self, v);
    rb_raise(fm_eTypeError, "Invalid klass for division");
}

VALUE matrix_copy(VALUE self)
{
	struct matrix* M = get_matrix_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(R, result, M->m, M->n);
    copy_d_array(M->m * M->n, M->data, R->data);
    return result;
}

VALUE matrix_row_size(VALUE self)
{
	struct matrix* data = get_matrix_from_rb_value(self);
    return INT2NUM(data->m);
}

VALUE matrix_column_size(VALUE self)
{
	struct matrix* data = get_matrix_from_rb_value(self);
    return INT2NUM(data->n);
}

VALUE matrix_transpose(VALUE self)
{
	struct matrix* M = get_matrix_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(R, result, M->n, M->m);
    c_matrix_transpose(M->m, M->n, M->data, R->data);
    return result;
}

VALUE matrix_add_with(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    MAKE_MATRIX_AND_RB_VALUE(C, result, A->m, A->n);
    add_d_arrays_to_result(A->n * A->m, A->data, B->data, C->data);

    return result;
}

VALUE matrix_add_from(VALUE self, VALUE other)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_frozen_matrix(A);
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    add_d_arrays_to_first(A->n * B->m, A->data, B->data);
    return self;
}

VALUE matrix_sub_with(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    MAKE_MATRIX_AND_RB_VALUE(C, result, A->m, A->n);
    sub_d_arrays_to_result(A->n * A->m, A->data, B->data, C->data);
    return result;
}

VALUE matrix_sub_from(VALUE self, VALUE other)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_frozen_matrix(A);
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    sub_d_arrays_to_first(A->n * B->m, A->data, B->data);
    return self;
}

VALUE matrix_determinant(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);
    return DBL2NUM(c_matrix_determinant(A->n, A->data));
}

VALUE matrix_fill(VALUE self, VALUE value)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_frozen_matrix(A);
    double d = raise_rb_value_to_double(value);
    fill_d_array(A->m * A->n, A->data, d);
    return self;
}

VALUE matrix_equal(VALUE self, VALUE other)
{
    if(RBASIC_CLASS(other) != cMatrix)
        return Qfalse;
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    if(A->n != B->n || A->m != B->m)
        return Qfalse;
        
    if(equal_d_arrays(A->n * A->m, A->data, B->data))
		return Qtrue;
	return Qfalse;
}

VALUE matrix_abs(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(R, result, A->m, A->n);
    abs_d_array(A->n * A->m, A->data, R->data);
    return result;
}

VALUE matrix_greater_or_equal(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    if(greater_or_equal_d_array(A->n * A->m, A->data, B->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_less_or_equal(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    if(less_or_equal_d_array(A->n * A->m, A->data, B->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_greater(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    if(greater_d_array(A->n * A->m, A->data, B->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_less(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    if(less_d_array(A->n * A->m, A->data, B->data))
        return Qtrue;
    return Qfalse;
}

void convert_matrix_array(int argc, VALUE *argv, struct matrix*** mtrs)
{
    for(int i = 0; i < argc; ++i)
        raise_check_rbasic(argv[i], cMatrix, "matrix");
    
    *mtrs = (struct matrix**)malloc(argc * sizeof(struct matrix*));

    for(int i = 0; i < argc; ++i)
	    TypedData_Get_Struct(argv[i], struct matrix, &matrix_type, (*mtrs)[i]);
}

VALUE matrix_vstack(int argc, VALUE *argv, VALUE obj)
{
    raise_check_no_arguments(argc);
    
    struct matrix** mtrs;
    convert_matrix_array(argc, argv, &mtrs);

    if(!c_matrix_equal_by_m(argc, mtrs))
    {
        free(mtrs);
        rb_raise(fm_eIndexError, "Rows of different size");
    }

    int m = mtrs[0]->m;
    int n = c_matrix_sum_by_n(argc, mtrs);

    MAKE_MATRIX_AND_RB_VALUE(C, result, m, n);
    c_matrix_vstack(argc, mtrs, C->data);
    free(mtrs);
    return result;
}

VALUE matrix_hstack(int argc, VALUE *argv, VALUE obj)
{
    raise_check_no_arguments(argc);
    
    struct matrix** mtrs;
    convert_matrix_array(argc, argv, &mtrs);

    if(!c_matrix_equal_by_n(argc, mtrs))
    {
        free(mtrs);
        rb_raise(fm_eIndexError, "Columns of different size");
    }

    int m = c_matrix_sum_by_m(argc, mtrs);
    int n = mtrs[0]->n;

    MAKE_MATRIX_AND_RB_VALUE(C, result, m, n);
    c_matrix_hstack(argc, mtrs, C->data, m);

    free(mtrs);
    return result;
}

VALUE matrix_scalar(VALUE obj, VALUE size, VALUE value)
{
    int n = raise_rb_value_to_int(size);
    double v = raise_rb_value_to_double(value);

    MAKE_MATRIX_AND_RB_VALUE(C, result, n, n);
    c_matrix_scalar(n, C->data, v);
    return result;
}

VALUE matrix_antisymmetric(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);

    if(c_matrix_antisymmetric(A->n, A->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_symmetric(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);
    if(c_matrix_symmetric(A->n, A->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_minus(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(C, result, A->m, A->n);
    multiply_d_array_to_result(A->n * A->m, A->data, -1, C->data);
    return result;
}

VALUE matrix_plus(VALUE self)
{
    return self;
}

VALUE matrix_row_vector(VALUE self, VALUE v)
{
    int idx = raise_rb_value_to_int(v);
	struct matrix* A = get_matrix_from_rb_value(self);

    int m = A->m;
    int n = A->n;
    idx = (idx < 0) ? m + idx : idx;
    
    if(idx < 0 || idx >= m)
        return Qnil;
    
    MAKE_VECTOR_AND_RB_VALUE(C, result, n);
    copy_d_array(m, A->data + idx * m, C->data);
    return result;
}

VALUE matrix_column_vector(VALUE self, VALUE v)
{
    int idx = raise_rb_value_to_int(v);
	struct matrix* A = get_matrix_from_rb_value(self);

    int m = A->m;
    int n = A->n;
    idx = (idx < 0) ? n + idx : idx;
    
    if(idx < 0 || idx >= n)
        return Qnil;

    MAKE_VECTOR_AND_RB_VALUE(C, result, n);
    c_matrix_column_vector(m, n, A->data, C->data, idx);
    return result;
}

VALUE matrix_diagonal(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);
    
    if(c_matrix_diagonal(A->n, A->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_hadamard_product(VALUE self, VALUE other)
{
    raise_check_rbasic(other, cMatrix, "matrix");
	struct matrix* A = get_matrix_from_rb_value(self);
	struct matrix* B = get_matrix_from_rb_value(other);

    raise_check_equal_size_matrix(A, B);

    MAKE_MATRIX_AND_RB_VALUE(C, result, A->m, A->n);
    multiply_elems_d_array_to_result(A->n * A->m, A->data, B->data, C->data);
    return result;
}

VALUE matrix_trace(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);
    return DBL2NUM(c_matrix_trace(A->n, A->data));
}

VALUE matrix_first_minor(VALUE self, VALUE row, VALUE column)
{
    int i = raise_rb_value_to_int(column);
    int j = raise_rb_value_to_int(row);
	struct matrix* A = get_matrix_from_rb_value(self);

    int m = A->m;
    int n = A->n;
    if(i < 0 || i >= m || j < 0 || j >= n)
        rb_raise(fm_eIndexError, "Index out of range");

    MAKE_MATRIX_AND_RB_VALUE(C, result, m - 1, n - 1);
    c_matrix_minor(m, n, A->data, C->data, i, j);
    return result;
}

VALUE matrix_cofactor(VALUE self, VALUE row, VALUE column)
{
    int i = raise_rb_value_to_int(column);
    int j = raise_rb_value_to_int(row);
	struct matrix* A = get_matrix_from_rb_value(self);

    int m = A->m;
    int n = A->n;
    if(i < 0 || i >= m || j < 0 || j >= n)
        rb_raise(fm_eIndexError, "Index out of range");
    raise_check_square_matrix(A);

    double* D = malloc(sizeof(double) * (n - 1) * (n - 1));
    c_matrix_minor(n, n, A->data, D, i, j);

    int coefficient = ((i + j) % 2 == 1) ? -1 : 1;
    double det = c_matrix_determinant(n - 1, D);

    free(D);
    return DBL2NUM(coefficient * det);
}

VALUE matrix_zero(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    if(zero_d_array(A->m * A->n, A->data))
            return Qtrue;
    return Qfalse;
}

VALUE matrix_rank(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    return INT2NUM(c_matrix_rank(A->m, A->n, A->data));
}

VALUE matrix_round(int argc, VALUE *argv, VALUE self)
{
    if(argc > 1)
        rb_raise(fm_eTypeError, "Wrong number of arguments");
    int d;
    if(argc == 1)
        d = raise_rb_value_to_int(argv[0]);
    else
        d = 0;

    struct matrix* A = get_matrix_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(R, result, A->m, A->n);
    round_d_array(A->m * A->n, A->data, R->data, d);
    return result;
}

VALUE matrix_lower_triangular(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);

    if(c_matrix_lower_triangular(A->n, A->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_upper_triangular(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);

    if(c_matrix_upper_triangular(A->n, A->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_permutation(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);

    if(c_matrix_permutation(A->n, A->data))
        return Qtrue;
    return Qfalse;
}

VALUE matrix_orthogonal(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);
    
    int n = A->n;
    double* B = malloc(sizeof(double) * n * n);
    double* C = malloc(sizeof(double) * n * n);

    c_matrix_transpose(n, n, A->data, B);
    fill_d_array(n * n, C, 0);
    c_matrix_strassen(n, n, n, A->data, B, C);
    bool result = c_matrix_identity(n, C);

    free(B);
    free(C);
    if(result)
        return Qtrue;
    return Qfalse;
}

VALUE matrix_inverse(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);
    MAKE_MATRIX_AND_RB_VALUE(R, result, A->n, A->n);
    if(!c_matrix_inverse(R->n, A->data, R->data))
        rb_raise(fm_eIndexError, "The discriminant is zero");
    return result;
}

VALUE matrix_adjugate(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    raise_check_square_matrix(A);
    MAKE_MATRIX_AND_RB_VALUE(R, result, A->n, A->n);
    if(!c_matrix_adjugate(R->n, A->data, R->data))
        rb_raise(fm_eIndexError, "The discriminant is zero");
    return result;
}

VALUE matrix_exponentiation(VALUE self, VALUE value)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    int d = raise_rb_value_to_int(value);
    
    MAKE_MATRIX_AND_RB_VALUE(C, result, A->m, A->n);
    if(!c_matrix_exponentiation(A->m, A->n, A->data, C->data, d))
        rb_raise(fm_eIndexError, "Invalid exponentiation");
    return result;
}

VALUE matrix_normal(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    if(A->m != A-> n)
        return Qfalse;
    
    int n = A->n;
    double* B = malloc(n * n * sizeof(double));
    double* C = malloc(n * n * sizeof(double));
    double* D = malloc(n * n * sizeof(double));
    
    c_matrix_transpose(n, n, A->data, B);
    c_matrix_strassen(n, n, n, A->data, B, C);
    c_matrix_strassen(n, n, n, B, A->data, D);
    
    VALUE res = Qfalse;
    if(equal_d_arrays(n * n, C, D))
        res = Qtrue;
    
    free(B);
    free(C);
    free(D);
    return res;
}

VALUE matrix_unitary(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    if(A->m != A-> n)
        return Qfalse;
    
    int n = A->n;
    double* B = malloc(n * n * sizeof(double));
    double* C = malloc(n * n * sizeof(double));
    
    c_matrix_transpose(n, n, A->data, B);
    c_matrix_strassen(n, n, n, A->data, B, C);
    
    VALUE res = Qfalse;
    if(c_matrix_identity(n, C))
        res = Qtrue;
    
    free(B);
    free(C);
    return res;
}

VALUE matrix_freeze(VALUE self)
{
	struct matrix* A = get_matrix_from_rb_value(self);
    A->frozen = true;
    return self;
}

void init_fm_matrix()
{
    VALUE  mod = rb_define_module("FastMatrix");
	cMatrix = rb_define_class_under(mod, "Matrix", rb_cData);

	rb_define_alloc_func(cMatrix, matrix_alloc);

	rb_define_method(cMatrix, "initialize", matrix_initialize, 2);
	rb_define_method(cMatrix, "[]", matrix_get, 2);
	rb_define_method(cMatrix, "[]=", matrix_set, 3);
	rb_define_method(cMatrix, "*", matrix_multiply, 1);
	rb_define_method(cMatrix, "column_count", matrix_row_size, 0);
	rb_define_method(cMatrix, "row_count", matrix_column_size, 0);
	rb_define_method(cMatrix, "clone", matrix_copy, 0);
	rb_define_method(cMatrix, "transpose", matrix_transpose, 0);
	rb_define_method(cMatrix, "+", matrix_add_with, 1);
	rb_define_method(cMatrix, "add!", matrix_add_from, 1);
	rb_define_method(cMatrix, "-", matrix_sub_with, 1);
	rb_define_method(cMatrix, "sub!", matrix_sub_from, 1);
	rb_define_method(cMatrix, "fill!", matrix_fill, 1);
    rb_define_method(cMatrix, "abs", matrix_abs, 0);
    rb_define_method(cMatrix, ">=", matrix_greater_or_equal, 1);
    rb_define_method(cMatrix, "<=", matrix_less_or_equal, 1);
    rb_define_method(cMatrix, ">", matrix_greater, 1);
    rb_define_method(cMatrix, "<", matrix_less, 1);
    rb_define_method(cMatrix, "determinant", matrix_determinant, 0);
    rb_define_method(cMatrix, "eql?", matrix_equal, 1);
    rb_define_method(cMatrix, "antisymmetric?", matrix_antisymmetric, 0);
    rb_define_method(cMatrix, "symmetric?", matrix_symmetric, 0);
    rb_define_method(cMatrix, "-@", matrix_minus, 0);
    rb_define_method(cMatrix, "+@", matrix_plus, 0);
    rb_define_method(cMatrix, "column", matrix_column_vector, 1);
    rb_define_method(cMatrix, "row", matrix_row_vector, 1);
    rb_define_method(cMatrix, "diagonal?", matrix_diagonal, 0);
    rb_define_method(cMatrix, "hadamard_product", matrix_hadamard_product, 1);
    rb_define_method(cMatrix, "trace", matrix_trace, 0);
    rb_define_method(cMatrix, "first_minor", matrix_first_minor, 2);
    rb_define_method(cMatrix, "cofactor", matrix_cofactor, 2);
    rb_define_method(cMatrix, "zero?", matrix_zero, 0);
    rb_define_method(cMatrix, "rank", matrix_rank, 0);
    rb_define_method(cMatrix, "round", matrix_round, -1);
    rb_define_method(cMatrix, "lower_triangular?", matrix_lower_triangular, 0);
    rb_define_method(cMatrix, "upper_triangular?", matrix_upper_triangular, 0);
    rb_define_method(cMatrix, "permutation?", matrix_permutation, 0);
    rb_define_method(cMatrix, "orthogonal?", matrix_orthogonal, 0);
    rb_define_method(cMatrix, "inverse", matrix_inverse, 0);
    rb_define_method(cMatrix, "adjugate", matrix_adjugate, 0);
    rb_define_method(cMatrix, "/", matrix_division, 1);
    rb_define_method(cMatrix, "**", matrix_exponentiation, 1);
    rb_define_method(cMatrix, "normal?", matrix_normal, 0);
    rb_define_method(cMatrix, "unitary?", matrix_unitary, 0);
    rb_define_method(cMatrix, "freeze", matrix_freeze, 0);
    rb_define_module_function(cMatrix, "vstack", matrix_vstack, -1);
    rb_define_module_function(cMatrix, "hstack", matrix_hstack, -1);
    rb_define_module_function(cMatrix, "scalar", matrix_scalar, 2);
}
