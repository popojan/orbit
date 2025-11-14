#!/usr/bin/env wolframscript
(* TRULY FAIR Comprehensive Sqrt Method Comparison *)
(* Strategy: For EACH method, measure precision, then ask Wolfram for SAME precision *)

(* All sqrt methods *)
sqrttrf[nn_,n_,m_]:=(n^2+nn)/(2 n)+(n^2-nn)/(2 n)*ChebyshevU[m-1,Sqrt[nn/(-n^2+nn)]]/ChebyshevU[m+1,Sqrt[nn/(-n^2+nn)]]//Simplify;
sym[nn_,n_,m_]:=Module[{x=sqrttrf[nn,n,m]},nn/(2 x)+x/2];
nestqrt[nn_,n_,{m1_,m2_}]:=Nest[sym[nn,#,m1]&,n,m2];

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
Print["TRULY FAIR SQRT METHOD COMPARISON: sqrt(13)"];
Print["Strategy: Each algo runs, then Wolfram matches ITS precision"];
Print["================================================================"];
Print[""];

(* METHOD 1: Nested Chebyshev m1=3, m2=2 *)
Print["METHOD 1: Nested Chebyshev m1=3, m2=2 (Pell base)"];
Print["  STEP 1: Run our method"];
ourTime1=RepeatedTiming[ourResult1=nestqrt[d,pellBase,{3,2}],1][[1]];
ourPrec1=Floor[-QuadError[d,ourResult1]];
ourDenom1=IntegerLength[Denominator[ourResult1]];
Print["    Our time: ",N[ourTime1,4],"s"];
Print["    Our precision: ",ourPrec1," sqrt digits"];
Print["    Our denom digits: ",ourDenom1];
Print["  STEP 2: Run Wolfram at SAME precision (",ourPrec1," digits)"];
wmTime1=RepeatedTiming[wmResult1=Rationalize[Sqrt[N[d,ourPrec1+50]],10^(-ourPrec1)],1][[1]];
wmDenom1=IntegerLength[Denominator[wmResult1]];
Print["    WM time: ",N[wmTime1,4],"s"];
Print["    WM denom digits: ",wmDenom1," (optimal)"];
Print["  RESULT:"];
Print["    Overhead: ",N[ourDenom1/wmDenom1,3],"x"];
Print["    Speed: ",N[wmTime1/ourTime1,3],"x (>1 means we're faster)"];
Print[""];

(* METHOD 2: Babylonian 8 iters *)
Print["METHOD 2: Babylonian (Newton) 8 iters (crude start)"];
Print["  STEP 1: Run our method"];
ourTime2=RepeatedTiming[ourResult2=BabylonianSqrt[d,crude,8],1][[1]];
ourPrec2=Floor[-QuadError[d,ourResult2]];
ourDenom2=IntegerLength[Denominator[ourResult2]];
Print["    Our time: ",N[ourTime2,4],"s"];
Print["    Our precision: ",ourPrec2," sqrt digits"];
Print["    Our denom digits: ",ourDenom2];
Print["  STEP 2: Run Wolfram at SAME precision (",ourPrec2," digits)"];
wmTime2=RepeatedTiming[wmResult2=Rationalize[Sqrt[N[d,ourPrec2+50]],10^(-ourPrec2)],1][[1]];
wmDenom2=IntegerLength[Denominator[wmResult2]];
Print["    WM time: ",N[wmTime2,4],"s"];
Print["    WM denom digits: ",wmDenom2," (optimal)"];
Print["  RESULT:"];
Print["    Overhead: ",N[ourDenom2/wmDenom2,3],"x"];
Print["    Speed: ",N[wmTime2/ourTime2,3],"x (>1 means we're faster)"];
Print[""];

(* METHOD 3: Original Chebyshev-Pell 10 terms *)
Print["METHOD 3: Original Chebyshev-Pell 10 terms (Pell base)"];
Print["  STEP 1: Run our method"];
ourTime3=RepeatedTiming[ourResult3=OriginalChebyshevPell[d,10],1][[1]];
ourPrec3=Floor[-QuadError[d,ourResult3]];
ourDenom3=IntegerLength[Denominator[ourResult3]];
Print["    Our time: ",N[ourTime3,4],"s"];
Print["    Our precision: ",ourPrec3," sqrt digits"];
Print["    Our denom digits: ",ourDenom3];
Print["  STEP 2: Run Wolfram at SAME precision (",ourPrec3," digits)"];
wmTime3=RepeatedTiming[wmResult3=Rationalize[Sqrt[N[d,ourPrec3+50]],10^(-ourPrec3)],1][[1]];
wmDenom3=IntegerLength[Denominator[wmResult3]];
Print["    WM time: ",N[wmTime3,4],"s"];
Print["    WM denom digits: ",wmDenom3," (optimal)"];
Print["  RESULT:"];
Print["    Overhead: ",N[ourDenom3/wmDenom3,3],"x"];
Print["    Speed: ",N[wmTime3/ourTime3,3],"x (>1 means we're faster)"];
Print[""];

(* METHOD 4: ALFEE k=7 *)
Print["METHOD 4: ALFEE k=7 (Pell base) - dual bounds"];
Print["  STEP 1: Run our method"];
ourTime4=RepeatedTiming[{lowerResult4,upperResult4}=alfee[d,pellBase,7]//Simplify,1][[1]];
ourPrec4Lower=Floor[-QuadError[d,lowerResult4]];
ourPrec4Upper=Floor[-QuadError[d,upperResult4]];
ourPrec4=Min[ourPrec4Lower,ourPrec4Upper]; (* use worst of the two bounds *)
ourDenom4Lower=IntegerLength[Denominator[lowerResult4]];
ourDenom4Upper=IntegerLength[Denominator[upperResult4]];
ourDenom4=(ourDenom4Lower+ourDenom4Upper)/2; (* average *)
Print["    Our time: ",N[ourTime4,4],"s"];
Print["    Our precision: ",ourPrec4Lower,"/",ourPrec4Upper," sqrt digits (lower/upper)"];
Print["    Our denom digits: ",ourDenom4Lower,"/",ourDenom4Upper," (avg: ",N[ourDenom4,4],")"];
Print["    Bracket width: ",N[upperResult4-lowerResult4,10]];
Print["  STEP 2: Run Wolfram at SAME precision (",ourPrec4," digits)"];
wmTime4=RepeatedTiming[wmResult4=Rationalize[Sqrt[N[d,ourPrec4+50]],10^(-ourPrec4)],1][[1]];
wmDenom4=IntegerLength[Denominator[wmResult4]];
Print["    WM time: ",N[wmTime4,4],"s"];
Print["    WM denom digits: ",wmDenom4," (optimal)"];
Print["  RESULT:"];
Print["    Overhead: ",N[ourDenom4/wmDenom4,3],"x"];
Print["    Speed: ",N[wmTime4/ourTime4,3],"x (>1 means we're faster)"];
Print[""];

Print["================================================================"];
Print["SUMMARY TABLE"];
Print["================================================================"];
Print["Method               | Prec | Our Time | WM Time | Denom OH | Speed"];
Print["----------------------------------------------------------------------"];
Print["Nested m1=3,m2=2     | ",ourPrec1," | ",N[ourTime1,4]," | ",N[wmTime1,4]," | ",N[ourDenom1/wmDenom1,2],"x | ",N[wmTime1/ourTime1,2],"x"];
Print["Babylonian 8 iters   | ",ourPrec2," | ",N[ourTime2,4]," | ",N[wmTime2,4]," | ",N[ourDenom2/wmDenom2,2],"x | ",N[wmTime2/ourTime2,2],"x"];
Print["Original Cheb-Pell   | ",ourPrec3," | ",N[ourTime3,4]," | ",N[wmTime3,4]," | ",N[ourDenom3/wmDenom3,2],"x | ",N[wmTime3/ourTime3,2],"x"];
Print["ALFEE k=7            | ",ourPrec4," | ",N[ourTime4,4]," | ",N[wmTime4,4]," | ",N[ourDenom4/wmDenom4,2],"x | ",N[wmTime4/ourTime4,2],"x"];
Print[""];
Print["Notes:"];
Print["- Each method compared at ITS OWN precision vs Wolfram"];
Print["- Denom OH = our denominator / Wolfram optimal (>1 means overhead)"];
Print["- Speed = WM time / our time (>1 means we're faster)"];
