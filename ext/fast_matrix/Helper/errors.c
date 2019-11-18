#include "Helper/errors.h"

VALUE fm_eTypeError;
VALUE fm_eIndexError;
VALUE fm_eFrozenError;

double raise_rb_value_to_double(VALUE v)
{
    if(RB_FLOAT_TYPE_P(v) || FIXNUM_P(v)
        || RB_TYPE_P(v, T_BIGNUM))
        return NUM2DBL(v);

    rb_raise(fm_eTypeError, "Value is not number");
    return 0;
}

int raise_rb_value_to_int(VALUE v)
{
    if(FIXNUM_P(v))
        return NUM2INT(v);

    rb_raise(fm_eTypeError, "Index is not integer");
    return 0;
}

void raise_check_range(int v, int min, int max)
{
    if(v < min || v >= max)
        rb_raise(fm_eIndexError, "Index out of range");
}

void raise_check_rbasic(VALUE v, VALUE rBasic, const char* rbasic_name)
{
    if(RBASIC_CLASS(v) != rBasic)
        rb_raise(fm_eTypeError, "Expected class %s", rbasic_name);
}

void init_fm_errors()
{
    VALUE  mod = rb_define_module("FastMatrix");
    
    fm_eTypeError  = rb_define_class_under(mod, "TypeError",  rb_eTypeError);
    fm_eIndexError = rb_define_class_under(mod, "IndexError", rb_eIndexError);
    fm_eFrozenError = rb_define_class_under(mod, "FrozenError", rb_eFrozenError);
}
