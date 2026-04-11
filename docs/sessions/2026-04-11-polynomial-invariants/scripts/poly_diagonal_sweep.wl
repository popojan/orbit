<< Orbit`

(* Diagonal counts under y <= kx for k = 1, 2, 3, ... *)
(* BeattyBallotCount[1/k, {n, n}] = paths from (1,0) to (n,n) under Floor[kx] *)

Print["=== Diagonal sequences under y <= kx ==="];
Print[""];

Do[
  vals = Table[BeattyBallotCount[1/k, {n, n}], {n, 1, 15}];
  Print["k=", k, ": ", vals];,
  {k, 1, 7}
];

Print[""];
Print["=== k=1: should be Catalan-related ==="];
Print["Catalan: ", Table[CatalanNumber[n], {n, 1, 15}]];
Print["Ballot B(n,n): ", Table[Binomial[2n-1,n]/n, {n,1,15}]];

vals1 = Table[BeattyBallotCount[1, {n, n}], {n, 1, 15}];
Print["k=1 actual: ", vals1];

Print[""];
Print["=== OEIS search strings ==="];
Do[
  vals = Table[BeattyBallotCount[1/k, {n, n}], {n, 1, 10}];
  Print["k=", k, ": ", StringRiffle[ToString /@ vals, ","]];,
  {k, 1, 5}
];
