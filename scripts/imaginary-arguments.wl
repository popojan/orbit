(* Ryze imaginární argumenty zeta funkce: s = i*t *)

Print["=== Ryze imaginární argumenty s = i·t ===\n"];

(* Funkcionální rovnice *)
f[s_] := 2^s Pi^(s-1) Sin[Pi s/2] Gamma[1-s]

(* Test pro několik hodnot t *)
testT = {1, 2, Pi, 14.134725};  (* poslední je první netriviální nula *)

Print["Pro s = i·t:\n"];
Print["  Re(s) = 0      (hranice kritického pásu)"];
Print["  Re(1-s) = 1    (hranice konvergence)"];
Print["  Re(2s) = 0     (stále na hranici)\n"];

Do[
  s = I*t;
  Print["--- t = ", t, " ---"];
  Print["s = ", s];
  Print["ζ(s) = ", N[Zeta[s], 10]];
  Print["1-s = ", 1-s, ", ζ(1-s) = ", N[Zeta[1-s], 10]];
  Print["2s = ", 2s, ", ζ(2s) = ", N[Zeta[2s], 10]];
  Print["f(s)·ζ(1-s) = ", N[f[s] Zeta[1-s], 10]];
  Print[];
, {t, testT}];

Print["=== Řetězec zdvojování pro s = i ===\n"];

s = I;
chain = Table[
  {k, 2^k s, Re[2^k s], N[Zeta[2^k s], 6]},
  {k, 0, 5}
];
Print["k | 2^k·s | Re | ζ(2^k·s)"];
Print["--------------------------------"];
Do[Print[row[[1]], " | ", row[[2]], " | ", row[[3]], " | ", row[[4]]], {row, chain}];

Print["\nVšechny členy mají Re = 0 → nikdy nepřejdeme do oblasti konvergence!"];

Print["\n=== Funkcionální rovnice — kam mapuje? ===\n"];

Print["Pro s = it:"];
Print["  ζ(it) ↔ ζ(1-it)    kde Re(1-it) = 1"];
Print["  ζ(2it) ↔ ζ(1-2it)  kde Re(1-2it) = 1"];
Print["  ..."];
Print["\nVšechny obrazy mají Re = 1 (hranice konvergence Dirichletovy řady).\n"];

(* Konvergence na Re = 1 *)
Print["=== Konvergence na Re(s) = 1 ===\n"];

Print["Dirichletova řada ζ(s) = Σ n^{-s} konverguje pro Re(s) > 1."];
Print["Na Re(s) = 1: podmíněná konvergence pro s ≠ 1.\n"];

(* Numerické ověření *)
s = 1 + 2 I;
partial[n_] := Sum[k^(-s), {k, 1, n}];
Print["ζ(1+2i) přesně: ", N[Zeta[s], 10]];
Print["Parciální sumy:"];
Do[Print["  N=", n, ": ", N[partial[n], 10]], {n, {10, 100, 1000}}];

Print["\n=== L_P identita pro imaginární argumenty ===\n"];

LP[s_] := (Zeta[s]^2 - Zeta[2s])/2

s = I;
Print["Pro s = i:"];
Print["  ζ(i) = ", N[Zeta[s], 10]];
Print["  ζ(2i) = ", N[Zeta[2s], 10]];
Print["  L_P(i) = ", N[LP[s], 10]];
Print["  ζ(i)² = ", N[Zeta[s]^2, 10]];
Print["  2·L_P(i) + ζ(2i) = ", N[2 LP[s] + Zeta[2s], 10]];

Print["\n=== Uzavření řetězce? ===\n"];

Print["Podmínka uzavření pro reálné s: 2^k·s ≡ 1-s"];
Print["Pro s = it: 2^k·it = 1 - it ?"];
Print["  → 2^k·t = -t (imaginární část)"];
Print["  → 0 = 1 (reálná část) — SPOR!\n"];
Print["Řetězec se NIKDY neuzavře pro ryze imaginární argumenty."];

Print["\n=== Kritický pás: 0 < Re(s) < 1 ===\n"];

(* Test pro s v kritickém pásu *)
testS = {1/2 + 14.134725 I, 1/4 + 10 I, 3/4 + 5 I};

Do[
  Print["s = ", N[s, 6]];
  Print["  Re(s) = ", Re[s], " ∈ (0,1) — kritický pás"];
  Print["  ζ(s) = ", N[Zeta[s], 10]];
  Print["  |ζ(s)| = ", N[Abs[Zeta[s]], 10]];
  If[Abs[Zeta[s]] < 0.001, Print["  ← BLÍZKO NULY!"]];
  Print[];
, {s, testS}];

Print["=== Shrnutí ===\n"];
Print["Pro s = it (ryze imaginární):"];
Print["  • Řetězec zdvojování zůstává na Re = 0"];
Print["  • Funkcionální rovnice mapuje na Re = 1"];
Print["  • Řetězec se NIKDY neuzavře"];
Print["  • L_P identita platí, ale nedává nezávislou informaci"];
