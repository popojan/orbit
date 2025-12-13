#!/usr/bin/env wolframscript
(* Safe BFS orbit analysis with denominator limit *)
(* Date: 2025-12-13 *)
(* Purpose: Explore orbits under Möbius involutions without memory explosion *)

(* --- Core definitions --- *)

oddPart[n_] := n / 2^IntegerExponent[n, 2]

(* Orbit invariant: odd part of p(q-p) *)
(* NOTE: This invariant is ONLY preserved by {silver, copper} *)
(*       It is BROKEN by golden and gamma4! *)
orbitInvariant[p_, q_] := oddPart[p * (q - p)]
orbitInvariant[r_Rational] := orbitInvariant[Numerator[r], Denominator[r]]

(* --- All 4 Möbius involutions --- *)
(* Each f satisfies f(f(x)) = x *)

silver[x_] := (1 - x)/(1 + x) // Together;  (* Cayley transform, fix: √2-1 *)
copper[x_] := 1 - x;                         (* Reflection, fix: 1/2 *)
golden[x_] := (2 - x)/(2x + 1) // Together; (* fix: 1/φ = (√5-1)/2 *)
gamma4[x_] := (1 - 2x)/(2 - x) // Together; (* fix: 2-√3 *)

(* NOTE: gold = x/(1-x) is NOT an involution! (gold² ≠ id) *)

(* --- Safe BFS with denominator limit --- *)
(* CRITICAL: Without maxDenom limit, orbits are INFINITE and will eat all memory! *)

orbitBFS[start_, maxDenom_:100] := Module[
  {visited = {}, queue = {start}, x, sx, cx},
  While[queue != {},
    x = First[queue]; queue = Rest[queue];
    If[!MemberQ[visited, x] && 0 < x < 1,
      AppendTo[visited, x];
      sx = silver[x]; cx = copper[x];
      If[Denominator[sx] <= maxDenom && 0 < sx < 1, AppendTo[queue, sx]];
      If[Denominator[cx] <= maxDenom && 0 < cx < 1, AppendTo[queue, cx]];
    ]
  ];
  Sort[visited]
]

(* --- Find all orbits for rationals with q <= maxQ --- *)

findAllOrbits[maxQ_, maxDenom_:100] := Module[
  {rationals, remaining, orbitsFound, rep, orb, orbInRange},
  rationals = DeleteDuplicates@Flatten@Table[p/q, {q, 2, maxQ}, {p, 1, q-1}];
  remaining = rationals;
  orbitsFound = {};

  While[remaining != {},
    rep = First[remaining];
    orb = orbitBFS[rep, maxDenom];
    orbInRange = Select[orb, MemberQ[rationals, #] &];
    AppendTo[orbitsFound, {
      orbitInvariant[rep],
      orbInRange
    }];
    remaining = Complement[remaining, orbInRange];
  ];

  SortBy[orbitsFound, First]
]

(* --- Example usage --- *)

If[$ScriptCommandLine =!= {},
  Print["=== SAFE ORBIT BFS ANALYSIS ===\n"];

  (* Test orbit of 7/11 *)
  orb = orbitBFS[7/11, 50];
  Print["Orbit of 7/11 (maxDenom=50): ", Length[orb], " elements"];
  Print["Elements: ", orb];
  Print["All have invariant=", orbitInvariant[7/11], "? ",
    Union[orbitInvariant /@ orb]];
  Print[""];

  (* Find all orbits for small rationals *)
  Print["Finding orbits for q ≤ 12..."];
  orbits = findAllOrbits[12, 50];
  Print["Found ", Length[orbits], " orbits\n"];

  Do[
    {inv, members} = o;
    Print["  inv=", inv, ": ", members],
    {o, orbits}
  ];
]
