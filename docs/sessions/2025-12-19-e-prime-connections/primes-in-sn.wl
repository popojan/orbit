(* Primes dividing the e-convergent denominators s_n *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["   PRIMES DIVIDING THE E-CONVERGENT SEQUENCE s_n                   "];
Print["═══════════════════════════════════════════════════════════════════\n"];

(* Define s_n sequence *)
s[0] = 1; s[-1] = 1;
Do[s[n] = (4 n + 2) s[n - 1] + s[n - 2], {n, 1, 500}];

Print["First 15 terms of s_n:"];
Print[Table[s[n], {n, 0, 14}], "\n"];

(* === PART 1: Rank of apparition for small primes === *)
Print["═══ PART 1: RANK OF APPARITION ═══\n"];
Print["For each prime p, find the smallest n > 0 such that p | s_n\n"];

rankOfApparition[p_, maxN_: 500] := Module[{n},
  SelectFirst[Range[maxN], Divisible[s[#], p] &, "none"]
];

primes = Prime[Range[30]];
ranks = Table[{p, rankOfApparition[p]}, {p, primes}];

Print["Prime p → First n with p | s_n:"];
Do[
  {p, r} = ranks[[i]];
  Print["  ", p, " → n = ", r, "  (s_", r, " mod ", p, " = ", Mod[s[r], p], ")"];
, {i, Length[ranks]}];

(* === PART 2: Pattern analysis === *)
Print["\n═══ PART 2: DIVISIBILITY PATTERNS ═══\n"];

analyzeModP[p_, maxN_: 200] := Module[{zeros},
  zeros = Select[Range[0, maxN], Mod[s[#], p] == 0 &];
  {p, zeros, Union[Mod[zeros, p]]}
];

Print["For each prime, positions where p | s_n and their residues mod p:\n"];
Do[
  p = Prime[i];
  {pp, zeros, residues} = analyzeModP[p, 150];
  If[Length[zeros] > 0,
    Print["p = ", p, ":"];
    Print["  Zeros at n = ", Take[zeros, Min[10, Length[zeros]]],
          If[Length[zeros] > 10, " ...", ""]];
    Print["  n mod ", p, " = ", residues];
    (* Check if periodic *)
    If[Length[zeros] >= 2,
      diffs = Differences[zeros];
      If[Length[Union[diffs]] == 1,
        Print["  Period: ", diffs[[1]]];
        ,
        Print["  Differences: ", Take[diffs, Min[8, Length[diffs]]]];
      ];
    ];
    Print[""];
  ];
, {i, 1, 15}];

(* === PART 3: Looking for structure === *)
Print["═══ PART 3: STRUCTURE ANALYSIS ═══\n"];

(* Count zeros in each residue class *)
Print["Number of n with p | s_n for n in [0, 200], by residue class:\n"];

countByResidue[p_, maxN_: 200] := Module[{zeros, counts},
  zeros = Select[Range[0, maxN], Mod[s[#], p] == 0 &];
  counts = Counts[Mod[zeros, p]];
  {p, counts}
];

Do[
  p = Prime[i];
  {pp, counts} = countByResidue[p];
  If[Length[counts] > 0,
    Print["p = ", p, ": ", counts];
  ];
, {i, 1, 10}];

(* === PART 4: Connection to (Z/pZ)* structure === *)
Print["\n═══ PART 4: GROUP-THEORETIC ANALYSIS ═══\n"];

Print["For p | s_n, are the residue classes related to (Z/pZ)* structure?\n"];

Do[
  p = Prime[i];
  zeros = Select[Range[0, 200], Mod[s[#], p] == 0 &];
  residues = Union[Mod[zeros, p]];

  If[Length[residues] > 0 && Length[residues] < p,
    (* Check if residues form a subgroup or coset *)
    order = p - 1; (* |(Z/pZ)*| *)
    Print["p = ", p, ": zeros at n ≡ ", residues, " (mod ", p, ")"];
    Print["  |zero classes| = ", Length[residues], ", φ(", p, ") = ", order];

    (* Check quadratic residues *)
    qr = Select[Range[p - 1], JacobiSymbol[#, p] == 1 &];
    nqr = Select[Range[p - 1], JacobiSymbol[#, p] == -1 &];

    resInQR = Intersection[residues, qr];
    resInNQR = Intersection[residues, nqr];

    Print["  Quadratic residues: ", qr];
    Print["  Zero classes in QR: ", resInQR, ", in NQR: ", resInNQR];
    Print[""];
  ];
, {i, 2, 8}]; (* Skip p=2 *)

(* === PART 5: Special focus on 7 and 11 === *)
Print["═══ PART 5: THE SPECIAL PRIMES 7 AND 11 ═══\n"];

Print["Detailed analysis of s_n mod 7:"];
seq7 = Table[Mod[s[n], 7], {n, 0, 50}];
Print["s_n mod 7 for n = 0..50:"];
Print[seq7];
Print["Period: ", FindRepeat[seq7][[1]] // Length, "\n"];

Print["Detailed analysis of s_n mod 11:"];
seq11 = Table[Mod[s[n], 11], {n, 0, 60}];
Print["s_n mod 11 for n = 0..60:"];
Print[seq11];
Print["Period: ", FindRepeat[seq11][[1]] // Length, "\n"];

Print["Combined mod 77:"];
seq77 = Table[Mod[s[n], 77], {n, 0, 100}];
zeros77 = Select[Range[0, 100], Mod[s[#], 77] == 0 &];
Print["s_n ≡ 0 (mod 77) at n = ", zeros77];
Print["These are n ≡ ", Union[Mod[zeros77, 77]], " (mod 77)"];
