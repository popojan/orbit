(* Explore ADDITIVE structure of k = p1*p2*p3 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Greedy prime representation *)
primeRepSparse[n_] := Module[{r = n, primes = {}},
  While[r >= 2,
    p = NextPrime[r, -1]; (* largest prime <= r *)
    If[p < 2, Break[]];
    AppendTo[primes, p];
    r = r - p;
  ];
  If[r > 0, AppendTo[primes, r]];
  primes
];

Print["=== Additive decomposition of k ===\n"];

data = {};
Do[
  p1 = 5;
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    (* Greedy decomposition of k *)
    decomp = primeRepSparse[k];
    nPrimes = Length[decomp];
    firstPrime = First[decomp];
    remainder = Last[decomp];

    (* Also try decomposing p2 + p3 *)
    sumDecomp = primeRepSparse[p2 + p3];
    diffDecomp = primeRepSparse[p3 - p2];

    (* Additive features *)
    sumLen = Length[sumDecomp];
    diffLen = Length[diffDecomp];

    If[Length[data] < 30,
      Print["k = 5*", p2, "*", p3, " = ", k, " -> ss=", ss];
      Print["  PrimeRep(k): ", decomp];
      Print["  PrimeRep(p2+p3): ", sumDecomp, "  len=", sumLen];
      Print["  PrimeRep(p3-p2): ", diffDecomp, "  len=", diffLen];
      Print[""];
    ];

    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3,
      "nPrimes" -> nPrimes, "sumLen" -> sumLen, "diffLen" -> diffLen,
      "firstPrime" -> firstPrime, "remainder" -> remainder|>];
  ],
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 35]]}
];

Print["\n=== Testing additive features ===\n"];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];

(* Test for class {1, 2} *)
classData = byClass[{1, 2}];
Print["Class {1, 2}: ", Length[classData], " cases"];
Print["Values: ", Sort[Union[#["ss"] & /@ classData]]];

(* Test nPrimes in decomposition of k *)
grouped = GroupBy[classData, #["nPrimes"] &];
Print["\nnPrimes(k):"];
Do[
  ssVals = Union[#["ss"] & /@ grouped[np]];
  Print["  ", np, " primes -> ", ssVals],
  {np, Sort[Keys[grouped]]}
];

(* Test sumLen *)
grouped = GroupBy[classData, #["sumLen"] &];
Print["\nLen(PrimeRep(p2+p3)):"];
Do[
  ssVals = Union[#["ss"] & /@ grouped[sl]];
  Print["  len=", sl, " -> ", ssVals],
  {sl, Sort[Keys[grouped]]}
];

(* Test diffLen *)
grouped = GroupBy[classData, #["diffLen"] &];
Print["\nLen(PrimeRep(p3-p2)):"];
Do[
  ssVals = Union[#["ss"] & /@ grouped[dl]];
  Print["  len=", dl, " -> ", ssVals],
  {dl, Sort[Keys[grouped]]}
];

(* Test remainder mod 2 *)
grouped = GroupBy[classData, Mod[#["remainder"], 2] &];
Print["\nremainder(k) mod 2:"];
Do[
  ssVals = Union[#["ss"] & /@ grouped[rm]];
  Print["  ", rm, " -> ", ssVals],
  {rm, Sort[Keys[grouped]]}
];
