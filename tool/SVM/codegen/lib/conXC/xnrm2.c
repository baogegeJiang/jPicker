/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xnrm2.c
 *
 * Code generation for function 'xnrm2'
 *
 */

/* Include files */
#include <math.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "xnrm2.h"

/* Function Definitions */
float b_xnrm2(const float x[3], int ix0)
{
  float y;
  float scale;
  int k;
  float absxk;
  float t;
  y = 0.0F;
  scale = 1.29246971E-26F;
  for (k = ix0; k <= ix0 + 1; k++) {
    absxk = (float)fabs(x[k - 1]);
    if (absxk > scale) {
      t = scale / absxk;
      y = 1.0F + y * t * t;
      scale = absxk;
    } else {
      t = absxk / scale;
      y += t * t;
    }
  }

  return scale * (float)sqrt(y);
}

float xnrm2(int n, const emxArray_real32_T *x, int ix0)
{
  float y;
  float scale;
  int kend;
  int k;
  float absxk;
  float t;
  y = 0.0F;
  if (!(n < 1)) {
    if (n == 1) {
      y = (float)fabs(x->data[ix0 - 1]);
    } else {
      scale = 1.29246971E-26F;
      kend = (ix0 + n) - 1;
      for (k = ix0; k <= kend; k++) {
        absxk = (float)fabs(x->data[k - 1]);
        if (absxk > scale) {
          t = scale / absxk;
          y = 1.0F + y * t * t;
          scale = absxk;
        } else {
          t = absxk / scale;
          y += t * t;
        }
      }

      y = scale * (float)sqrt(y);
    }
  }

  return y;
}

/* End of code generation (xnrm2.c) */
