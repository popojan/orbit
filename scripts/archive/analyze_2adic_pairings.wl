#!/usr/bin/env wolframscript
(* Analyze 2-adic structure of Wilson pairings *)

Print["2-adic Structure of Wilson Pairings\n"];
Print[StringRepeat["=", 70]];

Print["\nFor each prime, analyze how 2-adic valuations distribute in pairings\n"];

primes = Select[Range[3, 61, 2], PrimeQ];

Print["p | Zero v2 reduction? | First half v2 | Second half v2 | Symmetric?"];
Print[StringRepeat["-", 75]];

results = Table[
  Module[{h, firstHalf, secondHalf, v2First, v2Second, symmetric,
          result, denom, fact, nu2D, nu2mMinus1, reduction, zeroReduction},

    h = (p-1)/2;

    (* 2-adic valuations in first and second halves *)
    firstHalf = Range[1, h];
    secondHalf = Range[h+1, p-1];

    v2First = Sum[IntegerExponent[k, 2], {k, firstHalf}];
    v2Second = Sum[IntegerExponent[k, 2], {k, secondHalf}];

    symmetric = (v2First == v2Second);

    (* Check if this prime has zero v2 reduction *)
    alt = Sum[(-1)^k * k!/(2k+1), {k, 1, h}];
    result = Mod[alt, 1/(p-1)!];
    denom = Denominator[result];
    fact = FactorInteger[denom];
    nu2D = SelectFirst[fact, #[[1]] == 2 &, {2, 0}][[2]];
    nu2mMinus1 = IntegerExponent[(p-1)!, 2];
    reduction = nu2mMinus1 - nu2D;
    zeroReduction = (reduction == 0);

    Print[StringPadRight[ToString[p], 2], " | ",
          StringPadRight[If[zeroReduction, "YES", "NO"], 19], " | ",
          StringPadRight[ToString[v2First], 13], " | ",
          StringPadRight[ToString[v2Second], 14], " | ",
          If[symmetric, "YES", "NO"]];

    {p, zeroReduction, v2First, v2Second, symmetric}
  ],
  {p, primes}
];

Print["\n" <> StringRepeat["=", 70]];
Print["CORRELATION ANALYSIS\n"];
Print[StringRepeat["=", 70], "\n"];

zeroRedPrimes = Select[results, #[[2]] &][[All, 1]];
symmetricPrimes = Select[results, #[[5]] &][[All, 1]];

Print["Primes with ZERO v2 reduction: ", zeroRedPrimes];
Print["Primes with SYMMETRIC 2-adic pairings: ", symmetricPrimes];

Print["\nDo they match? ", zeroRedPrimes == symmetricPrimes];

If[zeroRedPrimes != symmetricPrimes,
  Print["\nIn zero reduction but NOT symmetric: ",
        Complement[zeroRedPrimes, symmetricPrimes]];
  Print["Symmetric but NOT zero reduction: ",
        Complement[symmetricPrimes, zeroRedPrimes]];
];

Print["\nDone! Testing pairing symmetry hypothesis..."];
