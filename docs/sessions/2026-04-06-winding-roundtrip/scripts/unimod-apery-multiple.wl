(* ================================================================ *)
(* For each n, find rational α such that k = α·ζ(3) gives |det|=1 *)
(* Also try: α·e, α·π, α·(2π), α·(11/4)                         *)
(* ================================================================ *)

nMax = 40;
gList = Table[N[Im[ZetaZero[n]], 25], {n, nMax}];
lpList = Table[Log[N[Prime[j], 25]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

z3 = N[Zeta[3], 25];

(* For each n, find smallest α = p/q (q ≤ qMax) with det = ±1 *)
findUnimodMultiple[n_, base_, qMax_: 40] := Module[
  {best = None, bestQ = Infinity},
  Do[
    k = (p/q) * base;
    If[k <= 0, Continue[]];
    d = Det[fWM[n, k]];
    If[Abs[d] == 1 && q < bestQ,
      best = p/q; bestQ = q],
  {q, 1, qMax}, {p, 1, Ceiling[10 q / base]}];
  best
]

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  UNIMODULAR k = α · constant                        ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

(* Quick: det(α·ζ(3)) for small integer/half-integer α, n=3..25 *)
Print["=== det at k = α·ζ(3) for integer and half-integer α ===\n"];
Print["n    α=1     α=2     α=3     α=1/2   α=3/2   α=5/2   α=7/2"];
Do[
  dets = Table[
    Det[fWM[n, alpha * z3]],
  {alpha, {1, 2, 3, 1/2, 3/2, 5/2, 7/2}}];
  Print[PaddedForm[n, 3], "  ",
    Sequence @@ Table[PaddedForm[dets[[i]], 7], {i, 7}]],
{n, 3, 25}];

(* Now: for each n, find α = p/q with det(α·ζ(3)) = ±1 *)
Print["\n=== Smallest α = p/q such that det(α·ζ(3)·W) = ±1 ===\n"];
Print["n    α           k=α·ζ(3)     det"];
aperyAlphas = {};
Do[
  alpha = findUnimodMultiple[n, z3, 40];
  If[alpha =!= None,
    k = alpha * z3;
    d = Det[fWM[n, k]];
    AppendTo[aperyAlphas, {n, alpha, d}];
    Print[PaddedForm[n, 3], "  ",
      PaddedForm[ToString[alpha], 10], "  ",
      NumberForm[N[k], {6, 3}], "       ", d],
    Print[PaddedForm[n, 3], "  NOT FOUND (q≤40)"]],
{n, 3, 30}];

(* Pattern analysis *)
Print["\n=== Pattern in α values ==="];
If[Length[aperyAlphas] > 0,
  alphas = aperyAlphas[[All, 2]];
  Print["α values: ", alphas];
  Print["α as decimals: ", N /@ alphas];
  Print["Numerators: ", Numerator /@ alphas];
  Print["Denominators: ", Denominator /@ alphas];
  (* Check: is α·ζ(3) close to known constants? *)
  Print["\nα·ζ(3) values:"];
  Do[
    {n, alpha, d} = entry;
    kv = N[alpha * z3];
    Print["  n=", n, ": α·ζ(3) = ", NumberForm[kv, {8, 5}],
      "  (α=", alpha, ")",
      If[Abs[kv - Round[kv]] < 0.05, "  ← near integer " <> ToString[Round[kv]], ""],
      If[Abs[kv - N[Pi]] < 0.1, "  ← near π", ""],
      If[Abs[kv - N[E]] < 0.1, "  ← near e", ""],
      If[Abs[kv - N[2 Pi]] < 0.2, "  ← near 2π", ""]],
  {entry, aperyAlphas}]];

(* Also: compare with α·e and α·2π *)
Print["\n=== Same for base = e ===\n"];
Print["n    α           k=α·e       det"];
Do[
  alpha = findUnimodMultiple[n, N[E, 25], 30];
  If[alpha =!= None,
    k = alpha * E;
    d = Det[fWM[n, N[k, 25]]];
    Print[PaddedForm[n, 3], "  ",
      PaddedForm[ToString[alpha], 10], "  ",
      NumberForm[N[k], {6, 3}], "       ", d],
    Print[PaddedForm[n, 3], "  NOT FOUND"]],
{n, 3, 20}];
