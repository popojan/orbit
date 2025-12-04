(* Compare with Wolfram's built-in ClassNumber (uses better algorithm) *)

(* Our O(p) Dirichlet formula *)
classNumberDirichlet[p_] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}] / p

(* Direct factorial *)
factorialModP[p_] := Mod[Times @@ Range[(p-1)/2], p]

(* Sign determination *)
signFromH[h_] := (-1)^((h + 1)/2)

Print["=== Comparing algorithms ===\n"];

(* Note: Mathematica's ClassNumber might use sublinear algorithm *)
testPrimes = Select[{10007, 100003, 1000003, 10000019}, Mod[#,4]==3 &];

Table[
  Print["p = ", p, " (", Length[IntegerDigits[p]], " digits)"];
  
  (* Wolfram built-in *)
  t1 = AbsoluteTiming[hBuiltin = ClassNumber[QuadraticField[-p]];][[1]];
  Print["  ClassNumber[QuadraticField[-p]]: ", t1, " sec, h=", hBuiltin];
  
  (* Our Dirichlet O(p) *)
  t2 = AbsoluteTiming[hDir = classNumberDirichlet[p];][[1]];
  Print["  Dirichlet O(p) formula: ", t2, " sec, h=", hDir];
  
  (* Factorial for comparison *)
  t3 = AbsoluteTiming[fac = factorialModP[p];][[1]];
  Print["  Factorial mod p: ", t3, " sec"];
  
  Print["  Built-in / Dirichlet speedup: ", N[t2/t1], "x"];
  Print[];
, {p, testPrimes}];

(* Even larger *)
Print["=== Very large p ==="];
p = 100000007;
Print["p = ", p, " (", Length[IntegerDigits[p]], " digits)"];

t1 = AbsoluteTiming[hBuiltin = ClassNumber[QuadraticField[-p]];][[1]];
Print["Built-in: ", t1, " sec, h = ", hBuiltin];

(* Factorial might be faster! *)
t3 = AbsoluteTiming[fac = factorialModP[p];][[1]];
Print["Factorial: ", t3, " sec"];

Print["\nPredicted sign from h: ", signFromH[hBuiltin]];
Print["Actual from factorial: ", If[fac == 1, "+1", "-1"]];
Print["Match: ", signFromH[hBuiltin] == If[fac == 1, 1, -1]];
