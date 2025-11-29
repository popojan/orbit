(* Old Code Reference - subnref/sumnref functions *)
(* This file documents the original code and its relationship to Chebyshev polynomials *)

(* ============================================================= *)
(* COEFFICIENT DEFINITIONS *)
(* ============================================================= *)

(* Coefficients for subnref2 (related to U polynomials) *)
a[k_, n_] := -(((-1)^(k + n) 4^(k - 1) (-1 + k + 2 n^2) Pochhammer[n - k + 2, -3 + 2 k])/Gamma[2 k])

(* Coefficients for sumnref2 (related to T polynomials) *)
c[k_, n_] := ((-1)^(k + n) 4^(k - 1) (2 n - 1) Pochhammer[n - k + 1, 2 k - 2])/Gamma[2 k]

(* ============================================================= *)
(* POLYNOMIAL FORMS (trigonometric region |x| <= 1) *)
(* ============================================================= *)

(* subnref2: sin-like function, corresponds to f_{2k}(x) = -(1-x^2) U_{2k-1}(x) *)
subnref2[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}]

(* sumnref2: cos-like function, corresponds to T_{2k+1}(x) *)
sumnref2[x_, k_] := Sum[c[i, k + 1] x^(2 i - 1), {i, 2 k + 1}]

(* Derivative of sumnref2 *)
dsumnref2[x_, k_] := Sum[(2 i - 1) c[i, k + 1] x^(2 i - 2), {i, 2 k + 1}]

(* ============================================================= *)
(* CLOSED FORMS (using radicals) *)
(* ============================================================= *)

(* subnref1: hyperbolic-ready form using sqrt(x^2(x^2-1)) *)
subnref1[x_, k_] :=
  1/(2 x) (-1)^k Sqrt[x^2 (-1 + x^2)] *
  ((1 - 2 x^2 - 2 Sqrt[x^2 (-1 + x^2)])^k -
   (1 - 2 x^2 + 2 Sqrt[x^2 (-1 + x^2)])^k)

(* sumnref1: hyperbolic-ready form *)
sumnref1[x_, n_] :=
  1/(2 x) (-1)^n *
  (Sqrt[x^2 (-1 + x^2)] *
   ((1 - 2 x^2 - 2 Sqrt[x^2 (-1 + x^2)])^n -
    (1 - 2 x^2 + 2 Sqrt[x^2 (-1 + x^2)])^n) +
   x^2 *
   ((1 - 2 x^2 - 2 Sqrt[x^2 (-1 + x^2)])^n +
    (1 - 2 x^2 + 2 Sqrt[x^2 (-1 + x^2)])^n))

(* Derivative of subnref1 *)
dsumnref1[x_, k_] := -1/(2 Sqrt[x^2 (-1 + x^2)]) (1 + 2 k) *
  ((-1 + 2 x^2 - 2 Sqrt[x^2 (-1 + x^2)])^k (x^2 - Sqrt[x^2 (-1 + x^2)]) -
   (x^2 + Sqrt[x^2 (-1 + x^2)]) (-1 + 2 x^2 + 2 Sqrt[x^2 (-1 + x^2)])^k)

(* ============================================================= *)
(* TRIGONOMETRIC FORMS *)
(* ============================================================= *)

(* subnref3: explicit sin form *)
subnref3[x_, n_] := E^(I n Pi) Sqrt[1 - x^2] Sin[2 n ArcSin[x]]

(* sumnref3: explicit cos form *)
sumnref3[x_, k_] := E^(I k Pi) (x Cos[2 k ArcSin[x]] + Sqrt[1 - x^2] Sin[2 k ArcSin[x]])

(* ============================================================= *)
(* ODD-INDEX VERSIONS *)
(* ============================================================= *)

subnref2o[x_, k_] := 1/(2 x) (subnref2[x, (k - 1)/2] + subnref2[x, (k + 1)/2])
sumnref2o[x_, k_] := 1/(2 x) (sumnref2[x, (k - 1)/2] + sumnref2[x, (k + 1)/2])

(* ============================================================= *)
(* POLYGON-RELATED FUNCTIONS *)
(* ============================================================= *)

(* Division function for regular (2k+1)-gon with vertex at {0,1} *)
divnref2[x_, k_] := -(-1)^k subnref2[x, 2 k + 1]/(2 sumnref2[x, k]) // Simplify

(* Numerator functions *)
num[x_, k_] := Evaluate@D[sumnref2[x, k], x]/divnref2[x, k] // FullSimplify

(* Alternative num definition using explicit derivatives *)
num2[k_] := 2 (x^2 - 1) (dsumnref2[x, k] sumnref2[x, k])/subnref2[x, 2 k + 1] // FullSimplify

(* ============================================================= *)
(* TRIGONOMETRIC SHORTCUTS *)
(* ============================================================= *)

(* sink: for odd k *)
sink[k_, x_] := (-1)^((k - 1)/2)/x (sumnref2o[x, k] - subnref2o[x, k])

(* cos2k: for even 2k *)
cos2k[k_, x_] := (-1)^(k/2)/x (sumnref2[x, k/2] - subnref2[x, k/2])

(* ============================================================= *)
(* VERIFIED IDENTITIES *)
(* ============================================================= *)

(*
The following identities have been numerically and algebraically verified:

1. subnref2[x, k] = -(1 - x^2) ChebyshevU[2k - 1, x]
                  = f_{2k}(x) where f_k(x) = T_{k+1}(x) - x T_k(x)

2. sumnref2[x, k] = ChebyshevT[2k + 1, x]

3. For x = cos(theta):
   - subnref2[cos(theta), k] = -sin(theta) sin(2k theta)
   - sumnref2[cos(theta), k] = cos((2k+1) theta)

4. For x = cosh(t) (hyperbolic region):
   - subnref1[cosh(t), k] = -sinh(t) sinh(2k t)
   - sumnref1[cosh(t), k] = cosh((2k+1) t)

5. Key algebraic identity:
   (1 - x^2) U_{n-1}(x) = x T_n(x) - T_{n+1}(x)
*)
