/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sqrt.c
 *
 * Code generation for function 'sqrt'
 *
 */

/* Include files */
#include <math.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "sqrt.h"

/* Function Definitions */
void b_sqrt(float *x)
{
  *x = (float)sqrt(*x);
}

/* End of code generation (sqrt.c) */
