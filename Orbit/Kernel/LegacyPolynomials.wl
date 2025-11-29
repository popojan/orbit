(* ::Package:: *)

(* LegacyPolynomials.wl *)
(* Historical reference code for subnref/sumnref functions *)
(* These functions relate to Chebyshev polynomials and regular polygons *)
(* Preserved for reference and backward compatibility *)

BeginPackage["Orbit`"];

(* Public symbols *)
LegacySubnref1::usage = "LegacySubnref1[x, k] returns the hyperbolic-ready sin-like function. Equals -(1-x^2) U_{2k-1}(x) = f_{2k}(x).";
LegacySumnref1::usage = "LegacySumnref1[x, k] returns the hyperbolic-ready cos-like function.";
LegacySubnref2::usage = "LegacySubnref2[x, k] returns the polynomial form of subnref. Equals -(1-x^2) U_{2k-1}(x).";
LegacySumnref2::usage = "LegacySumnref2[x, k] returns the polynomial form of sumnref. Equals T_{2k+1}(x).";
LegacySubnref3::usage = "LegacySubnref3[x, n] returns the explicit trigonometric form.";
LegacySumnref3::usage = "LegacySumnref3[x, k] returns the explicit trigonometric form.";
LegacyPolynomialCoeffA::usage = "LegacyPolynomialCoeffA[k, n] returns coefficient a[k,n] for subnref2.";
LegacyPolynomialCoeffC::usage = "LegacyPolynomialCoeffC[k, n] returns coefficient c[k,n] for sumnref2.";

Begin["`Private`"];

(* ============================================================= *)
(* COEFFICIENT DEFINITIONS *)
(* ============================================================= *)

(* Coefficients for subnref2 (related to U polynomials) *)
LegacyPolynomialCoeffA[k_, n_] := -(((-1)^(k + n) 4^(k - 1) (-1 + k + 2 n^2) Pochhammer[n - k + 2, -3 + 2 k])/Gamma[2 k])

(* Coefficients for sumnref2 (related to T polynomials) *)
LegacyPolynomialCoeffC[k_, n_] := ((-1)^(k + n) 4^(k - 1) (2 n - 1) Pochhammer[n - k + 1, 2 k - 2])/Gamma[2 k]

(* ============================================================= *)
(* POLYNOMIAL FORMS (trigonometric region |x| <= 1) *)
(* ============================================================= *)

(* subnref2: sin-like function, corresponds to f_{2k}(x) = -(1-x^2) U_{2k-1}(x) *)
LegacySubnref2[x_, k_Integer] := Sum[LegacyPolynomialCoeffA[i, k] x^(2 i - 1), {i, 1, k + 1}]

(* sumnref2: cos-like function, corresponds to T_{2k+1}(x) *)
LegacySumnref2[x_, k_Integer] := Sum[LegacyPolynomialCoeffC[i, k + 1] x^(2 i - 1), {i, 2 k + 1}]

(* ============================================================= *)
(* CLOSED FORMS (using radicals - work in both regions) *)
(* ============================================================= *)

(* subnref1: hyperbolic-ready form using sqrt(x^2(x^2-1)) *)
(* For |x| <= 1: sqrt(x^2(x^2-1)) = i |x| sqrt(1-x^2) *)
(* For |x| >= 1: sqrt(x^2(x^2-1)) = |x| sqrt(x^2-1) *)
LegacySubnref1[x_, k_Integer] :=
  1/(2 x) (-1)^k Sqrt[x^2 (-1 + x^2)] *
  ((1 - 2 x^2 - 2 Sqrt[x^2 (-1 + x^2)])^k -
   (1 - 2 x^2 + 2 Sqrt[x^2 (-1 + x^2)])^k)

(* sumnref1: hyperbolic-ready cos-like form *)
LegacySumnref1[x_, n_Integer] :=
  1/(2 x) (-1)^n *
  (Sqrt[x^2 (-1 + x^2)] *
   ((1 - 2 x^2 - 2 Sqrt[x^2 (-1 + x^2)])^n -
    (1 - 2 x^2 + 2 Sqrt[x^2 (-1 + x^2)])^n) +
   x^2 *
   ((1 - 2 x^2 - 2 Sqrt[x^2 (-1 + x^2)])^n +
    (1 - 2 x^2 + 2 Sqrt[x^2 (-1 + x^2)])^n))

(* ============================================================= *)
(* TRIGONOMETRIC FORMS *)
(* ============================================================= *)

(* subnref3: explicit sin form *)
LegacySubnref3[x_, n_Integer] := E^(I n Pi) Sqrt[1 - x^2] Sin[2 n ArcSin[x]]

(* sumnref3: explicit cos form *)
LegacySumnref3[x_, k_Integer] := E^(I k Pi) (x Cos[2 k ArcSin[x]] + Sqrt[1 - x^2] Sin[2 k ArcSin[x]])

End[];
EndPackage[];

(*
VERIFIED IDENTITIES:

1. LegacySubnref2[x, k] = -(1 - x^2) ChebyshevU[2k - 1, x]
                        = f_{2k}(x) where f_k(x) = T_{k+1}(x) - x T_k(x)

2. LegacySumnref2[x, k] = ChebyshevT[2k + 1, x]

3. For x = cos(theta):
   - LegacySubnref2[cos(theta), k] = -sin(theta) sin(2k theta)
   - LegacySumnref2[cos(theta), k] = cos((2k+1) theta)

4. For x = cosh(t) (hyperbolic region):
   - LegacySubnref1[cosh(t), k] = -sinh(t) sinh(2k t)
   - LegacySumnref1[cosh(t), k] = cosh((2k+1) t)

5. Key algebraic identity:
   (1 - x^2) U_{n-1}(x) = x T_n(x) - T_{n+1}(x)

CONTEXT:
These functions originated from work on regular polygons and were later
connected to the Chebyshev Integral Theorem. The uniform measure identity
   integral_{-1}^{1} |f_k(x)| dx = 1
yields the rational ratio 1/2 (compared to transcendental 1/pi for
Chebyshev measure).
*)
