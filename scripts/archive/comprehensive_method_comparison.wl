#!/usr/bin/env wolframscript
(* Comprehensive Sqrt Method Comparison *)
(* Includes: Rationalize, Nested Chebyshev, Binet, Babylonian, Original Chebyshev-Pell *)

(* All sqrt methods *)
sqrttrf[nn_,n_,m_]:=(n^2+nn)/(2 n)+(n^2-nn)/(2 n)*ChebyshevU[m-1,Sqrt[nn/(-n^2+nn)]]/ChebyshevU[m+1,Sqrt[nn/(-n^2+nn)]]//Simplify;
sym[nn_,n_,m_]:=Module[{x=sqrttrf[nn,n,m]},nn/(2 x)+x/2];
nestqrt[nn_,n_,{m1_,m2_}]:=Nest[sym[nn,#,m1]&,n,m2];

(* Binet-like formula - CORRECTED - returns lower bound *)
BinetSqrt[d_,n_,k_]:=Sqrt[d]*(((n+Sqrt[d])^k-(n-Sqrt[d])^k)/((n+Sqrt[d])^k+(n-Sqrt[d])^k))//Simplify;

(* ALFEE - returns {lower, upper} bounds simultaneously *)
alfee[nn_,n_,k_]:={#,nn/#}&@(Sqrt[nn]*((n+Sqrt[nn])^k-(n-Sqrt[nn])^k)/((n+Sqrt[nn])^k+(n-Sqrt[nn])^k));

(* Babylonian (Newton) *)
BabylonianSqrt[d_,n0_,iters_]:=Nest[(d/(2 #)+#/2)&,n0,iters];

(* Original Chebyshev-Pell *)
PellSolve[d_]:=Module[{a=1,b=0,c=-d,t,u=1,v=0,r=0,s=1},
  While[t=a+b+b+c;If[t>0,a=t;b+=c;u+=v;r+=s,b+=a;c=t;v+=u;s+=r];Not[a==1&&b==0&&c==-d]];{u,r}];

ChebyshevTerm[x_,k_]:=1/(ChebyshevT[Ceiling[k/2],x+1]*(ChebyshevU[Floor[k/2],x+1]-ChebyshevU[Floor[k/2]-1,x+1]));

OriginalChebyshevPell[d_,terms_]:=Module[{sol=PellSolve[d],x,y,base},
  {x,y}=sol;
  base=(x-1)/y;
  base*(1+Sum[ChebyshevTerm[x-1,k],{k,1,terms}])
];

QuadError[n_,approx_]:=Log[10,Abs[n-approx^2]];

d=13;
{pellX,pellY}=PellSolve[d];
pellBase=(pellX-1)/pellY;
crude=3;

Print["================================================================"];
Print["COMPREHENSIVE SQRT METHOD COMPARISON: sqrt(13)"];
Print["Target precision: ~150 digits (modest)"];
Print["Using RepeatedTiming for accurate short-duration measurements"];
Print["================================================================"];
Print[""];

(* METHOD 1: Wolfram Rationalize - BASELINE *)
Print["METHOD 1: Wolfram Rationalize (CF convergents) - BASELINE"];
targetPrec=155;
wmTime=RepeatedTiming[wmResult=Rationalize[Sqrt[N[d,targetPrec+50]],10^(-targetPrec)],1][[1]];
wmPrec=Floor[-QuadError[d,wmResult]];
wmDenom=IntegerLength[Denominator[wmResult]];
Print["  Time: ",N[wmTime,4],"s (RepeatedTiming)"];
Print["  Sqrt precision: ",wmPrec," digits"];
Print["  Denom digits: ",wmDenom," (optimal by definition)"];
Print[""];

(* METHOD 2: Nested Chebyshev *)
Print["METHOD 2: Nested Chebyshev m1=3, m2=2 (Pell base)"];
nestTime=RepeatedTiming[nestResult=nestqrt[d,pellBase,{3,2}],1][[1]];
nestPrec=Floor[-QuadError[d,nestResult]];
nestDenom=IntegerLength[Denominator[nestResult]];
Print["  Time: ",N[nestTime,4],"s (RepeatedTiming)"];
Print["  Sqrt precision: ",nestPrec," digits"];
Print["  Denom digits: ",nestDenom];
Print["  Overhead vs CF: ",N[nestDenom/wmDenom,3],"x"];
Print["  Speed vs WM: ",If[nestTime>0,N[wmTime/nestTime,3],"N/A"],"x"];
Print[""];

(* METHOD 3: Binet *)
Print["METHOD 3: Binet-like formula k=7 (Pell base)"];
binetTime=RepeatedTiming[binetResult=BinetSqrt[d,pellBase,7],1][[1]];
binetPrec=Floor[-QuadError[d,binetResult]];
binetDenom=IntegerLength[Denominator[binetResult]];
Print["  Time: ",N[binetTime,4],"s (RepeatedTiming)"];
Print["  Sqrt precision: ",binetPrec," digits"];
Print["  Denom digits: ",binetDenom];
Print["  Overhead vs CF: ",N[binetDenom/wmDenom,3],"x"];
Print["  Speed vs WM: ",If[binetTime>0,N[wmTime/binetTime,3],"N/A"],"x"];
Print[""];

(* METHOD 4: Babylonian *)
Print["METHOD 4: Babylonian (Newton) 8 iters (crude start)"];
babylonTime=RepeatedTiming[babylonResult=BabylonianSqrt[d,crude,8],1][[1]];
babylonPrec=Floor[-QuadError[d,babylonResult]];
babylonDenom=IntegerLength[Denominator[babylonResult]];
Print["  Time: ",N[babylonTime,4],"s (RepeatedTiming)"];
Print["  Sqrt precision: ",babylonPrec," digits"];
Print["  Denom digits: ",babylonDenom];
Print["  Overhead vs CF: ",N[babylonDenom/wmDenom,3],"x"];
Print["  Speed vs WM: ",If[babylonTime>0,N[wmTime/babylonTime,3],"N/A"],"x"];
Print[""];

(* METHOD 5: Original Chebyshev-Pell *)
Print["METHOD 5: Original Chebyshev-Pell 10 terms (Pell base)"];
origTime=RepeatedTiming[origResult=OriginalChebyshevPell[d,10],1][[1]];
origPrec=Floor[-QuadError[d,origResult]];
origDenom=IntegerLength[Denominator[origResult]];
Print["  Time: ",N[origTime,4],"s (RepeatedTiming)"];
Print["  Sqrt precision: ",origPrec," digits"];
Print["  Denom digits: ",origDenom];
Print["  Overhead vs CF: ",N[origDenom/wmDenom,3],"x"];
Print["  Speed vs WM: ",If[origTime>0,N[wmTime/origTime,3],"N/A"],"x"];
Print[""];

(* METHOD 6: ALFEE - dual bounds *)
Print["METHOD 6: ALFEE k=7 (Pell base) - returns {lower, upper} bounds"];
alfeeTime=RepeatedTiming[{alfeeLower,alfeeUpper}=alfee[d,pellBase,7]//Simplify,1][[1]];
alfeePrecLower=Floor[-QuadError[d,alfeeLower]];
alfeePrecUpper=Floor[-QuadError[d,alfeeUpper]];
alfeeDenomLower=IntegerLength[Denominator[alfeeLower]];
alfeeDenomUpper=IntegerLength[Denominator[alfeeUpper]];
Print["  Time: ",N[alfeeTime,4],"s (RepeatedTiming)"];
Print["  Lower bound precision: ",alfeePrecLower," digits"];
Print["  Upper bound precision: ",alfeePrecUpper," digits"];
Print["  Lower denom digits: ",alfeeDenomLower];
Print["  Upper denom digits: ",alfeeDenomUpper];
Print["  Bracket width: ",N[alfeeUpper-alfeeLower,10]];
Print["  Speed vs WM: ",If[alfeeTime>0,N[wmTime/alfeeTime,3],"N/A"],"x"];
Print[""];

Print["================================================================"];
Print["SUMMARY TABLE"];
Print["================================================================"];
Print["Method               | Prec | Time(s) | Denom | Overhead | Speed"];
Print["------------------------------------------------------------------"];
Print["Wolfram Rationalize  | ",wmPrec," | ",N[wmTime,4]," | ",wmDenom," | 1.0x | 1.0x"];
Print["Nested Chebyshev     | ",nestPrec," | ",N[nestTime,4]," | ",nestDenom," | ",N[nestDenom/wmDenom,2],"x | ",If[nestTime>0,N[wmTime/nestTime,2],"N/A"],"x"];
Print["Binet k=7            | ",binetPrec," | ",N[binetTime,4]," | ",binetDenom," | ",N[binetDenom/wmDenom,2],"x | ",If[binetTime>0,N[wmTime/binetTime,2],"N/A"],"x"];
Print["Babylonian 8 iters   | ",babylonPrec," | ",N[babylonTime,4]," | ",babylonDenom," | ",N[babylonDenom/wmDenom,2],"x | ",If[babylonTime>0,N[wmTime/babylonTime,2],"N/A"],"x"];
Print["Original Cheb-Pell   | ",origPrec," | ",N[origTime,4]," | ",origDenom," | ",N[origDenom/wmDenom,2],"x | ",If[origTime>0,N[wmTime/origTime,2],"N/A"],"x"];
Print["ALFEE k=7 (lower)    | ",alfeePrecLower," | ",N[alfeeTime,4]," | ",alfeeDenomLower," | ",N[alfeeDenomLower/wmDenom,2],"x | ",If[alfeeTime>0,N[wmTime/alfeeTime,2],"N/A"],"x"];
Print["ALFEE k=7 (upper)    | ",alfeePrecUpper," | ",N[alfeeTime,4]," | ",alfeeDenomUpper," | ",N[alfeeDenomUpper/wmDenom,2],"x | ",If[alfeeTime>0,N[wmTime/alfeeTime,2],"N/A"],"x"];
