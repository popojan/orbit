<< Orbit`

(* k=3: paths from (1,0) to (n,n) under y <= 3x *)
(* Compute enough terms for asymptotic analysis *)

Print["=== k=3 diagonal sequence ==="];
vals3 = Table[BeattyBallotCount[1/3, {n, n}], {n, 1, 25}];
Print["a(n): ", vals3];
Print[""];

(* Asymptotic: a(n) ~ C * 4^n / n^(3/2) *)
(* Extract C by looking at a(n) * sqrt(n) / 4^n *)
Print["=== Asymptotic analysis ==="];
Print["a(n) * Sqrt[n] / 4^n:"];
asymp = Table[{n, N[vals3[[n]] Sqrt[n] / 4^n, 20]}, {n, 15, 25}];
Do[Print["  n=", a[[1]], ": ", a[[2]]], {a, asymp}];

Print[""];
Print["Limit should be C/Sqrt[Pi] for some C"];
Print["a(25)*Sqrt[25]/4^25 = ", N[vals3[[25]] Sqrt[25] / 4^25, 20]];
Print["times Sqrt[Pi] = ", N[vals3[[25]] Sqrt[25 Pi] / 4^25, 20]];

Print[""];
Print["=== Compare with 1/phi^2 for k=2 ==="];
Print["1/phi^2 = ", N[1/GoldenRatio^2, 20]];
Print[""];

(* For k=2, asymptotic constant is 1/phi^2 *)
(* Let's compute the k=2 constant too for verification *)
vals2 = Table[BeattyBallotCount[1/2, {n, n}], {n, 1, 25}];
Print["k=2: a(25)*Sqrt[25*Pi]/4^25 = ", N[vals2[[25]] Sqrt[25 Pi] / 4^25, 20]];
Print["1/phi^2 = ", N[1/GoldenRatio^2, 20]];
Print["Match: ", Abs[N[vals2[[25]] Sqrt[25 Pi] / 4^25 - 1/GoldenRatio^2, 20]] < 0.001];

Print[""];
Print["=== k=3 constant identification ==="];
c3 = N[vals3[[25]] Sqrt[25 Pi] / 4^25, 20];
Print["k=3 approx constant: ", c3];
Print[""];

(* Try algebraic numbers *)
Print["Candidates:"];
Print["  1/2 = ", N[1/2, 20]];
Print["  1/3 = ", N[1/3, 20]];
Print["  1/sqrt(2) = ", N[1/Sqrt[2], 20]];
Print["  1/sqrt(3) = ", N[1/Sqrt[3], 20]];
Print["  2/3 = ", N[2/3, 20]];
Print["  1/phi = ", N[1/GoldenRatio, 20]];
Print["  1/phi^2 = ", N[1/GoldenRatio^2, 20]];
Print["  (sqrt(5)-1)/2 = ", N[(Sqrt[5]-1)/2, 20]];
Print[""];

(* Use RootApproximant to identify *)
Print["RootApproximant: ", RootApproximant[c3, 6]];
Print["MinimalPolynomial: ", MinimalPolynomial[RootApproximant[c3, 6], x]];

Print[""];
Print["=== More terms for better convergence ==="];
vals3big = Table[BeattyBallotCount[1/3, {n, n}], {n, 1, 35}];
c3big = N[vals3big[[35]] Sqrt[35 Pi] / 4^35, 30];
Print["k=3 constant (n=35): ", c3big];
Print["RootApproximant: ", RootApproximant[c3big, 8]];

Print[""];
Print["=== All k constants ==="];
Print[""];
Do[
  vals = Table[BeattyBallotCount[1/k, {n, n}], {n, 1, 30}];
  ck = N[vals[[30]] Sqrt[30 Pi] / 4^30, 20];
  approx = RootApproximant[ck, 8];
  Print["k=", k, ": C ~ ", ck, "  RootApproximant: ", approx,
    "  MinPoly: ", MinimalPolynomial[approx, x]];,
  {k, 1, 7}
];
