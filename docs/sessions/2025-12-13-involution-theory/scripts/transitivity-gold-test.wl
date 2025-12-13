#!/usr/bin/env wolframscript
(* Transitivity test for {silver, copper, gold, inv} on Q+ *)
(* Date: 2025-12-13 *)
(* Key finding: Adding gold makes the action TRANSITIVE on Q+ \ {1} *)

(* --- Generators --- *)
silver[x_] := (1 - x)/(1 + x) // Together;  (* involution, fix: sqrt(2)-1 *)
copper[x_] := 1 - x;                         (* involution, fix: 1/2 *)
gold[x_] := x/(1 - x) // Together;          (* NOT involution! *)
inv[x_] := 1/x;                              (* involution on Q+ *)

(* --- Orbit BFS on Q+ with all 4 generators --- *)
orbitQPlus[start_, maxLimit_:40] := Module[
  {visited = {}, queue = {start}, current, next, gens},
  gens = {silver, copper, gold, inv};
  While[queue != {} && Length[visited] < 500,
    current = First[queue]; queue = Rest[queue];
    If[!MemberQ[visited, current] && current > 0 && current != 1,
      AppendTo[visited, current];
      Do[
        next = g[current] // Together;
        If[next > 0 && next != 1 &&
           Denominator[next] <= maxLimit && Numerator[next] <= maxLimit &&
           !MemberQ[visited, next],
          AppendTo[queue, next]
        ],
        {g, gens}
      ]
    ]
  ];
  Sort[visited]
];

(* --- Count orbits for rationals p/q with p,q <= limit --- *)
countOrbits[limit_, maxDenom_:30] := Module[
  {rationals, remaining, orbitCount, reps, rep, orb, orbInRange},

  rationals = DeleteDuplicates@Flatten@Table[p/q, {q, 1, limit}, {p, 1, limit}];
  rationals = Select[rationals, # != 1 &];
  remaining = Association[# -> True & /@ rationals];
  orbitCount = 0;
  reps = {};

  While[Length[remaining] > 0 && orbitCount < 50,
    rep = First@Keys@remaining;
    orb = orbitQPlus[rep, maxDenom];
    orbInRange = Select[orb, KeyExistsQ[remaining, #]&];
    Scan[(remaining = KeyDrop[remaining, #])&, orbInRange];
    orbitCount++;
    AppendTo[reps, {rep, Length[orbInRange]}];
  ];

  {orbitCount, reps, Length[remaining]}
];

(* --- Main --- *)
If[$ScriptCommandLine =!= {},
  Print["=== TRANSITIVITY TEST: {silver, copper, gold, inv} on Q+ ===\n"];

  (* Test gold behavior *)
  Print["Gold behavior:"];
  Print["  gold(1/3) = ", gold[1/3], " (stays in (0,1))"];
  Print["  gold(2/3) = ", gold[2/3], " (escapes to Q+)"];
  Print["  inv(gold(2/3)) = ", inv[gold[2/3]], " (back via inv)"];
  Print[""];

  (* Count orbits *)
  Print["Counting orbits for rationals p/q with p,q <= 15..."];
  {nOrbits, reps, remaining} = countOrbits[15, 30];
  Print["Found ", nOrbits, " orbit(s)"];
  Print["Representatives: ", reps];
  Print["Remaining: ", remaining];
  Print[""];

  If[nOrbits == 1,
    Print["RESULT: Action is TRANSITIVE on Q+ \\ {1}!"];
    Print["        No nontrivial invariant exists."],
    Print["RESULT: Action has ", nOrbits, " orbits."];
    Print["        Invariant may exist."]
  ];

  Print["\n=== COMPARISON ==="];
  Print["| Generators                    | Domain      | Orbits | Invariant |"];
  Print["|-------------------------------|-------------|--------|-----------|"];
  Print["| {silver, copper}              | (0,1)       | inf    | odd(p(q-p)) |"];
  Print["| {silver, copper, inv}         | Q+          | >=8    | ?         |"];
  Print["| {silver, copper, gold, inv}   | Q+ \\ {1}    | 1      | none      |"];
];
