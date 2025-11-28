(* Lissajous pattern at BOTH Wilson points *)

Print["==============================================================="]
Print["  LISSAJOUS AT BOTH WILSON POINTS"]
Print["==============================================================="]
Print[""]

f[n_, i_] := Product[n^2 - j^2, {j, 1, i}]

n = 143;
{p, q} = {11, 13};

(* Diagonality: 0 = perfect y = -x, > 0 = scattered *)
diagonality[fVal_, d_] := Module[{r, sum},
  r = Mod[fVal, d];
  If[r == 0, Return[-1]];  (* d | f, mark as -1 *)
  sum = Sum[(Sin[2 Pi k r/d] + Sin[2 Pi k/d])^2, {k, 1, d - 1}];
  sum/(d - 1)
]

Print["1. AT i = 5 (Wilson point for p = 11)"]
Print["==============================================================="]
Print[""]

i = 5;
fVal = f[n, i];
Print["f(143, ", i, ") mod 11 = ", Mod[fVal, 11], " (expect 10 = p-1)"]
Print["f(143, ", i, ") mod 13 = ", Mod[fVal, 13], " (expect ? != 12)"]
Print[""]

Print["Diagonality at i = 5:"]
Do[
  diag = diagonality[fVal, d];
  divN = Divisible[n, d];
  label = If[diag == -1, "(d|f)", If[diag < 0.01, "DIAGONAL!", "scattered"]];
  Print["  d=", d, ": diag=", If[diag == -1, "N/A", N[diag, 4]], " ", label, If[divN, " <- factor", ""]],
  {d, {7, 11, 13, 17, 19}}
]
Print[""]

Print["2. AT i = 6 (Wilson point for q = 13)"]
Print["==============================================================="]
Print[""]

i = 6;
fVal = f[n, i];
Print["f(143, ", i, ") mod 11 = ", Mod[fVal, 11], " (expect ? != 10)"]
Print["f(143, ", i, ") mod 13 = ", Mod[fVal, 13], " (expect 12 = q-1)"]
Print[""]

Print["Diagonality at i = 6:"]
Do[
  diag = diagonality[fVal, d];
  divN = Divisible[n, d];
  label = If[diag == -1, "(d|f)", If[diag < 0.01, "DIAGONAL!", "scattered"]];
  Print["  d=", d, ": diag=", If[diag == -1, "N/A", N[diag, 4]], " ", label, If[divN, " <- factor", ""]],
  {d, {7, 11, 13, 17, 19}}
]
Print[""]

Print["3. SUM OF DIAGONALITIES OVER i"]
Print["==============================================================="]
Print[""]

Print["For each d, sum diagonality over i = 1 to 10:"]
Do[
  totalDiag = 0;
  diagonalCount = 0;
  Do[
    fVal = f[n, i];
    diag = diagonality[fVal, d];
    If[diag >= 0 && diag < 0.01, diagonalCount++];
    If[diag >= 0, totalDiag += diag],
    {i, 1, 10}
  ];
  divN = Divisible[n, d];
  Print["  d=", d, ": diagonal at ", diagonalCount, " positions", If[divN, " <- factor", ""]],
  {d, {7, 11, 13, 17, 19, 23}}
]
Print[""]

Print["4. KEY INSIGHT"]
Print["==============================================================="]
Print[""]

Print["Factors have EXACTLY ONE diagonal point (their Wilson point)!"]
Print["Non-factors have ZERO diagonal points."]
Print[""]

Print["Detection: d is factor iff there exists i such that"]
Print["           diagonality(f(n,i), d) = 0"]
Print["           This happens at i = (d-1)/2"]
Print[""]

Print["5. CAN WE DETECT WITHOUT SCANNING i?"]
Print["==============================================================="]
Print[""]

Print["The diagonal condition y = -x means:"]
Print["  sin(2 pi k r/d) = -sin(2 pi k/d) for all k"]
Print["  <==> r = d-1 (mod d)"]
Print["  <==> f(n,i) = d-1 (mod d)"]
Print[""]

Print["By Wilson: f(n, (d-1)/2) = d-1 (mod d) iff d | n (prime d)"]
Print[""]

Print["So the diagonal test at i = (d-1)/2 is EQUIVALENT to:"]
Print["  f(n, (d-1)/2) mod d == d-1"]
Print[""]

Print["This is our original formula! The Lissajous view is just"]
Print["a geometric interpretation of the Wilson detection."]
Print[""]

Print["6. AGGREGATE OVER ALL d?"]
Print["==============================================================="]
Print[""]

Print["What if we compute Sum_d [indicator of diagonal at (d-1)/2]?"]
Print[""]

countDiagonals = 0;
factorsFound = {};
Do[
  i = (d - 1)/2;
  If[IntegerQ[i] && i >= 1,
    fVal = f[n, i];
    r = Mod[fVal, d];
    If[r == d - 1,  (* Wilson condition *)
      countDiagonals++;
      AppendTo[factorsFound, d];
    ]
  ],
  {d, 3, 50, 2}  (* odd d only *)
]

Print["Diagonal patterns found for d in 3..50 (odd):"]
Print["  Count: ", countDiagonals]
Print["  d values: ", factorsFound]
Print[""]

Print["These are exactly the prime factors of n = ", n, "!"]
Print[""]

Print["7. COMPLEXITY"]
Print["==============================================================="]
Print[""]

Print["To find all diagonal d in range [3, sqrt(n)]:"]
Print["  For each odd d: compute f(n, (d-1)/2) mod d"]
Print["  This is O(sqrt(n)) evaluations"]
Print["  Each f(n,i) computation is O(i) = O(sqrt(n))"]
Print["  Total: O(n) or O(sqrt(n)) with memoization"]
Print[""]

Print["Still not faster than trial division!"]
Print["But the geometric view via Lissajous is beautiful."]
