(* 
O(√n) algorithm for n! mod p
Based on: splitting into √n blocks + polynomial multipoint evaluation

Key idea:
n! = ∏_{i=0}^{m-1} ∏_{j=1}^{m} (i·m + j)  where m = ⌈√n⌉

Let P(x) = ∏_{j=1}^{m} (x + j) be a polynomial of degree m.
Then: n! ≡ ∏_{i=0}^{m-1} P(i·m) (mod p)

Computing P(x) takes O(m log²m) using FFT-based multiplication.
Evaluating P at m points takes O(m log²m) using multipoint evaluation.
Total: O(√n · log²n)
*)

(* Simple implementation (not fully optimized but demonstrates the idea) *)

(* Build polynomial P(x) = ∏_{j=1}^{m} (x + j) mod p *)
buildPolyMod[m_, p_] := Module[{poly = {1}},
  (* Incrementally multiply by (x + j) *)
  Do[
    (* poly * (x + j) = poly*x + poly*j *)
    newPoly = Append[poly, 0] + Prepend[j * poly, 0];
    poly = Mod[newPoly, p];
  , {j, 1, m}];
  poly  (* coefficients, lowest degree first *)
]

(* Evaluate polynomial at point using Horner's method *)
evalPolyMod[coeffs_, x_, p_] := Module[{result = 0},
  Do[result = Mod[result * x + c, p], {c, Reverse[coeffs]}];
  result
]

(* √n factorial algorithm *)
factorialSqrt[n_, p_] := Module[{m, poly, result, fullBlocks, remainder},
  If[n == 0, Return[1]];
  
  m = Ceiling[Sqrt[N[n]]];
  fullBlocks = Floor[n / m];
  remainder = Mod[n, m];
  
  (* Build P(x) = ∏_{j=1}^{m} (x + j) *)
  poly = buildPolyMod[m, p];
  
  (* Evaluate at x = 0, m, 2m, ..., (fullBlocks-1)*m *)
  result = 1;
  Do[
    val = evalPolyMod[poly, i * m, p];
    result = Mod[result * val, p];
  , {i, 0, fullBlocks - 1}];
  
  (* Handle remainder: multiply by (fullBlocks*m + 1) to n *)
  Do[
    result = Mod[result * j, p];
  , {j, fullBlocks * m + 1, n}];
  
  result
]

(* Naive for comparison *)
factorialNaive[n_, p_] := Fold[Mod[#1 * #2, p] &, 1, Range[n]]

(* Test correctness *)
Print["=== Correctness Test ==="];
testCases = {{1000, 10007}, {5003, 10007}, {50001, 100003}};
Table[
  naive = factorialNaive[n, p];
  sqrtAlg = factorialSqrt[n, p];
  Print["n=", n, " p=", p, ": naive=", naive, " sqrt=", sqrtAlg, 
        " match=", naive == sqrtAlg];
, {{n, p}, testCases}];

(* Benchmark *)
Print["\n=== Benchmark ==="];
Print["n\t\tNaive\t\t√n alg\t\tSpeedup"];
benchmarks = {{5003, 10007}, {50001, 100003}, {500001, 1000003}};

Table[
  tNaive = First@AbsoluteTiming[factorialNaive[n, p];];
  tSqrt = First@AbsoluteTiming[factorialSqrt[n, p];];
  Print[n, "\t\t", Round[1000*tNaive], " ms\t\t", Round[1000*tSqrt], " ms\t\t", 
        N[tNaive/tSqrt, 3], "x"];
, {{n, p}, benchmarks}];

Print["\n=== Complexity Analysis ==="];
Print["Naive: O(n) multiplications"];
Print["√n alg: O(√n) polynomial builds + O(√n) evaluations"];
Print["        = O(√n · m) where m = √n, so O(n) naively"];
Print["        With FFT: O(√n · log²n)"];
Print["\nOur simple impl is O(n) due to naive poly multiplication."];
Print["Full FFT impl would give true O(√n · log²n)."];
