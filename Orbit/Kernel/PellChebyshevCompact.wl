(* ::Package:: *)

(* Chebyshev Compact Pell Encoding                                         *)
(* Encodes Pell regulator as (n, s, z², nm, C) — O(log n) bits total.     *)
(* Key idea: target an early convergent (k~2) via Chebyshev evaluation     *)
(* instead of the full Pell solution. R = C · δ(target).                   *)
(* See: docs/sessions/2026-03-26-pell-floor-solver/CHEBYSHEV-COMPACT.md    *)

BeginPackage["Orbit`"];

PellChebyshevEncode::usage =
"PellChebyshevEncode[n] encodes the Pell regulator for non-square n as a \
compact tuple. Returns \
<|\"s\" -> base, \"z2\" -> z², \"nm\" -> norm, \"C\" -> multiplier, \
\"R\" -> regulator, \"Target\" -> convergent, \"Digits\" -> total encoding digits|>. \
The regulator satisfies R = C * (2 Log[p + q Sqrt[n]] - Log|nm|) where \
p/q = PellChebyshevTarget[n, s, z2].

The encoding is O(Log[n]) bits regardless of how large the Pell solution is.

Example:
  PellChebyshevEncode[421]
    (* Pell solution is 33 digits, but encoding is 5 digits *)";

PellChebyshevDecode::usage =
"PellChebyshevDecode[n, s, z2, nm, c] recovers the Pell regulator from a \
compact encoding. Returns the symbolic expression for R.

Steps:
  1. target = PellChebyshevTarget[n, s, z2]
  2. {p, q} = NumeratorDenominator[target]
  3. R = c * (2 Log[p + q Sqrt[n]] - Log|nm|)

Example:
  PellChebyshevDecode[421, 22, -5, -3, 3]";

PellChebyshevTarget::usage =
"PellChebyshevTarget[n, s, z2] recovers the target convergent from (s, z²). \
Returns the rational p/q such that sqrttrf(n, s, 1) = p/q with evaluation \
point z = Sqrt[z2].

Formula: target = (s² + n)/(2s) + (s² - n)/(2s) · 1/(4z² - 1)";

Begin["`Private`"];

(* ================================================================== *)
(* Norm in Z[sqrt(n)]                                                  *)
(* ================================================================== *)

iChebNorm[x_, n_] := With[{pq = NumeratorDenominator[x]},
  pq[[1]]^2 - n pq[[2]]^2]

(* ================================================================== *)
(* Chebyshev target recovery                                           *)
(* ================================================================== *)

PellChebyshevTarget[n_Integer, s_, z2_] :=
  (s^2 + n)/(2 s) + (s^2 - n)/(2 s) * 1/(4 z2 - 1)

(* ================================================================== *)
(* z² from target and base point                                       *)
(* ================================================================== *)

iZ2FromTarget[n_, target_, s_] := Module[{R},
  R = (2 s target - s^2 - n)/(s^2 - n);
  If[R == 0, $Failed, (1 + R)/(4 R)]]

(* ================================================================== *)
(* Complexity: total digits of a rational                              *)
(* ================================================================== *)

iComplexity[x_Integer] := IntegerLength[Abs[x]]
iComplexity[x_Rational] := IntegerLength[Abs[Numerator[x]]] +
  IntegerLength[Abs[Denominator[x]]]

(* ================================================================== *)
(* Determine C from orbit structure                                    *)
(* ================================================================== *)

(* Compute C = R / delta(target) by finding R from the Pell solution.
   Uses the CF to find the fundamental solution, then C = R/delta. *)
iComputeChebC[target_, n_] := Module[
  {cf, pellXY, R, p, q, nmVal, delta, cRaw},

  cf = ContinuedFraction[Sqrt[n], 200];
  (* Find Pell solution: first convergent with |nm| = 1 *)
  pellXY = Catch[Do[
    Module[{conv = FromContinuedFraction[Take[cf, k]]},
      If[Abs[Numerator[conv]^2 - n Denominator[conv]^2] == 1,
        Throw[conv]]],
  {k, 2, Length[cf]}]; $Failed];
  If[pellXY === $Failed, Return[1]];

  R = Log[Numerator[pellXY] + Denominator[pellXY] Sqrt[n]];
  {p, q} = NumeratorDenominator[target];
  nmVal = p^2 - n q^2;
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nmVal]];

  (* C = R/delta — rationalize *)
  cRaw = Simplify[R/delta];
  If[FreeQ[cRaw, Log],
    cRaw,
    Rationalize[N[cRaw, 30], 1/10000]]]

