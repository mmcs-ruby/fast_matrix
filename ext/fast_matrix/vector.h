#ifndef FAST_MATRIX_VECTOR_H
#define FAST_MATRIX_VECTOR_H 1

#include "ruby.h"

static VALUE vector_eTypeError;
static VALUE vector_eIndexError;
static VALUE cVector;

// vector
struct vector
{
    int n;
    double* data;
};

void vector_free(void* data);
size_t vector_size(const void* data);

static const rb_data_type_t vector_type =
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

void init_fm_vector();

#endif /* FAST_MATRIX_VECTOR_H */