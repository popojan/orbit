#!/usr/bin/env wolframscript
(* Clean exploration: mapping lines to unit circle *)

Print["=== MAPPING LINES TO UNIT CIRCLE VIA MOBIUS ===\n"];

(* ================================================================
   VERTICAL LINE Re(z) = c
   ================================================================ *)

Print["CASE 1: VERTICAL LINE Re(z) = c\n"];
Print["Parametrization: z = c + i*t, t in R"];
Print[];

Print["Formula: w = (z - (c-r))/(z - (c+r))"];
Print["where r > 0 is free parameter"];
Print[];

c = 1/2;
r = 1/2;

Print["Example: c = 1/2, r = 1/2"];
Print["  w = z/(z - 1)"];
Print[];

w1[z_] := z/(z - 1);

testT = {-5, -2, -1, 0, 1, 2, 5};
Print["Testing z = 1/2 + i*t:"];
Print["t\t|w|\tVerified"];
Print[StringRepeat["-", 40]];

Do[
  z = c + I*testT[[i]];
  absW = Abs[w1[z]] // N;
  ok = If[Abs[absW - 1] < 10^-10, "YES", "NO"];
  Print[testT[[i]], "\t", absW, "\t", ok];
, {i, Length[testT]}];

Print[];
Print["Result: ALL points map to |w| = 1"];
Print[];

(* Algebraic proof *)
Print["ALGEBRAIC PROOF for Re(z) = c:"];
Print[];

z = c + I*t;
num = z;
den = z - 2*c;

Print["z = c + i*t"];
Print["w = z/(z - 2c) = (c + i*t)/(c + i*t - 2c) = (c + i*t)/(-c + i*t)"];
Print[];

numAbs2 = Simplify[Abs[num]^2, Assumptions -> Element[{c, t}, Reals]];
denAbs2 = Simplify[Abs[den]^2, Assumptions -> Element[{c, t}, Reals]];

Print["|num|^2 = |c + i*t|^2 = ", numAbs2];
Print["|den|^2 = |-c + i*t|^2 = ", denAbs2];
Print["|w|^2 = ", Simplify[numAbs2/denAbs2]];
Print[];
Print["Therefore |w| = 1 for all t in R"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   GENERAL LINE
   ================================================================ *)

Print["CASE 2: GENERAL LINE z = z0 + v*t\n"];
Print["where z0 = point on line, v = direction vector"];
Print[];

Print["Construction:"];
Print["1. Perpendicular direction: v_perp = i*v"];
Print["2. Symmetric points: a = z0 + r*v_perp, b = z0 - r*v_perp"];
Print["3. Transformation: w = (z - a)/(z - b)"];
Print[];

(* Example: line through 1+i with direction 1+2i *)
z0 = 1 + I;
v = 1 + 2*I;
vPerp = I*v;
r = 1;

a = z0 + r*vPerp;
b = z0 - r*vPerp;

Print["Example: z = (1+i) + (1+2i)*t"];
Print["  z0 = ", z0];
Print["  v = ", v];
Print["  v_perp = i*v = ", vPerp // Simplify];
Print["  a = ", a // Simplify];
Print["  b = ", b // Simplify];
Print[];

w2[z_] := (z - a)/(z - b);

testTGen = {-2, -1, 0, 1, 2};
Print["Testing points on line:"];
Print["t\t|w|\tVerified"];
Print[StringRepeat["-", 40]];

Do[
  t = testTGen[[i]];
  zTest = z0 + v*t;
  absW = Abs[w2[zTest]] // N;
  ok = If[Abs[absW - 1] < 10^-10, "YES", "NO"];
  Print[t, "\t", absW, "\t", ok];
, {i, Length[testTGen]}];

Print[];
Print["Result: ALL points map to |w| = 1"];
Print[];

(* Algebraic proof *)
Print["ALGEBRAIC PROOF for general line:"];
Print[];
Print["For z on line: z = z0 + v*t"];
Print["Distance to a: |z - a| = |z0 + v*t - z0 - r*i*v| = |v||t - r*i|"];
Print["Distance to b: |z - b| = |z0 + v*t - z0 + r*i*v| = |v||t + r*i|"];
Print[];
Print["|t - r*i| = sqrt(t^2 + r^2)"];
Print["|t + r*i| = sqrt(t^2 + r^2)"];
Print[];
Print["Therefore |z - a| = |z - b| for all t"];
Print["Hence |w| = 1 for all points on line"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   SUMMARY
   ================================================================ *)

Print["SUMMARY\n"];

Print["VERTICAL LINE Re(z) = c:"];
Print["  Formula: w = (z - (c-r))/(z - (c+r))"];
Print["  Example: w = z/(z-1) for Re(z) = 1/2 with r = 1/2"];
Print[];

Print["GENERAL LINE z = z0 + v*t:"];
Print["  a = z0 + r*(i*v)  [perpendicular offset]"];
Print["  b = z0 - r*(i*v)  [opposite offset]"];
Print["  w = (z - a)/(z - b)"];
Print[];

Print["PARAMETER r:"];
Print["  Different r gives different rotation on circle"];
Print["  All valid r > 0 work (infinitely many choices)"];
Print[];

Print["RECIPROCAL EQUATION:"];
Print["  Generic line-to-circle Mobius: does NOT satisfy f(z)*f(1/z) = C"];
Print["  Palindromic form (az+b)/(bz+a): DOES satisfy f(z)*f(1/z) = 1"];
Print["  These are DIFFERENT properties"];
Print[];

Print["CONCLUSION:"];
Print["  YES - we can map ANY line to unit circle via Mobius"];
Print["  YES - we can map critical line Re(z) = 1/2 to circle"];
Print["  BUT - this does NOT automatically give reciprocal equation"];
Print["  For BOTH properties: need special palindromic structure"];
