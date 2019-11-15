#include "c_matrix.h"
#include "Helper/c_array_operations.h"

// in  - matrix m x n
// out - matrix n x m
void c_matrix_transpose(int m, int n, const double* in, double* out)
{
    for(int i = 0; i < m; ++i)
        for(int j = 0; j < n; ++j)
            out[j + n * i] = in[i + m * j];
}

// A - matrix k x n
// B - matrix m x k
// C - matrix m x n
void c_matrix_multiply(int n, int k, int m, const double* A, const double* B, double* C)
{
    fill_d_array(m * n, C, 0);

    for(int j = 0; j < n; ++j)
    {
        double* p_c = C + m * j;
        const double* p_a = A + k * j;

        for(int t = 0; t < k; ++t)
        {
            const double* p_b = B + m * t;
            double d_a = p_a[t];
            if(d_a != 0)
                for(int i = 0; i < m; ++i)
                    p_c[i] += d_a * p_b[i];
        }
    }
}

// M - matrix m x n
// V - vector m
// R - vector n
void c_matrix_vector_multiply(int n, int m, const double* M, const double* V, double* R)
{
    fill_d_array(n, R, 0);

    for(int j = 0; j < n; ++j)
    {
        const double* p_m = M + m * j;
        for(int i = 0; i < m; ++i)
            R[j] += V[i] * p_m[i];
    }
}


// A - matrix k x n
// B - matrix m x k
// C - matrix m x n
void strassen_iteration(int n, int k, int m, const double* A, const double* B, double* C, int s_a, int s_b, int s_c)
{
    for(int j = 0; j < n; ++j)
    {
        double* p_c = C + s_c * j;
        const double* p_a = A + s_a * j;

        for(int t = 0; t < k; ++t)
        {
            const double* p_b = B + s_b * t;
            double d_a = p_a[t];
            for(int i = 0; i < m; ++i)
                p_c[i] += d_a * p_b[i];
        }
    }
}

bool check_strassen(int m, int n, int k)
{
    return n > 2 && m > 2 && k > 2 && (double)m * (double)n * (double)k > 1000000;
}

//    A          B
// [x x x]    [x x x]
// [x x x] => [x x x]
// [x x x]    [x x x]
void strassen_copy(int m, int n, const double* A, double* B, int s_a, int s_b)
{
    for(int i = 0; i < n; ++i)
    {
        const double* p_A = A + i * s_a;
        double* p_B = B + i * s_b;
        for(int j = 0; j < m; ++j)
            p_B[j] = p_A[j];
    }
}

// if right = false and down = false | if right = true and down = false:       
//        A          B               |      A           B
//     [x x x]    [x x x]            |   [x x x]    [x x x 0]
//     [x x x] => [x x x]            |   [x x x] => [x x x 0]
//     [x x x]    [x x x]            |   [x x x]    [x x x 0]
//                                   |
// if right = false and down = true  | if right = true and down = true:       
//        A          B               |      A           B
//     [x x x]    [x x x]            |   [x x x]    [x x x 0]
//     [x x x] => [x x x]            |   [x x x] => [x x x 0]
//     [x x x]    [x x x]            |   [x x x]    [x x x 0]
//                [0 0 0]            |              [0 0 0 0]
void strassen_copy_with_zero(int m, int n, const double* A, double* B, int s_a, int s_b, bool right, bool down)
{
    double* p_B;
    for(int i = 0; i < n; ++i)
    {
        const double* p_A = A + i * s_a;
        p_B = B + i * s_b;
        for(int j = 0; j < m; ++j)
            p_B[j] = p_A[j];
        if(right)
            p_B[m] = 0;
    }

    if(down)
    {
        p_B = B + n * s_b;
        for(int j = 0; j < m; ++j)
            p_B[j] = 0;
        if(right)
            p_B[m] = 0;
    }
}

