(* ================================================================ *)
(* Test ζ(3) never-singular for LARGE n (up to 200)               *)
(* Also test: k=1, 11/4, 2π for comparison                        *)
(* ================================================================ *)

nMax = 200;
Print["Pre-computing zeros and log-primes to n=", nMax, "..."];
gList = Table[N[Im[ZetaZero[n]], 20], {n, nMax}];
lpList = Table[Log[N[Prime[j], 20]], {j, nMax}];
Print["Done.\n"];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

(* Test specific k values for n=3..nMax *)
kValues = {1, N[Zeta[3], 20], 113/94, 119/99, 11/4, N[2 Pi, 20]};
kLabels = {"k=1", "k=ζ(3)", "k=113/94", "k=119/99", "k=11/4", "k=2π"};

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  LARGE-n SINGULARITY TEST: n = 3..", nMax, "              ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Do[
  {kv, kl} = {kValues[[ki]], kLabels[[ki]]};
  Print["Testing ", kl, " ≈ ", NumberForm[N[kv], {8, 5}], "..."];
  singularities = {};
  t0 = AbsoluteTime[];
  Do[
    d = Det[fWM[n, kv]];
    If[d == 0,
      AppendTo[singularities, n];
      If[Length[singularities] <= 5,
        Print["  SINGULAR at n=", n]]
    ];
    (* Progress *)
    If[Mod[n, 50] == 0,
      Print["  n=", n, " checked, sing so far: ", Length[singularities],
        " (", Round[AbsoluteTime[] - t0], "s)"]],
  {n, 3, nMax}];
  dt = AbsoluteTime[] - t0;
  Print["  TOTAL: ", Length[singularities], "/", nMax - 2,
    " singular  (", Round[dt], "s)"];
  If[Length[singularities] > 0,
    Print["  Singular at: ", singularities],
    Print["  ★ NEVER SINGULAR through n=", nMax]];
  Print[""],
{ki, Length[kValues]}];
