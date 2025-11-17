#!/usr/bin/env wolframscript
(*
Explore the Chebyshev U ratio and its connection to our sum
*)

Print["=" * 70];
Print["CHEBYSHEV U RATIO EXPLORATION"];
Print["=" * 70];
Print[];

n = 13; x = 649; y = 180;

Print["n = ", n, ", x = ", x, ", y = ", y];
Print["sqrt(n) = ", N[Sqrt[n], 20]];
Print["floor(sqrt(n)) = ", Floor[Sqrt[n]]];
Print["floor(sqrt(n))+1 = ", Floor[Sqrt[n]] + 1];
Print[];

(* Our term *)
term[xx_, k_] := 1/(ChebyshevT[Ceiling[k/2], xx+1] *
(ChebyshevU[Floor[k/2], xx+1] - ChebyshevU[Floor[k/2]-1, xx+1]));

partialSum[xx_, k_] := 1 + Sum[term[xx, j], {j, 1, k}];

(* Try the U ratio at different arguments *)
Print["=" * 70];
Print["U RATIO AT VARIOUS ARGUMENTS"];
Print["=" * 70];
Print[];

(* Argument 1: x (our Pell solution) *)
Print["At argument x = ", x];
Do[
Module[{ratio},
ratio = ChebyshevU[m-1, x] / ChebyshevU[m+1, x];
Print["  m=", m, ": U[m-1]/U[m+1] = ", N[ratio, 15]];
],
{m, 1, 5}
];
Print[];

(* Argument 2: x-1 (what we use in terms) *)
Print["At argument x-1 = ", x-1, ":");
Do[
Module[{ratio},
ratio = ChebyshevU[m-1, x-1] / ChebyshevU[m+1, x-1];
Print["  m=", m, ": U[m-1]/U[m+1] = ", N[ratio, 15]];
],
{m, 1, 5}
];
Print[];

(* Argument 3: x+1 (what appears in denominators) *)
Print["At argument x+1 = ", x+1, ":");
Do[
Module[{ratio},
ratio = ChebyshevU[m-1, x+1] / ChebyshevU[m+1, x+1];
Print["  m=", m, ": U[m-1]/U[m+1] = ", N[ratio, 15]];
],
{m, 1, 5}
];
Print[];

(* Argument 4: from sqrttrf formula α = sqrt(d/-(n²-d)) *)
(* Using n0 = (x-1)/y *)
Module[{n0, d, alpha},
n0 = (x-1)/y;
d = n;
alpha = Sqrt[d/(-n0^2 + d)];
Print["At sqrttrf argument α = sqrt(d/-(n0²-d)) where n0=(x-1)/y:"];
Print["  α = ", N[alpha, 15]];
Print["  (imaginary: ", Im[N[alpha, 15]], ")"];
Print[];
Do[
Module[{ratio, simplified},
ratio = ChebyshevU[m-1, alpha] / ChebyshevU[m+1, alpha];
simplified = Simplify[ratio];
Print["  m=", m, ": U[m-1]/U[m+1] = ", N[simplified, 15]];
If[Im[N[simplified]] == 0,
Print["    -> REAL! Value: ", N[simplified, 20]];
];
],
{m, 1, 5}
];
];
Print[];

Print["=" * 70];
Print["SUBTRACTION APPROACH: (floor(sqrt(n))+1) - sum"];
Print["=" * 70];
Print[];

Module[{base, actualSqrt},
base = Floor[Sqrt[n]] + 1;
actualSqrt = Sqrt[n];

Print["Base (floor+1) = ", base];
Print["sqrt(n) = ", N[actualSqrt, 20]];
Print["Difference = ", N[base - actualSqrt, 20]];
Print[];

(* Our approximation from below *)
Do[
Module[{approx, diff, subtractApprox},
approx = (x-1)/y * partialSum[x-1, k];
diff = actualSqrt - approx;
subtractApprox = base - diff;  (* What would we get by subtraction? *)

Print["k=", k, ":");
Print["  Our approx (adding) = ", N[approx, 15]];
Print["  Error = ", N[diff, 15]];
Print["  If we subtract error from base: ", N[subtractApprox, 15]];
Print["  Equals base? ", N[Abs[subtractApprox - base]] < 10^(-10)];
],
{k, 1, 4}
];
];

Print[];
Print["=" * 70];
