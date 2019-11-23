#include "LUPDecomposition/lup.h"
#include "LUPDecomposition/c_lup.h"
#include "LUPDecomposition/helper.h"
#include "Matrix/matrix.h"
#include "Matrix/helper.h"

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

VALUE lup_l(VALUE self)
{
	struct lupdecomposition* lp = get_lup_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(R, result, lp->n, lp->n);
    c_lup_l(lp->n, lp->data, R->data);
    return result;
}

VALUE lup_u(VALUE self)
{
	struct lupdecomposition* lp = get_lup_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(R, result, lp->n, lp->n);
    c_lup_u(lp->n, lp->data, R->data);
    return result;
}

VALUE lup_p(VALUE self)
{
	struct lupdecomposition* lp = get_lup_from_rb_value(self);
    MAKE_MATRIX_AND_RB_VALUE(R, result, lp->n, lp->n);
    c_lup_p(lp->n, lp->permutation, R->data);
    return result;
}

void init_fm_lup()
{
	cLUPDecomposition = rb_define_class_under(cMatrix, "LUPDecomposition", rb_cData);
	rb_define_alloc_func(cLUPDecomposition, lup_alloc);

	rb_define_method(cLUPDecomposition, "l", lup_l, 0);
	rb_define_method(cLUPDecomposition, "u", lup_u, 0);
	rb_define_method(cLUPDecomposition, "p", lup_p, 0);
}