void strassen_sum_to_first(int m, int n, double* A, const double* B, int s_a, int s_b)
{
    for(int i = 0; i < n; ++i)
    {
        double* p_A = A + i * s_a;
        const double* p_B = B + i * s_b;
        for(int j = 0; j < m; ++j)
            p_A[j] += p_B[j];
    }
}

void strassen_sub_to_first(int m, int n, double* A, const double* B, int s_a, int s_b)
{
    for(int i = 0; i < n; ++i)
    {
        double* p_A = A + i * s_a;
        const double* p_B = B + i * s_b;
        for(int j = 0; j < m; ++j)
            p_A[j] -= p_B[j];
    }
}

// A - matrix k x n
// B - matrix m x k
// C - matrix m x n
void c_matrix_strassen(int n, int k, int m, const double* A, const double* B, double* C)
{
    if(!check_strassen(m, n, k))
        return c_matrix_multiply(n, k, m, A, B, C);

    int k2 = k / 2;
    int k1 = k - k2;
    int m2 = m / 2;
    int m1 = m - m2;
    int n2 = n / 2;
    int n1 = n - n2;

    double* termA = malloc(k1 * n1 * sizeof(double));
    double* termB = malloc(m1 * k1 * sizeof(double));

    double* P1 = malloc(7 * m1 * n1 * sizeof(double));
    double* P2 = P1 + m1 * n1;
    double* P3 = P2 + m1 * n1;
    double* P4 = P3 + m1 * n1;
    double* P5 = P4 + m1 * n1;
    double* P6 = P5 + m1 * n1;
    double* P7 = P6 + m1 * n1;
    fill_d_array(7 * m1 * n1, P1, 0);

    //  -----------P1-----------
    strassen_copy(k1, n1, A, termA, k, k1);
    strassen_sum_to_first(k2, n2, termA, A + k1 + k * n1, k1, k);
    
    strassen_copy(m1, k1, B, termB, m, m1);
    strassen_sum_to_first(m2, k2, termB, B + m1 + m * k1, m1, m);

    c_matrix_strassen(n1, k1, m1, termA, termB, P1);
    //  -----------P2-----------
    strassen_copy_with_zero(k1, n2, A + k * n1, termA, k, k1, false, n1 != n2);
    strassen_sum_to_first(k2, n2, termA, A + k1 + k * n1, k1, k);
    
    strassen_copy(m1, k1, B, termB, m, m1);

    c_matrix_strassen(n1, k1, m1, termA, termB, P2);
    //  -----------P3-----------
    strassen_copy(k1, n1, A, termA, k, k1);
    
    strassen_copy_with_zero(m2, k1, B + m1, termB, m, m1, m1 != m2, false);
    strassen_sub_to_first(m2, k2, termB, B + m1 + m * k1, m1, m);
    
    c_matrix_strassen(n1, k1, m1, termA, termB, P3);
    //  -----------P4-----------
    strassen_copy_with_zero(k2, n2, A + k1 + k * n1, termA, k, k1, k1 != k2, n1 != n2);

    strassen_copy_with_zero(m1, k2, B + m * k1, termB, m, m1, false, k1 != k2);
    strassen_sub_to_first(m1, k1, termB, B, m1, m);
    
    c_matrix_strassen(n1, k1, m1, termA, termB, P4);
    //  -----------P5-----------
    strassen_copy(k1, n1, A, termA, k, k1);
    strassen_sum_to_first(k2, n1, termA, A + k1, k1, k);
    
    strassen_copy_with_zero(m2, k2, B + m1 + m * k1, termB, m, m1, m1 != m2, k1 != k2);

    c_matrix_strassen(n1, k1, m1, termA, termB, P5);
    //  -----------P6-----------
    strassen_copy_with_zero(k1, n2, A + k * n1, termA, k, k1, false, n1 != n2);
    strassen_sub_to_first(k1, n1, termA, A, k1, k);
    
    strassen_copy(m1, k1, B, termB, m, m1);
    strassen_sum_to_first(m2, k1, termB, B + m1, m1, m);
    
    c_matrix_strassen(n1, k1, m1, termA, termB, P6);
    //  -----------P7-----------
    strassen_copy_with_zero(k2, n1, A + k1, termA, k, k1, k1 != k2, false);
    strassen_sub_to_first(k2, n2, termA, A + k1 + k * n1, k1, k);
    
    strassen_copy_with_zero(m1, k2, B + k1 * m, termB, m, m1, false, k1 != k2);
    strassen_sum_to_first(m2, k2, termB, B + m1 + m * k1, m1, m);
    
    c_matrix_strassen(n1, k1, m1, termA, termB, P7);

    //  -----------C11-----------
    double* C11 = C;
    strassen_copy(m1, n1, P1, C11, m1, m);
    strassen_sum_to_first(m1, n1, C11, P4, m, m1);
    strassen_sub_to_first(m1, n1, C11, P5, m, m1);
    strassen_sum_to_first(m1, n1, C11, P7, m, m1);
    //  -----------C12-----------
    double* C12 = C + m1;
    strassen_copy(m2, n1, P3, C12, m1, m);
    strassen_sum_to_first(m2, n1, C12, P5, m, m1);
    //  -----------C21-----------
    double* C21 = C + m * n1;
    strassen_copy(m1, n2, P2, C21, m1, m);
    strassen_sum_to_first(m1, n2, C21, P4, m, m1);
    //  -----------C22-----------
    double* C22 = C + m1 + m * n1;
    strassen_copy(m2, n2, P1, C22, m1, m);
    strassen_sub_to_first(m2, n2, C22, P2, m, m1);
    strassen_sum_to_first(m2, n2, C22, P3, m, m1);
    strassen_sum_to_first(m2, n2, C22, P6, m, m1);
    
    free(termA);
    free(termB);
    free(P1);
}

