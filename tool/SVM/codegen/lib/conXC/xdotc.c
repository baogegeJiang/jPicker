/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xdotc.c
 *
 * Code generation for function 'xdotc'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "conXC.h"
#include "xdotc.h"

/* Function Definitions */
float xdotc(int n, const emxArray_real32_T *x, int ix0, const emxArray_real32_T *
            y, int iy0)
{
  float d;
  int ix;
  int iy;
  int k;
  d = 0.0F;
  if (!(n < 1)) {
    ix = ix0;
    iy = iy0;
    for (k = 1; k <= n; k++) {
      d += x->data[ix - 1] * y->data[iy - 1];
      ix++;
      iy++;
    }
  }

  return d;
}

/* End of code generation (xdotc.c) */
