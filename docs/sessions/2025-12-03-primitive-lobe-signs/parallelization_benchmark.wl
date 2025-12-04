(* Benchmark: parallelizability comparison *)

(* 1. Direct factorial mod p - inherently sequential *)
factorialModP[p_] := Module[{result = 1},
  Do[result = Mod[result * k, p], {k, 1, (p-1)/2}];
  result
]

(* 2. Class number via Dirichlet - parallelizable sum *)
classNumberDirichlet[p_] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}] / p

(* 3. Parallelizable class number - split into chunks *)
classNumberParallel[p_, chunks_:8] := Module[{n = p-1, chunkSize, ranges, partialSums},
  chunkSize = Ceiling[n / chunks];
  ranges = Partition[Range[n], UpTo[chunkSize]];
  (* Each chunk can be computed independently *)
  partialSums = ParallelMap[
    Total[# * JacobiSymbol[#, p] & /@ #] &,
    ranges
  ];
  -Total[partialSums] / p
]

(* 4. Sign from class number *)
signFromH[h_] := (-1)^((h + 1)/2)

(* Test correctness first *)
Print["=== Correctness Check ===\n"];
testPrimes = Select[Prime[Range[100, 200]], Mod[#, 4] == 3 &][[;;5]];

Table[
  hf = factorialModP[p];
  h = classNumberDirichlet[p];
  hPar = classNumberParallel[p, 4];
  predictedSign = signFromH[h];
  actualSign = If[hf == 1, 1, -1];
  Print["p=", p, ": h=", h, " (parallel:", hPar, "), predicted=", predictedSign, 
        ", actual=", actualSign, " ", If[predictedSign == actualSign, "✓", "✗"]];
, {p, testPrimes}];

(* Benchmark *)
Print["\n=== Timing Comparison ===\n"];

benchPrimes = {10007, 100003, 1000003};

Table[
  Print["p = ", p, " (", Floor[Log10[p]], " digits)"];
  
  (* Factorial *)
  t1 = AbsoluteTiming[factorialModP[p]][[1]];
  Print["  Factorial mod p: ", t1, " sec"];
  
  (* Class number sequential *)
  t2 = AbsoluteTiming[classNumberDirichlet[p]][[1]];
  Print["  Class number (seq): ", t2, " sec"];
  
  (* Class number parallel *)
  t3 = AbsoluteTiming[classNumberParallel[p, 8]][[1]];
  Print["  Class number (8 cores): ", t3, " sec"];
  
  Print["  Speedup parallel/seq: ", N[t2/t3], "x"];
  Print[];
, {p, Select[benchPrimes, Mod[#, 4] == 3 &]}];

(* Larger test *)
Print["=== Larger p test ==="];
p = 10000019; (* ~10^7, ≡ 3 mod 4 *)
Print["p = ", p];

t1 = AbsoluteTiming[fac = factorialModP[p];][[1]];
Print["Factorial: ", t1, " sec, result mod p in {1, p-1}: ", MemberQ[{1, p-1}, fac]];

t2 = AbsoluteTiming[h = classNumberDirichlet[p];][[1]];
Print["Class number (seq): ", t2, " sec, h = ", h];

t3 = AbsoluteTiming[hPar = classNumberParallel[p, 8];][[1]];
Print["Class number (8-way): ", t3, " sec"];

Print["\nPredicted sign: ", signFromH[h]];
Print["Actual: ", If[fac == 1, "+1", "-1"]];
