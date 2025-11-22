#!/usr/bin/env wolframscript
(* Analyze FactorialTerm sum for hypergeometric structure *)

<< Orbit`

Print["Analyzing FactorialTerm hypergeometric form...\n"];

(* The sum inside FactorialTerm[x, j] *)
factSum[x_, j_] := Sum[2^(i-1) * x^i * Factorial[j+i] /
                        (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];

(* Analyze term structure *)
Print["Term structure analysis:\n"];
Print["a(i) = 2^(i-1) * x^i * (j+i)! / ((j-i)! * (2i)!)"];
Print[];

(* Compute ratio of consecutive terms *)
Print["Ratio of consecutive terms a(i+1)/a(i):\n"];
ratioExpr = Module[{ai, ai1},
  ai = 2^(i-1) * x^i * Factorial[j+i] / (Factorial[j-i] * Factorial[2*i]);
  ai1 = 2^i * x^(i+1) * Factorial[j+i+1] / (Factorial[j-i-1] * Factorial[2*i+2]);
  Simplify[ai1/ai]
];
Print["  ", ratioExpr];
Print[];

(* Test specific case j=3 *)
j = 3;
Print["Testing j = ", j, ":\n"];

(* Compute the sum explicitly *)
sumVal = factSum[x, j];
Print["Sum = ", sumVal];
Print[];

(* Try various hypergeometric forms *)
Print["Testing hypergeometric matches:\n"];

(* General 2F1 form *)
testHyper[a_, b_, c_] := Module[{hyp, diff},
  hyp = Hypergeometric2F1[a, b, c, x];
  diff = Simplify[sumVal - hyp];
  {a, b, c, diff}
];

(* Try some parameter combinations *)
tests = {
  {1, 1, 1},
  {1, 2, 2},
  {1, j+1, 2},
  {j+1, j+1, 2*j+1},
  {-j, j+1, 1}
};

Print["Testing 2F1[a,b,c,x]:\n"];
Do[
  {a, b, c, diff} = testHyper[tests[[i,1]], tests[[i,2]], tests[[i,3]]];
  Print["  2F1[", a, ",", b, ",", c, ",x]: diff = ", diff];
, {i, 1, Length[tests]}];
Print[];

(* Try rewriting with binomial coefficients *)
Print["Rewriting terms with binomials:\n"];
Print["(j+i)! / (j-i)! = (j-i+1)(j-i+2)...(j+i)"];
Print["This is a product of 2i consecutive integers starting at j-i+1"];
Print[];
Print["(2i)! = 2^i * i! * (1)(3)(5)...(2i-1) [double factorial]"];
Print[];

(* Express in Pochhammer notation *)
Print["Pochhammer symbol analysis:\n"];
Print["(a)_n = a(a+1)(a+2)...(a+n-1) = Gamma(a+n)/Gamma(a)"];
Print[];
Print["(j+i)! / (j-i)! = Gamma(j+i+1) / Gamma(j-i+1)"];
Print["                = (j-i+1)_{2i}"];
Print[];

(* Check if sum matches 3F2 *)
Print["Testing 3F2 forms:\n"];
hyp3F2 = HypergeometricPFQ[{1, j+1, -j}, {1, 1/2}, x/4];
Print["  3F2[{1,j+1,-j},{1,1/2},x/4] = ", Simplify[hyp3F2]];
diff3F2 = Simplify[sumVal - hyp3F2];
Print["  Difference: ", diff3F2];
Print[];

(* Numerical comparison *)
Print["Numerical verification (j=3, x=2):\n"];
j = 3;
x = 2;
sumNum = N[factSum[2, 3], 10];
factNum = N[FactorialTerm[2, 3], 10];
Print["  Sum value: ", sumNum];
Print["  FactorialTerm: ", factNum];
Print["  1/(1+sum): ", N[1/(1+sumNum), 10]];
Print[];

Print["DONE!"];
