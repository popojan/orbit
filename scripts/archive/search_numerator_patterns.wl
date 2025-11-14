#!/usr/bin/env wolframscript
(* Search for patterns in the "chaotic" numerators *)

Print["Searching for Numerator Patterns\n"];
Print[StringRepeat["=", 70]];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

(* Odd composites *)
OddComposites[n_] := Select[Range[9, n, 2], CompositeQ];

Print["\nFor odd m, analyzing unreduced alt[m] = A/B:\n"];

data = Table[
  Module[{altVal, A, B, gcd, composites, prodComp},
    altVal = alt[m];
    A = Abs[Numerator[altVal]];
    B = Denominator[altVal];
    gcd = GCD[A, B];

    composites = OddComposites[m];
    prodComp = If[Length[composites] > 0, Times @@ composites, 1];

    {m, A, B, gcd, prodComp}
  ],
  {m, Range[9, 31, 2]}
];

Print["m | |Numerator| | Denom | GCD | Prod(composites)"];
Print[StringRepeat["-", 70]];

Do[
  {m, A, B, gcd, prodComp} = item;
  Print[StringPadRight[ToString[m], 2], " | ",
        StringPadRight[ToString[A], 12], " | ",
        StringPadRight[ToString[B], 5], " | ",
        StringPadRight[ToString[gcd], 3], " | ",
        prodComp];
  ,
  {item, data}
];

Print["\n" <> StringRepeat["=", 70]];
Print["Testing potential patterns:\n"];

Print["1. Is |Numerator| related to Prod(composites)?"];
Do[
  {m, A, B, gcd, prodComp} = item;
  ratio = N[A / prodComp, 5];
  Print["  m=", m, ": A/Prod(comp) = ", ratio];
  ,
  {item, Take[data, 5]}
];

Print["\n2. Is |Numerator| related to GCD?"];
Do[
  {m, A, B, gcd, prodComp} = item;
  ratio = N[A / gcd, 5];
  Print["  m=", m, ": A/GCD = ", ratio];
  ,
  {item, Take[data, 5]}
];

Print["\n3. Is |Numerator| * GCD related to something?"];
Do[
  {m, A, B, gcd, prodComp} = item;
  product = A * gcd;
  Print["  m=", m, ": A*GCD = ", product, " = ", FactorInteger[product]];
  ,
  {item, Take[data, 5]}
];

Print["\n4. What about |Numerator| modulo small primes?"];
primes = {3, 5, 7, 11, 13};
Print["m | A mod 3 | A mod 5 | A mod 7 | A mod 11 | A mod 13"];
Print[StringRepeat["-", 60]];
Do[
  {m, A} = item[[{1,2}]];
  Print[StringPadRight[ToString[m], 2], " | ",
        StringPadRight[ToString[Mod[A, 3]], 8], " | ",
        StringPadRight[ToString[Mod[A, 5]], 8], " | ",
        StringPadRight[ToString[Mod[A, 7]], 8], " | ",
        StringPadRight[ToString[Mod[A, 11]], 9], " | ",
        Mod[A, 13]];
  ,
  {item, data}
];

Print["\n5. Ratio to (m-1)! or ((m-1)/2)! ?"];
Do[
  {m, A} = item[[{1,2}]];
  ratioFull = N[A / (m-1)!, 5];
  ratioHalf = N[A / ((m-1)/2)!, 5];
  Print["  m=", m, ": A/(m-1)! = ", ratioFull, ", A/((m-1)/2)! = ", ratioHalf];
  ,
  {item, Take[data, 5]}
];

Print["\nDone! Any patterns visible?"];
