#!/usr/bin/env wolframscript
(* Exploration of circi, circj, circirr functions *)

(* Define the functions *)
circi[k_, Rational[a_, b_]] := (1 + I) ((a + I b)^4)^k (a^2 + b^2)^(-2 k)
circj[k_, Rational[a_, b_]] := (a - I b)^(4 k) (a^2 + b^2)^(-2 k)
circirr[k_, r_] := Exp[Log[1 + I] + k (Log[(1 + I/r)^4] - Log[(1^2 + r^-2)^2])]

Print["=== RADIUS VERIFICATION ===\n"];

(* Test circi radius *)
Print["Testing circi[k, a/b] radius:"];
testRationals = {1/2, 1/3, 2/3, 3/4, 1/1};
Do[
  Do[
    z = circi[k, rat];
    radius = Abs[z];
    Print["  k=", k, ", a/b=", rat, ": |z| = ", N[radius, 6]];
  , {k, 0, 3}];
  Print[""];
, {rat, testRationals[[1;;2]]}];

Print["Testing circj[k, a/b] radius:"];
Do[
  Do[
    z = circj[k, rat];
    radius = Abs[z];
    Print["  k=", k, ", a/b=", rat, ": |z| = ", N[radius, 6]];
  , {k, 0, 3}];
  Print[""];
, {rat, testRationals[[1;;2]]}];

Print["\n=== COMPARING circi vs circj ===\n"];

(* How are they related? *)
rat = 1/2;
Print["For a/b = ", rat, ":\n"];
Do[
  zi = circi[k, rat];
  zj = circj[k, rat];

  Print["k = ", k, ":"];
  Print["  circi = ", zi // N];
  Print["  circj = ", zj // N];
  Print["  circi/circj = ", Simplify[zi/zj] // N];
  Print["  |circi|/|circj| = ", N[Abs[zi]/Abs[zj], 6]];
  Print[""];
, {k, 0, 4}];

Print["=== PERIODS ===\n"];

Print["Testing period for circi[k, 1/2]:"];
rat = 1/2;
z0 = circi[0, rat];
Do[
  zk = circi[k, rat];
  dist = Abs[zk - z0];
  If[dist < 10^-8 && k > 0,
    Print["  k = ", k, ": RETURNS! Distance = ", N[dist, 6]];
    Break[];
  ];
  If[k <= 10,
    Print["  k = ", k, ": distance = ", N[dist, 6]];
  ];
, {k, 1, 30}];

Print["\nTesting period for circj[k, 1/2]:"];
z0 = circj[0, rat];
Do[
  zk = circj[k, rat];
  dist = Abs[zk - z0];
  If[dist < 10^-8 && k > 0,
    Print["  k = ", k, ": RETURNS! Distance = ", N[dist, 6]];
    Break[];
  ];
  If[k <= 10,
    Print["  k = ", k, ": distance = ", N[dist, 6]];
  ];
, {k, 1, 30}];

Print["\n=== EXPLORING circirr ===\n"];

Print["Testing circirr[k, r] for different r:"];
testR = {1, 2, Sqrt[2], 1/2};
Do[
  Print["\nr = ", r, ":"];
  Do[
    z = circirr[k, r];
    Print["  k = ", k, ": z = ", N[z, 5], ", |z| = ", N[Abs[z], 6]];
  , {k, 0, 4}];
, {r, testR}];

Print["\n=== CONNECTION: circirr vs circi ===\n"];

(* Is circirr[k, r] related to circi[k, 1/r]? *)
Print["Testing if circirr[k, r] matches circi[k, 1/r]:"];
Do[
  r = 2;
  zi = circirr[k, r];
  zj = circi[k, 1/r];
  Print["k = ", k, ":"];
  Print["  circirr[k, ", r, "] = ", N[zi, 5]];
  Print["  circi[k, 1/", r, "] = ", N[zj, 5]];
  Print["  Match: ", N[Abs[zi - zj], 6] < 10^-8];
, {k, 0, 4}];

Print["\n=== ANGLE ANALYSIS ===\n"];

Print["Analyzing angle progression for circj (unit circle):"];
rat = 1/2;
Do[
  z = circj[k, rat];
  angle = Arg[z];
  Print["k = ", k, ": angle = ", N[angle, 6], " (", N[angle*180/Pi, 5], "°)"];
, {k, 0, 8}];

Print["\nAnalyzing angle progression for circi (√2 circle):"];
Do[
  z = circi[k, rat];
  angle = Arg[z];
  Print["k = ", k, ": angle = ", N[angle, 6], " (", N[angle*180/Pi, 5], "°)"];
, {k, 0, 8}];

Print["\n=== COMPARISON WITH mul[k, a] ===\n"];

(* My original construction *)
mul[k_, a_] := (I (-I - a)^k - (I - a)^k - I (-I + a)^k + (I + a)^k)/
               ((-I - a)^k - I (I - a)^k + (-I + a)^k - I (I + a)^k);

(* Compare tangent from circj vs mul *)
Print["Comparing tangent extraction:"];
rat = 1/2;
Do[
  (* From circj *)
  z = circj[k, rat];
  tanFromCircj = Im[z]/Re[z];

  (* From mul *)
  a = N[rat];
  tanFromMul = mul[k, a];

  Print["k = ", k, ":"];
  Print["  tan from circj: ", N[tanFromCircj, 6]];
  Print["  tan from mul:   ", N[tanFromMul, 6]];
  Print["  Match: ", N[Abs[tanFromCircj - tanFromMul], 8] < 10^-6];
, {k, 0, 5}];
