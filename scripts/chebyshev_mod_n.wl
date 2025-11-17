#!/usr/bin/env wolframscript
(*
Analyze Chebyshev polynomials mod n when x+1 == 0 (mod n)
*)

Print["=" * 70];
Print["CHEBYSHEV POLYNOMIALS MOD n"];
Print["=" * 70];
Print[];

(* n=13 case *)
n = 13;
x = 649;
y = 180;

Print["n = ", n];
Print["x = ", x, ", y = ", y];
Print["x + 1 = ", x + 1, " = ", Mod[x + 1, n], " (mod ", n, ")"];
Print[];

(* Evaluate Chebyshev polynomials at x+1 *)
arg = x + 1;

Print["=" * 70];
Print["CHEBYSHEV T_m(x+1) MOD n"];
Print["=" * 70];
Print[];

Do[
  val = ChebyshevT[m, arg];
  valMod = Mod[val, n];
  Print["T_", m, "(", arg, ") = ", val, " == ", valMod, " (mod ", n, ")"];
  ,
  {m, 0, 10}
];

Print[];
Print["=" * 70];
Print["CHEBYSHEV U_m(x+1) MOD n"];
Print["=" * 70];
Print[];

Do[
  val = ChebyshevU[m, arg];
  valMod = Mod[val, n];
  Print["U_", m, "(", arg, ") = ", val, " == ", valMod, " (mod ", n, ")"];
  ,
  {m, 0, 10}
];

Print[];
Print["=" * 70];
Print["U_m(x+1) - U_{m-1}(x+1) MOD n"];
Print["=" * 70];
Print[];

Do[
  um = ChebyshevU[m, arg];
  um1 = ChebyshevU[m - 1, arg];
  diff = um - um1;
  diffMod = Mod[diff, n];
  Print["U_", m, " - U_", m - 1, " = ", diff, " == ", diffMod, " (mod ", n, ")"];
  ,
  {m, 1, 10}
];

Print[];
Print["=" * 70];
Print["DENOMINATOR IN term[x, k] MOD n"];
Print["=" * 70];
Print[];

Do[
  tm = ChebyshevT[Ceiling[k / 2], arg];
  um = ChebyshevU[Floor[k / 2], arg];
  um1 = ChebyshevU[Floor[k / 2] - 1, arg];

  denom = tm * (um - um1);
  denomMod = Mod[denom, n];

  Print["k=", k, " (", If[EvenQ[k], "EVEN", "ODD"], "): denom = ", denom];
  Print["  mod ", n, ": ", denomMod];
  Print["  Divisible by n? ", Divisible[denom, n]];
  Print[];
  ,
  {k, 2, 10}
];

Print["=" * 70];
