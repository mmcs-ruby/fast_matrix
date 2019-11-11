#include "Helper/c_array_operations.h"
#include "math.h"
#include "stdlib.h"

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

void multiply_elems_d_array_to_result(int len, const double* a, const double* b, double* res)
{
    for(int i = 0; i < len; ++i)
        res[i] = a[i] * b[i];
}

void multiply_d_array_to_result(int len, const double* a, double v, double* res)
{
    for(int i = 0; i < len; ++i)
        res[i] = a[i] * v;
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

void sub_d_arrays_to_result(int len, const double* dec, const double* sub, double* dif)
{
    for(int i = 0; i < len; ++i)
        dif[i] = dec[i] - sub[i];
}

void sub_d_arrays_to_first(int len, double* dif, const double* sub)
{
    for(int i = 0; i < len; ++i)
        dif[i] -= sub[i];
}

bool equal_d_arrays(int len, const double* A, const double* B)
{
    for(int i = 0; i < len; ++i)
        if(A[i] != B[i])
            return false;
    return true;
}

void abs_d_array(int len, const double* A, double* B)
{
    for(int i = 0; i < len; ++i)
        B[i] = fabs(A[i]);
}

bool greater_or_equal_d_array(int len, const double* A, const double* B)
{
    for(int i = 0; i < len; ++i)
        if(A[i] < B[i])
            return false;
    return true;
}

bool zero_d_array(int len, const double* A)
{
    for(int i = 0; i < len; ++i)
        if(A[i] != 0)
            return false;
    return true;
}

void swap_d_arrays(int len, double* A, double* B)
{
    for(int i = 0; i < len; ++i)
    {
        double buf = A[i];
        A[i] = B[i];
        B[i] = buf;
    }
}

void round_d_array(int len, const double* Input, double* Output, int acc)
{
    double d = pow(10, acc);
    for(int i = 0; i < len; ++i)
        Output[i] = roundf(Input[i] * d) / d;
}
