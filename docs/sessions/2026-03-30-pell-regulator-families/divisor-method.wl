pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* NEW INSIGHT: δ ≤ 2 iff r | 4a₀² where a₀² = n - r.
   So r | 4(n - r) iff r | 4n. 
   Algorithm: enumerate divisors of 4n, check if n - r is a perfect square. *)

Print["=== DIVISOR METHOD: enumerate r | 4n, check n-r = square ===\n"];

divisorSolve[n0_] := Module[{divs, hits = {}},
  divs = Divisors[4 n0];
  Do[
    If[r > 0 && r < n0,
      a0sq = n0 - r;
      If[a0sq > 0 && IntegerQ[Sqrt[a0sq]],
        a0 = Sqrt[a0sq];
        z = (2 a0^2 + r)/r;
        delta = Denominator[z];
        If[delta <= 2, AppendTo[hits, {a0, r, delta, z}]]]],
  {r, divs}];
  (* Also try negative r: n = a0^2 - |r|, a0 > sqrt(n) *)
  Do[
    a0sq = n0 + r;
    If[IntegerQ[Sqrt[a0sq]],
      a0 = Sqrt[a0sq];
      rneg = -r;
      z = (2 a0^2 + rneg)/rneg;
      delta = Denominator[z];
      If[delta <= 2 && Abs[z] > 1,
        AppendTo[hits, {a0, rneg, delta, z}]]],
  {r, divs}];
  hits
];

(* Test on previously uncovered n *)
Print["Previously 'hard' n:\n"];
Do[
  hits = divisorSolve[n0];
  ndivs = Length[Divisors[4 n0]];
  If[Length[hits] > 0,
    best = First[SortBy[hits, Abs[#[[4]]] &]]; (* smallest |z| *)
    {a0, r, d, z} = best;
    Print["  n=", StringPadRight[ToString[n0], 5],
      " τ(4n)=", StringPadRight[ToString[ndivs], 4],
      " FOUND: a₀=", a0, " r=", r, " δ=", d, " z=", z,
      " (", Length[hits], " hits total)"],
    Print["  n=", StringPadRight[ToString[n0], 5],
      " τ(4n)=", StringPadRight[ToString[ndivs], 4],
      " NO HIT"]],
{n0, {127, 193, 409, 541, 991, 31, 71, 73, 89, 97, 61, 916, 311, 431, 661, 811}}];

Print["\n=== COVERAGE with divisor method (c=1 only, all a₀) ===\n"];

Nmax = 1000;
oldHits = 0; newHits = 0; totalNS = 0;
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  totalNS++;
  (* Old method: only a0 = floor(sqrt(n)) *)
  a0old = Floor[Sqrt[n0]]; rold = n0 - a0old^2;
  oldOK = rold > 0 && Denominator[(2 a0old^2 + rold)/rold] <= 2;
  If[oldOK, oldHits++];
  (* New method: all divisors of 4n *)
  hits = divisorSolve[n0];
  If[Length[hits] > 0, newHits++],
{n0, 2, Nmax}];

Print["n ≤ ", Nmax, ":"];
Print["  Old (a₀ = floor(√n) only): ", oldHits, "/", totalNS,
  " = ", Round[100. oldHits/totalNS, 0.1], "%"];
Print["  NEW (all r | 4n):           ", newHits, "/", totalNS,
  " = ", Round[100. newHits/totalNS, 0.1], "%"];
Print["  Gain:                        +", newHits - oldHits, " n values"];
Print[];

(* Cost analysis *)
Print["Cost: enumerate τ(4n) divisors. Typical τ(4n):"];
taus = Table[If[!IntegerQ[Sqrt[n0]], Length[Divisors[4n0]], Nothing], {n0, 2, Nmax}];
Print["  mean τ(4n): ", Round[N@Mean[taus], 0.1]];
Print["  max τ(4n):  ", Max[taus]];
Print["  median:     ", Median[taus]];
