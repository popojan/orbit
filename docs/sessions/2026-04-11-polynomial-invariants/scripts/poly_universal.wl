<< Orbit`

alpha = Sqrt[2]; w = 1;
vLin[nn_, ww_, j_] := (nn - ww j)/nn Binomial[nn + j - 1, j]

convs = Convergents[alpha, 12];
pNums = Numerator /@ convs;    (* 1, 3, 7, 17, 41, 99, 239, 577, ... *)
qDens = Denominator /@ convs;  (* 1, 2, 5, 12, 29, 70, 169, 408, ... *)

Print["p_k: ", pNums];
Print["q_k: ", qDens];
Print[""];

(* ============================================================ *)
(* UNIVERSALITY: the polynomial at height j is window-independent *)
(* This means P_j(n; alpha) is a well-defined function of alpha  *)
(* ============================================================ *)

Print["=== CONFIRMED: P_j(n) is universal (window-independent) ==="];
Print[""];

(* ============================================================ *)
(* KEY QUESTION: What do P_j values at convergent numerators give? *)
(* ============================================================ *)

Print["=== P_j evaluated at convergent numerators ==="];
Print[""];

(* Compute P_j for several heights *)
Do[
  height = qDens[[j + 1]]; (* q_j *)
  (* compute from a window large enough *)
  kUse = j + 3; (* need window [p_{k-2}, p_{k-1}] with height = q_{k-2} *)
  If[kUse > 10, Continue[]];
  cv = Convergents[alpha, kUse];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  row = BeattyBallotCount[alpha, All, {maxPos, height}];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  poly = InterpolatingPolynomial[pts, n] // Expand;

  Print["height j=", j, " (q_j=", height, "):"];

  (* Evaluate at each convergent numerator p_i *)
  Do[
    pk = pNums[[i]];
    If[pk < 2 || pk > maxPos + 100, Continue[]];
    val = poly /. n -> pk;
    (* compare with vLin *)
    vlinVal = vLin[pk, w, height];
    ballot = If[height > 0, Binomial[pk + height - 1, height]/pk, 1];
    Print["  P(p_", i - 1, "=", pk, ") = ", val,
      If[val === vlinVal, "  = vLin", ""],
      If[val === ballot, "  = B(p,q)", ""],
      If[val === 0, "  = 0", ""]
    ];,
    {i, 1, Min[10, Length[pNums]]}
  ];
  Print[""];,
  {j, 1, 6}
];

(* ============================================================ *)
(* Structure of Q(n) via its roots                               *)
(* ============================================================ *)

Print["=== Roots of Q(n) = j! * P_j(n) / (n - intRoot) ==="];
Print[""];

Do[
  height = qDens[[j + 1]];
  kUse = j + 3;
  If[kUse > 9, Continue[]];
  cv = Convergents[alpha, kUse];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  row = BeattyBallotCount[alpha, All, {maxPos, height}];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  poly = InterpolatingPolynomial[pts, n] // Expand;

  intPoly = Expand[height! * poly];
  intRoot = Ceiling[height * alpha] - 1;
  quotient = PolynomialQuotient[intPoly, n - intRoot, n];

  roots = NSolve[quotient == 0, n, 20];
  rootVals = Sort[n /. roots, Re[#1] < Re[#2] &];

  Print["j=", j, " (q_j=", height, ", int root=", intRoot, "):"];
  Print["  Q roots: ", N[rootVals, 8]];

  (* Check: are any roots close to -p_k values? *)
  negPNums = -pNums;
  Print["  -p_k values: ", Take[negPNums, Min[8, Length[negPNums]]]];
  Print[""];,
  {j, 1, 5}
];

(* ============================================================ *)
(* Self-similar structure: ratio of polynomials at adjacent levels *)
(* ============================================================ *)

Print["=== Polynomial at p_{k} for successive heights ==="];
Print["(values at p_5=99)"];
Print[""];

row99 = BeattyBallotCount[alpha, All, {239, 70}];
Do[
  val = row99[[99, j + 1]];  (* this won't work, need different approach *)
  0;,  (* placeholder *)
  {j, 0, 5}
];

(* Actually compute column at n=99 for various heights *)
Do[
  val = BeattyBallotCount[alpha, {99, j}];
  ballot = If[j > 0, Binomial[99 + j - 1, j]/99, 1];
  vlin = vLin[99, w, j];
  Print["  v_", j, "(99) = ", val,
    "  vLin=", vlin,
    "  ballot=", ballot,
    "  ratio v/B=", If[ballot != 0, val/ballot // FullSimplify, "n/a"]];,
  {j, 0, 10}
];
