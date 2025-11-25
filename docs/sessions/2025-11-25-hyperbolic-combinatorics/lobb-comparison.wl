(* Compare our coefficients with Lobb triangle *)

Print["=== LOBB TRIANGLE ===\n"];

(* Lobb formula: T(n,k) = (2k+1) * Binomial[2n, n-k] / (n+k+1) *)
lobbT[n_, k_] := (2*k + 1) * Binomial[2*n, n - k] / (n + k + 1)

Print["First rows of Lobb triangle:"];
Do[
  row = Table[lobbT[n, k], {k, 0, n}];
  Print["n=", n, ": ", row],
  {n, 0, 6}
];

Print["\n=== OUR COEFFICIENTS ===\n"];

Print["Our formula: 2^(i-1) * Poch[k-i+1, 2i] / (2i)!"];
Print["For fixed k, varying i:"];

ourCoeffs[kVal_] := Table[
  2^(i-1) * Pochhammer[kVal-i+1, 2*i] / Factorial[2*i],
  {i, 1, kVal}
]

Do[
  coeffs = ourCoeffs[kVal];
  Print["k=", kVal, ": ", coeffs],
  {kVal, 1, 6}
];

Print["\n=== COMPARISON ===\n"];

(* Are our coefficients a row/column/diagonal of Lobb? *)

(* Try diagonals *)
Print["Lobb diagonals (constant k):"];
Do[
  diag = Table[lobbT[n, kVal], {n, kVal, kVal + 5}];
  Print["k=", kVal, ": ", N[diag, 5]],
  {kVal, 0, 3}
];

Print["\nLobb rows (constant n):"];
Do[
  row = Table[lobbT[nVal, k], {k, 0, nVal}];
  Print["n=", nVal, ": ", N[row, 5]],
  {nVal, 1, 6}
];

Print["\n=== PATTERN MATCH TEST ===\n"];

(* Check if our {6, 10, 4} matches any Lobb structure *)
target = {6, 10, 4};
Print["Looking for: ", target];

found = False;
Do[
  row = Table[lobbT[n, k], {k, 0, n}];
  If[Length[row] >= 3 && Take[row, 3] == target,
    Print["MATCH: Lobb row n=", n, " first 3 terms"];
    found = True
  ],
  {n, 0, 10}
];

If[!found,
  Print["No direct match in first 10 rows"];
  Print["Trying subsequences..."];
  
  Do[
    row = Table[lobbT[n, k], {k, 0, n}];
    If[MemberQ[Partition[row, 3, 1], target],
      Print["FOUND as consecutive subsequence in row n=", n]
    ],
    {n, 3, 10}
  ];
];

Print["\n=== RELATIONSHIP TO (2k+1) FACTOR ===\n"];

(* Lobb has (2k+1) factor, our hyperbolic has (1+2k) in argument *)
Print["Our identity: Cosh[(1+2k)*ArcSinh[...]] <-> factorial series"];
Print["Lobb formula: (2k+1) * ..."];
Print["Same factor (1+2k)! This might not be coincidence.\n"];

Print["Hypothesis: Factorial series might be related to"];
Print["weighted sum over Lobb triangle entries"];

