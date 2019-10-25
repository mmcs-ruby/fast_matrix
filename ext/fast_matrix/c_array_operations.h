#ifndef C_ARRAY_OPERATIONS
#define C_ARRAY_OPERATIONS

#include  <stdbool.h>

void fill_d_array(int len, double* a, double v);
void multiply_d_array(int len, double* a, double v);
void copy_d_array(int len, const double* input, double* output);
void add_d_arrays_to_result(int len, const double* a1, const double* a2, double* result);
void add_d_arrays_to_first(int len, double* sum, const double* added);
bool equal_d_arrays(int len, double* A, double* B);

#endif  /*C_ARRAY_OPERATIONS*/