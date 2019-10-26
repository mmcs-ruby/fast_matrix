#ifndef FAST_MATRIX_MATRIX_H
#define FAST_MATRIX_MATRIX_H 1

#include "ruby.h"

extern VALUE cMatrix;
extern const rb_data_type_t matrix_type;

// matrix
//     m --->
//   [ 0,    1, ..,  m-1]
// n [ m,  m+1, .., 2m-1]
// | [2m, 2m+1, .., 3m-1]
// V [ . . . . .
//         . . . .  nm-1]
struct matrix
{
    int m;
    int n;

    double* data;
};

void c_matrix_init(struct matrix* mtr, int m, int n);

void init_fm_matrix();

#endif /* FAST_MATRIX_MATRIX_H */
