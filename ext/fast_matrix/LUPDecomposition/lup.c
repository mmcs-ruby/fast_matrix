#include "LUPDecomposition/lup.h"
#include "LUPDecomposition/c_lup.h"
#include "Matrix/matrix.h"

VALUE cLUPDecomposition;

void lup_free(void* data);
size_t lup_size(const void* data);

const rb_data_type_t lup_type =
{
    .wrap_struct_name = "lupdecomposition",
    .function =
    {
        .dmark = NULL,
        .dfree = lup_free,
        .dsize = lup_size,
    },
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
};

void lup_free(void* data)
{
    free(((*(struct lupdecomposition*)data)).data);
    free(((*(struct lupdecomposition*)data)).permutation);
    free(data);
}

size_t lup_size(const void* data)
{
	return sizeof(struct lupdecomposition);
}

VALUE lup_alloc(VALUE self)
{
	struct lupdecomposition* lp = malloc(sizeof(struct lupdecomposition));
    lp->data = NULL;
    lp->permutation = NULL;
	return TypedData_Wrap_Struct(self, &lup_type, lp);
}

void init_fm_lup()
{
	cLUPDecomposition = rb_define_class_under(cMatrix, "LUPDecomposition", rb_cData);
	rb_define_alloc_func(cLUPDecomposition, lup_alloc);

	// rb_define_method(cLUPDecomposition, "initialize", lup_initialize, 2);
}
