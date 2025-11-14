#!/usr/bin/env wolframscript
(* Verify numerator = 1 for all primes *)

Print["Verifying numerator = 1 for primes up to 100\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

primes = Select[Range[3, 101, 2], PrimeQ];

Print["Testing ", Length[primes], " primes...\n"];

allOnes = True;
counterexamples = {};

Do[
  result = Mod[alt[m], 1/(m-1)!];
  num = Numerator[result];

  If[num != 1,
    allOnes = False;
    AppendTo[counterexamples, {m, num}];
    Print["COUNTEREXAMPLE: m=", m, ", numerator=", num];
  ];
  ,
  {m, primes}
];

If[allOnes,
  Print["SUCCESS! All ", Length[primes], " primes have numerator = 1"];
  Print["\nThis means for prime m:"];
  Print["  Mod[alt[m], 1/(m-1)!] = 1/D"];
  Print["where D is a specific divisor of (m-1)!"];
  Print["\nAnd for composite m:"];
  Print["  Mod[alt[m], 1/(m-1)!] = 0"];
  Print["\nThis is a perfect primality criterion!"];
  ,
  Print["\nFound ", Length[counterexamples], " counterexamples:"];
  Print[counterexamples];
];

Print["\nDone!"];
