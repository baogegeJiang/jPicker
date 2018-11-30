/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "rt_nonfinite.h"
#include "conXC.h"
#include "main.h"
#include "conXC_terminate.h"
#include "conXC_emxAPI.h"
#include "conXC_initialize.h"

/* Function Declarations */
static emxArray_real_T *argInit_Unboundedx1_real_T(void);
static emxArray_real32_T *argInit_Unboundedx3_real32_T(void);
static float argInit_real32_T(void);
static double argInit_real_T(void);
static void main_conXC(void);

/* Function Definitions */
static emxArray_real_T *argInit_Unboundedx1_real_T(void)
{
  emxArray_real_T *result;
  static int iv2[1] = { 2 };

  int idx0;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(1, iv2);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result->data[idx0] = argInit_real_T();
  }

  return result;
}

static emxArray_real32_T *argInit_Unboundedx3_real32_T(void)
{
  emxArray_real32_T *result;
  static int iv3[2] = { 2, 3 };

  int idx0;
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real32_T(2, iv3);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < 3; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[idx0 + result->size[0] * idx1] = argInit_real32_T();
    }
  }

  return result;
}

static float argInit_real32_T(void)
{
  return 0.0F;
}

static double argInit_real_T(void)
{
  return 0.0;
}

static void main_conXC(void)
{
  emxArray_real_T *x;
  emxArray_real_T *b_index;
  emxArray_real32_T *data;
  emxInitArray_real_T(&x, 2);

  /* Initialize function 'conXC' input arguments. */
  /* Initialize function input argument 'index'. */
  b_index = argInit_Unboundedx1_real_T();

  /* Initialize function input argument 'data'. */
  data = argInit_Unboundedx3_real32_T();

  /* Call the entry-point 'conXC'. */
  conXC(b_index, data, argInit_real_T(), argInit_real_T(), x);
  emxDestroyArray_real_T(x);
  emxDestroyArray_real32_T(data);
  emxDestroyArray_real_T(b_index);
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  conXC_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_conXC();

  /* Terminate the application.
     You do not need to do this more than one time. */
  conXC_terminate();
  return 0;
}

/* End of code generation (main.c) */
