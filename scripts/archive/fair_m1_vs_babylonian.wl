#!/usr/bin/env wolframscript
(* FAIR COMPARISON: Nested m1=1 vs Babylonian *)
(* Strategy: Match precision levels for fair comparison *)

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

Print["=== FAIR COMPARISON: Nested m1=1 vs Babylonian ==="];
Print["Strategy: Match precision levels for fair comparison"];
Print["Both methods seeded with Pell base: ", N[pellBase, 10]];
Print[""];

(* TEST 1: Low precision *)
Print["TEST 1: Nested m1=1, m2=3"];
{nest3Time, nest3Result} = RepeatedTiming[nestqrt[d, pellBase, {1, 3}], 1];
nest3Prec = Floor[-QuadError[d, nest3Result]];
nest3Denom = IntegerLength[Denominator[nest3Result]];
Print["  Nested: ", nest3Prec, " digits in ", N[nest3Time, 4], "s, denom=", nest3Denom];

babylonIters1 = 8;
{bab1Time, bab1Result} = RepeatedTiming[BabylonianSqrt[d, pellBase, babylonIters1], 1];
bab1Prec = Floor[-QuadError[d, bab1Result]];
bab1Denom = IntegerLength[Denominator[bab1Result]];
Print["  Babylonian ", babylonIters1, " iters: ", bab1Prec, " digits in ", N[bab1Time, 4], "s, denom=", bab1Denom];
Print[""];

winner1 = If[nest3Time < bab1Time,
  "Nested (" <> ToString[N[bab1Time/nest3Time, 2]] <> "x faster)",
  "Babylonian (" <> ToString[N[nest3Time/bab1Time, 2]] <> "x faster)"
];
Print["  Winner: ", winner1];
Print[""];

(* TEST 2: Medium precision *)
Print["TEST 2: Nested m1=1, m2=4"];
{nest4Time, nest4Result} = RepeatedTiming[nestqrt[d, pellBase, {1, 4}], 1];
nest4Prec = Floor[-QuadError[d, nest4Result]];
nest4Denom = IntegerLength[Denominator[nest4Result]];
Print["  Nested: ", nest4Prec, " digits in ", N[nest4Time, 4], "s, denom=", nest4Denom];

babylonIters2 = 12;
{bab2Time, bab2Result} = RepeatedTiming[BabylonianSqrt[d, pellBase, babylonIters2], 1];
bab2Prec = Floor[-QuadError[d, bab2Result]];
bab2Denom = IntegerLength[Denominator[bab2Result]];
Print["  Babylonian ", babylonIters2, " iters: ", bab2Prec, " digits in ", N[bab2Time, 4], "s, denom=", bab2Denom];
Print[""];

winner2 = If[nest4Time < bab2Time,
  "Nested (" <> ToString[N[bab2Time/nest4Time, 2]] <> "x faster)",
  "Babylonian (" <> ToString[N[nest4Time/bab2Time, 2]] <> "x faster)"
];
Print["  Winner: ", winner2];
Print[""];

(* TEST 3: High precision *)
Print["TEST 3: Nested m1=1, m2=5"];
{nest5Time, nest5Result} = RepeatedTiming[nestqrt[d, pellBase, {1, 5}], 1];
nest5Prec = Floor[-QuadError[d, nest5Result]];
nest5Denom = IntegerLength[Denominator[nest5Result]];
Print["  Nested: ", nest5Prec, " digits in ", N[nest5Time, 4], "s, denom=", nest5Denom];

babylonIters3 = 15;
{bab3Time, bab3Result} = RepeatedTiming[BabylonianSqrt[d, pellBase, babylonIters3], 1];
bab3Prec = Floor[-QuadError[d, bab3Result]];
bab3Denom = IntegerLength[Denominator[bab3Result]];
Print["  Babylonian ", babylonIters3, " iters: ", bab3Prec, " digits in ", N[bab3Time, 4], "s, denom=", bab3Denom];
Print[""];

winner3 = If[nest5Time < bab3Time,
  "Nested (" <> ToString[N[bab3Time/nest5Time, 2]] <> "x faster)",
  "Babylonian (" <> ToString[N[nest5Time/bab3Time, 2]] <> "x faster)"
];
Print["  Winner: ", winner3];
Print[""];

(* SUMMARY *)
Print["SUMMARY: Babylonian precision per iteration"];
Print["  ", babylonIters1, " iters: ", bab1Prec, " digits"];
Print["  ", babylonIters2, " iters: ", bab2Prec, " digits"];
Print["  ", babylonIters3, " iters: ", bab3Prec, " digits"];
Print[""];

Print["SUMMARY: Nested m1=1 precision per m2"];
Print["  m2=3: ", nest3Prec, " digits"];
Print["  m2=4: ", nest4Prec, " digits"];
Print["  m2=5: ", nest5Prec, " digits"];
