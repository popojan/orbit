#!/usr/bin/env wolframscript
(* CONVERGENCE RATE COMPARISON: Nested m1=1 vs Babylonian *)
(* Focus: digits gained per iteration, not wall-clock speed *)
(* Both seeded with same starting value (Pell base) *)

(* All required functions *)
PellSolve[d_] := Module[{a=1,b=0,c=-d,t,u=1,v=0,r=0,s=1},
  While[t=a+b+b+c;If[t>0,a=t;b+=c;u+=v;r+=s,b+=a;c=t;v+=u;s+=r];Not[a==1&&b==0&&c==-d]];{u,r}];

sqrttrf[nn_,n_,m_]:=(n^2+nn)/(2 n)+(n^2-nn)/(2 n)*ChebyshevU[m-1,Sqrt[nn/(-n^2+nn)]]/ChebyshevU[m+1,Sqrt[nn/(-n^2+nn)]]//Simplify;
sym[nn_,n_,m_]:=Module[{x=sqrttrf[nn,n,m]},nn/(2 x)+x/2];
nestqrt[nn_,n_,{m1_,m2_}]:=Nest[sym[nn,#,m1]&,n,m2];

BabylonianSqrt[d_,n0_,iters_]:=Nest[(d/(2 #)+#/2)&,n0,iters];

QuadError[n_,approx_]:=Log[10,Abs[n-approx^2]];

(* Setup *)
d = 13;
{pellX, pellY} = PellSolve[d];
pellBase = (pellX - 1)/pellY;
crude = Ceiling[Sqrt[d]];

Print["================================================================"];
Print["CONVERGENCE RATE COMPARISON: Nested m1=1 vs Babylonian"];
Print["Focus: Digits gained per iteration"];
Print["================================================================"];
Print[""];

Print["Test d = ", d];
Print["Pell base: ", pellBase, " = ", N[pellBase, 10]];
Print["Crude start: ", crude];
Print[""];

(* SEED COMPARISON: Pell base *)
Print["================================================================"];
Print["SEEDING: Pell base (optimal rational start)"];
Print["================================================================"];
Print[""];

Print["NESTED m1=1 convergence (Pell seed):"];
Print["Iteration | m2 | Digits | Gain per iteration"];
Print["-----------------------------------------------"];
basePrecPell = Floor[-QuadError[d, pellBase]];
Print["Base      | 0  | ", basePrecPell, " | --"];

Do[
  result = nestqrt[d, pellBase, {1, m2}];
  prec = Floor[-QuadError[d, result]];
  gainPerIter = If[m2 > 0, N[(prec - basePrecPell)/m2, 4], 0];
  Print["Nested    | ", m2, "  | ", prec, " | ", gainPerIter, " digits/iter"];
, {m2, 1, 5}];

Print[""];
Print["BABYLONIAN convergence (Pell seed):"];
Print["Iteration | iters | Digits | Gain per iteration"];
Print["-----------------------------------------------"];
Print["Base      | 0     | ", basePrecPell, " | --"];

Do[
  result = BabylonianSqrt[d, pellBase, iters];
  prec = Floor[-QuadError[d, result]];
  gainPerIter = If[iters > 0, N[(prec - basePrecPell)/iters, 4], 0];
  Print["Babylonian| ", iters, "     | ", prec, " | ", gainPerIter, " digits/iter"];
, {iters, 1, 5}];

Print[""];
Print[""];

(* SEED COMPARISON: Crude ceiling *)
Print["================================================================"];
Print["SEEDING: Ceiling[Sqrt[d]] (crude integer start)"];
Print["================================================================"];
Print[""];

Print["NESTED m1=1 convergence (crude seed):"];
Print["Iteration | m2 | Digits | Gain per iteration"];
Print["-----------------------------------------------"];
basePrecCrude = Floor[-QuadError[d, crude]];
Print["Base      | 0  | ", basePrecCrude, " | --"];

Do[
  result = nestqrt[d, crude, {1, m2}];
  prec = Floor[-QuadError[d, result]];
  gainPerIter = If[m2 > 0, N[(prec - basePrecCrude)/m2, 4], 0];
  Print["Nested    | ", m2, "  | ", prec, " | ", gainPerIter, " digits/iter"];
, {m2, 1, 5}];

Print[""];
Print["BABYLONIAN convergence (crude seed):"];
Print["Iteration | iters | Digits | Gain per iteration"];
Print["-----------------------------------------------"];
Print["Base      | 0     | ", basePrecCrude, " | --"];

Do[
  result = BabylonianSqrt[d, crude, iters];
  prec = Floor[-QuadError[d, result]];
  gainPerIter = If[iters > 0, N[(prec - basePrecCrude)/iters, 4], 0];
  Print["Babylonian| ", iters, "     | ", prec, " | ", gainPerIter, " digits/iter"];
, {iters, 1, 5}];

Print[""];
Print[""];

(* CONVERGENCE RATE ANALYSIS *)
Print["================================================================"];
Print["CONVERGENCE RATE SUMMARY"];
Print["================================================================"];
Print[""];

(* Pell seed *)
nest1Pell = Floor[-QuadError[d, nestqrt[d, pellBase, {1, 1}]]];
nest5Pell = Floor[-QuadError[d, nestqrt[d, pellBase, {1, 5}]]];
avgGainNestPell = N[(nest5Pell - basePrecPell)/5, 4];

bab1Pell = Floor[-QuadError[d, BabylonianSqrt[d, pellBase, 1]]];
bab5Pell = Floor[-QuadError[d, BabylonianSqrt[d, pellBase, 5]]];
avgGainBabPell = N[(bab5Pell - basePrecPell)/5, 4];

Print["Pell base seeding:"];
Print["  Nested m1=1: ", avgGainNestPell, " digits/iteration (average over 5 iters)"];
Print["  Babylonian:  ", avgGainBabPell, " digits/iteration (average over 5 iters)"];
Print["  Ratio (Bab/Nest): ", N[avgGainBabPell/avgGainNestPell, 3], "x"];
Print[""];

(* Crude seed *)
nest1Crude = Floor[-QuadError[d, nestqrt[d, crude, {1, 1}]]];
nest5Crude = Floor[-QuadError[d, nestqrt[d, crude, {1, 5}]]];
avgGainNestCrude = N[(nest5Crude - basePrecCrude)/5, 4];

bab1Crude = Floor[-QuadError[d, BabylonianSqrt[d, crude, 1]]];
bab5Crude = Floor[-QuadError[d, BabylonianSqrt[d, crude, 5]]];
avgGainBabCrude = N[(bab5Crude - basePrecCrude)/5, 4];

Print["Crude ceiling seeding:"];
Print["  Nested m1=1: ", avgGainNestCrude, " digits/iteration (average over 5 iters)"];
Print["  Babylonian:  ", avgGainBabCrude, " digits/iteration (average over 5 iters)"];
Print["  Ratio (Bab/Nest): ", N[avgGainBabCrude/avgGainNestCrude, 3], "x"];
Print[""];

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];
Print["The algorithm with higher digits/iteration has better convergence."];
Print["Note: Babylonian doubles precision each iteration asymptotically."];
Print["Note: Nested Chebyshev m1=1 has different convergence pattern."];
