/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * norm.c
 *
 * Code generation for function 'norm'
 *
 */

/* Include files */
#include <math.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "norm.h"
#include "svd.h"

/* Function Definitions */
double b_norm(const double x[302])
{
  double y;
  double scale;
  int k;
  double absxk;
  double t;
  y = 0.0;
  scale = 3.3121686421112381E-170;
  for (k = 0; k < 302; k++) {
    absxk = fabs(x[k]);
    if (absxk > scale) {
      t = scale / absxk;
      y = 1.0 + y * t * t;
      scale = absxk;
    } else {
      t = absxk / scale;
      y += t * t;
    }
  }

  return scale * sqrt(y);
}

float norm(const emxArray_real32_T *x)
{
  float y;
  int j;
  float absx;
  int i;
  float tmp_data[3];
  int tmp_size[1];
  float absxk;
  float t;
  if (x->size[0] == 0) {
    y = 0.0F;
  } else if (x->size[0] == 1) {
    y = 0.0F;
    absx = 1.29246971E-26F;
    for (j = 1; j < 4; j++) {
      absxk = (float)fabs(x->data[j - 1]);
      if (absxk > absx) {
        t = absx / absxk;
        y = 1.0F + y * t * t;
        absx = absxk;
      } else {
        t = absxk / absx;
        y += t * t;
      }
    }

    y = absx * (float)sqrt(y);
  } else {
    y = 0.0F;
    for (j = 0; j < 3; j++) {
      for (i = 1; i <= x->size[0]; i++) {
        absx = (float)fabs(x->data[(i + x->size[0] * j) - 1]);
        if (rtIsNaNF(absx) || (absx > y)) {
          y = absx;
        }
      }
    }

    if ((!rtIsInfF(y)) && (!rtIsNaNF(y))) {
      svd(x, tmp_data, tmp_size);
      y = tmp_data[0];
    }
  }

  return y;
}

/* End of code generation (norm.c) */
