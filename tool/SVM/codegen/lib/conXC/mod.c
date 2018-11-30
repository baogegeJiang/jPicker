/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mod.c
 *
 * Code generation for function 'mod'
 *
 */

/* Include files */
#include <math.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "mod.h"
#include "conXC_emxutil.h"

/* Function Definitions */
void b_mod(const emxArray_real_T *x, double y, emxArray_real_T *r)
{
  int unnamed_idx_1;
  int k;
  double b_r;
  unnamed_idx_1 = x->size[1];
  k = r->size[0] * r->size[1];
  r->size[0] = 1;
  r->size[1] = x->size[1];
  emxEnsureCapacity_real_T(r, k);
  for (k = 0; k < unnamed_idx_1; k++) {
    b_r = x->data[k];
    if ((!rtIsInf(x->data[k])) && (!rtIsNaN(x->data[k])) && ((!rtIsInf(y)) &&
         (!rtIsNaN(y)))) {
      if (x->data[k] == 0.0) {
        b_r = 0.0;
      } else {
        if (y != 0.0) {
          b_r = fmod(x->data[k], y);
          if (b_r == 0.0) {
            b_r = 0.0;
          } else {
            if (x->data[k] < 0.0) {
              b_r += y;
            }
          }
        }
      }
    } else {
      if (y != 0.0) {
        b_r = rtNaN;
      }
    }

    r->data[k] = b_r;
  }
}

/* End of code generation (mod.c) */
