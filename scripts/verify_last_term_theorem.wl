(* THEOREM: FractionalPart[Σ_m · (m-1)!] comes ONLY from the last term *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["âââââââââââââââââââââââââââââââââââââââââââââââââââââââââ"];
Print["THEOREM: Fractional Part = Last Term Contribution"];
Print["âââââââââââââââââââââââââââââââââââââââââââââââââââââââââ"];
Print[""];
Print["For prime m, let k = â(m-1)/2â. Then:"];
Print[""];
Print["  FractionalPart[Î£_m^alt Â· (m-1)!] = FractionalPart[(-1)^k Â· k! Â· (m-1)! / (2k+1)]"];
Print[""];
Print["Or equivalently: The sum of the first k-1 terms, when multiplied by (m-1)!,"];
Print["                 yields an INTEGER."];
Print[""];
Print["âââââââââââââââââââââââââââââââââââââââââââââââââââââââââ"];
Print[""];

primes = Select[Range[3, 53, 2], PrimeQ];

Print["Verification:"];
Print[""];
Print["m | k | FP(full) | FP(first k-1) | FP(last only) | Integer part(first k-1) | Match?"];
Print[StringRepeat["-", 100]];

allMatch = True;

Do[
  Module[{m, k, full, firstK1, lastOnly, fpFull, fpFirst, fpLast, intFirst, match},
    m = p;
    k = Floor[(m-1)/2];

    (* Full sum *)
    full = Sum[(-1)^i * i! / (2i+1), {i, 1, k}] * (m-1)!;
    fpFull = FractionalPart[full];

    (* First k-1 terms *)
    firstK1 = If[k > 1, Sum[(-1)^i * i! / (2i+1), {i, 1, k-1}] * (m-1)!, 0];
    fpFirst = FractionalPart[firstK1];
    intFirst = firstK1 - fpFirst;

    (* Last term only *)
    lastOnly = (-1)^k * k! * (m-1)! / (2*k + 1);
    fpLast = FractionalPart[lastOnly];

    (* Check if fpFull == fpLast *)
    match = (fpFull == fpLast);

    If[!match, allMatch = False];

    Print[m, " | ", k, " | ", fpFull, " | ", fpFirst, " | ", fpLast, " | ",
      If[IntegerQ[intFirst], "â INTEGER", "â NOT INT"], " | ",
      If[match, "â", "â"]];
  ],
  {p, primes}
];

Print[""];
If[allMatch,
  Print["âââ THEOREM VERIFIED FOR ALL TESTED PRIMES! âââ"];
  ,
  Print["â Theorem failed for some primes"];
];

Print[""];
Print[""];
Print["âââââââââââââââââââââââââââââââââââââââââââââââââââââââââ"];
Print["COROLLARY: Closed Form for Fractional Part"];
Print["âââââââââââââââââââââââââââââââââââââââââââââââââââââââââ"];
Print[""];
Print["  FractionalPart[Î£_m^alt Â· (m-1)!] = FractionalPart[(-1)^k Â· k! Â· (m-1)! / (2k+1)]"];
Print[""];
Print["Computing this fractional part explicitly:"];
Print[""];

Print["m | k | (-1)^k * k! * (m-1)! / (2k+1) mod 1 | Simplified"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, k, expr, fpVal, num, den},
    m = p;
    k = Floor[(m-1)/2];

    expr = (-1)^k * k! * (m-1)! / (2*k + 1);
    fpVal = FractionalPart[expr];
    num = Numerator[fpVal];
    den = Denominator[fpVal];

    Print[m, " | ", k, " | ", fpVal, " | ", num, "/", den,
      If[den == m, " (den = m)", ""]];
  ],
  {p, primes[[1;;12]]}
];

Print[""];
Print["âââââââââââââââââââââââââââââââââââââââââââââââââââââââââ"];
