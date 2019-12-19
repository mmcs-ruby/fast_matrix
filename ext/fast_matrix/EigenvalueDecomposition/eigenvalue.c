#include "EigenvalueDecomposition/eigenvalue.h"

VALUE cEigenvalueDecomposition;

void eigenvalue_free(void* data);
size_t eigenvalue_size(const void* data);

const rb_data_type_t eigenvalue_type =
{
    .wrap_struct_name = "eigenvaluedecomposition",
    .function =
    {
        .dmark = NULL,
        .dfree = eigenvalue_free,
    	.dsize = eigenvalue_size,
    },
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
};

void eigenvalue_free(void* data)
{	
	struct eigenvalue* eigen = (struct eigenvalue*)data;
	free(eigen->v);
	free(eigen->d);
}

size_t eigenvalue_size(const void* data)
{
	return sizeof(struct eigenvalue);
}

VALUE eigenvalue_alloc(VALUE self)
{
	struct eigenvalue* eigen = malloc(sizeof(struct eigenvalue));
	eigen->v = NULL;
	eigen->d = NULL;
	return TypedData_Wrap_Struct(self, &eigenvalue_type, eigen);
}


void init_fm_eigenvalue()
{
	cEigenvalueDecomposition = rb_define_class_under(cMatrix, "EigenvalueDecomposition", rb_cData);
	rb_define_alloc_func(cEigenvalueDecomposition, eigenvalue_alloc);

	// rb_define_method(cEigenvalueDecomposition, "d", eigenvalue_d, 0);
}
