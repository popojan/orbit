(* Pell DNA Database Generator *)
(* Computes factored Fibonacci representation for Pell solutions *)
(* Format: {a, b, p, q} where x/y = (F_a/F_b) × (p/q) *)

(* Generate Fibonacci numbers up to limit *)
fibs = Module[{f = {1, 1}},
  While[Last[f] < 10^10, AppendTo[f, f[[-1]] + f[[-2]]]];
  f
];

(* Find fundamental Pell solution *)
pellFundamental[d_] := Module[{a0, cf, n, p, q, pp, qq},
  If[IntegerQ[Sqrt[d]], Return[{0, 0, 0}]];  (* Perfect square *)
  a0 = Floor[Sqrt[d]];
  cf = ContinuedFraction[Sqrt[d], 200];
  (* Find period *)
  For[n = 2, n <= Length[cf], n++,
    {p, q} = {Numerator[#], Denominator[#]} &@ FromContinuedFraction[Take[cf, n]];
    If[p^2 - d*q^2 == 1, Return[{p, q, 1}]];
    If[p^2 - d*q^2 == -1, (* Need to double *)
      {pp, qq} = {p^2 + d*q^2, 2*p*q};
      Return[{pp, qq, 1}]
    ];
  ];
  {0, 0, 0}  (* Not found *)
];

(* Find best Fibonacci fraction approximation *)
(* Returns {a, b, score} where F_a/F_b ≈ x/y *)
findBestFibRatio[x_, y_] := Module[{best = {1, 1, 10^20}, target, ratio, score},
  target = x/y;
  Do[
    If[fibs[[b]] > 0,
      ratio = fibs[[a]] / fibs[[b]];
      score = Abs[Log[target/ratio]];  (* Log-scale distance *)
      If[score < best[[3]], best = {a, b, score}]
    ],
    {a, 2, Min[50, Length[fibs]]},
    {b, 2, Min[50, Length[fibs]]}
  ];
  Take[best, 2]
];

(* Compute correction factor after Fibonacci scaling *)
computeCorrection[x_, y_, a_, b_] := Module[{fa, fb, g, p, q},
  fa = fibs[[a]];
  fb = fibs[[b]];
  (* x/y = (fa/fb) × (p/q), so p/q = (x×fb)/(y×fa) *)
  {p, q} = {x * fb, y * fa};
  g = GCD[p, q];
  {p/g, q/g}
];

(* Total storage size: 4 integers *)
storageSize[a_, b_, p_, q_] := Total[Ceiling[Log2[# + 1]] & /@ {a, b, p, q}];

(* Generate database for D up to limit *)
generatePellDNA[maxD_] := Module[{results = {}, x, y, norm, a, b, p, q, rawBits, compBits},
  Do[
    If[!IntegerQ[Sqrt[d]],
      {x, y, norm} = pellFundamental[d];
      If[x > 0,
        {a, b} = findBestFibRatio[x, y];
        {p, q} = computeCorrection[x, y, a, b];
        rawBits = Ceiling[Log2[x + 1]] + Ceiling[Log2[y + 1]];
        compBits = storageSize[a, b, p, q];
        AppendTo[results, <|
          "D" -> d,
          "x" -> x,
          "y" -> y,
          "a" -> a,
          "b" -> b,
          "p" -> p,
          "q" -> q,
          "rawBits" -> rawBits,
          "compBits" -> compBits,
          "ratio" -> N[rawBits/compBits, 3]
        |>]
      ]
    ],
    {d, 2, maxD}
  ];
  results
];

(* Run and export *)
Print["Generating Pell DNA database..."];
results = generatePellDNA[200];

(* Summary stats *)
Print["\n=== PELL DNA DATABASE ===\n"];
Print["D\tx\ty\t(a,b)\t(p,q)\traw\tcomp\tratio"];
Print[StringJoin[Table["-", 70]]];

Do[
  r = results[[i]];
  Print[r["D"], "\t",
    If[r["x"] < 10000, r["x"], "..."],  "\t",
    If[r["y"] < 10000, r["y"], "..."], "\t",
    "(", r["a"], ",", r["b"], ")\t",
    "(", If[r["p"] < 1000, r["p"], "..."], ",", If[r["q"] < 1000, r["q"], "..."], ")\t",
    r["rawBits"], "\t", r["compBits"], "\t", r["ratio"]
  ],
  {i, Length[results]}
];

(* Export as JSON for web viewer *)
Print["\n=== JSON OUTPUT ===\n"];
jsonData = Table[
  r = results[[i]];
  StringJoin["{",
    "\"D\":", ToString[r["D"]], ",",
    "\"x\":\"", ToString[r["x"]], "\",",
    "\"y\":\"", ToString[r["y"]], "\",",
    "\"a\":", ToString[r["a"]], ",",
    "\"b\":", ToString[r["b"]], ",",
    "\"p\":\"", ToString[r["p"]], "\",",
    "\"q\":\"", ToString[r["q"]], "\",",
    "\"ratio\":", ToString[r["ratio"]],
  "}"],
  {i, Length[results]}
];

Print["const PELL_DNA = ["];
Print[StringRiffle[jsonData, ",\n"]];
Print["];"];

(* Summary *)
Print["\n=== SUMMARY ==="];
totalRaw = Total[#["rawBits"] & /@ results];
totalComp = Total[#["compBits"] & /@ results];
Print["Total raw bits: ", totalRaw];
Print["Total compressed bits: ", totalComp];
Print["Overall compression: ", N[totalRaw/totalComp, 4], "x"];
Print["Entries: ", Length[results]];
