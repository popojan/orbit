#!/usr/bin/env wolframscript
(* Explore inversion transformations in Egypt approximations *)

<< Orbit`

Print["Exploring inversion symmetries in Egypt approximations\n"];
Print[StringRepeat["=", 70]];
Print[];

(* Test various inversion candidates *)
inversionCandidates = {
  {"Standard: 1/x", Function[x, 1/x]},
  {"Scaled: 2/x", Function[x, 2/x]},
  {"Shifted: 1/(x-1)", Function[x, 1/(x-1)]},
  {"Möbius: (2+x)/(2-x)", Function[x, (2+x)/(2-x)]},
  {"Hyperbolic: Tanh[ArcSinh[√(x/2)]]", Function[x, Tanh[ArcSinh[Sqrt[x/2]]]]},
  {"Conjugate s: -ArcSinh[√(x/2)]", Function[x, Sinh[-ArcSinh[Sqrt[x/2]]]^2 * 2]}
};

(* Compute Egypt approximation r_k for given n and k *)
egyptApprox[n_, k_] := Module[{x, denom},
  x = n - 1;
  denom = Sum[FactorialTerm[x, j], {j, 1, k}];
  N[n / denom, 15]
];

(* Test reciprocity: does r_k(n) and r_k(f(n)) show pattern? *)
testReciprocity[n_, k_, invName_, invFunc_] := Module[{r1, r2, x1, x2, product, ratio},
  r1 = egyptApprox[n, k];

  (* Apply inversion to n-1 (the x parameter) *)
  x2 = invFunc[n - 1];

  (* Check if x2 + 1 is valid *)
  If[!NumericQ[x2] || x2 <= 0,
    Return[<|"name" -> invName, "valid" -> False|>]
  ];

  r2 = egyptApprox[x2 + 1, k];

  product = r1 * r2;
  ratio = r1 / r2;

  <|
    "name" -> invName,
    "valid" -> True,
    "n" -> n,
    "k" -> k,
    "r1" -> r1,
    "r2" -> r2,
    "product" -> product,
    "ratio" -> ratio,
    "productIsN" -> Abs[product - n] < 0.001,
    "productIs2N" -> Abs[product - 2*n] < 0.001,
    "ratioIsN" -> Abs[ratio - n] < 0.001
  |>
];

Print["Testing reciprocity patterns:\n"];
Print["For each inversion f(x), compute r_k(n) and r_k(f(n-1)+1)"];
Print["Check if product or ratio shows pattern\n"];
Print[StringRepeat["-", 70]];
Print[];

(* Test cases *)
testN = {2, 3, 5, 7, 10, 13};
testK = {1, 2, 3, 5, 10};

results = Table[
  Table[
    testReciprocity[n, k, inv[[1]], inv[[2]]],
    {inv, inversionCandidates}
  ],
  {n, testN}, {k, testK}
];

(* Analyze results *)
Print["RESULTS SUMMARY:\n"];

Do[
  inv = inversionCandidates[[i]];
  invName = inv[[1]];

  Print["Inversion: ", invName];
  Print[StringRepeat["-", 50]];

  (* Collect all results for this inversion *)
  invResults = Flatten[results, 1][[All, i]];
  validResults = Select[invResults, #["valid"] === True &];

  If[Length[validResults] == 0,
    Print["  No valid results (domain issues)\n"];
    Continue[];
  ];

  (* Check patterns *)
  productIsN = Count[validResults, r_ /; r["productIsN"] === True];
  productIs2N = Count[validResults, r_ /; r["productIs2N"] === True];
  ratioIsN = Count[validResults, r_ /; r["ratioIsN"] === True];

  Print["  Valid tests: ", Length[validResults], "/", Length[Flatten[results, 1]]];
  Print["  Product = n: ", productIsN, " cases"];
  Print["  Product = 2n: ", productIs2N, " cases"];
  Print["  Ratio = n: ", ratioIsN, " cases"];

  (* Show example if pattern found *)
  If[productIsN > 0 || productIs2N > 0 || ratioIsN > 0,
    Print["\n  PATTERN DETECTED! Example:"];
    example = First[Select[validResults,
      #["productIsN"] || #["productIs2N"] || #["ratioIsN"] &]];
    Print["    n=", example["n"], ", k=", example["k"]];
    Print["    r1=", N[example["r1"], 6]];
    Print["    r2=", N[example["r2"], 6]];
    Print["    product=", N[example["product"], 6]];
    Print["    ratio=", N[example["ratio"], 6]];
  ];

  Print[];
, {i, 1, Length[inversionCandidates]}];

Print[StringRepeat["=", 70]];
Print[];

(* Deeper analysis: hyperbolic coordinate symmetry *)
Print["HYPERBOLIC COORDINATE ANALYSIS:\n"];
Print["Testing s_k symmetry under inversion\n"];

hyperbolicCoord[x_] := ArcSinh[Sqrt[x/2]];

analyzeHyperbolicSymmetry[n_, k_] := Module[{r, x, s, sNeg, xRecip},
  r = egyptApprox[n, k];
  x = r - 1;
  s = hyperbolicCoord[x];

  (* Test: does -s correspond to reciprocal? *)
  sNeg = -s;
  xRecip = 2*Sinh[sNeg]^2;

  <|
    "n" -> n,
    "k" -> k,
    "r" -> r,
    "x" -> x,
    "s" -> s,
    "x_from_-s" -> xRecip,
    "reciprocal_x" -> 1/x,
    "matches_1/x" -> Abs[xRecip - 1/x] < 0.001,
    "matches_2/x" -> Abs[xRecip - 2/x] < 0.001
  |>
];

Print["n\tk\tr_k\t\tx\t\ts\t\tx(-s)\t\t1/x\t\t2/x"];
Print[StringRepeat["-", 90]];

hypResults = Table[
  analyzeHyperbolicSymmetry[n, k],
  {n, {2, 5, 10, 13}}, {k, {1, 2, 5, 10}}
];

Do[
  res = hypResults[[i, j]];
  Print[
    res["n"], "\t",
    res["k"], "\t",
    N[res["r"], 6], "\t",
    N[res["x"], 5], "\t",
    N[res["s"], 5], "\t",
    N[res["x_from_-s"], 5], "\t",
    N[res["reciprocal_x"], 5], "\t",
    N[2/res["x"], 5]
  ];
, {i, 1, Length[hypResults]}, {j, 1, Length[hypResults[[1]]]}];

Print[];

(* Check if x(-s) matches any simple pattern *)
matches1x = Count[Flatten[hypResults], r_ /; r["matches_1/x"] === True];
matches2x = Count[Flatten[hypResults], r_ /; r["matches_2/x"] === True];

Print["Matches with 1/x: ", matches1x];
Print["Matches with 2/x: ", matches2x];
Print[];

If[matches1x > 0 || matches2x > 0,
  Print["SYMMETRY FOUND in hyperbolic coordinates!"];
,
  Print["No simple symmetry detected. More complex transformation likely."];
];

Print[];
Print[StringRepeat["=", 70]];
Print[];

(* Test Poincaré disk inversion *)
Print["POINCARÉ DISK INVERSION:\n"];
Print["Testing if r_upper * r_lower = 1 in Poincaré coordinates\n"];

poincareRadius[x_] := Tanh[ArcSinh[Sqrt[x/2]]];

analyzePoincareInversion[n_, k_] := Module[{r, x, rPoincare, rInv},
  r = egyptApprox[n, k];
  x = r - 1;
  rPoincare = poincareRadius[x];
  rInv = 1 / rPoincare;  (* Expected radius of inverted point *)

  <|
    "n" -> n,
    "k" -> k,
    "x" -> x,
    "r_poincare" -> rPoincare,
    "1/r_poincare" -> rInv,
    "inside_disk" -> rPoincare < 1,
    "inverted_outside" -> rInv > 1
  |>
];

Print["n\tk\tx\t\tr\t\t1/r\t\tinside?\toutside?"];
Print[StringRepeat["-", 70]];

poincareResults = Table[
  analyzePoincareInversion[n, k],
  {n, {2, 5, 10, 13}}, {k, {1, 2, 5, 10}}
];

Do[
  res = poincareResults[[i, j]];
  Print[
    res["n"], "\t",
    res["k"], "\t",
    N[res["x"], 5], "\t",
    N[res["r_poincare"], 5], "\t",
    N[res["1/r_poincare"], 5], "\t",
    res["inside_disk"], "\t",
    res["inverted_outside"]
  ];
, {i, 1, Length[poincareResults]}, {j, 1, Length[poincareResults[[1]]]}];

Print[];

allInside = AllTrue[Flatten[poincareResults], #["inside_disk"] === True &];
allInvOutside = AllTrue[Flatten[poincareResults], #["inverted_outside"] === True &];

If[allInside,
  Print["✓ All Egypt approximations map INSIDE Poincaré disk"];
,
  Print["✗ Some approximations outside disk"];
];

If[allInvOutside,
  Print["✓ All inverted points would be OUTSIDE disk"];
,
  Print["✗ Some inverted points inside disk"];
];

Print[];
Print["This confirms: Egypt trajectory stays in upper sheet (r < 1 in Poincaré)"];
Print["Inversion would map to lower sheet (r > 1)"];
Print[];

Print["DONE!\n"];
