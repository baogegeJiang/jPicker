/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xaxpy.h
 *
 * Code generation for function 'xaxpy'
 *
 */

#ifndef XAXPY_H
#define XAXPY_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "conXC_types.h"

/* Function Declarations */
extern void b_xaxpy(int n, float a, const emxArray_real32_T *x, int ix0,
                    emxArray_real32_T *y, int iy0);
extern void c_xaxpy(int n, float a, const emxArray_real32_T *x, int ix0,
                    emxArray_real32_T *y, int iy0);
extern void xaxpy(int n, float a, int ix0, emxArray_real32_T *y, int iy0);

#endif

/* End of code generation (xaxpy.h) */
