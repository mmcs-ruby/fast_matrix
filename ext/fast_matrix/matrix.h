#ifndef FAST_MATRIX_MATRIX_H
#define FAST_MATRIX_MATRIX_H 1

#include "ruby.h"

static VALUE matrix_eTypeError;
static VALUE matrix_eIndexError;
static VALUE cMatrix;

// matrix
//     m --->
//   [ 0,    1, ..,  m-1]
// n [ m,  m+1, .., 2m-1]
// | [2m, 2m+1, .., 3m-1]
// V [ . . . . .
//         . . . .  nm-1]
struct matrix
{
    int m;
    int n;

    double* data;
};

void matrix_free(void* data);
size_t matrix_size(const void* data);

static const rb_data_type_t matrix_type =
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

void init_fm_matrix();

#endif /* FAST_MATRIX_MATRIX_H */