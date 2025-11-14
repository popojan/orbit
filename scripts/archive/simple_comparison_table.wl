(* ==================================================================
   SIMPLE COMPARISON TABLE

   Strategy: Run our methods FIRST, see what precision achieved,
   then only compare with Wolfram for modest results (<1000 sqrt digits)
   ================================================================== *)

PellSolve[d_] := Module[{a=1,b=0,c=-d,t,u=1,v=0,r=0,s=1},
  While[t=a+b+b+c;If[t>0,a=t;b+=c;u+=v;r+=s,b+=a;c=t;v+=u;s+=r];Not[a==1&&b==0&&c==-d]];{u,r}];

sqrttrf[nn_,n_,m_]:=(n^2+nn)/(2 n)+(n^2-nn)/(2 n)*ChebyshevU[m-1,Sqrt[nn/(-n^2+nn)]]/ChebyshevU[m+1,Sqrt[nn/(-n^2+nn)]]//Simplify;
sym[nn_,n_,m_]:=Module[{x=sqrttrf[nn,n,m]},nn/(2 x)+x/2];
nestqrt[nn_,n_,{m1_,m2_}]:=Nest[sym[nn,#,m1]&,n,m2];

QuadError[n_,approx_]:=Log[10,Abs[n-approx^2]];
SqrtPrecision[n_,approx_]:=-QuadError[n,approx]/2;

d=13;
{x,y}=PellSolve[d];
pellBase=(x-1)/y;
crude=Floor[Sqrt[d]];

Print["================================================================="];
Print["COMPARISON TABLE: Nested Chebyshev vs Wolfram Rationalize"];
Print["sqrt(", d, ")"];
Print["================================================================="];
Print[""];

(* Methods to test *)
methods = {
  {"m1=3, m2=2 (Pell)", pellBase, 3, 2},
  {"m1=3, m2=3 (Pell)", pellBase, 3, 3},
  {"m1=2, m2=4 (Pell)", pellBase, 2, 4},
  {"m1=2, m2=5 (Pell)", pellBase, 2, 5},
  {"m1=1, m2=7 (Pell)", pellBase, 1, 7},
  {"m1=1, m2=8 (Pell)", pellBase, 1, 8},
  {"m1=3, m2=2 (crude)", crude, 3, 2},
  {"m1=3, m2=3 (crude)", crude, 3, 3}
};

results = {};

Do[
  Module[{name, base, m1, m2, result, ourTime, sqrtDigits, ourDenom,
          wmTime, wmDenom, overhead, speedup, wmComparison},

    {name, base, m1, m2} = method;

    (* Compute OUR method *)
    {ourTime, result} = AbsoluteTiming[nestqrt[d, base, {m1, m2}]];
    sqrtDigits = Floor[SqrtPrecision[d, result]];
    ourDenom = IntegerLength[Denominator[result]];

    (* Only compare with Wolfram if modest precision *)
    If[sqrtDigits < 1000,
      (* Modest - do comparison *)
      {wmTime, wmResult} = AbsoluteTiming[
        Rationalize[Sqrt[N[d, sqrtDigits + 100]], 10^(-sqrtDigits)]
      ];
      wmDenom = IntegerLength[Denominator[wmResult]];
      overhead = N[ourDenom/wmDenom, 3];
      speedup = N[wmTime/ourTime, 3];
      wmComparison = {N[wmTime, 4], wmDenom, overhead, speedup},

      (* High precision - skip Wolfram *)
      wmComparison = {"-", "-", "-", "-"}
    ];

    AppendTo[results,
      Join[{name, sqrtDigits, N[ourTime, 4], ourDenom}, wmComparison]
    ];
  ],
  {method, methods}
];

(* Print table *)
Print[Grid[
  Prepend[results,
    {"Method", "√Digits", "Our Time", "Our Denom", "WM Time", "WM Denom", "Overhead", "WM/Our"}],
  Frame -> All,
  Alignment -> {{Left, Right, Right, Right, Right, Right, Right, Right}},
  Spacings -> {2, 1},
  ItemStyle -> {Automatic, {1 -> Bold}}
]];

Print[""];
Print["================================================================="];
Print["LEGEND"];
Print["  √Digits   = sqrt precision digits achieved"];
Print["  Our Time  = Time for nested Chebyshev"];
Print["  Our Denom = Denominator digits (our method)"];
Print["  WM Time   = Wolfram Rationalize at SAME precision"];
Print["  WM Denom  = Wolfram denominator (optimal CF)"];
Print["  Overhead  = (Our Denom)/(WM Denom) - size penalty"];
Print["  WM/Our    = Speed ratio (>1 means we're faster)"];
Print["  '-'       = Skipped (precision too high for WM)"];
Print["================================================================="];
