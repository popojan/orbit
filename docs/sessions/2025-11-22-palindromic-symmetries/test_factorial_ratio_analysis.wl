#!/usr/bin/env wolframscript
(* Detailed ratio analysis for FactorialTerm sum *)

Print["Analyzing term ratio for hypergeometric identification...\n"];

(* Define the general term *)
term[i_, j_, x_] := 2^(i-1) * x^i * Factorial[j+i] / (Factorial[j-i] * Factorial[2*i]);

(* Compute and simplify the ratio *)
Print["Ratio a(i+1)/a(i):\n"];
ratio = Simplify[term[i+1, j, x] / term[i, j, x]];
Print["  ", ratio];
Print[];

(* Factor and rewrite *)
Print["Factoring the ratio:\n"];
ratioFactored = Factor[ratio];
Print["  ", ratioFactored];
Print[];

(* Rewrite in terms of (i + constant) for Pochhammer identification *)
Print["Rewriting numerator factors:\n"];
num = Numerator[ratioFactored];
Print["  Numerator: ", num];

(* Expand and analyze *)
numExpanded = Expand[num /. j -> j];
Print["  Expanded: ", numExpanded];
Print[];

Print["Rewriting denominator factors:\n"];
den = Denominator[ratioFactored];
Print["  Denominator: ", den];
denExpanded = Expand[den];
Print["  Expanded: ", denExpanded];
Print[];

(* Express as Pochhammer ratios *)
Print["Pochhammer form analysis:\n"];
Print["For hypergeometric ₚFₑ, ratio must be:\n"];
Print["  (i+a₁)(i+a₂)...(i+aₚ) / ((i+b₁)(i+b₂)...(i+bₑ)(i+1)) * z\n"];
Print[];

(* Try specific j values *)
Print["Testing specific j values:\n"];
Do[
  r = Simplify[ratio /. j -> jval];
  Print["j=", jval, ": ", r];
, {jval, 2, 5}];
Print[];

(* Check if the sum itself has a closed form *)
Print["Checking for closed forms (j=1 to 5):\n"];
Do[
  s = Sum[term[i, jval, x], {i, 1, jval}];
  sSimp = Simplify[Together[s]];
  Print["j=", jval, ": ", sSimp];
, {jval, 1, 5}];
Print[];

(* Try expressing in terms of rising factorials (Pochhammer) *)
Print["Pochhammer rewrite attempt:\n"];
Print["(j+i)! / (j-i)! = Pochhammer[j-i+1, 2i]"];
Print["                = (j-i+1)_{2i}"];
Print[];
Print["(2i)! = Pochhammer[1, 2i] = (1)_{2i}"];
Print[];
Print["But we also have 2^(i-1) factor which doesn't fit standard hypergeometric.\n"];

(* Check if removing the 2^(i-1) gives hypergeometric *)
termNoPow2[i_, j_, x_] := x^i * Factorial[j+i] / (Factorial[j-i] * Factorial[2*i]);

Print["Without 2^(i-1) factor:\n"];
sumNoPow2[j_] := Sum[termNoPow2[i, j, x], {i, 1, j}];

Do[
  s = sumNoPow2[jval];
  sSimp = Simplify[Together[s]];
  Print["j=", jval, ": ", sSimp];
, {jval, 1, 4}];
Print[];

(* Try matching to known hypergeometric identities *)
Print["Comparing to standard hypergeometric sums:\n"];

(* The Chu-Vandermonde identity: 2F1[-n, b; c; 1] = (c-b)_n / (c)_n *)
(* Gauss theorem: 2F1[a,b;c;1] = Gamma(c)Gamma(c-a-b)/(Gamma(c-a)Gamma(c-b)) if Re(c-a-b)>0 *)

Print["Hypergeometric at x=1 (if terminating):\n"];
Do[
  s = N[Sum[term[i, jval, 1], {i, 1, jval}], 10];
  Print["j=", jval, ", x=1: ", s];
, {jval, 1, 5}];
Print[];

Print["DONE!"];