void c_matrix_hstack(int argc, struct matrix** mtrs, double* C, int m)
{
    for(int i = 0; i < argc; ++i)
    {
        struct matrix* M = mtrs[i];
        //  a little misuse of the method
        strassen_copy(M->m, M->n, M->data, C, M->m, m);
        C += M->m;
    }
}

void c_matrix_column_vector(int m, int n, const double* M, double* V, int idx)
{
    M = M + idx;
    for(int i = 0; i < n; ++i)
    {
        V[i] = *M;
        M += m;
    }
}

void c_matrix_scalar(int n, double* C, double v)
{
    int ptr = 0;
    
    for(int i = 0; i < n * n; ++i)
    {
        if(i == ptr)
        {
            ptr += n + 1;
            C[i] = v;
        }else
            C[i] = 0;
    }
}

bool c_matrix_symmetric(int n, const double* C)
{
    for(int i = 0; i < n; ++i)
        for(int j = i; j < n; ++j)
            if(C[i + j * n] != C[j + i * n])
                return false;
    return true;
}

bool c_matrix_antisymmetric(int n, const double* C)
{
    for(int i = 0; i < n; ++i)
        for(int j = i; j < n; ++j)
            if(C[i + j * n] != -C[j + i * n])
                return false;
    return true;
}

bool c_matrix_diagonal(int n, const double* C)
{
    int ptr = 0;
    
    for(int i = 0; i < n * n; ++i)
    {
        if(i == ptr)
            ptr += n + 1;
        else if(C[i] != 0)
            return false;
    }
    return true;
}

double c_matrix_trace(int n, const double* A)
{
    int sum = 0;
    for(int i = 0; i < n; ++i)
        sum += A[i + i * n];
    return sum;
}

void c_matrix_minor(int m, int n, const double* A, double* B, int m_idx, int n_idx)
{
    for(int j = 0; j < n - 1; ++j)
    {
        int j_step = (j >= n_idx) ? 1 : 0;
        for(int i = 0; i < m - 1; ++i)
        {
            int i_step = (i >= m_idx) ? 1 : 0;
            B[i + j * (m - 1)] = A[(i + i_step) + (j + j_step) * m];
        }
    }
}

