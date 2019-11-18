#ifndef FAST_MATRIX_ERRORS_H
#define FAST_MATRIX_ERRORS_H 1

#include "ruby.h"

extern VALUE fm_eTypeError;
extern VALUE fm_eIndexError;
extern VALUE fm_eFrozenError;

//  convert ruby value to double or raise an error if this is not possible
double raise_rb_value_to_double(VALUE v);
//  convert ruby value to int or raise an error if this is not possible
int raise_rb_value_to_int(VALUE v);
//  check if the value is in range and raise an error if not
void raise_check_range(int v, int min, int max);
//  check if the basic class of value is rBasic and raise an error if not
void raise_check_rbasic(VALUE v, VALUE rBasic, const char* rbasic_name);

void init_fm_errors();

#endif /* FAST_MATRIX_ERRORS_H */
