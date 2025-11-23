#!/usr/bin/env wolframscript

Print["VERIFICATION OF CORRECTED CLOSED FORM"];
Print[StringRepeat["=", 70]];
Print[];

(* AB definition *)
AB[k_] := 1/k /; OddQ[k];
AB[k_] := -(1/2)(1/(k+1) + 1/(k-1)) /; EvenQ[k];

(* Corrected closed form from Mathematica *)
GClosed[z_] := ArcTanh[z] + (2*z + (1+z^2)*Log[(z-1)^2]/2 - (1+z^2)*Log[1+z])/(4*z);

(* Direct sum *)
GDirect[z_] := Sum[AB[k]*z^k, {k, 1, 200}];

Print["Testing corrected closed form:"];
Print[];

testVals = {1/10, 1/4, 1/3, 1/2, 2/3, 3/4};

Do[
  closed = N[GClosed[z], 20];
  direct = N[GDirect[z], 20];
  error = Abs[closed - direct];
  
  Print["z = ", z, ":"];
  Print["  Closed form: ", closed];
  Print["  Direct sum:  ", direct];
  Print["  Error:       ", error];
  Print["  Match?       ", error < 10^-15];
  Print[];
, {z, testVals}];

Print[StringRepeat["=", 70]];
Print["SPECIAL VALUE: z = 1/2"];
Print[StringRepeat["=", 70]];
Print[];

Print["G(1/2) = ArcTanh(1/2) + ..."];
Print[];

(* Break down the formula *)
z = 1/2;
part1 = ArcTanh[1/2];
part2Num = 2*(1/2) + (1 + (1/2)^2)*Log[(1/2 - 1)^2]/2 - (1 + (1/2)^2)*Log[1 + 1/2];
part2 = part2Num / (4*(1/2));

Print["Part 1: ArcTanh(1/2) = ", N[part1, 20]];
Print["Part 2 numerator: ", N[part2Num, 20]];
Print["Part 2 full: ", N[part2, 20]];
Print["Total: ", N[part1 + part2, 20]];
Print[];

Print["Simplified form check:"];
gHalfSimple = 1/2 - Log[3]/8;
Print["  1/2 - Log[3]/8 = ", N[gHalfSimple, 20]];
Print["  Matches?       ", Abs[N[GClosed[1/2], 20] - gHalfSimple] < 10^-15];
Print[];

Print[StringRepeat["=", 70]];
Print["ONE-LINER FOR WOLFRAM"];
Print[StringRepeat["=", 70]];
Print[];

Print["G[z_] := ArcTanh[z] + (2z + (1+z^2)Log[(z-1)^2]/2 - (1+z^2)Log[1+z])/(4z)"];
Print[];
Print["Test: G[1/2]"];
Print[];

Print["DONE!"];
