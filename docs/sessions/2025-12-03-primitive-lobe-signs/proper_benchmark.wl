(* Proper benchmark: three methods for ((p-1)/2)! mod p *)

(* === METHOD 1: Direct factorial mod p === *)
(* O(p) sequential multiplications *)
directFactorial[p_] := Fold[Mod[#1 * #2, p] &, 1, Range[(p-1)/2]]

(* === METHOD 2: Sign from Wolfram ClassNumber === *)
(* Uses whatever algorithm Mathematica has internally *)
signFromWolfram[p_] := Module[{h},
  h = NumberFieldClassNumber[Sqrt[-p]];
  If[IntegerQ[h], (-1)^((h + 1)/2), $Failed]
]

(* === METHOD 3: Sign from Dirichlet formula (parallelizable) === *)
(* O(p) but embarrassingly parallel: h = -Σ k·(k/p) / p *)
signFromDirichlet[p_] := Module[{h},
  h = -Sum[k * JacobiSymbol[k, p], {k, 1, p - 1}] / p;
  (-1)^((h + 1)/2)
]

(* Parallel version of Dirichlet *)
signFromDirichletParallel[p_, chunks_:8] := Module[{n = p-1, chunkSize, ranges, partialSums, h},
  chunkSize = Ceiling[n / chunks];
  ranges = Partition[Range[n], UpTo[chunkSize]];
  partialSums = ParallelMap[
    Total[# * JacobiSymbol[#, p] & /@ #] &,
    ranges
  ];
  h = -Total[partialSums] / p;
  (-1)^((h + 1)/2)
]

(* === BENCHMARK === *)
Print["╔══════════════════════════════════════════════════════════════╗"];
Print["║  Benchmark: ((p-1)/2)! mod p for p ≡ 3 (mod 4)              ║"];
Print["╚══════════════════════════════════════════════════════════════╝\n"];

(* Test primes p ≡ 3 (mod 4) of increasing size *)
testPrimes = {
  10007,      (* 5 digits *)
  100003,     (* 6 digits *)  
  1000003,    (* 7 digits *)
  10000019,   (* 8 digits *)
  100000007   (* 9 digits *)
};

Print["p\t\t\tDirect\t\tWolfram h\tDirichlet\tMatch?"];
Print[StringJoin[Table["─", 75]]];

results = {};

Do[
  Print["\nTesting p = ", p, " (", Length[IntegerDigits[p]], " digits)..."];
  
  (* Method 1: Direct *)
  t1 = AbsoluteTiming[
    fac = directFactorial[p];
    sign1 = If[fac == 1, 1, -1];
  ];
  
  (* Method 2: Wolfram ClassNumber *)
  t2 = AbsoluteTiming[sign2 = signFromWolfram[p];];
  
  (* Method 3: Dirichlet *)
  t3 = AbsoluteTiming[sign3 = signFromDirichlet[p];];
  
  match = (sign1 == sign2 == sign3) || (sign2 === $Failed && sign1 == sign3);
  
  Print["  Direct factorial:  ", Round[t1[[1]], 0.001], " sec, sign = ", sign1];
  Print["  Wolfram ClassNum:  ", Round[t2[[1]], 0.001], " sec, sign = ", sign2];
  Print["  Dirichlet formula: ", Round[t3[[1]], 0.001], " sec, sign = ", sign3];
  Print["  All match: ", If[match, "✓", "✗"]];
  
  AppendTo[results, {p, t1[[1]], t2[[1]], t3[[1]], match}];
, {p, testPrimes}];

(* Summary table *)
Print["\n\n═══════════════════════════════════════════════════════════════"];
Print["SUMMARY TABLE (times in seconds)"];
Print["═══════════════════════════════════════════════════════════════"];
Print["p\t\t\tDirect\t\tWolfram\t\tDirichlet"];
Do[
  r = results[[i]];
  Print[r[[1]], "\t\t", NumberForm[r[[2]], {4,3}], "\t\t", 
        NumberForm[r[[3]], {4,3}], "\t\t", NumberForm[r[[4]], {4,3}]];
, {i, Length[results]}];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["ANALYSIS"];
Print["═══════════════════════════════════════════════════════════════"];
Print["• Direct factorial: O(p) sequential - simple but not parallelizable"];
Print["• Wolfram ClassNumber: depends on internal algorithm"];  
Print["• Dirichlet: O(p) but embarrassingly parallel"];
Print[""];
Print["For large p, Dirichlet could use GPU/distributed computing."];
