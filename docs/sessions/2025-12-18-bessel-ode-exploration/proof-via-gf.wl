(* DŮKAZ přes generující funkci *)

Print["=== PROOF VIA GENERATING FUNCTION ===\n"];

(* EGF pro Besselovy polynomy: *)
(* Σ y_{n-1}(x) t^n/n! = exp((1 - sqrt(1-2xt))/x) *)

Print["Exponential generating function:"];
Print["Σ_{n=0}^∞ y_{n-1}(x) t^n/n! = exp((1 - sqrt(1-2xt))/x)\n"];

(* Ověření pro malé n *)
y[0, x_] := 1;
y[1, x_] := 1 + x;
y[n_, x_] := y[n, x] = (2 n - 1) x y[n - 1, x] + y[n - 2, x];

Print["Verification at x=1:"];
gf[t_] := Exp[(1 - Sqrt[1 - 2 t])];  (* x=1 *)
gfSeries = Series[gf[t], {t, 0, 8}];
Print["EGF expansion: ", Normal[gfSeries]];

Print["\nCoefficients from GF (times n!):"];
Table[
  coef = SeriesCoefficient[gfSeries, n];
  Print["n=", n, ": coef*n! = ", coef * n!, ", y_{n-1}(1) = ", y[n - 1, 1]];
  , {n, 1, 7}
];

(* Pro x=1: exp(1 - sqrt(1-2t)) *)
(* Při t → 1/2: sqrt(1-2t) → 0, exp(1-0) = e *)
Print["\n=== KEY OBSERVATION ==="];
Print["At x=1: EGF = exp(1 - sqrt(1-2t))"];
Print["As t → 1/2: sqrt(1-2t) → 0, so EGF → exp(1) = e\n"];

Print["This suggests: Σ y_{n-1}(1)/n! · (1/2)^n = e"];
Print["Let's verify:\n"];

partialSum[N_] := Sum[y[n - 1, 1]/n! (1/2)^n, {n, 1, N}];
Table[
  ps = N[partialSum[k], 15];
  Print["Σ_{n=1}^", k, " y_{n-1}(1)/n! · (1/2)^n = ", ps];
  , {k, {10, 20, 30, 40, 50}}
];
Print["e = ", N[E, 15]];

Print["\n=== DIFFERENT LIMIT ==="];
Print["We want: lim y_n(1)/(2n-1)!! = e"];
Print["EGF gives: Σ y_{n-1}(1) t^n/n! = exp(1-sqrt(1-2t))\n"];

Print["OGF (ordinary): Σ y_n(x) t^n = ?"];
Print["Let's compute OGF at x=1:"];
ogfPartial[N_] := Sum[y[n, 1] t^n, {n, 0, N}];
Print["Partial OGF: ", ogfPartial[6]];

Print["\nThe OGF diverges for |t| ≥ some radius."];
Print["We need asymptotic analysis of coefficients.\n"];

Print["=== DARBOUX'S METHOD ==="];
Print["If f(t) = Σ a_n t^n has singularity at t = ρ,"];
Print["then a_n ~ [singularity contribution] / ρ^n\n"];

Print["For EGF = exp(1 - sqrt(1-2t)):"];
Print["Singularity at t = 1/2 (branch point of sqrt)"];
Print["Near t = 1/2: sqrt(1-2t) ≈ sqrt(2) sqrt(1/2 - t)"];
Print["So EGF ≈ exp(1) · exp(-sqrt(2) sqrt(1/2-t))"];
Print["      = e · exp(-sqrt(2) sqrt(1/2-t))\n"];

Print["Using Darboux: y_{n-1}(1)/n! ~ e · [coef of t^n in exp(-sqrt(2)sqrt(1/2-t))]"];

