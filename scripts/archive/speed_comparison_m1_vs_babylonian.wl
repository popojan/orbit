#!/usr/bin/env wolframscript
(* SPEED COMPARISON: Nested m1=1 vs Babylonian *)
(* Both seeded with Pell base, same Wolfram implementation *)
(* Compare both convergence AND wall-clock time *)

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

Print["================================================================"];
Print["SPEED & CONVERGENCE: Nested m1=1 vs Babylonian"];
Print["Both using Wolfram 14.3, both seeded with Pell base"];
Print["================================================================"];
Print[""];
Print["Pell base: ", pellBase, " = ", N[pellBase, 10]];
Print[""];

(* TEST: Match precision levels and compare time *)
Print["================================================================"];
Print["MATCHED PRECISION TESTS"];
Print["================================================================"];
Print[""];

(* Test 1: ~100 digits *)
Print["TEST 1: Target ~100 digits"];
Print["----------------------------------------"];
{nest2Time, nest2Result} = RepeatedTiming[nestqrt[d, pellBase, {1, 2}], 1];
nest2Prec = Floor[-QuadError[d, nest2Result]];
Print["Nested m1=1, m2=2:"];
Print["  Time: ", N[nest2Time, 6], "s"];
Print["  Precision: ", nest2Prec, " digits"];
Print["  Digits/sec: ", N[nest2Prec/nest2Time, 3]];
Print[""];

(* Find Babylonian iters to match *)
targetPrec = nest2Prec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters to match):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print["  Digits/sec: ", N[babPrec/babTime, 3]];
Print[""];
Print["WINNER: ", If[nest2Time < babTime,
  "Nested (" <> ToString[N[babTime/nest2Time, 2]] <> "x faster)",
  "Babylonian (" <> ToString[N[nest2Time/babTime, 2]] <> "x faster)"]];
Print[""];
Print[""];

(* Test 2: ~1000 digits *)
Print["TEST 2: Target ~1000 digits"];
Print["----------------------------------------"];
{nest3Time, nest3Result} = RepeatedTiming[nestqrt[d, pellBase, {1, 3}], 1];
nest3Prec = Floor[-QuadError[d, nest3Result]];
Print["Nested m1=1, m2=3:"];
Print["  Time: ", N[nest3Time, 6], "s"];
Print["  Precision: ", nest3Prec, " digits"];
Print["  Digits/sec: ", N[nest3Prec/nest3Time, 3]];
Print[""];

targetPrec = nest3Prec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters to match):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print["  Digits/sec: ", N[babPrec/babTime, 3]];
Print[""];
Print["WINNER: ", If[nest3Time < babTime,
  "Nested (" <> ToString[N[babTime/nest3Time, 2]] <> "x faster)",
  "Babylonian (" <> ToString[N[nest3Time/babTime, 2]] <> "x faster)"]];
Print[""];
Print[""];

(* Test 3: ~4000 digits *)
Print["TEST 3: Target ~4000 digits"];
Print["----------------------------------------"];
{nest4Time, nest4Result} = RepeatedTiming[nestqrt[d, pellBase, {1, 4}], 1];
nest4Prec = Floor[-QuadError[d, nest4Result]];
Print["Nested m1=1, m2=4:"];
Print["  Time: ", N[nest4Time, 6], "s"];
Print["  Precision: ", nest4Prec, " digits"];
Print["  Digits/sec: ", N[nest4Prec/nest4Time, 3]];
Print[""];

targetPrec = nest4Prec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters to match):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print["  Digits/sec: ", N[babPrec/babTime, 3]];
Print[""];
Print["WINNER: ", If[nest4Time < babTime,
  "Nested (" <> ToString[N[babTime/nest4Time, 2]] <> "x faster)",
  "Babylonian (" <> ToString[N[nest4Time/babTime, 2]] <> "x faster)"]];
Print[""];
Print[""];

(* Test 4: ~24000 digits *)
Print["TEST 4: Target ~24000 digits"];
Print["----------------------------------------"];
{nest5Time, nest5Result} = RepeatedTiming[nestqrt[d, pellBase, {1, 5}], 1];
nest5Prec = Floor[-QuadError[d, nest5Result]];
Print["Nested m1=1, m2=5:"];
Print["  Time: ", N[nest5Time, 6], "s"];
Print["  Precision: ", nest5Prec, " digits"];
Print["  Digits/sec: ", N[nest5Prec/nest5Time, 3]];
Print[""];

targetPrec = nest5Prec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters to match):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print["  Digits/sec: ", N[babPrec/babTime, 3]];
Print[""];
Print["WINNER: ", If[nest5Time < babTime,
  "Nested (" <> ToString[N[babTime/nest5Time, 2]] <> "x faster)",
  "Babylonian (" <> ToString[N[nest5Time/babTime, 2]] <> "x faster)"]];
Print[""];
Print[""];

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print["Both algorithms implemented in Wolfram Language 14.3"];
Print["Both seeded with optimal Pell base"];
Print["Nested m1=1 has superior convergence rate (~6x per iter)"];
Print["Babylonian has simpler arithmetic per iteration"];
Print["At what precision does Nested overtake Babylonian in speed?"];
