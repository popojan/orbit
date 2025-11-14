#!/usr/bin/env wolframscript
(* Investigate connection between alt[m] and ((m-1)/2)! *)

Print["======================================================================"];
Print["Investigating alt[m] structure via half-factorials"];
Print["======================================================================\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

primes = Select[Range[3, 41, 2], PrimeQ];

Print["For prime m, let h = (m-1)/2 (the upper summation limit)"];
Print["Analyzing relationship between alt[m], h!, and (m-1)!\n"];

Print["m | h=(m-1)/2 | ν_2(h!) | ν_2((m-1)!) | ν_2(D) | Reduction"];
Print[StringRepeat["-", 70]];

data = Table[
  Module[{h, nu2h, nu2mMinus1, result, denom, fact, nu2D, reduction},
    h = (m-1)/2;
    nu2h = IntegerExponent[h!, 2];
    nu2mMinus1 = IntegerExponent[(m-1)!, 2];

    result = Mod[alt[m], 1/(m-1)!];
    denom = Denominator[result];
    fact = FactorInteger[denom];
    nu2D = SelectFirst[fact, #[[1]] == 2 &, {2, 0}][[2]];

    reduction = nu2mMinus1 - nu2D;

    Print[StringPadRight[ToString[m], 2], " | ",
          StringPadRight[ToString[h], 11], " | ",
          StringPadRight[ToString[nu2h], 7], " | ",
          StringPadRight[ToString[nu2mMinus1], 13], " | ",
          StringPadRight[ToString[nu2D], 6], " | ",
          reduction];

    {m, h, nu2h, nu2mMinus1, nu2D, reduction}
  ],
  {m, primes}
];

Print["\n======================================================================"];
Print["PATTERN ANALYSIS"];
Print["======================================================================\n"];

Print["Checking if reduction correlates with ν_2(h!):\n"];

Do[
  {m, h, nu2h, nu2mMinus1, nu2D, reduction} = item;
  Print["m=", StringPadRight[ToString[m], 2], ": ν_2(h!)=", StringPadRight[ToString[nu2h], 2],
        ", reduction=", reduction,
        If[nu2h == reduction, " <- MATCH!", ""],
        If[nu2h == reduction + 1, " <- off by 1", ""]];
  ,
  {item, data}
];

Print["\nAnalyzing alt[m] structure modulo 2-adic valuations:"];
Print["Wilson: (m-1)! ≡ -1 (mod m) for prime m"];
Print["Question: How does alt[m] relate to ((m-1)/2)! mod m?\n"];

(* Compute alt[m] mod m *)
Print["m | alt[m] mod m | ((m-1)/2)! mod m | Wilson check"];
Print[StringRepeat["-", 60]];

Do[
  Module[{h, altModM, hFactModM, wilsonCheck},
    h = (m-1)/2;
    altModM = Mod[alt[m], m];
    hFactModM = Mod[h!, m];
    wilsonCheck = Mod[(m-1)!, m];

    Print[StringPadRight[ToString[m], 2], " | ",
          StringPadRight[ToString[altModM], 12], " | ",
          StringPadRight[ToString[hFactModM], 17], " | ",
          wilsonCheck, " = ", Mod[wilsonCheck, m]];
  ],
  {m, Take[primes, 10]}
];

Print["\nDone!"];
