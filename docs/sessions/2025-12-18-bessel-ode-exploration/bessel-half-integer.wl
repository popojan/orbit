(* Poloceločíselné řády - explicitní exponenciály *)

Print["=== Half-integer orders: K_{n+1/2}(x) = √(π/2x) e^{-x} · P_n(1/x) ===\n"];

(* Extrahujme polynomy P_n *)
extractPoly[n_] := Module[{k = BesselK[n + 1/2, x], simplified},
  simplified = FullSimplify[k / (Sqrt[Pi/(2x)] Exp[-x])];
  Expand[simplified /. 1/x -> t] /. t -> 1/x
];

Print["Polynomials P_n(1/x):"];
Table[
  Print["n=", n, ": P_", n, " = ", extractPoly[n]];
  , {n, 0, 5}
];

(* Tyto polynomy jsou reverzní Bessel polynomials! *)
Print["\n=== These are reverse Bessel polynomials θ_n(x) ==="];
Print["θ_n(x) = Σ_{k=0}^n (n+k)!/(k!(n-k)!) (x/2)^k"];

(* Nyní: co když dosadíme x = -1/2? *)
Print["\n=== Evaluating at x = -1/2 ==="];
Print["K_{n+1/2}(-1/2) involves e^{1/2} = √e"];
Table[
  val = BesselK[n + 1/2, -1/2];
  Print["K_{", n, "+1/2}(-1/2) = ", FullSimplify[val]];
  , {n, -3, 3}
];

(* Numericky *)
Print["\n=== Numerical values at x = -1/2 ==="];
Table[
  val = N[BesselK[n + 1/2, -1/2], 15];
  Print["K_{", n, "+1/2}(-1/2) = ", val];
  , {n, -3, 3}
];

(* Naše g(n) pro celočíselné n používá K_{2n-1}(-1/2) a K_{2n+1}(-1/2) *)
(* Pro n=1: K_1(-1/2), K_3(-1/2) - celočíselné řády, ne poloceločíselné *)
Print["\n=== Integer orders K_n(-1/2) - no closed exponential form ==="];
Table[
  Print["K_", n, "(-1/2) = ", N[BesselK[n, -1/2], 15]];
  , {n, -3, 5}
];

(* ALE: spojení přes rekurentní vztah *)
Print["\n=== Recurrence connects integer and half-integer orders ==="];
Print["K_{ν+1}(x) = (2ν/x) K_ν(x) + K_{ν-1}(x)"];

(* Ověření *)
test = BesselK[nu + 1, x] - (2 nu/x) BesselK[nu, x] - BesselK[nu - 1, x];
Print["Check: ", FullSimplify[test]];

