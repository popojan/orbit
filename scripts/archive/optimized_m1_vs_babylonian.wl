#!/usr/bin/env wolframscript
(* OPTIMIZED SPEED COMPARISON: Pre-simplified m1=1 vs Babylonian *)

PellSolve[d_] := Module[{a=1,b=0,c=-d,t,u=1,v=0,r=0,s=1},
  While[t=a+b+b+c;If[t>0,a=t;b+=c;u+=v;r+=s,b+=a;c=t;v+=u;s+=r];Not[a==1&&b==0&&c==-d]];{u,r}];

(* OPTIMIZED: Pre-simplified sqrttrf for m=1 *)
(* Derived externally: sqrttrf[nn,n,1] = (nn*(3*n^2 + nn))/(n^3 + 3*n*nn) *)
(* Factored for minimal operations: = nn*(3*n^2 + nn) / (n*(n^2 + 3*nn)) *)
sqrttrfOpt[nn_, n_] := (nn*(3*n^2 + nn))/(n*(n^2 + 3*nn));
symOpt[nn_, n_] := Module[{x = sqrttrfOpt[nn, n]}, nn/(2*x) + x/2];
nestqrtOptimized[nn_, n0_, m2_] := Nest[symOpt[nn, #]&, n0, m2];

BabylonianSqrt[d_,n0_,iters_]:=Nest[(d/(2 #)+#/2)&,n0,iters];

QuadError[n_,approx_]:=Log[10,Abs[n-approx^2]];

(* Setup *)
d = 13;
{pellX, pellY} = PellSolve[d];
pellBase = (pellX - 1)/pellY;

Print["================================================================"];
Print["OPTIMIZED SPEED TEST: Pre-simplified m1=1 vs Babylonian"];
Print["Using closed-form m1=1 (no ChebyshevU evaluation!)"];
Print["Both seeded with Pell base"];
Print["================================================================"];
Print[""];

(* Test at matched precision levels *)
Print["TEST 1: ~100 digits"];
Print["----------------------------------------"];
{nestTime, nestResult} = RepeatedTiming[nestqrtOptimized[d, pellBase, 2], 1];
nestPrec = Floor[-QuadError[d, nestResult]];
Print["Optimized Nested m1=1, m2=2:"];
Print["  Time: ", N[nestTime, 6], "s"];
Print["  Precision: ", nestPrec, " digits"];

targetPrec = nestPrec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print[""];
Print["RESULT: ", If[nestTime < babTime,
  "Nested wins " <> ToString[N[babTime/nestTime, 3]] <> "x faster!",
  "Babylonian wins " <> ToString[N[nestTime/babTime, 3]] <> "x faster"]];
Print[""];
Print[""];

Print["TEST 2: ~1000 digits"];
Print["----------------------------------------"];
{nestTime, nestResult} = RepeatedTiming[nestqrtOptimized[d, pellBase, 3], 1];
nestPrec = Floor[-QuadError[d, nestResult]];
Print["Optimized Nested m1=1, m2=3:"];
Print["  Time: ", N[nestTime, 6], "s"];
Print["  Precision: ", nestPrec, " digits"];

targetPrec = nestPrec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print[""];
Print["RESULT: ", If[nestTime < babTime,
  "Nested wins " <> ToString[N[babTime/nestTime, 3]] <> "x faster!",
  "Babylonian wins " <> ToString[N[nestTime/babTime, 3]] <> "x faster"]];
Print[""];
Print[""];

Print["TEST 3: ~4000 digits"];
Print["----------------------------------------"];
{nestTime, nestResult} = RepeatedTiming[nestqrtOptimized[d, pellBase, 4], 1];
nestPrec = Floor[-QuadError[d, nestResult]];
Print["Optimized Nested m1=1, m2=4:"];
Print["  Time: ", N[nestTime, 6], "s"];
Print["  Precision: ", nestPrec, " digits"];

targetPrec = nestPrec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print[""];
Print["RESULT: ", If[nestTime < babTime,
  "Nested wins " <> ToString[N[babTime/nestTime, 3]] <> "x faster!",
  "Babylonian wins " <> ToString[N[nestTime/babTime, 3]] <> "x faster"]];
Print[""];
Print[""];

Print["TEST 4: ~24000 digits"];
Print["----------------------------------------"];
{nestTime, nestResult} = RepeatedTiming[nestqrtOptimized[d, pellBase, 5], 1];
nestPrec = Floor[-QuadError[d, nestResult]];
Print["Optimized Nested m1=1, m2=5:"];
Print["  Time: ", N[nestTime, 6], "s"];
Print["  Precision: ", nestPrec, " digits"];

targetPrec = nestPrec;
babIters = 1;
While[Floor[-QuadError[d, BabylonianSqrt[d, pellBase, babIters]]] < targetPrec, babIters++];
{babTime, babResult} = RepeatedTiming[BabylonianSqrt[d, pellBase, babIters], 1];
babPrec = Floor[-QuadError[d, babResult]];
Print["Babylonian (", babIters, " iters):"];
Print["  Time: ", N[babTime, 6], "s"];
Print["  Precision: ", babPrec, " digits"];
Print[""];
Print["RESULT: ", If[nestTime < babTime,
  "Nested wins " <> ToString[N[babTime/nestTime, 3]] <> "x faster!",
  "Babylonian wins " <> ToString[N[nestTime/babTime, 3]] <> "x faster"]];
Print[""];