bool c_matrix_lower_triangular(int n, const double* A)
{
    for(int i = 0; i < n; ++i)
    {
        const double* line = A + (i + 1) + n * i;
        for(int j = 0; j < n - i - 1; ++j)
            if(line[j] != 0)
                return false;
    }
    return true;
}

bool c_matrix_upper_triangular(int n, const double* A)
{
    for(int i = 1; i < n; ++i)
    {
        const double* line = A + n * i;
        for(int j = 0; j < i; ++j)
            if(line[j] != 0)
                return false;
    }
    return true;
}

bool c_matrix_permutation(int n, const double* A)
{
    bool* f = malloc(n * sizeof(bool));
    for(int i = 0; i < n; ++i)
        f[i] = false;
    
    bool result;
    for(int i = 0; i < n; ++i)
    {
        const double* line = A + n * i; 
        result = false;
        for(int j = 0; j < n; ++j)
        {
            double v = line[j];
            if(v == 0)
                continue;

            if(v != 1 || result || f[j])
            {    
                result = false;
                break;
            }
            
            result = f[j] = true;
        }
        if(!result)
            break;
    }

    if(result)
        for(int i = 0; i < n; ++i)
            if(!f[i])
            {
                result = false;
                break;
            }
    free(f);
    return result;
}

bool c_matrix_identity(int n, const double* A)
{
    for(int i = 0; i < n; ++i)
    {
        const double* p_a = A + i * n;
        for(int j = 0; j < n; ++j)
            if(i == j)
            { if(p_a[j] != 1) return false; }
            else
            { if(p_a[j] != 0) return false; }
    }
    return true;
}

bool c_matrix_equal_by_m(int argc, struct matrix** mtrs)
{
    int m = mtrs[0]->m;
    for(int i = 1; i < argc; ++i)
        if(m != mtrs[i]->m)
            return false;
    return true;
}

bool c_matrix_equal_by_n(int argc, struct matrix** mtrs)
{
    int n = mtrs[0]->n;
    for(int i = 1; i < argc; ++i)
        if(n != mtrs[i]->n)
            return false;
    return true;
}

int c_matrix_sum_by_m(int argc, struct matrix** mtrs)
{
    int sum = 0;
    for(int i = 0; i < argc; ++i)
        sum += mtrs[i]->m;
    return sum;
}

int c_matrix_sum_by_n(int argc, struct matrix** mtrs)
{
    int sum = 0;
    for(int i = 0; i < argc; ++i)
        sum += mtrs[i]->n;
    return sum;
}

void c_matrix_vstack(int argc, struct matrix** mtrs, double* C)
{
    for(int i = 0; i < argc; ++i)
    {
        struct matrix* M = mtrs[i];
        int len = M->m * M->n;
        copy_d_array(len, M->data, C);
        C += len;
    }
}

int c_matrix_rank(int m, int n, const double* C)
{
    double* A = malloc(sizeof(double) * m * n);
    copy_d_array(m * n, C, A);

    int i = 0;
    int c_ptr = 0;
    while(i < n && c_ptr < m)
    {
        double* line = A + c_ptr + i * m;
        double val = line[0];
        
        if(val == 0)
            for(int j = i + 1; j < n; ++j)
                if(A[c_ptr + j * m] != 0)
                {
                    double* buf = A + c_ptr + j * m;
                    swap_d_arrays(m - c_ptr, buf, line);
                    val = line[0];
                    break;
                }

        if(val == 0)
        {
            ++c_ptr;
            continue;
        }

        for(int j = i + 1; j < n; ++j)
        {
            double* target = A + c_ptr + j * m;
            double mul = target[0];
            if(mul == 0)
                continue;
            for(int k = 1; k < m - c_ptr; ++k)
                target[k] = val * target[k] - mul * line[k];
        }
        ++c_ptr;
        ++i;
    }
    free(A);
    return i;
}

