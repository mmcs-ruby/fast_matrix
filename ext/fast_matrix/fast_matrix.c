#include "fast_matrix.h"
#include "Helper/errors.h"
#include "Matrix/matrix.h"
#include "Vector/vector.h"
#include "LUPDecomposition/lup.h"


void Init_fast_matrix()
{
    init_fm_errors();
    init_fm_matrix();
    init_fm_vector();
    init_fm_lup();
}
