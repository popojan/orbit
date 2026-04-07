(* Pell-Ballot: Brute-force enumeration for small cases *)
(* Enumerates ALL permutations of right/up steps, checks hyperbola constraint *)
(* Only feasible for small x1+y1 (up to ~12) *)

<< Orbit`

(* Count by enumeration: all orderings of nR rights + nU ups *)
countPathsEnum[d_Integer, {x1_Integer, y1_Integer}] := Module[
  {nR = x1 - 1, nU = y1, base, perms, valid = 0},
  base = Join[Table[1, nR], Table[0, nU]];  (* 1=right, 0=up *)
  perms = DeleteDuplicates[Permutations[base]];
  Do[
    Module[{u = 1, r = 0, ok = True},
      Do[
        If[perm[[k]] == 1, u++, r++];
        If[u^2 - d r^2 < 1, ok = False; Break[]],
      {k, nR + nU}];
      If[ok, valid++]
    ],
  {perm, perms}];
  valid
]

(* Example: D=2 with full path listing *)
Print["=== D=2: all paths from (1,0) to (3,2) ==="];
d = 2; x1 = 3; y1 = 2;
base = Join[Table[1, x1 - 1], Table[0, y1]];
perms = DeleteDuplicates[Permutations[base]];
Do[
  Module[{u = 1, r = 0, pts = {{1, 0}}, ok = True, vals = {1}},
    Do[
      If[perm[[k]] == 1, u++, r++];
      AppendTo[pts, {u, r}];
      AppendTo[vals, u^2 - d r^2];
      If[u^2 - d r^2 < 1, ok = False],
    {k, Length[perm]}];
    Print[StringJoin[If[# == 1, "R", "U"] & /@ perm],
          "  ", pts, "  u^2-2r^2=", vals,
          If[ok, "  VALID", "  crosses"]]
  ],
{perm, perms}];
Print[""];
Print["Valid: ", countPathsEnum[2, {3, 2}], " = C_2 = ", CatalanNumber[2]];
