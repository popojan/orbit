#!/usr/bin/env wolframscript
(*
Verify x == -1 (mod n) pattern for multiple n
*)

Print["=" * 70];
Print["VERIFY: x == -1 (mod n) PATTERN"];
Print["=" * 70];
Print[];

testValues = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61};

results = Table[
  Module[{sol, x, y, xMod},
    sol = Solve[x^2 - n*y^2 == 1 && x > 0 && y > 0 && x < 10^15, {x, y}, Integers];
    If[Length[sol] > 0,
      {x, y} = {x, y} /. sol[[1]];
      xMod = Mod[x, n];
      {n, x, y, xMod, xMod == n - 1, Mod[2 + x, n]}
    ,
      {n, "No solution found", "-", "-", False, "-"}
    ]
  ],
  {n, testValues}
];

Print["n\tx\ty\tx mod n\tx==-1?\t(2+x) mod n"];
Print["-" * 70];
Do[
  {n, x, y, xMod, isMinusOne, twoPlus} = result;
  Print[n, "\t", x, "\t", y, "\t", xMod, "\t", isMinusOne, "\t", twoPlus];
  ,
  {result, results}
];

Print[];
Print["=" * 70];
Print["SUMMARY"];
Print["=" * 70];
Print[];

numMinusOne = Count[results, {_, _, _, _, True, _}];
total = Length[results];

Print["Cases where x == -1 (mod n): ", numMinusOne, " out of ", total];
Print[];

(* Analyze which ones are -1 *)
minusOneCase = Select[results, #[[5]] == True &];
plusOneCase = Select[results, #[[4]] == 1 &];

Print["n where x == -1 (mod n): ", minusOneCase[[All, 1]]];
Print["n where x == +1 (mod n): ", plusOneCase[[All, 1]]];
Print[];

(* Check correlation with (2+x) mod n *)
Print["For x == -1 cases, (2+x) mod n values:"];
Print[minusOneCase[[All, {1, 6}]]];
Print[];

Print["For x == +1 cases, (2+x) mod n values:"];
If[Length[plusOneCase] > 0,
  Print[plusOneCase[[All, {1, 6}]]];
,
  Print["  (none)"];
];

Print[];
Print["=" * 70];
