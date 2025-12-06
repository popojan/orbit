(* ::Package:: *)

(* CunninghamRepresentation: Oscar Cunningham's f(x) = x/(1-x) representation for real numbers *)
(* Reference: https://oscarcunningham.com/494/a-better-representation-for-real-numbers/ *)

BeginPackage["Orbit`"];

(* Public symbols *)
CunninghamSequence::usage = "CunninghamSequence[x, n] generates n terms of the Cunningham representation for x \[Element] [0,1). Uses f(t) = t/(1-t), extracting Floor[f(x)] at each step.";

CunninghamRepresentation::usage = "CunninghamRepresentation[r, n] returns {z, seq} where z = Floor[r] and seq is the Cunningham sequence for the fractional part.";

CunninghamConvergents::usage = "CunninghamConvergents[seq] computes the convergents p/q from a Cunningham sequence using the recurrence p' = p + a*q, q' = p + (a+1)*q.";

CunninghamFromSequence::usage = "CunninghamFromSequence[z, seq] reconstructs a real number from its Cunningham representation.";

CunninghamPeriod::usage = "CunninghamPeriod[Sqrt[d], maxTerms] detects the period of the Cunningham representation for Sqrt[d]. Returns {period, pattern} or $Failed if no period found.";

CunninghamPellRatio::usage = "CunninghamPellRatio[d, maxTerms] finds the quasi-solution ratio a/b where a^2 - d*b^2 = -1 from Cunningham convergents of Sqrt[d]. Returns {a, b} or $Failed.";

Begin["`Private`"];

(* Exact integer arithmetic for rationals a/b where 0 <= a < b *)
CunninghamSequence[Rational[a0_, b0_], n_Integer] /; 0 <= a0 < b0 := Module[
  {a = a0, b = b0, seq = {}, digit, newA},
  Do[
    If[a == 0, Break[]];
    (* x/(1-x) = a/(b-a), digit = Floor[a/(b-a)] *)
    digit = Quotient[a, b - a];
    AppendTo[seq, digit];
    (* New fraction: (a - digit*(b-a)) / (b-a) *)
    newA = a - digit*(b - a);
    {a, b} = {newA, b - a};
  , {n}];
  seq
]

(* Handle integer 0 *)
CunninghamSequence[0, n_Integer] := {}
CunninghamSequence[0, UpTo[n_Integer]] := {}

(* Numeric fallback for general NumericQ (floats, symbolic like Pi, etc.) *)
CunninghamSequence[x0_?NumericQ, n_Integer] /; 0 < x0 < 1 && Head[x0] =!= Rational := Module[
  {x = N[x0, Max[50, 3*n]], seq = {}, digit, prec},
  prec = Precision[x];
  Do[
    If[x == 0 || x < 10^(-prec + 10), Break[]];
    digit = Floor[x/(1 - x)];
    AppendTo[seq, digit];
    x = x/(1 - x) - digit;
    If[x >= 1, Break[]];
  , {n}];
  seq
]

(* Support UpTo for convenience *)
CunninghamSequence[x0_, UpTo[n_Integer]] := CunninghamSequence[x0, n]

(* Full representation for any positive real *)
CunninghamRepresentation[r_?NumericQ, n_Integer] /; r >= 0 := Module[
  {z = Floor[r], frac},
  frac = r - z;
  {z, CunninghamSequence[frac, n]}
]

(* Low-level: convergents from raw sequence (fractional part only) *)
cunninghamConvergentsFromSeq[seq_List] := Module[
  {p = 0, q = 1, result = {}},
  Do[
    {p, q} = {p + a*q, p + (a + 1)*q};
    AppendTo[result, p/q];
  , {a, seq}];
  result
]

(* High-level API: CunninghamConvergents[x, n] like Convergents[x, n] *)
CunninghamConvergents[x_?NumericQ, n_Integer] := Module[
  {z = Floor[x], frac, seq, fracConvs},
  frac = x - z;
  seq = CunninghamSequence[frac, n];
  fracConvs = cunninghamConvergentsFromSeq[seq];
  z + # & /@ fracConvs
]

(* Also accept UpTo *)
CunninghamConvergents[x_?NumericQ, UpTo[n_Integer]] := CunninghamConvergents[x, n]

(* Keep backward compatibility: raw sequence input *)
CunninghamConvergents[seq_List] := cunninghamConvergentsFromSeq[seq]

(* Convergents as {p, q} pairs *)
CunninghamConvergentPairs[seq_List] := Module[
  {p = 0, q = 1, result = {}},
  Do[
    {p, q} = {p + a*q, p + (a + 1)*q};
    AppendTo[result, {p, q}];
  , {a, seq}];
  result
]

(* Reconstruct from representation *)
CunninghamFromSequence[z_Integer, seq_List] := Module[
  {convs},
  If[seq === {}, Return[z]];
  convs = CunninghamConvergents[seq];
  z + Last[convs]
]

(* Period detection for quadratic irrationals *)
CunninghamPeriod[Sqrt[d_Integer], maxTerms_Integer: 200] /; d > 0 && !IntegerQ[Sqrt[d]] := Module[
  {frac, seq, period},
  frac = N[Sqrt[d] - Floor[Sqrt[d]], Max[100, 2*maxTerms]];
  seq = CunninghamSequence[frac, maxTerms];

  (* Find smallest period *)
  Do[
    If[Length[seq] >= 2*per &&
       seq[[1 ;; per]] === seq[[per + 1 ;; 2*per]],
      Return[{per, seq[[1 ;; per]]}]
    ];
  , {per, 1, Floor[maxTerms/2]}];

  $Failed
]

(* Find Pell quasi-solution from Cunningham convergents *)
CunninghamPellRatio[d_Integer, maxTerms_Integer: 200] /; d > 0 && !IntegerQ[Sqrt[d]] := Module[
  {frac, seq, pairs, p, q, pellVal},
  frac = N[Sqrt[d] - Floor[Sqrt[d]], Max[100, 2*maxTerms]];
  seq = CunninghamSequence[frac, maxTerms];
  pairs = CunninghamConvergentPairs[seq];

  (* Find first convergent giving Pell quasi-solution *)
  Do[
    {p, q} = pairs[[k]];
    pellVal = p^2 - d*q^2;
    If[pellVal == -1, Return[{p, q}]];
  , {k, Length[pairs]}];

  $Failed
]

(* Connection to Egyptian fractions: given a/b with a^2 - D*b^2 = -1,
   compute Egypt parameters *)
CunninghamToEgypt[a_Integer, b_Integer, d_Integer] /; a^2 - d*b^2 == -1 := Module[
  {x, y},
  x = a^2 + d*b^2;  (* Pell fundamental x *)
  y = 2*a*b;        (* Pell fundamental y *)
  <|
    "a" -> a,
    "b" -> b,
    "D" -> d,
    "x" -> x,
    "y" -> y,
    "ratio" -> a/b,  (* = (x-1)/y *)
    "firstDenominator" -> 8*a^2  (* d_1 = 8a^2 *)
  |>
]

End[];

EndPackage[];
