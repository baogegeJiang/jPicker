/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * abs.c
 *
 * Code generation for function 'abs'
 *
 */

/* Include files */
#include <math.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "abs.h"

/* Function Definitions */
void b_abs(const double x[302], double y[302])
{
  int k;
  for (k = 0; k < 302; k++) {
    y[k] = fabs(x[k]);
  }
}

/* End of code generation (abs.c) */
