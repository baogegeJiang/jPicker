/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * svd.c
 *
 * Code generation for function 'svd'
 *
 */

/* Include files */
#include <math.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "conXC.h"
#include "svd.h"
#include "xaxpy.h"
#include "xdotc.h"
#include "xnrm2.h"
#include "conXC_emxutil.h"
#include "xrotg.h"
#include "sqrt.h"

/* Function Definitions */
void svd(const emxArray_real32_T *A, float U_data[], int U_size[1])
{
  emxArray_real32_T *b_A;
  int m;
  int ns;
  int n;
  int minnp;
  float s_data[3];
  emxArray_real32_T *work;
  float e[3];
  int nct;
  int qs;
  int q;
  int iter;
  int mm;
  boolean_T apply_transform;
  float ztest0;
  float ztest;
  float snorm;
  boolean_T exitg1;
  float f;
  float scale;
  float sqds;
  float b;
  emxInit_real32_T1(&b_A, 2);
  m = b_A->size[0] * b_A->size[1];
  b_A->size[0] = A->size[0];
  b_A->size[1] = 3;
  emxEnsureCapacity_real32_T1(b_A, m);
  ns = A->size[0] * A->size[1];
  for (m = 0; m < ns; m++) {
    b_A->data[m] = A->data[m];
  }

  n = A->size[0];
  ns = A->size[0] + 1;
  if (!(ns < 3)) {
    ns = 3;
  }

  minnp = A->size[0];
  if (!(minnp < 3)) {
    minnp = 3;
  }

  if (0 <= ns - 1) {
    memset(&s_data[0], 0, (unsigned int)(ns * (int)sizeof(float)));
  }

  for (ns = 0; ns < 3; ns++) {
    e[ns] = 0.0F;
  }

  emxInit_real32_T(&work, 1);
  ns = A->size[0];
  m = work->size[0];
  work->size[0] = ns;
  emxEnsureCapacity_real32_T(work, m);
  for (m = 0; m < ns; m++) {
    work->data[m] = 0.0F;
  }

  if (A->size[0] != 0) {
    if (A->size[0] > 1) {
      nct = A->size[0] - 1;
    } else {
      nct = 0;
    }

    if (!(nct < 3)) {
      nct = 3;
    }

    if (nct > 1) {
      m = nct;
    } else {
      m = 1;
    }

    for (q = 0; q < m; q++) {
      iter = q + n * q;
      mm = n - q;
      apply_transform = false;
      if (q + 1 <= nct) {
        ztest0 = xnrm2(mm, b_A, iter + 1);
        if (ztest0 > 0.0F) {
          apply_transform = true;
          if (b_A->data[iter] < 0.0F) {
            ztest0 = -ztest0;
          }

          s_data[q] = ztest0;
          if ((float)fabs(s_data[q]) >= 9.86076132E-32F) {
            ztest0 = 1.0F / s_data[q];
            ns = iter + mm;
            for (qs = iter; qs < ns; qs++) {
              b_A->data[qs] *= ztest0;
            }
          } else {
            ns = iter + mm;
            for (qs = iter; qs < ns; qs++) {
              b_A->data[qs] /= s_data[q];
            }
          }

          b_A->data[iter]++;
          s_data[q] = -s_data[q];
        } else {
          s_data[q] = 0.0F;
        }
      }

      for (ns = q + 1; ns + 1 < 4; ns++) {
        qs = q + n * ns;
        if (apply_transform) {
          ztest0 = -(xdotc(mm, b_A, iter + 1, b_A, qs + 1) / b_A->data[q +
                     b_A->size[0] * q]);
          xaxpy(mm, ztest0, iter + 1, b_A, qs + 1);
        }

        e[ns] = b_A->data[qs];
      }

      if (q + 1 <= 1) {
        ztest0 = b_xnrm2(e, 2);
        if (ztest0 == 0.0F) {
          e[0] = 0.0F;
        } else {
          if (e[1] < 0.0F) {
            ztest0 = -ztest0;
          }

          e[0] = ztest0;
          if ((float)fabs(ztest0) >= 9.86076132E-32F) {
            ztest0 = 1.0F / ztest0;
            for (qs = 1; qs < 3; qs++) {
              e[qs] *= ztest0;
            }
          } else {
            for (qs = 1; qs < 3; qs++) {
              e[qs] /= ztest0;
            }
          }

          e[1]++;
          e[0] = -e[0];
          if (2 <= n) {
            for (ns = 2; ns <= n; ns++) {
              work->data[ns - 1] = 0.0F;
            }

            for (ns = 1; ns + 1 < 4; ns++) {
              b_xaxpy(mm - 1, e[ns], b_A, n * ns + 2, work, 2);
            }

            for (ns = 1; ns + 1 < 4; ns++) {
              c_xaxpy(mm - 1, -e[ns] / e[1], work, 2, b_A, n * ns + 2);
            }
          }
        }
      }
    }

    m = A->size[0] + 1;
    if (3 < m) {
      m = 3;
    }

    if (nct < 3) {
      s_data[nct] = b_A->data[nct + b_A->size[0] * nct];
    }

    if (A->size[0] < m) {
      s_data[m - 1] = 0.0F;
    }

    if (2 < m) {
      e[1] = b_A->data[1 + b_A->size[0] * 2];
    }

    e[m - 1] = 0.0F;
    for (q = 0; q < m; q++) {
      if (s_data[q] != 0.0F) {
        ztest = (float)fabs(s_data[q]);
        ztest0 = s_data[q] / ztest;
        s_data[q] = ztest;
        if (q + 1 < m) {
          e[q] /= ztest0;
        }
      }

      if ((q + 1 < m) && (e[q] != 0.0F)) {
        ztest = (float)fabs(e[q]);
        ztest0 = e[q];
        e[q] = ztest;
        s_data[q + 1] *= ztest / ztest0;
      }
    }

    mm = m;
    iter = 0;
    snorm = 0.0F;
    for (ns = 0; ns < m; ns++) {
      ztest0 = (float)fabs(s_data[ns]);
      ztest = (float)fabs(e[ns]);
      if ((ztest0 > ztest) || rtIsNaNF(ztest)) {
      } else {
        ztest0 = ztest;
      }

      if (!((snorm > ztest0) || rtIsNaNF(ztest0))) {
        snorm = ztest0;
      }
    }

    while ((m > 0) && (!(iter >= 75))) {
      q = m - 1;
      exitg1 = false;
      while (!(exitg1 || (q == 0))) {
        ztest0 = (float)fabs(e[q - 1]);
        if ((ztest0 <= 1.1920929E-7F * ((float)fabs(s_data[q - 1]) + (float)fabs
              (s_data[q]))) || (ztest0 <= 9.86076132E-32F) || ((iter > 20) &&
             (ztest0 <= 1.1920929E-7F * snorm))) {
          e[q - 1] = 0.0F;
          exitg1 = true;
        } else {
          q--;
        }
      }

      if (q == m - 1) {
        ns = 4;
      } else {
        qs = m;
        ns = m;
        exitg1 = false;
        while ((!exitg1) && (ns >= q)) {
          qs = ns;
          if (ns == q) {
            exitg1 = true;
          } else {
            ztest0 = 0.0F;
            if (ns < m) {
              ztest0 = (float)fabs(e[ns - 1]);
            }

            if (ns > q + 1) {
              ztest0 += (float)fabs(e[ns - 2]);
            }

            ztest = (float)fabs(s_data[ns - 1]);
            if ((ztest <= 1.1920929E-7F * ztest0) || (ztest <= 9.86076132E-32F))
            {
              s_data[ns - 1] = 0.0F;
              exitg1 = true;
            } else {
              ns--;
            }
          }
        }

        if (qs == q) {
          ns = 3;
        } else if (qs == m) {
          ns = 1;
        } else {
          ns = 2;
          q = qs;
        }
      }

      switch (ns) {
       case 1:
        f = e[m - 2];
        e[m - 2] = 0.0F;
        for (qs = m - 1; qs >= q + 1; qs--) {
          xrotg(&s_data[qs - 1], &f, &ztest0, &ztest);
          if (qs > q + 1) {
            f = -ztest * e[0];
            e[0] *= ztest0;
          }
        }
        break;

       case 2:
        f = e[q - 1];
        e[q - 1] = 0.0F;
        while (q + 1 <= m) {
          xrotg(&s_data[q], &f, &ztest0, &ztest);
          f = -ztest * e[q];
          e[q] *= ztest0;
          q++;
        }
        break;

       case 3:
        scale = (float)fabs(s_data[m - 1]);
        ztest = (float)fabs(s_data[m - 2]);
        if (!((scale > ztest) || rtIsNaNF(ztest))) {
          scale = ztest;
        }

        ztest = (float)fabs(e[m - 2]);
        if (!((scale > ztest) || rtIsNaNF(ztest))) {
          scale = ztest;
        }

        ztest = (float)fabs(s_data[q]);
        if (!((scale > ztest) || rtIsNaNF(ztest))) {
          scale = ztest;
        }

        ztest = (float)fabs(e[q]);
        if (!((scale > ztest) || rtIsNaNF(ztest))) {
          scale = ztest;
        }

        f = s_data[m - 1] / scale;
        ztest0 = s_data[m - 2] / scale;
        ztest = e[m - 2] / scale;
        sqds = s_data[q] / scale;
        b = ((ztest0 + f) * (ztest0 - f) + ztest * ztest) / 2.0F;
        ztest0 = f * ztest;
        ztest0 *= ztest0;
        if ((b != 0.0F) || (ztest0 != 0.0F)) {
          ztest = b * b + ztest0;
          b_sqrt(&ztest);
          if (b < 0.0F) {
            ztest = -ztest;
          }

          ztest = ztest0 / (b + ztest);
        } else {
          ztest = 0.0F;
        }

        f = (sqds + f) * (sqds - f) + ztest;
        b = sqds * (e[q] / scale);
        for (qs = q + 1; qs < m; qs++) {
          xrotg(&f, &b, &ztest0, &ztest);
          if (qs > q + 1) {
            e[0] = f;
          }

          f = ztest0 * s_data[qs - 1] + ztest * e[qs - 1];
          e[qs - 1] = ztest0 * e[qs - 1] - ztest * s_data[qs - 1];
          b = ztest * s_data[qs];
          s_data[qs] *= ztest0;
          s_data[qs - 1] = f;
          xrotg(&s_data[qs - 1], &b, &ztest0, &ztest);
          f = ztest0 * e[qs - 1] + ztest * s_data[qs];
          s_data[qs] = -ztest * e[qs - 1] + ztest0 * s_data[qs];
          b = ztest * e[qs];
          e[qs] *= ztest0;
        }

        e[m - 2] = f;
        iter++;
        break;

       default:
        if (s_data[q] < 0.0F) {
          s_data[q] = -s_data[q];
        }

        ns = q + 1;
        while ((q + 1 < mm) && (s_data[q] < s_data[ns])) {
          ztest = s_data[q];
          s_data[q] = s_data[ns];
          s_data[ns] = ztest;
          q = ns;
          ns++;
        }

        iter = 0;
        m--;
        break;
      }
    }
  }

  emxFree_real32_T(&work);
  emxFree_real32_T(&b_A);
  U_size[0] = minnp;
  for (qs = 0; qs < minnp; qs++) {
    U_data[qs] = s_data[qs];
  }
}

/* End of code generation (svd.c) */
