#include "c_array_operations.h"

void fill_d_array(int len, double* a, double v)
{
    for(int i = 0; i < len; ++i)
        a[i] = v;
}

void multiply_d_array(int len, double* a, double v)
{
    for(int i = 0; i < len; ++i)
        a[i] *= v;
}

void copy_d_array(int len, const double* input, double* output)
{
    for(int i = 0; i < len; ++i)
        output[i] = input[i];
}

void add_d_arrays_to_result(int len, const double* a1, const double* a2, double* result)
{
    for(int i = 0; i < len; ++i)
        result[i] = a1[i] + a2[i];
}

void add_d_arrays_to_first(int len, double* sum, const double* added)
{
    for(int i = 0; i < len; ++i)
        sum[i] += added[i];
}