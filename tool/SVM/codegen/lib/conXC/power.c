/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * power.c
 *
 * Code generation for function 'power'
 *
 */

/* Include files */
#include <math.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "power.h"
#include "conXC_emxutil.h"

/* Function Definitions */
void b_power(const emxArray_real32_T *a, emxArray_real32_T *y)
{
  unsigned int a_idx_0;
  unsigned int b_a_idx_0;
  int k;
  a_idx_0 = (unsigned int)a->size[0];
  b_a_idx_0 = (unsigned int)a->size[0];
  k = y->size[0];
  y->size[0] = (int)b_a_idx_0;
  emxEnsureCapacity_real32_T(y, k);
  for (k = 0; k < (int)a_idx_0; k++) {
    y->data[k] = (float)sqrt(a->data[k]);
  }
}

void power(const emxArray_real32_T *a, emxArray_real32_T *y)
{
  unsigned int a_idx_0;
  unsigned int b_a_idx_0;
  int k;
  a_idx_0 = (unsigned int)a->size[0];
  b_a_idx_0 = (unsigned int)a->size[0];
  k = y->size[0];
  y->size[0] = (int)b_a_idx_0;
  emxEnsureCapacity_real32_T(y, k);
  for (k = 0; k < (int)a_idx_0; k++) {
    y->data[k] = a->data[k] * a->data[k];
  }
}

/* End of code generation (power.c) */