(* ================================================================== *)
(* Find best encoding: scan convergents × shifts                       *)
(* ================================================================== *)

iFindBestEncoding[n_] := Module[
  {s0 = Floor[Sqrt[n]], cf, pellXY, R, convs,
   best = None, bestTotal = Infinity},

  cf = ContinuedFraction[Sqrt[n], 200];

  (* Find Pell solution for R *)
  pellXY = Catch[Do[
    Module[{conv = FromContinuedFraction[Take[cf, k]]},
      If[Abs[Numerator[conv]^2 - n Denominator[conv]^2] == 1,
        Throw[conv]]],
  {k, 2, Length[cf]}]; $Failed];
  If[pellXY === $Failed, Return[None]];
  R = Log[Numerator[pellXY] + Denominator[pellXY] Sqrt[n]];

  convs = Table[
    Module[{conv = FromContinuedFraction[Take[cf, k]]},
      {conv, iChebNorm[conv, n], k - 1}],
  {k, 2, Min[30, Length[cf]]}];

  (* For each convergent, check C is a simple rational, then try shifts *)
  Do[
    Module[{target = c[[1]], tgtNm = c[[2]], cfIdx = c[[3]],
            p, q, delta, cVal},
      {p, q} = NumeratorDenominator[target];
      delta = 2 Log[p + q Sqrt[n]] - Log[Abs[tgtNm]];
      cVal = TimeConstrained[FullSimplify[R/delta], 5, $Failed];
      If[cVal === $Failed, Continue[]];

      (* C must be exact (no residual Log) and a simple rational *)
      If[!FreeQ[cVal, Log], Continue[]];
      If[!(IntegerQ[cVal] || (Head[cVal] === Rational &&
           Denominator[cVal] <= 4)), Continue[]];

      (* Now find best shift *)
      Do[
        If[s^2 == n || s === target, Continue[]];
        Module[{z2, totalC},
          z2 = iZ2FromTarget[n, target, s];
          If[z2 === $Failed, Continue[]];
          z2 = FullSimplify[z2];
          totalC = iComplexity[z2] + iComplexity[s];
          If[totalC < bestTotal,
            bestTotal = totalC;
            best = <|"s" -> s, "z2" -> z2, "nm" -> tgtNm,
                     "C" -> cVal, "Target" -> target,
                     "cfIndex" -> cfIdx,
                     "totalDigits" -> totalC|>]],
      {s, Join[
        Range[Max[1, s0 - 3], s0 + 3],
        {(2 s0 + 1)/2, (2 s0 - 1)/2}]}]],
  {c, convs}];

  best]

(* ================================================================== *)
(* Public API                                                          *)
(* ================================================================== *)

PellChebyshevEncode[n_Integer /; n > 1 && !IntegerQ[Sqrt[n]]] := Module[
  {enc, target, p, q, nmVal, cVal, delta, R},

  enc = iFindBestEncoding[n];
  If[enc === None, Return[$Failed]];

  target = enc["Target"];
  {p, q} = NumeratorDenominator[target];
  nmVal = enc["nm"];
  cVal = enc["C"];
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nmVal]];
  R = cVal * delta;

  <|"s" -> enc["s"],
    "z2" -> enc["z2"],
    "nm" -> nmVal,
    "C" -> cVal,
    "R" -> R,
    "Target" -> target,
    "Digits" -> enc["totalDigits"]|>]

PellChebyshevDecode[n_Integer, s_, z2_, nm_Integer, c_] := Module[
  {target, p, q},
  target = PellChebyshevTarget[n, s, z2];
  {p, q} = NumeratorDenominator[target];
  c * (2 Log[p + q Sqrt[n]] - Log[Abs[nm]])]

End[];
EndPackage[];
