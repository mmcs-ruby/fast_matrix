#include "fast_matrix.h"

VALUE rb_mFastMatrix;

void
Init_fast_matrix(void)
{
  rb_mFastMatrix = rb_define_module("FastMatrix");
}
