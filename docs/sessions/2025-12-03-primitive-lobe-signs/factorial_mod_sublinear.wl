(* Sublinear factorial mod p algorithms *)

(* Naive O(n) - our baseline *)
factorialModNaive[n_, p_] := Fold[Mod[#1 * #2, p] &, 1, Range[n]]

(* 
Sublinear approach using factorial splitting:
n! = product over blocks, where each block is evaluable as polynomial

Key idea: For m = √n, split into m blocks of size m:
n! = ∏_{i=0}^{m-1} ∏_{j=1}^{m} (i*m + j) mod p

The inner product P_i = ∏_{j=1}^{m} (i*m + j) can be computed using
polynomial interpolation if we precompute P(x) = ∏_{j=1}^{m} (x + j)
*)

(* Polynomial product ∏_{j=1}^{m} (x + j) *)
polyProduct[m_] := Expand[Product[x + j, {j, 1, m}]]

(* Evaluate polynomial at multiple points mod p using Horner *)
polyEvalMod[coeffs_, x0_, p_] := Fold[Mod[#1 * x0 + #2, p] &, 0, Reverse[coeffs]]

(* √n approach for n! mod p *)
factorialModSqrt[n_, p_] := Module[{m, poly, coeffs, result, remaining},
  m = Ceiling[Sqrt[n]];
  
  (* Build polynomial P(x) = ∏_{j=1}^{m} (x + j) *)
  poly = polyProduct[m];
  coeffs = CoefficientList[poly, x];
  
  (* Evaluate at x = 0, m, 2m, ... *)
  result = 1;
  Do[
    blockEnd = Min[(i+1)*m, n];
    blockStart = i*m + 1;
    If[blockEnd >= blockStart,
      (* Compute ∏_{j=blockStart}^{blockEnd} j mod p *)
      blockProd = Fold[Mod[#1 * #2, p] &, 1, Range[blockStart, blockEnd]];
      result = Mod[result * blockProd, p];
    ];
  , {i, 0, m-1}];
  
  result
]

(* Actually, simpler √n approach using symmetry *)
(* Wilson: (p-1)! ≡ -1 (mod p) *)
(* So: ((p-1)/2)! * ((p-1)/2)! * (-1)^... ≡ -1 (mod p) *)
(* This gives us ((p-1)/2)!² mod p, but we need the value, not square *)

(* Test correctness *)
Print["=== Correctness test ==="];
testCases = {{100, 1009}, {500, 1009}, {1000, 10007}, {5000, 10007}};
Table[
  {n, p} = tc;
  naive = factorialModNaive[n, p];
  (* sqrt = factorialModSqrt[n, p]; *)
  builtin = Mod[n!, p];
  Print["n=", n, " p=", p, ": naive=", naive, " builtin=", builtin, 
        " match=", naive == builtin];
, {tc, testCases}];

(* The real question: is there O(√p) algorithm for ((p-1)/2)! mod p? *)
Print["\n=== Key insight ==="];
Print["For ((p-1)/2)! mod p specifically:"];
Print["- Wilson: (p-1)! ≡ -1 (mod p)"];
Print["- Split: (p-1)! = ((p-1)/2)! × (p - ((p-1)/2))!₋"];
Print["         where (p-k)! ≡ (-1)^k × (p-1)!/(k-1)! for reflection"];
Print[""];
Print["This gives relationship but not direct √p computation."];

(* Benchmark what we have *)
Print["\n=== Timing for ((p-1)/2)! mod p ==="];
testPrimes = {10007, 100003};
Table[
  n = (p-1)/2;
  t = First@AbsoluteTiming[result = factorialModNaive[n, p];];
  Print["p=", p, " n=", n, ": ", Round[1000*t], " ms"];
, {p, Select[testPrimes, Mod[#,4]==3&]}];
