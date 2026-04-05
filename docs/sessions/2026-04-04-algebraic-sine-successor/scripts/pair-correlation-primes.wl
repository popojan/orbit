(* ================================================================ *)
(* Pair correlation C(α) and prime detection                        *)
(* C(α) = (1/Nz) Σ_n cos(γ_n α) spikes at α = ln(prime powers)   *)
(* ================================================================ *)

nz = 500;
Print["Computing ", nz, " zero heights..."];
gammas = Table[N[Im[ZetaZero[n]], 12], {n, nz}];
Print["Done."];

CF[alpha_] := Mean[Cos[gammas alpha]];

(* === C(ln n) vs von Mangoldt === *)
Print["\n=== C(ln n) detects Λ(n) ===\n"];
Print["n  | Λ(n)    | -C(ln n)√n | type"];
Do[
  c = CF[Log[N[n]]];
  lambda = MangoldtLambda[n] // N;
  spike = -c Sqrt[N[n]];
  Print[n, If[n < 10, "  ", " "],
    "| ", NumberForm[lambda, {5, 2}],
    " | ", NumberForm[spike, {6, 3}],
    "  | ", If[lambda > 0,
      If[PrimeQ[n], "PRIME", "p^" <> ToString[Round[Log[FactorInteger[n][[1, 1]], n]]]],
      ""]],
{n, 2, 50}];

(* === C(α) for continuous α — where are the spikes? === *)
Print["\n=== Continuous C(α) scan ==="];
Print["Primes should show as negative spikes\n"];
alphas = Table[a, {a, 0.5, 4.0, 0.01}];
Do[
  c = CF[alpha];
  If[c < -0.1,
    (* What prime is nearby? *)
    nearP = SelectFirst[Prime /@ Range[30], Abs[Log[N[#]] - alpha] < 0.02 &];
    Print["α=", NumberForm[alpha, {4, 2}],
      ": C=", NumberForm[c, {5, 3}],
      If[nearP =!= Missing["NotFound"], "  ← near ln(" <> ToString[nearP] <> ") = " <> ToString[NumberForm[Log[N[nearP]], {4, 2}]], ""]]
  ],
{alpha, alphas}];

(* === M^T M: prime-prime correlation === *)
Print["\n=== M^T M (15 primes, ", nz, " zeros) ==="];
np = 15;
lnP = Table[Log[N[Prime[j]]], {j, np}];
m = Table[Cos[gammas[[n]] lnP[[j]]], {n, nz}, {j, np}];
mtm = Transpose[m] . m / nz;

Print["Eigenvalues:"];
eigs = Sort[Eigenvalues[N[mtm]], Greater];
Do[Print["  λ_", i, " = ", NumberForm[eigs[[i]], {5, 3}]], {i, Min[8, np]}];
Print["λ₁/λ₂ = ", NumberForm[eigs[[1]]/eigs[[2]], {4, 2}]];

(* === MM^T: zero-zero correlation === *)
Print["\n=== MM^T (30 zeros, 100 primes) ==="];
nzSmall = 30; npLarge = 100;
lnPL = Table[Log[N[Prime[j]]], {j, npLarge}];
mSmall = Table[Cos[gammas[[n]] lnPL[[j]]], {n, nzSmall}, {j, npLarge}];
mmt = mSmall . Transpose[mSmall] / npLarge;

Print["Eigenvalues:"];
eigsZ = Sort[Eigenvalues[N[mmt]], Greater];
Do[Print["  λ_", i, " = ", NumberForm[eigsZ[[i]], {5, 3}]], {i, Min[8, nzSmall]}];
Print["λ₁/λ₂ = ", NumberForm[eigsZ[[1]]/eigsZ[[2]], {4, 2}]];

(* === Consecutive zero correlations (GUE test) === *)
Print["\nConsecutive zero correlations:"];
Do[
  gap = gammas[[n + 1]] - gammas[[n]];
  Print["  (ρ_", n, ",ρ_", n + 1, "): corr=", NumberForm[mmt[[n, n + 1]], {5, 3}],
    ", gap=", NumberForm[gap, {4, 2}]],
{n, 1, Min[10, nzSmall - 1]}];
