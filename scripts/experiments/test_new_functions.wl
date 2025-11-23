#!/usr/bin/env wolframscript
(* Test newly added functions *)

<< Orbit`

Print["=== TESTING TangentMultiplication ===\n"];

(* Test against known tan formulas *)
Print["Test 1: tan(θ) identity"];
test1 = TangentMultiplication[1, a];
Print["TangentMultiplication[1, a] = ", test1];
Print["Should be: a"];
Print["Match: ", Simplify[test1 == a], "\n"];

Print["Test 2: tan(2θ) = 2tan(θ)/(1-tan²(θ))"];
test2 = TangentMultiplication[2, a];
expected2 = (2*a)/(1 - a^2);
Print["TangentMultiplication[2, a] = ", test2];
Print["Expected: ", expected2];
Print["Match: ", Simplify[test2 == expected2], "\n"];

Print["Test 3: tan(3θ) = (3tan(θ)-tan³(θ))/(1-3tan²(θ))"];
test3 = TangentMultiplication[3, a];
expected3 = (3*a - a^3)/(1 - 3*a^2);
Print["TangentMultiplication[3, a] = ", test3];
Print["Expected: ", expected3];
Print["Match: ", Simplify[test3 == expected3], "\n"];

Print["Test 4: Numeric values"];
vals = Table[{k, TangentMultiplication[k, 1/2]}, {k, 1, 5}];
Print["k | TangentMultiplication[k, 1/2]"];
Do[Print[val[[1]], " | ", N[val[[2]], 6]], {val, vals}];
Print[""];

Print["Test 5: Connection to AlgebraicCirclePoint"];
a24 = 2 + Sqrt[2] + Sqrt[3] + Sqrt[6];
Do[
  z = AlgebraicCirclePoint[k, a24];
  tanFromCircle = z[[2]]/z[[1]];  (* Im/Re *)
  tanFromMult = TangentMultiplication[k, a24];
  match = Abs[N[tanFromCircle - tanFromMult, 20]] < 10^-10;
  Print["k=", k, ": Match = ", match];
, {k, 0, 5}];

Print["\n=== TESTING GammaPalindromicSqrt ===\n"];

Print["Test 1: Basic call with Pell solution"];
sol = PellSolution[13];
start = (x - 1)/y /. sol;
Print["Pell solution for 13: ", sol];
Print["Starting point: ", start];
Print[""];

result1 = GammaPalindromicSqrt[13, start, 3];
Print["GammaPalindromicSqrt[13, start, 3] = ", N[result1, 10]];
Print["Sqrt[13] = ", N[Sqrt[13], 10]];
Print["Error: ", N[Abs[result1 - Sqrt[13]], 10]];
Print[""];

Print["Test 2: Different k values"];
Do[
  res = GammaPalindromicSqrt[13, start, k];
  err = Abs[res - Sqrt[13]];
  Print["k=", k, ": result = ", N[res, 8], ", error = ", N[err, 6]];
, {k, 1, 5}];

Print["\n=== TESTING reconstruct VARIANT (original) ===\n"];

(* Original reconstruct from user *)
reconstruct[nn_, n_, k_] :=
 Module[{lim = 1 + 1/2 (1 - (-1)^k) + Floor[k/2]},
  Function[w,
    nn Sum[w[[i]] (-24 + 16 i^2 (1 + k) + 4 i (1 + k) (2 + k) -
         k (24 + k (7 + k)))/(-1 + 4 i^2), {i, 1, lim}]/
     Sum[w[[i]], {i, 1, lim}]][
   Table[(n^(2 - 2 i + 2 Ceiling[k/2]) nn^i)/(
    Gamma[-1 + 2 i] Gamma[4 - 2 i + k]), {i, 1, lim}]]];

Print["Comparing GammaPalindromicSqrt with original reconstruct:"];
Do[
  gamma = GammaPalindromicSqrt[13, start, k];
  recon = reconstruct[13, start, k];
  diff = N[Abs[gamma - recon], 10];
  Print["k=", k, ": difference = ", diff, " (should be 0)"];
, {k, 1, 5}];
