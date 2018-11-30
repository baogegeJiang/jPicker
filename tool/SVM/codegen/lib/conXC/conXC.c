/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * conXC.c
 *
 * Code generation for function 'conXC'
 *
 */

/* Include files */
#include <math.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "norm.h"
#include "abs.h"
#include "conXC_emxutil.h"
#include "power.h"
#include "mod.h"

/* Function Definitions */
void conXC(const emxArray_real_T *b_index, const emxArray_real32_T *data, double
           fastCal, double fastCalNum, emxArray_real_T *x)
{
  int nm1d2;
  int n;
  float xp[40];
  float xb[40];
  int i0;
  emxArray_real_T *y;
  emxArray_real32_T *r0;
  emxArray_real32_T *r1;
  emxArray_real_T *r2;
  emxArray_real32_T *b_data;
  emxArray_real32_T *c_data;
  emxArray_real_T *r3;
  double indexTmp;
  int i;
  double c_index;
  int i1;
  int i2;
  int i3;
  int j;
  double a;
  static const short iv0[40] = { 80, 95, 120, 155, 200, 255, 320, 395, 480, 575,
    680, 795, 920, 1055, 1200, 1355, 1520, 1695, 1880, 2075, 2280, 2495, 2720,
    2955, 3200, 3455, 3720, 3995, 4280, 4575, 4880, 5195, 5520, 5855, 6200, 6555,
    6920, 7295, 7680, 8075 };

  int i4;
  double b;
  static const short iv1[40] = { 75, 80, 95, 120, 155, 200, 255, 320, 395, 480,
    575, 680, 795, 920, 1055, 1200, 1355, 1520, 1695, 1880, 2075, 2280, 2495,
    2720, 2955, 3200, 3455, 3720, 3995, 4280, 4575, 4880, 5195, 5520, 5855, 6200,
    6555, 6920, 7295, 7680 };

  int k;
  double ndbl;
  double apnd;
  double cdiff;
  double absa;
  double absb;
  float b_x;
  int b_n;
  unsigned int kd;
  double b_y[302];

  /* 30 */
  nm1d2 = data->size[0];
  if (!(nm1d2 > 3)) {
    nm1d2 = 3;
  }

  if (data->size[0] == 0) {
    n = 0;
  } else {
    n = nm1d2;
  }

  memset(&xp[0], 0, 40U * sizeof(float));
  memset(&xb[0], 0, 40U * sizeof(float));
  i0 = x->size[0] * x->size[1];
  x->size[0] = 382;
  x->size[1] = b_index->size[0];
  emxEnsureCapacity_real_T(x, i0);
  nm1d2 = 382 * b_index->size[0];
  for (i0 = 0; i0 < nm1d2; i0++) {
    x->data[i0] = 0.0;
  }

  emxInit_real_T(&y, 2);
  emxInit_real32_T(&r0, 1);
  emxInit_real32_T(&r1, 1);
  emxInit_real_T(&r2, 2);
  emxInit_real32_T(&b_data, 1);
  emxInit_real32_T1(&c_data, 2);
  emxInit_real_T1(&r3, 1);
  if (fastCal == 0.0) {
    for (i = 0; i < b_index->size[0]; i++) {
      c_index = b_index->data[i];
      if (b_index->data[i] - 75.0 > b_index->data[i] + 75.0) {
        i0 = 0;
        i1 = 0;
        i2 = 0;
        i3 = 0;
      } else {
        i0 = (int)(b_index->data[i] - 75.0) - 1;
        i1 = (int)(b_index->data[i] + 75.0);
        i2 = (int)(b_index->data[i] - 75.0) - 1;
        i3 = (int)(b_index->data[i] + 75.0);
      }

      for (j = 0; j < 40; j++) {
        a = c_index - (double)iv0[j];
        b = (c_index - (double)iv1[j]) - 1.0;
        if (rtIsNaN(a) || rtIsNaN(b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (b < a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 0;
          emxEnsureCapacity_real_T(y, i4);
        } else if ((rtIsInf(a) || rtIsInf(b)) && (a == b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (floor(a) == a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = (int)floor((b - a) / 3.0) + 1;
          emxEnsureCapacity_real_T(y, i4);
          nm1d2 = (int)floor((b - a) / 3.0);
          for (i4 = 0; i4 <= nm1d2; i4++) {
            y->data[y->size[0] * i4] = a + 3.0 * (double)i4;
          }
        } else {
          ndbl = floor((b - a) / 3.0 + 0.5);
          apnd = a + ndbl * 3.0;
          cdiff = apnd - b;
          absa = fabs(a);
          absb = fabs(b);
          if ((absa > absb) || rtIsNaN(absb)) {
            absb = absa;
          }

          if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
            ndbl++;
            apnd = b;
          } else if (cdiff > 0.0) {
            apnd = a + (ndbl - 1.0) * 3.0;
          } else {
            ndbl++;
          }

          if (ndbl >= 0.0) {
            b_n = (int)ndbl;
          } else {
            b_n = 0;
          }

          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = b_n;
          emxEnsureCapacity_real_T(y, i4);
          if (b_n > 0) {
            y->data[0] = a;
            if (b_n > 1) {
              y->data[b_n - 1] = apnd;
              nm1d2 = (b_n - 1) / 2;
              for (k = 1; k < nm1d2; k++) {
                kd = k * 3U;
                y->data[k] = a + (double)kd;
                y->data[(b_n - k) - 1] = apnd - (double)kd;
              }

              if (nm1d2 << 1 == b_n - 1) {
                y->data[nm1d2] = (a + apnd) / 2.0;
              } else {
                kd = nm1d2 * 3U;
                y->data[nm1d2] = a + (double)kd;
                y->data[nm1d2 + 1] = apnd - (double)kd;
              }
            }
          }
        }

        b_mod(y, n, r2);
        i4 = c_data->size[0] * c_data->size[1];
        c_data->size[0] = r2->size[1];
        c_data->size[1] = 3;
        emxEnsureCapacity_real32_T1(c_data, i4);
        for (i4 = 0; i4 < 3; i4++) {
          nm1d2 = r2->size[1];
          for (k = 0; k < nm1d2; k++) {
            c_data->data[k + c_data->size[0] * i4] = data->data[((int)(r2->
              data[r2->size[0] * k] + 1.0) + data->size[0] * i4) - 1];
          }
        }

        b_x = norm(c_data);
        xp[j] = b_x / (float)sqrt((double)(iv0[j] - iv1[j]) + 1.0);
        a = c_index + (double)iv1[j];
        b = (c_index + (double)iv0[j]) - 1.0;
        if (rtIsNaN(a) || rtIsNaN(b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (b < a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 0;
          emxEnsureCapacity_real_T(y, i4);
        } else if ((rtIsInf(a) || rtIsInf(b)) && (a == b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (floor(a) == a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = (int)floor((b - a) / 3.0) + 1;
          emxEnsureCapacity_real_T(y, i4);
          nm1d2 = (int)floor((b - a) / 3.0);
          for (i4 = 0; i4 <= nm1d2; i4++) {
            y->data[y->size[0] * i4] = a + 3.0 * (double)i4;
          }
        } else {
          ndbl = floor((b - a) / 3.0 + 0.5);
          apnd = a + ndbl * 3.0;
          cdiff = apnd - b;
          absa = fabs(a);
          absb = fabs(b);
          if ((absa > absb) || rtIsNaN(absb)) {
            absb = absa;
          }

          if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
            ndbl++;
            apnd = b;
          } else if (cdiff > 0.0) {
            apnd = a + (ndbl - 1.0) * 3.0;
          } else {
            ndbl++;
          }

          if (ndbl >= 0.0) {
            b_n = (int)ndbl;
          } else {
            b_n = 0;
          }

          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = b_n;
          emxEnsureCapacity_real_T(y, i4);
          if (b_n > 0) {
            y->data[0] = a;
            if (b_n > 1) {
              y->data[b_n - 1] = apnd;
              nm1d2 = (b_n - 1) / 2;
              for (k = 1; k < nm1d2; k++) {
                kd = k * 3U;
                y->data[k] = a + (double)kd;
                y->data[(b_n - k) - 1] = apnd - (double)kd;
              }

              if (nm1d2 << 1 == b_n - 1) {
                y->data[nm1d2] = (a + apnd) / 2.0;
              } else {
                kd = nm1d2 * 3U;
                y->data[nm1d2] = a + (double)kd;
                y->data[nm1d2 + 1] = apnd - (double)kd;
              }
            }
          }
        }

        b_mod(y, n, r2);
        i4 = c_data->size[0] * c_data->size[1];
        c_data->size[0] = r2->size[1];
        c_data->size[1] = 3;
        emxEnsureCapacity_real32_T1(c_data, i4);
        for (i4 = 0; i4 < 3; i4++) {
          nm1d2 = r2->size[1];
          for (k = 0; k < nm1d2; k++) {
            c_data->data[k + c_data->size[0] * i4] = data->data[((int)(r2->
              data[r2->size[0] * k] + 1.0) + data->size[0] * i4) - 1];
          }
        }

        b_x = norm(c_data);
        xb[j] = b_x / (float)sqrt((double)(iv0[j] - iv1[j]) + 1.0);
      }

      if (b_index->data[i] - 75.0 > b_index->data[i] + 75.0) {
        i4 = 0;
        k = 0;
      } else {
        i4 = (int)(b_index->data[i] - 75.0) - 1;
        k = (int)(b_index->data[i] + 75.0);
      }

      nm1d2 = b_data->size[0];
      b_data->size[0] = i1 - i0;
      emxEnsureCapacity_real32_T(b_data, nm1d2);
      nm1d2 = i1 - i0;
      for (i1 = 0; i1 < nm1d2; i1++) {
        b_data->data[i1] = data->data[i0 + i1];
      }

      power(b_data, r0);
      i0 = b_data->size[0];
      b_data->size[0] = i3 - i2;
      emxEnsureCapacity_real32_T(b_data, i0);
      nm1d2 = i3 - i2;
      for (i0 = 0; i0 < nm1d2; i0++) {
        b_data->data[i0] = data->data[(i2 + i0) + data->size[0]];
      }

      power(b_data, r1);
      i0 = b_data->size[0];
      b_data->size[0] = r0->size[0];
      emxEnsureCapacity_real32_T(b_data, i0);
      nm1d2 = r0->size[0];
      for (i0 = 0; i0 < nm1d2; i0++) {
        b_data->data[i0] = r0->data[i0] + r1->data[i0];
      }

      b_power(b_data, r0);
      i0 = r3->size[0];
      r3->size[0] = ((r0->size[0] + k) - i4) + 80;
      emxEnsureCapacity_real_T1(r3, i0);
      nm1d2 = r0->size[0];
      for (i0 = 0; i0 < nm1d2; i0++) {
        r3->data[i0] = r0->data[i0];
      }

      nm1d2 = k - i4;
      for (i0 = 0; i0 < nm1d2; i0++) {
        r3->data[i0 + r0->size[0]] = data->data[(i4 + i0) + (data->size[0] << 1)];
      }

      for (i0 = 0; i0 < 40; i0++) {
        r3->data[((i0 + r0->size[0]) + k) - i4] = xp[i0];
      }

      for (i0 = 0; i0 < 40; i0++) {
        r3->data[(((i0 + r0->size[0]) + k) - i4) + 40] = xb[i0];
      }

      for (i0 = 0; i0 < 382; i0++) {
        x->data[i0 + x->size[0] * i] = r3->data[i0];
      }

      b_abs(*(double (*)[302])&x->data[x->size[0] * i], b_y);
      c_index = b_norm(b_y);
      for (i0 = 0; i0 < 382; i0++) {
        x->data[i0 + x->size[0] * i] /= c_index;
      }
    }
  } else {
    indexTmp = -1000.0;
    for (i = 0; i < b_index->size[0]; i++) {
      c_index = b_index->data[i];
      if (b_index->data[i] - 75.0 > b_index->data[i] + 75.0) {
        i0 = 0;
        i1 = 0;
        i2 = 0;
        i3 = 0;
      } else {
        i0 = (int)(b_index->data[i] - 75.0) - 1;
        i1 = (int)(b_index->data[i] + 75.0);
        i2 = (int)(b_index->data[i] - 75.0) - 1;
        i3 = (int)(b_index->data[i] + 75.0);
      }

      for (j = 0; j < 5; j++) {
        a = c_index - (double)iv0[j];
        b = (c_index - (double)iv1[j]) - 1.0;
        if (rtIsNaN(a) || rtIsNaN(b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (b < a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 0;
          emxEnsureCapacity_real_T(y, i4);
        } else if ((rtIsInf(a) || rtIsInf(b)) && (a == b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (floor(a) == a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = (int)floor((b - a) / 3.0) + 1;
          emxEnsureCapacity_real_T(y, i4);
          nm1d2 = (int)floor((b - a) / 3.0);
          for (i4 = 0; i4 <= nm1d2; i4++) {
            y->data[y->size[0] * i4] = a + 3.0 * (double)i4;
          }
        } else {
          ndbl = floor((b - a) / 3.0 + 0.5);
          apnd = a + ndbl * 3.0;
          cdiff = apnd - b;
          absa = fabs(a);
          absb = fabs(b);
          if ((absa > absb) || rtIsNaN(absb)) {
            absb = absa;
          }

          if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
            ndbl++;
            apnd = b;
          } else if (cdiff > 0.0) {
            apnd = a + (ndbl - 1.0) * 3.0;
          } else {
            ndbl++;
          }

          if (ndbl >= 0.0) {
            b_n = (int)ndbl;
          } else {
            b_n = 0;
          }

          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = b_n;
          emxEnsureCapacity_real_T(y, i4);
          if (b_n > 0) {
            y->data[0] = a;
            if (b_n > 1) {
              y->data[b_n - 1] = apnd;
              nm1d2 = (b_n - 1) / 2;
              for (k = 1; k < nm1d2; k++) {
                kd = k * 3U;
                y->data[k] = a + (double)kd;
                y->data[(b_n - k) - 1] = apnd - (double)kd;
              }

              if (nm1d2 << 1 == b_n - 1) {
                y->data[nm1d2] = (a + apnd) / 2.0;
              } else {
                kd = nm1d2 * 3U;
                y->data[nm1d2] = a + (double)kd;
                y->data[nm1d2 + 1] = apnd - (double)kd;
              }
            }
          }
        }

        b_mod(y, n, r2);
        i4 = c_data->size[0] * c_data->size[1];
        c_data->size[0] = r2->size[1];
        c_data->size[1] = 3;
        emxEnsureCapacity_real32_T1(c_data, i4);
        for (i4 = 0; i4 < 3; i4++) {
          nm1d2 = r2->size[1];
          for (k = 0; k < nm1d2; k++) {
            c_data->data[k + c_data->size[0] * i4] = data->data[((int)(r2->
              data[r2->size[0] * k] + 1.0) + data->size[0] * i4) - 1];
          }
        }

        b_x = norm(c_data);
        xp[j] = b_x / (float)sqrt((double)(iv0[j] - iv1[j]) + 1.0);
        a = c_index + (double)iv1[j];
        b = (c_index + (double)iv0[j]) - 1.0;
        if (rtIsNaN(a) || rtIsNaN(b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (b < a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 0;
          emxEnsureCapacity_real_T(y, i4);
        } else if ((rtIsInf(a) || rtIsInf(b)) && (a == b)) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = 1;
          emxEnsureCapacity_real_T(y, i4);
          y->data[0] = rtNaN;
        } else if (floor(a) == a) {
          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = (int)floor((b - a) / 3.0) + 1;
          emxEnsureCapacity_real_T(y, i4);
          nm1d2 = (int)floor((b - a) / 3.0);
          for (i4 = 0; i4 <= nm1d2; i4++) {
            y->data[y->size[0] * i4] = a + 3.0 * (double)i4;
          }
        } else {
          ndbl = floor((b - a) / 3.0 + 0.5);
          apnd = a + ndbl * 3.0;
          cdiff = apnd - b;
          absa = fabs(a);
          absb = fabs(b);
          if ((absa > absb) || rtIsNaN(absb)) {
            absb = absa;
          }

          if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
            ndbl++;
            apnd = b;
          } else if (cdiff > 0.0) {
            apnd = a + (ndbl - 1.0) * 3.0;
          } else {
            ndbl++;
          }

          if (ndbl >= 0.0) {
            b_n = (int)ndbl;
          } else {
            b_n = 0;
          }

          i4 = y->size[0] * y->size[1];
          y->size[0] = 1;
          y->size[1] = b_n;
          emxEnsureCapacity_real_T(y, i4);
          if (b_n > 0) {
            y->data[0] = a;
            if (b_n > 1) {
              y->data[b_n - 1] = apnd;
              nm1d2 = (b_n - 1) / 2;
              for (k = 1; k < nm1d2; k++) {
                kd = k * 3U;
                y->data[k] = a + (double)kd;
                y->data[(b_n - k) - 1] = apnd - (double)kd;
              }

              if (nm1d2 << 1 == b_n - 1) {
                y->data[nm1d2] = (a + apnd) / 2.0;
              } else {
                kd = nm1d2 * 3U;
                y->data[nm1d2] = a + (double)kd;
                y->data[nm1d2 + 1] = apnd - (double)kd;
              }
            }
          }
        }

        b_mod(y, n, r2);
        i4 = c_data->size[0] * c_data->size[1];
        c_data->size[0] = r2->size[1];
        c_data->size[1] = 3;
        emxEnsureCapacity_real32_T1(c_data, i4);
        for (i4 = 0; i4 < 3; i4++) {
          nm1d2 = r2->size[1];
          for (k = 0; k < nm1d2; k++) {
            c_data->data[k + c_data->size[0] * i4] = data->data[((int)(r2->
              data[r2->size[0] * k] + 1.0) + data->size[0] * i4) - 1];
          }
        }

        b_x = norm(c_data);
        xb[j] = b_x / (float)sqrt((double)(iv0[j] - iv1[j]) + 1.0);
      }

      if (fabs(b_index->data[i] - indexTmp) > fastCalNum) {
        indexTmp = b_index->data[i];
        for (j = 0; j < 35; j++) {
          a = c_index - (double)iv0[j + 5];
          b = (c_index - (double)iv1[j + 5]) - 1.0;
          if (rtIsNaN(a) || rtIsNaN(b)) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = 1;
            emxEnsureCapacity_real_T(y, i4);
            y->data[0] = rtNaN;
          } else if (b < a) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = 0;
            emxEnsureCapacity_real_T(y, i4);
          } else if ((rtIsInf(a) || rtIsInf(b)) && (a == b)) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = 1;
            emxEnsureCapacity_real_T(y, i4);
            y->data[0] = rtNaN;
          } else if (floor(a) == a) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = (int)floor((b - a) / 3.0) + 1;
            emxEnsureCapacity_real_T(y, i4);
            nm1d2 = (int)floor((b - a) / 3.0);
            for (i4 = 0; i4 <= nm1d2; i4++) {
              y->data[y->size[0] * i4] = a + 3.0 * (double)i4;
            }
          } else {
            ndbl = floor((b - a) / 3.0 + 0.5);
            apnd = a + ndbl * 3.0;
            cdiff = apnd - b;
            absa = fabs(a);
            absb = fabs(b);
            if ((absa > absb) || rtIsNaN(absb)) {
              absb = absa;
            }

            if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
              ndbl++;
              apnd = b;
            } else if (cdiff > 0.0) {
              apnd = a + (ndbl - 1.0) * 3.0;
            } else {
              ndbl++;
            }

            if (ndbl >= 0.0) {
              b_n = (int)ndbl;
            } else {
              b_n = 0;
            }

            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = b_n;
            emxEnsureCapacity_real_T(y, i4);
            if (b_n > 0) {
              y->data[0] = a;
              if (b_n > 1) {
                y->data[b_n - 1] = apnd;
                nm1d2 = (b_n - 1) / 2;
                for (k = 1; k < nm1d2; k++) {
                  kd = k * 3U;
                  y->data[k] = a + (double)kd;
                  y->data[(b_n - k) - 1] = apnd - (double)kd;
                }

                if (nm1d2 << 1 == b_n - 1) {
                  y->data[nm1d2] = (a + apnd) / 2.0;
                } else {
                  kd = nm1d2 * 3U;
                  y->data[nm1d2] = a + (double)kd;
                  y->data[nm1d2 + 1] = apnd - (double)kd;
                }
              }
            }
          }

          b_mod(y, n, r2);
          i4 = c_data->size[0] * c_data->size[1];
          c_data->size[0] = r2->size[1];
          c_data->size[1] = 3;
          emxEnsureCapacity_real32_T1(c_data, i4);
          for (i4 = 0; i4 < 3; i4++) {
            nm1d2 = r2->size[1];
            for (k = 0; k < nm1d2; k++) {
              c_data->data[k + c_data->size[0] * i4] = data->data[((int)
                (r2->data[r2->size[0] * k] + 1.0) + data->size[0] * i4) - 1];
            }
          }

          b_x = norm(c_data);
          xp[j + 5] = b_x / (float)sqrt((double)(iv0[j + 5] - iv1[j + 5]) + 1.0);
          a = c_index + (double)iv1[j + 5];
          b = (c_index + (double)iv0[j + 5]) - 1.0;
          if (rtIsNaN(a) || rtIsNaN(b)) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = 1;
            emxEnsureCapacity_real_T(y, i4);
            y->data[0] = rtNaN;
          } else if (b < a) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = 0;
            emxEnsureCapacity_real_T(y, i4);
          } else if ((rtIsInf(a) || rtIsInf(b)) && (a == b)) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = 1;
            emxEnsureCapacity_real_T(y, i4);
            y->data[0] = rtNaN;
          } else if (floor(a) == a) {
            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = (int)floor((b - a) / 3.0) + 1;
            emxEnsureCapacity_real_T(y, i4);
            nm1d2 = (int)floor((b - a) / 3.0);
            for (i4 = 0; i4 <= nm1d2; i4++) {
              y->data[y->size[0] * i4] = a + 3.0 * (double)i4;
            }
          } else {
            ndbl = floor((b - a) / 3.0 + 0.5);
            apnd = a + ndbl * 3.0;
            cdiff = apnd - b;
            absa = fabs(a);
            absb = fabs(b);
            if ((absa > absb) || rtIsNaN(absb)) {
              absb = absa;
            }

            if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
              ndbl++;
              apnd = b;
            } else if (cdiff > 0.0) {
              apnd = a + (ndbl - 1.0) * 3.0;
            } else {
              ndbl++;
            }

            if (ndbl >= 0.0) {
              b_n = (int)ndbl;
            } else {
              b_n = 0;
            }

            i4 = y->size[0] * y->size[1];
            y->size[0] = 1;
            y->size[1] = b_n;
            emxEnsureCapacity_real_T(y, i4);
            if (b_n > 0) {
              y->data[0] = a;
              if (b_n > 1) {
                y->data[b_n - 1] = apnd;
                nm1d2 = (b_n - 1) / 2;
                for (k = 1; k < nm1d2; k++) {
                  kd = k * 3U;
                  y->data[k] = a + (double)kd;
                  y->data[(b_n - k) - 1] = apnd - (double)kd;
                }

                if (nm1d2 << 1 == b_n - 1) {
                  y->data[nm1d2] = (a + apnd) / 2.0;
                } else {
                  kd = nm1d2 * 3U;
                  y->data[nm1d2] = a + (double)kd;
                  y->data[nm1d2 + 1] = apnd - (double)kd;
                }
              }
            }
          }

          b_mod(y, n, r2);
          i4 = c_data->size[0] * c_data->size[1];
          c_data->size[0] = r2->size[1];
          c_data->size[1] = 3;
          emxEnsureCapacity_real32_T1(c_data, i4);
          for (i4 = 0; i4 < 3; i4++) {
            nm1d2 = r2->size[1];
            for (k = 0; k < nm1d2; k++) {
              c_data->data[k + c_data->size[0] * i4] = data->data[((int)
                (r2->data[r2->size[0] * k] + 1.0) + data->size[0] * i4) - 1];
            }
          }

          b_x = norm(c_data);
          xb[j + 5] = b_x / (float)sqrt((double)(iv0[j + 5] - iv1[j + 5]) + 1.0);
        }
      }

      if (b_index->data[i] - 75.0 > b_index->data[i] + 75.0) {
        i4 = 0;
        k = 0;
      } else {
        i4 = (int)(b_index->data[i] - 75.0) - 1;
        k = (int)(b_index->data[i] + 75.0);
      }

      nm1d2 = b_data->size[0];
      b_data->size[0] = i1 - i0;
      emxEnsureCapacity_real32_T(b_data, nm1d2);
      nm1d2 = i1 - i0;
      for (i1 = 0; i1 < nm1d2; i1++) {
        b_data->data[i1] = data->data[i0 + i1];
      }

      power(b_data, r0);
      i0 = b_data->size[0];
      b_data->size[0] = i3 - i2;
      emxEnsureCapacity_real32_T(b_data, i0);
      nm1d2 = i3 - i2;
      for (i0 = 0; i0 < nm1d2; i0++) {
        b_data->data[i0] = data->data[(i2 + i0) + data->size[0]];
      }

      power(b_data, r1);
      i0 = b_data->size[0];
      b_data->size[0] = r0->size[0];
      emxEnsureCapacity_real32_T(b_data, i0);
      nm1d2 = r0->size[0];
      for (i0 = 0; i0 < nm1d2; i0++) {
        b_data->data[i0] = r0->data[i0] + r1->data[i0];
      }

      b_power(b_data, r0);
      i0 = r3->size[0];
      r3->size[0] = ((r0->size[0] + k) - i4) + 80;
      emxEnsureCapacity_real_T1(r3, i0);
      nm1d2 = r0->size[0];
      for (i0 = 0; i0 < nm1d2; i0++) {
        r3->data[i0] = r0->data[i0];
      }

      nm1d2 = k - i4;
      for (i0 = 0; i0 < nm1d2; i0++) {
        r3->data[i0 + r0->size[0]] = data->data[(i4 + i0) + (data->size[0] << 1)];
      }

      for (i0 = 0; i0 < 40; i0++) {
        r3->data[((i0 + r0->size[0]) + k) - i4] = xp[i0];
      }

      for (i0 = 0; i0 < 40; i0++) {
        r3->data[(((i0 + r0->size[0]) + k) - i4) + 40] = xb[i0];
      }

      for (i0 = 0; i0 < 382; i0++) {
        x->data[i0 + x->size[0] * i] = r3->data[i0];
      }

      for (k = 0; k < 302; k++) {
        b_y[k] = fabs(x->data[k + x->size[0] * i]);
      }

      c_index = b_norm(b_y);
      for (i0 = 0; i0 < 382; i0++) {
        x->data[i0 + x->size[0] * i] /= c_index;
      }
    }
  }

  emxFree_real_T(&r3);
  emxFree_real32_T(&c_data);
  emxFree_real32_T(&b_data);
  emxFree_real_T(&r2);
  emxFree_real32_T(&r1);
  emxFree_real32_T(&r0);
  emxFree_real_T(&y);
}

/* End of code generation (conXC.c) */
