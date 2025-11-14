(* ===================================================================
   FAIR PRECISION COMPARISON - Apples to Apples

   For each TARGET precision level:
   - Test ALL our methods (Nested variants, Binet variants, Egyptian)
   - For each method that reaches target, measure:
     * Time for our method
     * Denominator size for our rational
     * Time for Wolfram Rationalize at SAME precision
     * Denominator size for Wolfram (optimal via CF convergents)
     * Denominator overhead ratio

   TABLE FORMAT:
   Rows = Target precision levels
   Columns = Per method: (OurTime, OurDenom, WMTime, WMDenom, Overhead)
   =================================================================== *)

(* Pell solver *)
PellSolve[d_] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {u, r}
];

(* Nested Chebyshev *)
sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/
  ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify;

sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2];
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1] &, n, m2];

(* Binet-like formula *)
BinetSqrt[d_, n_, k_] :=
  d/2*(((n + Sqrt[d])^k - (n - Sqrt[d])^k)/
       ((n + Sqrt[d])^k + (n - Sqrt[d])^k));

(* Egyptian fraction approach *)
ChebTerm[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x + 1] *
  (ChebyshevU[Floor[k/2], x + 1] - ChebyshevU[Floor[k/2] - 1, x + 1]));

EgyptianSqrt[d_, {x_, y_}, numTerms_] := Module[{base},
  base = (x - 1)/y;
  base * (1 + Sum[ChebTerm[x - 1, k], {k, 1, numTerms}])
];

(* Error metrics *)
QuadError[n_, approx_] := Log[10, Abs[n - approx^2]];
SqrtPrecision[n_, approx_] := -QuadError[n, approx]/2;

(* ===================================================================
   BENCHMARK ONE METHOD AT ONE PRECISION
   =================================================================== *)

BenchmarkAtPrecision[d_, pellSolution_, targetPrec_, methodName_, computeFunc_] :=
  Module[{result, ourTime, actualPrec, ourDenom,
          wmResult, wmTime, wmDenom, overhead},

    (* Compute OUR method *)
    {ourTime, result} = AbsoluteTiming[computeFunc[]];

    (* Check if we reached target *)
    actualPrec = Floor[SqrtPrecision[d, result]];
    If[actualPrec < targetPrec,
      Return[{methodName, "N/A", "N/A", "N/A", "N/A", "N/A"}]
    ];

    ourDenom = IntegerLength[Denominator[result]];

    (* Compute WOLFRAM at SAME precision *)
    {wmTime, wmResult} = AbsoluteTiming[
      Rationalize[Sqrt[N[d, actualPrec + 100]], 10^(-actualPrec)]
    ];
    wmDenom = IntegerLength[Denominator[wmResult]];
    overhead = N[ourDenom/wmDenom, 3];

    (* Return row *)
    {methodName,
     N[ourTime, 4],
     ourDenom,
     N[wmTime, 4],
     wmDenom,
     overhead}
  ];

(* ===================================================================
   MAIN BENCHMARK
   =================================================================== *)

d = 13;
{x, y} = PellSolve[d];
pellBase = (x - 1)/y;
crude = Floor[Sqrt[d]];

Print["================================================================="];
Print["FAIR PRECISION COMPARISON: sqrt(", d, ")"];
Print["Pell solution: (", x, ", ", y, ")  =>  base = ", N[pellBase, 6]];
Print["================================================================="];
Print[""];

(* Precision targets (sqrt digits) *)
targets = {50, 100, 500, 1000, 5000};

Do[
  Print[""];
  Print[StringRepeat["=", 70]];
  Print["TARGET: ", targetPrec, " sqrt digits"];
  Print[StringRepeat["=", 70]];

  (* Define methods to test *)
  methods = {
    {"Nested m1=3,m2=2 (Pell)", nestqrt[d, pellBase, {3, 2}]&},
    {"Nested m1=3,m2=3 (Pell)", nestqrt[d, pellBase, {3, 3}]&},
    {"Nested m1=3,m2=4 (Pell)", nestqrt[d, pellBase, {3, 4}]&},
    {"Nested m1=2,m2=5 (Pell)", nestqrt[d, pellBase, {2, 5}]&},
    {"Nested m1=2,m2=6 (Pell)", nestqrt[d, pellBase, {2, 6}]&},
    {"Nested m1=1,m2=8 (Pell)", nestqrt[d, pellBase, {1, 8}]&},
    {"Nested m1=1,m2=9 (Pell)", nestqrt[d, pellBase, {1, 9}]&},
    {"Nested m1=3,m2=3 (crude)", nestqrt[d, crude, {3, 3}]&},
    {"Nested m1=3,m2=4 (crude)", nestqrt[d, crude, {3, 4}]&},
    {"Binet k=5 (Pell)", BinetSqrt[d, pellBase, 5]&},
    {"Binet k=8 (Pell)", BinetSqrt[d, pellBase, 8]&},
    {"Binet k=10 (Pell)", BinetSqrt[d, pellBase, 10]&},
    {"Egyptian 20 terms", EgyptianSqrt[d, {x, y}, 20]&},
    {"Egyptian 50 terms", EgyptianSqrt[d, {x, y}, 50]&}
  };

  (* Benchmark each method *)
  results = Table[
    BenchmarkAtPrecision[d, {x, y}, targetPrec, methods[[i, 1]], methods[[i, 2]]],
    {i, 1, Length[methods]}
  ];

  (* Filter out N/A results *)
  valid = Select[results, #[[2]] =!= "N/A" &];

  If[Length[valid] > 0,
    Print[""];
    Print[Grid[
      Prepend[valid,
        {"Method", "Our Time", "Our Denom", "WM Time", "WM Denom", "Overhead"}],
      Frame -> All,
      Alignment -> {{Left, Right, Right, Right, Right, Right}},
      Spacings -> {2, 1},
      ItemStyle -> {Automatic, {1 -> Bold}}
    ]];
    Print[""],
    Print["  No methods reached target precision"];
    Print[""]
  ];

, {targetPrec, targets}];

Print[""];
Print["================================================================="];
Print["LEGEND"];
Print["  Our Time   = Time to compute with our method"];
Print["  Our Denom  = Number of digits in our rational's denominator"];
Print["  WM Time    = Wolfram Rationalize time at SAME precision"];
Print["  WM Denom   = Wolfram denominator (optimal via CF convergents)"];
Print["  Overhead   = (Our Denom) / (WM Denom) - size penalty"];
Print[""];
Print["KEY INSIGHTS TO EXTRACT:");
Print["  1. Which method is fastest at each precision level?"];
Print["  2. What is the time tradeoff vs CF optimality?"];
Print["  3. How does m1/m2 choice affect speed and size?"];
Print["  4. When does Pell base matter vs crude start?"];
Print["================================================================="];