double c_matrix_determinant(int n, const double* A)
{
    double* M = malloc(n * n * sizeof(double));
    double det = 1;
    copy_d_array(n * n, A, M);

    for(int i = 0; i < n; ++i)
    {
        double* line_p = M + i + i * n;
        double current = *line_p; 

        if(current == 0)
            for(int j = i + 1; j < n; ++j)
                if(M[i + j * n] != 0)
                {
                    double* buf = M + i + j * n;
                    swap_d_arrays(n - i, buf, line_p);
                    current = line_p[0];
                    det *= -1;
                }

        if(current == 0)
        {
            free(M);
            return 0;
        }

        det *= current;

        for(int j = i + 1; j < n; ++j)
        {
            double* t_line = M + i + j * n;
            double head = *t_line;
            for(int k = 1; k < n - i; ++k)
                t_line[k] -= line_p[k] * head / current;
        }
    }

    free(M);
    return det;
}

void c_matrix_shift_identity(int n, double* A, int s_a)
{
    for(int i = 0; i < n; ++i)
    {
        double* line_p = A + i * s_a;
        for(int j = 0; j < n; ++j)
            line_p[j] = (i == j) ? 1 : 0;
    }
}

bool c_matrix_inverse(int n, const double* A, double* B)
{
    int m = 2 * n;
    double* M = malloc(m * n * sizeof(double));
    strassen_copy(n, n, A, M, n, m);
    c_matrix_shift_identity(n, M + n, m);

    for(int i = 0; i < n; ++i)
    {
        double* line_p = M + i + i * m;
        double current = *line_p; 

        if(current == 0)
            for(int j = i + 1; j < n; ++j)
                if(M[i + j * m] != 0)
                {
                    double* buf = M + i + j * m;
                    swap_d_arrays(m - i, buf, line_p);
                    current = line_p[0];
                }

        if(current == 0)
        {
            free(M);
            return false;
        }

        for(int j = 0; j < n; ++j)
        {
            double* t_line = M + i + j * m;
            double head = *t_line;
            if(i == j || head == 0) 
                continue;
            for(int k = 1; k < m - i; ++k)
                t_line[k] -= line_p[k] * head / current;
        }
        for(int k = 1; k < m - i; ++k)
            line_p[k] = line_p[k] / current;
    }

    strassen_copy(n, n, M + n, B, m, n);

    free(M);
    return true;
}

bool c_matrix_adjugate(int n, const double* A, double* B)
{
    if(!c_matrix_inverse(n, A, B))
        return false;
    double d = c_matrix_determinant(n, A);
    multiply_d_array(n * n, B, d);
    return true;
}

void c_matrix_recursive_exponentiation(int n, const double* A, double* B, int d)
{
    if(d == 2)
        return c_matrix_strassen(n, n, n, A, A, B);
    
    double* C = malloc(n * n * sizeof(double));
    
    if(d == 3)
    {
        c_matrix_strassen(n, n, n, A, A, C);
        c_matrix_strassen(n, n, n, A, C, B);
        free(C);
        return;
    }

    c_matrix_recursive_exponentiation(n, A, C, d / 2);
    
    if(d % 2 == 0)
    {
        c_matrix_strassen(n, n, n, C, C, B);
        free(C);
        return;
    }
    
    double* D = malloc(n * n * sizeof(double));
    
    c_matrix_strassen(n, n, n, C, C, D);
    c_matrix_strassen(n, n, n, A, D, B);
    free(C);
    free(D);
}

bool c_matrix_exponentiation(int m, int n, const double* A, double* B, int d)
{
    if(d == 1)
    {
        copy_d_array(m * n, A, B);
        return true;
    }

    if(m != n)
        return false;

    if(d == 0)
    {
        c_matrix_shift_identity(n, B, n);
        return true;
    }

    if(d > 0)
    {
        c_matrix_recursive_exponentiation(n, A, B, d);
        return true;
    }

    if(d == -1)
    {
        c_matrix_inverse(n, A, B);
        return true;
    }

    double* C = malloc(n * n * sizeof(double));
    c_matrix_inverse(n, A, C);
    c_matrix_recursive_exponentiation(n, C, B, -d);
    free(C);
    
    return true;
}