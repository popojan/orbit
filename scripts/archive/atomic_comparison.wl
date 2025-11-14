#!/usr/bin/env wolframscript
(* ATOMIC COMPARISON TEMPLATE *)
(* Clean abstraction: cmp[ourFunc, args] returns {ourResult, wmResult} *)

(* All sqrt methods *)
sqrttrf[nn_,n_,m_]:=(n^2+nn)/(2 n)+(n^2-nn)/(2 n)*ChebyshevU[m-1,Sqrt[nn/(-n^2+nn)]]/ChebyshevU[m+1,Sqrt[nn/(-n^2+nn)]]//Simplify;
sym[nn_,n_,m_]:=Module[{x=sqrttrf[nn,n,m]},nn/(2 x)+x/2];
nestqrt[nn_,n_,{m1_,m2_}]:=Nest[sym[nn,#,m1]&,n,m2];

alfee[nn_,n_,k_]:={#,nn/#}&@(Sqrt[nn]*((n+Sqrt[nn])^k-(n-Sqrt[nn])^k)/((n+Sqrt[nn])^k+(n-Sqrt[nn])^k));

BabylonianSqrt[d_,n0_,iters_]:=Nest[(d/(2 #)+#/2)&,n0,iters];

PellSolve[d_]:=Module[{a=1,b=0,c=-d,t,u=1,v=0,r=0,s=1},
  While[t=a+b+b+c;If[t>0,a=t;b+=c;u+=v;r+=s,b+=a;c=t;v+=u;s+=r];Not[a==1&&b==0&&c==-d]];{u,r}];

ChebyshevTerm[x_,k_]:=1/(ChebyshevT[Ceiling[k/2],x+1]*(ChebyshevU[Floor[k/2],x+1]-ChebyshevU[Floor[k/2]-1,x+1]));

OriginalChebyshevPell[d_,terms_]:=Module[{sol=PellSolve[d],x,y,base},
  {x,y}=sol;
  base=(x-1)/y;
  base*(1+Sum[ChebyshevTerm[x-1,k],{k,1,terms}])
];

QuadError[n_,approx_]:=Log[10,Abs[n-approx^2]];

(* ATOMIC COMPARISON FUNCTION *)
(* cmp[d, ourFunc] - runs our method, measures precision, runs Wolfram at same precision *)
cmp[d_, ourFunc_] := Module[{ourTime, ourResult, ourPrec, ourDenom, wmTime, wmResult, wmDenom},
  (* Step 1: Run our method *)
  {ourTime, ourResult} = RepeatedTiming[ourFunc[], 1];
  ourPrec = Floor[-QuadError[d, ourResult]];
  ourDenom = IntegerLength[Denominator[ourResult]];

  (* Step 2: Run Wolfram at SAME precision *)
  {wmTime, wmResult} = RepeatedTiming[
    Rationalize[Sqrt[N[d, ourPrec + 50]], 10^(-ourPrec)], 1
  ];
  wmDenom = IntegerLength[Denominator[wmResult]];

  (* Return structured result *)
  <|
    "OurTime" -> ourTime,
    "OurPrec" -> ourPrec,
    "OurDenom" -> ourDenom,
    "WMTime" -> wmTime,
    "WMDenom" -> wmDenom,
    "Overhead" -> N[ourDenom/wmDenom, 3],
    "Speedup" -> N[wmTime/ourTime, 3]
  |>
];

(* Special version for ALFEE (returns dual bounds) *)
cmpALFEE[d_, ourFunc_] := Module[{ourTime, lowerResult, upperResult, ourPrec, ourDenomLower, ourDenomUpper, wmTime, wmResult, wmDenom},
  (* Step 1: Run our method *)
  {ourTime, {lowerResult, upperResult}} = RepeatedTiming[ourFunc[]//Simplify, 1];
  ourPrec = Min[Floor[-QuadError[d, lowerResult]], Floor[-QuadError[d, upperResult]]];
  ourDenomLower = IntegerLength[Denominator[lowerResult]];
  ourDenomUpper = IntegerLength[Denominator[upperResult]];

  (* Step 2: Run Wolfram at SAME precision *)
  {wmTime, wmResult} = RepeatedTiming[
    Rationalize[Sqrt[N[d, ourPrec + 50]], 10^(-ourPrec)], 1
  ];
  wmDenom = IntegerLength[Denominator[wmResult]];

  (* Return structured result *)
  <|
    "OurTime" -> ourTime,
    "OurPrec" -> ourPrec,
    "OurDenomLower" -> ourDenomLower,
    "OurDenomUpper" -> ourDenomUpper,
    "BracketWidth" -> N[upperResult - lowerResult, 10],
    "WMTime" -> wmTime,
    "WMDenom" -> wmDenom,
    "Overhead" -> N[(ourDenomLower + ourDenomUpper)/(2*wmDenom), 3],
    "Speedup" -> N[wmTime/ourTime, 3]
  |>
];

(* Test setup *)
d = 13;
{pellX, pellY} = PellSolve[d];
pellBase = (pellX - 1)/pellY;
crude = 3;

Print["================================================================"];
Print["ATOMIC COMPARISON: sqrt(13)"];
Print["Using clean abstraction pattern: cmp[d, ourFunc]"];
Print["================================================================"];
Print[""];

(* METHOD 1: Nested Chebyshev *)
Print["METHOD 1: Nested Chebyshev m1=3, m2=2"];
result1 = cmp[d, Function[nestqrt[d, pellBase, {3, 2}]]];
Print["  Precision: ", result1["OurPrec"], " digits"];
Print["  Our time: ", N[result1["OurTime"], 4], "s"];
Print["  WM time: ", N[result1["WMTime"], 4], "s"];
Print["  Denom overhead: ", result1["Overhead"], "x"];
Print["  Speedup: ", result1["Speedup"], "x"];
Print[""];

(* METHOD 2: Babylonian *)
Print["METHOD 2: Babylonian 8 iters"];
result2 = cmp[d, Function[BabylonianSqrt[d, crude, 8]]];
Print["  Precision: ", result2["OurPrec"], " digits"];
Print["  Our time: ", N[result2["OurTime"], 4], "s"];
Print["  WM time: ", N[result2["WMTime"], 4], "s"];
Print["  Denom overhead: ", result2["Overhead"], "x"];
Print["  Speedup: ", result2["Speedup"], "x"];
Print[""];

(* METHOD 3: Original Chebyshev-Pell *)
Print["METHOD 3: Original Chebyshev-Pell 10 terms"];
result3 = cmp[d, Function[OriginalChebyshevPell[d, 10]]];
Print["  Precision: ", result3["OurPrec"], " digits"];
Print["  Our time: ", N[result3["OurTime"], 4], "s"];
Print["  WM time: ", N[result3["WMTime"], 4], "s"];
Print["  Denom overhead: ", result3["Overhead"], "x"];
Print["  Speedup: ", result3["Speedup"], "x"];
Print[""];

(* METHOD 4: ALFEE *)
Print["METHOD 4: ALFEE k=7 (dual bounds)"];
result4 = cmpALFEE[d, Function[alfee[d, pellBase, 7]]];
Print["  Precision: ", result4["OurPrec"], " digits"];
Print["  Bracket width: ", result4["BracketWidth"]];
Print["  Our time: ", N[result4["OurTime"], 4], "s"];
Print["  WM time: ", N[result4["WMTime"], 4], "s"];
Print["  Denom overhead: ", result4["Overhead"], "x"];
Print["  Speedup: ", result4["Speedup"], "x"];
Print[""];

(* SUMMARY TABLE *)
Print["================================================================"];
Print["SUMMARY TABLE"];
Print["================================================================"];
Print["Method               | Prec | Speedup | Overhead"];
Print["--------------------------------------------------"];
Print["Nested m1=3,m2=2     | ", result1["OurPrec"], " | ", result1["Speedup"], "x | ", result1["Overhead"], "x"];
Print["Babylonian 8 iters   | ", result2["OurPrec"], " | ", result2["Speedup"], "x | ", result2["Overhead"], "x"];
Print["Original Cheb-Pell   | ", result3["OurPrec"], " | ", result3["Speedup"], "x | ", result3["Overhead"], "x"];
Print["ALFEE k=7            | ", result4["OurPrec"], " | ", result4["Speedup"], "x | ", result4["Overhead"], "x"];
