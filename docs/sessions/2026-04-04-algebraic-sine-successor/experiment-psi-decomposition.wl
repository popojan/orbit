(* Decomposition of ψ(x) into orbit contributions *)
(* Each zeta zero ρ_n = 1/2 + iγ_n contributes an "orbit" *)
(* with Chebyshev parameter c_n = cos(γ_n)                 *)
(*                                                          *)
(* In log-coordinates t = ln(x):                            *)
(*   main term: e^t  (degenerate orbit, c = 1)              *)
(*   correction n: -2Re(e^{ρ_n t}/ρ_n)  (oscillatory orbit) *)

(* === Part 1: Individual zero contributions === *)
Print["=== Individual zero contributions to ψ(x) ===\n"];

nZeros = 20;
gammas = Table[N[Im[ZetaZero[n]], 15], {n, 1, nZeros}];

(* Classify zeros by their Chebyshev parameter *)
Print["Zero | γ_n          | c = cos(γ_n)  | |c|   | near-degen?"];
Print["-----|--------------|---------------|-------|------------"];
Do[
  g = gammas[[n]];
  c = Cos[g];
  nd = If[Abs[c] > 0.95, " ← NEAR-DEGENERATE", ""];
  Print[n, If[n<10," ",""], "   | ", NumberForm[g, {8, 4}],
    " | ", NumberForm[c, {6, 4}],
    "  | ", NumberForm[Abs[c], {4, 2}],
    "  | ", nd],
{n, 1, nZeros}];

(* How many zeros are near-degenerate? *)
nearDegen = Select[Range[nZeros], Abs[Cos[gammas[[#]]]] > 0.95 &];
Print["\nNear-degenerate zeros (|c| > 0.95): ", nearDegen,
  " out of ", nZeros, " (", N[100 Length[nearDegen]/nZeros], "%)"];

(* === Part 2: Why are some zeros near-degenerate? === *)
(* c ≈ 1 when γ ≈ 2kπ, c ≈ -1 when γ ≈ (2k+1)π *)
Print["\n=== Near-degenerate zeros: γ_n mod 2π ==="];
Do[
  g = gammas[[n]];
  gmod = Mod[g, 2 Pi];
  k = Round[g / (2 Pi)];
  residual = g - 2 k Pi;
  Print["ρ_", n, ": γ = ", NumberForm[g, {8, 4}],
    " ≈ ", k, "·2π + ", NumberForm[residual, {5, 4}],
    " (c = ", NumberForm[Cos[g], {5, 3}], ")"],
{n, nearDegen}];

(* === Part 3: Convergence of orbit sum === *)
Print["\n=== ψ(x) reconstruction: how many orbits needed? ==="];
Print["ψ_N(x) = x - Σ_{n=1}^N 2Re(x^ρ_n/ρ_n) - ln(2π)\n"];

psiExact[x_] := Total[MangoldtLambda /@ Range[x]];

psiN[x_, nz_] := Module[{result = x},
  Do[
    rho = 1/2 + I gammas[[n]];
    result -= 2 Re[x^rho / rho],
  {n, 1, Min[nz, nZeros]}];
  Re[result] - Log[2 Pi]
];

Print["x = 100:"];
exact100 = N[psiExact[100]];
Do[
  approx = psiN[100, nz];
  err = exact100 - approx;
  Print["  N=", nz, If[nz<10," ",""], " zeros: ψ_N = ", NumberForm[approx, {7, 2}],
    ", error = ", NumberForm[err, {5, 2}]],
{nz, {1, 2, 3, 5, 8, 12, 20}}];

Print["\nx = 1000:"];
exact1000 = N[psiExact[1000]];
Do[
  approx = psiN[1000, nz];
  err = exact1000 - approx;
  Print["  N=", nz, If[nz<10," ",""], " zeros: ψ_N = ", NumberForm[approx, {8, 2}],
    ", error = ", NumberForm[err, {6, 2}]],
{nz, {1, 2, 5, 10, 20}}];

(* === Part 4: Near-degenerate vs regular zero contributions === *)
Print["\n=== Contribution magnitude at x = 1000 ==="];
Print["(near-degenerate zeros contribute MORE at moderate x)\n"];
x0 = 1000;
Do[
  g = gammas[[n]];
  rho = 1/2 + I g;
  contrib = Abs[2 x0^rho / rho];
  c = Cos[g];
  Print["ρ_", n, ": |contrib| = ", NumberForm[N[contrib], {6, 2}],
    ", c = ", NumberForm[c, {5, 3}],
    If[Abs[c] > 0.95, " ★ near-degen", ""]],
{n, 1, Min[12, nZeros]}];

(* === Part 5: The "almost counting" stretches === *)
(* A near-degenerate zero (c ≈ 1) has quasi-period T ≈ 2π/arccos(c) *)
(* It "counts" for about T/4 steps in log-space before oscillating *)
Print["\n=== Quasi-periods of near-degenerate zeros ==="];
Print["(in log-space: how long does \"almost counting\" last?)\n"];
Do[
  g = gammas[[n]];
  c = Cos[g];
  If[Abs[c] > 0.9,
    theta = ArcCos[Abs[c]];
    quasiT = 2 Pi / theta;
    countingSteps = quasiT / 4; (* quarter period = "counting" phase *)
    xRange = Exp[countingSteps]; (* in x-space: counting up to this x *)
    Print["ρ_", n, ": c = ", NumberForm[c, {6, 4}],
      ", θ = ", NumberForm[theta, {5, 3}],
      ", quasi-T = ", NumberForm[quasiT, {5, 1}], " (in ln x)",
      ", counts up to x ≈ ", NumberForm[N[xRange], {5, 1}]]
  ],
{n, 1, nZeros}];
