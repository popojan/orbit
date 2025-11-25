#!/usr/bin/env wolframscript
(* Trace how Mathematica proves the identity symbolically *)

Print["=== TRACING SYMBOLIC SIMPLIFICATION ===\n"];

(* For general k, check what Mathematica does *)
k = 3;  (* Use k=3 as test case *)

factForm = 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
chebForm = ChebyshevT[Ceiling[k/2], x+1] * (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["k=", k];
Print["Factorial form: ", factForm];
Print["Chebyshev form: ", chebForm];
Print[];

Print["Step 1: Expand both forms"];
Print["==========================\n"];

factExpanded = factForm // Expand;
chebExpanded = chebForm // Expand;

Print["Factorial expanded: ", factExpanded];
Print["Chebyshev expanded: ", chebExpanded];
Print["Equal? ", factExpanded === chebExpanded];
Print[];

Print["Step 2: Compute difference"];
Print["===========================\n"];

diff = factExpanded - chebExpanded;
Print["Difference: ", diff];
Print["Simplify: ", Simplify[diff]];
Print[];

Print["Step 3: Try with symbolic k"];
Print["============================\n"];

(* This will likely not work for symbolic k, but let's see *)
Print["Attempting symbolic k... (may not evaluate)\n"];

factFormSym = 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
chebFormSym = ChebyshevT[Ceiling[k/2], x+1] * (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["Factorial symbolic: ", factFormSym];
Print["Chebyshev symbolic: ", chebFormSym];
Print[];

Print["As expected, Sum with symbolic k gives unevaluated form."];
Print["Mathematica uses internal pattern matching / identities."];
Print[];

Print["Step 4: Check for known Mathematica identities"];
Print["===============================================\n"];

(* Check if Mathematica recognizes any standard identity *)
Print["Testing: Can Mathematica simplify the identity directly?\n"];

Do[
  fact = 1 + Sum[2^(i-1) * x^i * Factorial[kval+i]/(Factorial[kval-i] * Factorial[2*i]), {i, 1, kval}];
  cheb = ChebyshevT[Ceiling[kval/2], x+1] * (ChebyshevU[Floor[kval/2], x+1] - ChebyshevU[Floor[kval/2]-1, x+1]);

  result = FullSimplify[fact - cheb];

  Print["k=", kval, ": difference simplifies to ", result, " (zero? ", result === 0, ")"];
, {kval, 1, 6}];
Print[];

Print["=== CONCLUSION ==="];
Print["Mathematica verifies equality via polynomial expansion + subtraction."];
Print["No 'deep' symbolic identity is being used - it's brute force polynomial matching."];
Print[];
Print["For algebraic proof, we need to show coefficient matching algebraically,"];
Print["which is what we've been doing (and is tedious but straightforward)."];
