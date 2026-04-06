(* ================================================================ *)
(* SHORT-CIRCUIT singularity survey                                *)
(* For each k: test n=3,4,...,50. Stop at first det=0.            *)
(* Much faster: most k eliminated at small n.                      *)
(* ================================================================ *)

nMax = 50;
gList = Table[N[Im[ZetaZero[n]], 20], {n, nMax}];
lpList = Table[Log[N[Prime[j], 20]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

(* Returns first n where det=0, or 0 if never singular *)
firstSingular[k_] := Module[{},
  Do[
    If[Det[fWM[n, k]] == 0, Return[n, Module]],
  {n, 3, nMax}];
  0  (* never singular *)
]

(* ================================================================ *)
Print["╔══════════════════════════════════════════════════════╗"];
Print["║  SHORT-CIRCUIT: k ∈ (0, 3.5], q ≤ 100, n=3..50     ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

rationals = Union[Flatten[
  Table[p/q, {q, 1, 100}, {p, 1, Ceiling[3.5 q]}]]];
rationals = Select[rationals, 0 < # <= 7/2 &];
rationals = SortBy[rationals, N];
Print["Total: ", Length[rationals], " rationals\n"];

neverSing = {};
t0 = AbsoluteTime[];
tested = 0;

Do[
  tested++;
  fs = firstSingular[k];
  If[fs == 0,
    AppendTo[neverSing, k];
    Print["  ★ k=", k, " = ", NumberForm[N[k], {8, 5}],
      "  q=", Denominator[k], "  NEVER SINGULAR"];
  ];
  (* Progress every 1000 *)
  If[Mod[tested, 1000] == 0,
    Print["  progress: ", tested, "/", Length[rationals],
      " (", Round[100. tested/Length[rationals]], "%)  elapsed: ",
      Round[AbsoluteTime[] - t0], "s  found: ", Length[neverSing]]],
{k, rationals}];

dt = AbsoluteTime[] - t0;
Print["\nDone: ", Round[dt], "s\n"];

Print["Never-singular in (0, 3.5]: ", Length[neverSing]];
If[Length[neverSing] > 0,
  Print["Smallest: ", First[neverSing], " = ", N[First[neverSing]]];
  Print["\nAll:"];
  cfE = Convergents[ContinuedFraction[E, 20]];
  cf2Pi = Convergents[ContinuedFraction[2 Pi, 20]];
  Do[
    labels = {};
    If[MemberQ[cfE, k], AppendTo[labels, "conv(e)"]];
    If[MemberQ[cf2Pi, k], AppendTo[labels, "conv(2π)"]];
    Print["  ", PaddedForm[ToString[k], 12], " = ",
      NumberForm[N[k], {10, 7}],
      "  CF=", ContinuedFraction[k],
      If[labels != {}, "  ← " <> StringRiffle[labels, ", "], ""]],
  {k, neverSing}];

  (* Distribution analysis *)
  Print["\nDenominators: ", Sort[Tally[Denominator /@ neverSing], #1[[2]] > #2[[2]] &]];
];
