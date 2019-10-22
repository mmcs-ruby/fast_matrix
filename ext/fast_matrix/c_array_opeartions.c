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