(* ::Package:: *)

BeginPackage["Egypt`"]

EgyptianFractions::usage = "EgyptianFractions[ q] converts a rational number to an egyptian fractions representation"

EgyptianSqrtApproximate::usage = "EgyptianSqrtApproximate[ n] approximates a square root by a rational number using egyptian fractions"

Begin["Private`"]

HalveRawFractionsOnce[{u_, v_, i_, j_}, lim_] :=
    If[j - i + 1 > lim,
        Module[{ret = {}, a, b},
            {a, b} = NumeratorDenominator @ First @ CalculateRawFractions
                 @ {{u, v, i, j}};
            If[OddQ @ a,
                AppendTo[ret, Floor[a / 2] / b];
                AppendTo[ret, Ceiling[a / 2] / b]
                ,
                AppendTo[ret, (a / 2 - 1) / b];
                AppendTo[ret, (a / 2 + 1) / b]
            ];
            Flatten[RawFractions /@ DeleteCases[ret, 0], 1]
        ]
        ,
        {{u, v, i, j}}
    ]

RawFractions[q_Rational] :=
    Module[{e = {}, v, a, b, t, r},
        {a, b} = NumeratorDenominator @ q;
        While[
            a > 0 && b > 1
            ,
            v = ModularInverse[-a, b];
            {t, a} = QuotientRemainder[a, (1 + a v)/b];
            b -= t v;
            PrependTo[e, {b, v, 1, t}];
        ];
        If[a > 0,
            Prepend[e, {1 / Sqrt @ a, 0, 0, 0}]
            ,
            e
        ]
    ]

FormatRawFractions[q_List] :=
    Function[{a, b, c, d},
        If[ c == 0 && d == 0
            ,
            1 / a / a
            ,
            HoldForm @ Sum[ 1 / (a + b \[FormalK]) / (a + b (\[FormalK] - 1)), {\[FormalK], c, d}]
        ]] @@@ q

EvaluateRawFractions[q_List] :=
    ReverseSort @ Flatten[Table[1 / (#1 + #2 k) / (#1 + #2 (k - 1)), 
        {k, #3, #4}]& @@@ q]

CalculateRawFractions[x_List] :=
    (1 - #3 + #4) / (#1 - #2 + #2 #3) / (#1 + #2 #4)& @@@ x

MergeFractions[eg_List] :=
    Module[{i, j, ret = {}},
        For[
            i = 1
            ,
            i <= Length @ eg
            ,
            If[Denominator @ eg[[i]] > 1,
                j = Flatten @ Position[Numerator[Accumulate @ eg[[i ;;
                     ]]], 1];
                j =
                    If[j != {},
                        i + Last @ j - 1
                        ,
                        i
                    ];
                AppendTo[ret, Total @ eg[[i ;; j]]];
                i = j + 1
                ,
                AppendTo[ret, eg[[i]]];
                i += 1
            ]
        ];
        ReverseSort @ ret
    ]

HalveAll[eg_List, lim_] :=
    FixedPoint[Join @@ (HalveRawFractionsOnce[#, lim]& /@ #)&, eg]

FixDuplicates[eg_List] :=
    FixedPoint[
        Module[{x = Split @ ReverseSort @ #, i},
            i = FirstPosition[x, _List ? (Length @ # > 1&)];
            ReverseSort @
                Flatten @
                    If[MissingQ @ i || i == {},
                        x
                        ,
                        i = First @ i;
                        Join[x[[ ;; i - 1]], {EvaluateRawFractions @ 
                            RawFractions @ Total @ x[[i]]}, x[[i + 1 ;; ]]]
                    ]
        ]&
        ,
        eg
    ]

EgyptianFractions[q_Rational, OptionsPattern[]] :=
    Module[{raw = RawFractions @ q},
        Switch[OptionValue[Method],
            "Classical",
                FixDuplicates @ EvaluateRawFractions @ HalveAll[raw, 
                    OptionValue[MaxItems]]
            ,
            "Raw",
                raw
            ,
            "SplitRaw",
                HalveAll[raw, OptionValue[MaxItems]]
            ,
            "Expression",
                FormatRawFractions @ raw
            ,
            "SplitExpression",
                FormatRawFractions @ HalveAll[raw, OptionValue[MaxItems]]
            ,
            "Merge",
                FixDuplicates @ MergeFractions @ Reverse @ EvaluateRawFractions
                     @ HalveAll[raw, OptionValue[MaxItems]]
            ,
            "ReverseMerge",
                FixDuplicates @ MergeFractions @ EvaluateRawFractions
                     @ HalveAll[raw, OptionValue[MaxItems]]
        ]
    ]

Options[EgyptianFractions] = {Method -> "Classical", MaxItems -> 8}

term0[x_, j_] :=
    1 / (1 + Sum[2 ^ (i - 1) x^i Factorial[j + i] / Factorial[j - i]
        / Factorial[2 i], {i, 1, j}])
term[x_, k_] :=
    1 / (     ChebyshevT[Ceiling[k/2],     x + 1]
          (   ChebyshevU[  Floor[k/2],     x + 1]
            - ChebyshevU[  Floor[k/2] - 1, x + 1]))

sqrtt[x_, n_] :=
    1 + Sum[term[x, j], {j, 1, n}]

sqrth[x_, n_] :=
    1 + Sum[HoldForm[#]& @ term[x, j], {j, 1, n}]

sqrtl[x_, n_] :=
    Join[{1}, Table[term[x, j], {j, 1, n}]]

pellsol0[n_, c_] :=
    Normal @ First @ Solve[x^2 - n y^2 == 1, {x, y}, PositiveIntegers
        ] /. C[1] -> c

(*https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf*)

pellsol[d_] := Module[
  { a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {x -> u, y -> r} ]

EgyptianSqrtApproximate[n_, OptionsPattern[]] :=
    Module[{sol, acc = OptionValue[Accuracy]},
        sol = pellsol[n];
        Switch[OptionValue[Method],
            "List",
                {(x - 1) / y, sqrtl[x - 1, acc]} /. sol
            ,
            "Rational",
                (x - 1) / y sqrtt[x - 1, acc] /. sol
            ,
            "Expression",
                (x - 1) / y sqrth[x - 1, acc] /. sol
        ]
    ]

Options[EgyptianSqrtApproximate] = {Method -> "List", Accuracy -> 8}

End[]

EndPackage[]
