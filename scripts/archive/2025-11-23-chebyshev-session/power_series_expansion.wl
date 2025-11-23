#!/usr/bin/env wolframscript

Print["POWER SERIES EXPANSION OF G[z]"];
Print[StringRepeat["=", 70]];
Print[];

(* Closed form *)
GClosed[z_] := ArcTanh[z] + (2*z + (1+z^2)*Log[(z-1)^2]/2 - (1+z^2)*Log[1+z])/(4*z);

(* Expected AB values *)
ABExpected[k_] := 1/k /; OddQ[k];
ABExpected[k_] := -(1/2)(1/(k+1) + 1/(k-1)) /; EvenQ[k];

Print[StringRepeat["=", 70]];
Print["METHOD 1: Series expansion"];
Print[StringRepeat["=", 70]];
Print[];

Print["Series[G[z], {z, 0, 10}]:"];
Print[];

series = Series[GClosed[z], {z, 0, 10}];
Print[series];
Print[];

Print[StringRepeat["=", 70]];
Print["METHOD 2: Extract coefficients"];
Print[StringRepeat["=", 70]];
Print[];

Print["k\tAB[k] from series\tAB[k] expected\tMatch?"];
Print[StringRepeat["-", 70]];

Do[
  coeff = SeriesCoefficient[GClosed[z], {z, 0, k}];
  expected = ABExpected[k];
  match = Simplify[coeff - expected] == 0;
  
  Print[k, "\t", coeff, "\t\t", expected, "\t\t", match];
, {k, 1, 10}];
Print[];

Print[StringRepeat["=", 70]];
Print["METHOD 3: Direct formula from derivatives"];
Print[StringRepeat["=", 70]];
Print[];

Print["AB[k] = (1/k!) · [d^k G/dz^k]_{z=0}"];
Print[];

(* This is slow for high k, just demonstrate for k=1,2,3 *)
Do[
  derivative = D[GClosed[z], {z, k}];
  coeffAtZero = Limit[derivative, z -> 0];
  abk = coeffAtZero / k!;
  expected = ABExpected[k];
  
  Print["k=", k, ":"];
  Print["  d^", k, "G/dz^", k, " |_{z=0} = ", coeffAtZero];
  Print["  AB[", k, "] = ", Simplify[abk]];
  Print["  Expected: ", expected];
  Print["  Match? ", Simplify[abk - expected] == 0];
  Print[];
, {k, 1, 3}];

Print[StringRepeat["=", 70]];
Print["PRACTICAL ONE-LINER"];
Print[StringRepeat["=", 70]];
Print[];

Print["To extract AB[k] from closed form G[z]:"];
Print[];
Print["(* Method 1: SeriesCoefficient *)"];
Print["AB[k_] := SeriesCoefficient[G[z], {z, 0, k}]"];
Print[];
Print["(* Method 2: Series expansion *)"];
Print["series = Series[G[z], {z, 0, maxK}]"];
Print["(* Read coefficients from series *)"];
Print[];

Print[StringRepeat["=", 70]];
Print["VERIFICATION: Reconstruct G[1/2]"];
Print[StringRepeat["=", 70]];
Print[];

Print["Using first 20 terms from series:"];
Print[];

coeffs = Table[SeriesCoefficient[GClosed[z], {z, 0, k}], {k, 1, 20}];
g12Reconstructed = Sum[coeffs[[k]] * (1/2)^k, {k, 1, 20}] // N;
g12Exact = N[GClosed[1/2], 20];

Print["From series (20 terms): ", g12Reconstructed];
Print["Exact (closed form):    ", g12Exact];
Print["Error:                  ", Abs[g12Reconstructed - g12Exact]];
Print[];

Print["DONE!"];
