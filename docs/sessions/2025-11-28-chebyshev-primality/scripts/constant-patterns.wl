(* Find which b patterns give constant Σsigns *)

Print["=== Analyzing constant patterns ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Collect more data with larger range *)
data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
    c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
    c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
    {b1, b2, b3} = Mod[{c1, c2, c3}, 2];
    AppendTo[data, <|
      "p1" -> p1, "p2" -> p2, "p3" -> p3,
      "k" -> k, "ss" -> ss, "b" -> {b1, b2, b3}
    |>]
  ],
  {p1, Prime[Range[2, 10]]},
  {p2, Prime[Range[3, 15]]},
  {p3, Prime[Range[4, 20]]}
];

Print["Total cases: ", Length[data], "\n"];

(* Check each b pattern *)
byB = GroupBy[data, #["b"] &];
Print["=== Results by b pattern ===\n"];

constantPatterns = {};
Do[
  subset = byB[b];
  ssVals = Union[#["ss"] & /@ subset];
  isConstant = Length[ssVals] == 1;
  If[isConstant,
    AppendTo[constantPatterns, b -> First[ssVals]];
    Print["b = ", b, ": CONSTANT ss = ", First[ssVals], " (", Length[subset], " cases)"],
    Print["b = ", b, ": ss ∈ ", ssVals, " (", Length[subset], " cases)"]
  ],
  {b, Sort[Keys[byB]]}
];

Print["\n=== Constant patterns summary ==="];
Print[constantPatterns];

(* Why is b = (0,1,1) constant? Let's analyze *)
Print["\n=== Deep dive: b = (0,1,1) ===\n"];

subset = Select[data, #["b"] == {0, 1, 1} &];
Do[
  d = subset[[i]];
  {p1, p2, p3} = {d["p1"], d["p2"], d["p3"]};
  k = p1 p2 p3;

  (* Compute detailed structure *)
  c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
  c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
  c3 = p1 p2 * PowerMod[p1 p2, -1, p3];

  (* Count signatures by parity of (a2 + a3) since b1=0 *)
  parityCount = <|"even" -> 0, "odd" -> 0|>;
  Do[
    sumParity = Mod[a2 + a3, 2];
    If[sumParity == 0,
      parityCount["even"]++,
      parityCount["odd"]++
    ],
    {a2, 2, p2 - 1},
    {a3, 2, p3 - 1}
  ];

  (* Number of primitive sigs (a1 only has one choice for p1=3) *)
  numPrimSigs = (p1 - 2) * (p2 - 2) * (p3 - 2);

  If[i <= 10,
    Print[p1, "*", p2, "*", p3, ":"];
    Print["  Naive parity count (ignoring mod k): even=", parityCount["even"],
          " odd=", parityCount["odd"]];
    Print["  Naive diff: ", parityCount["odd"] - parityCount["even"],
          " (for a1 choices: ", p1 - 2, ")"];
    Print["  Expected from naive: ", (p1 - 2) * (parityCount["odd"] - parityCount["even"])];
    Print["  But actual ss = ", d["ss"]];
    Print[""]
  ],
  {i, Length[subset]}
];

(* Pattern: when b=(0,1,1), the naive formula gives something,
   but actual is always -1. Why? *)

Print["\n=== Trying to understand the carry correction ===\n"];

(* For p1=3, analyze carry in detail *)
subset3 = Select[subset, #["p1"] == 3 &];
Print["For p1=3 with b=(0,1,1):"];

d = subset3[[1]];
{p1, p2, p3} = {d["p1"], d["p2"], d["p3"]};
k = p1 p2 p3;
c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
c3 = p1 p2 * PowerMod[p1 p2, -1, p3];

Print["Example: ", p1, "*", p2, "*", p3, " = ", k];
Print["c1 = ", c1, ", c2 = ", c2, ", c3 = ", c3];
Print[""];

(* Detailed signature analysis *)
oddCount = 0; evenCount = 0;
Do[
  S = a1 c1 + a2 c2 + a3 c3;
  n = Mod[S, k];
  carry = Quotient[S, k];
  nParity = Mod[n, 2];
  sParity = Mod[S, 2];

  If[nParity == 1, oddCount++, evenCount++],
  {a1, 2, p1 - 1},
  {a2, 2, p2 - 1},
  {a3, 2, p3 - 1}
];

Print["Odd n: ", oddCount, ", Even n: ", evenCount];
Print["Σsigns = ", oddCount - evenCount];

(* Check if there's a relationship to ω=2 formulas *)
Print["\n=== Connection to ω=2 ===\n"];

(* For ω=2: Σsigns(pq) = +1 if p^{-1} mod q is odd, -3 if even *)
Print["Checking if ω=3 relates to ω=2 subproducts:"];

Do[
  d = subset[[i]];
  {p1, p2, p3} = {d["p1"], d["p2"], d["p3"]};

  (* ω=2 results for subproducts *)
  inv12 = PowerMod[p1, -1, p2];
  inv13 = PowerMod[p1, -1, p3];
  inv21 = PowerMod[p2, -1, p1];
  inv23 = PowerMod[p2, -1, p3];
  inv31 = PowerMod[p3, -1, p1];
  inv32 = PowerMod[p3, -1, p2];

  ss12 = If[OddQ[inv12], 1, -3];
  ss13 = If[OddQ[inv13], 1, -3];
  ss23 = If[OddQ[inv23], 1, -3];

  If[i <= 10,
    Print[p1, "*", p2, "*", p3, ": ss=", d["ss"]];
    Print["  ss(", p1, "*", p2, ")=", ss12, " ss(", p1, "*", p3, ")=", ss13,
          " ss(", p2, "*", p3, ")=", ss23];
    Print["  Sum of subproduct ss: ", ss12 + ss13 + ss23];
    Print["  Product: ", ss12 * ss13 * ss23];
    Print[""]
  ],
  {i, Length[subset]}
];
