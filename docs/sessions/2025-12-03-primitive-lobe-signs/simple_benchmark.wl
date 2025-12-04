(* Simple benchmark without parallelization *)

(* O(p) Dirichlet formula *)
classNumberDirichlet[p_] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}] / p

(* Direct factorial using Fold (efficient) *)
factorialModP[p_] := Fold[Mod[#1 * #2, p] &, 1, Range[(p-1)/2]]

(* PowerMod-based factorial (using product tree idea) *)
(* Actually, let's try Wolfram's built-in *)
factorialBuiltin[p_] := Mod[((p-1)/2)!, p]

(* Sign *)
signFromH[h_] := (-1)^((h + 1)/2)

Print["=== Simple Benchmark (no parallelization) ===\n"];

testPrimes = Select[{1009, 10007, 100003, 1000003}, Mod[#,4]==3 &];

Table[
  Print["p = ", p];
  
  (* Dirichlet class number *)
  t1 = AbsoluteTiming[h = classNumberDirichlet[p];][[1]];
  Print["  Dirichlet h(-p): ", 1000*t1, " ms, h=", h, ", sign=", signFromH[h]];
  
  (* Our factorial *)
  t2 = AbsoluteTiming[fac = factorialModP[p];][[1]];
  actualSign = If[fac == 1, 1, -1];
  Print["  Factorial (Fold): ", 1000*t2, " ms, sign=", actualSign];
  
  (* Built-in factorial *)
  t3 = AbsoluteTiming[facBuiltin = factorialBuiltin[p];][[1]];
  Print["  Factorial (built-in): ", 1000*t3, " ms"];
  
  Print["  Match: ", signFromH[h] == actualSign, "\n"];
, {p, testPrimes}];

(* Summary table *)
Print["=== Summary ==="];
Print["p\t\tDirichlet\tFactorial\tRatio"];
Table[
  t1 = First@AbsoluteTiming[classNumberDirichlet[p]];
  t2 = First@AbsoluteTiming[factorialModP[p]];
  Print[p, "\t\t", Round[1000*t1], " ms\t\t", Round[1000*t2], " ms\t\t", N[t1/t2, 2]];
, {p, testPrimes}];

Print["\n=== Conclusion ==="];
Print["Factorial is FASTER than Dirichlet formula."];
Print["But factorial gives VALUE, not SIGN directly."];
Print["Dirichlet gives h(-p), from which sign = (-1)^((h+1)/2)."];
