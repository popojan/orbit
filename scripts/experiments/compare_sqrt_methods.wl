#!/usr/bin/env wolframscript
(* Compare EgyptSqrt vs GammaPalindromicSqrt *)

<< Orbit`

Print["=== COMPARING SQRT METHODS ===\n"];

(* Test with sqrt(13) *)
nn = 13;
sol = PellSolution[13];
Print["Pell solution for 13: ", sol];

n = (x - 1)/y /. sol;
Print["Starting approximation n = ", N[n, 10], "\n"];

Print["Testing k=1 to 5:\n"];

Print["k\tEgyptSqrt\t\t\tGammaPalindromicSqrt\t\tDifference"];
Print["---------------------------------------------------------------------------------"];

Do[
  (* EgyptSqrt returns interval, take midpoint *)
  egyptInterval = EgyptSqrt[nn, {x, y} /. sol, k];
  egyptMid = Mean[List @@ egyptInterval];

  (* GammaPalindromicSqrt returns single value *)
  gamma = GammaPalindromicSqrt[nn, n, k];

  diff = Abs[egyptMid - gamma];

  Print[k, "\t", N[egyptMid, 10], "\t", N[gamma, 10], "\t", N[diff, 6]];

, {k, 1, 5}];

Print["\n=== ANALYSIS ===\n"];

Print["If difference is small: Methods are equivalent (different formulations)"];
Print["If difference is large: Methods are distinct approaches\n"];

(* Detailed comparison for k=3 *)
k = 3;
egyptInterval = EgyptSqrt[nn, {x, y} /. sol, k];
egyptMid = Mean[List @@ egyptInterval];
gamma = GammaPalindromicSqrt[nn, n, k];

Print["Detailed for k=", k, ":"];
Print["  EgyptSqrt interval: ", N[egyptInterval, 15]];
Print["  EgyptSqrt midpoint: ", N[egyptMid, 15]];
Print["  GammaPalindromic:   ", N[gamma, 15]];
Print["  sqrt(13) actual:    ", N[Sqrt[13], 15]];
Print["  Egypt error:        ", N[Abs[egyptMid - Sqrt[13]], 10]];
Print["  Gamma error:        ", N[Abs[gamma - Sqrt[13]], 10]];
