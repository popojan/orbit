#!/usr/bin/env wolframscript
(* What's special about primes with diff=0? *)

Print["======================================================================"];
Print["Investigating Primes with Perfect Match (diff=0)"];
Print["======================================================================\n"];

perfectMatch = {3, 5, 23, 29, 31, 59};

Print["Perfect match primes: ", perfectMatch, "\n"];

(* Check various prime properties *)
Print["Checking prime properties:\n"];

Print["Sophie Germain (2p+1 prime)?"];
Do[
  q = 2*p + 1;
  Print["  ", p, ": 2*", p, "+1 = ", q, " -> ", PrimeQ[q]];
  ,
  {p, perfectMatch}
];

Print["\nSafe primes (p=2q+1 for prime q)?"];
Do[
  If[EvenQ[p-1],
    q = (p-1)/2;
    Print["  ", p, ": (", p, "-1)/2 = ", q, " -> ", PrimeQ[q]];
    ,
    Print["  ", p, ": not form 2q+1"];
  ];
  ,
  {p, perfectMatch}
];

Print["\np mod 4:"];
Do[
  Print["  ", p, " ≡ ", Mod[p, 4], " (mod 4)"];
  ,
  {p, perfectMatch}
];

Print["\np mod 8:"];
Do[
  Print["  ", p, " ≡ ", Mod[p, 8], " (mod 8)"];
  ,
  {p, perfectMatch}
];

Print["\n(p-1)/2 mod 4:"];
Do[
  halfMinus = (p-1)/2;
  Print["  ", p, ": (p-1)/2 = ", halfMinus, " ≡ ", Mod[halfMinus, 4], " (mod 4)"];
  ,
  {p, perfectMatch}
];

Print["\nNumber of terms in alt[m] sum:"];
Do[
  numTerms = Floor[(p-1)/2];
  Print["  ", p, ": Floor[(p-1)/2] = ", numTerms];
  ,
  {p, perfectMatch}
];

Print["\nν_2((p-1)/2!):"];
Do[
  half = (p-1)/2;
  nu2 = IntegerExponent[half!, 2];
  Print["  ", p, ": ν_2(", half, "!) = ", nu2];
  ,
  {p, perfectMatch}
];

Print["\n\nNow compare with diff=-1 primes:\n"];

diffNeg1 = {7, 11, 19, 37, 43, 47, 53, 61};

Print["p mod 4:"];
Do[
  Print["  ", p, " ≡ ", Mod[p, 4], " (mod 4)"];
  ,
  {p, diffNeg1}
];

Print["\np mod 8:"];
Do[
  Print["  ", p, " ≡ ", Mod[p, 8], " (mod 8)"];
  ,
  {p, diffNeg1}
];

Print["\n(p-1)/2 mod 4:"];
Do[
  halfMinus = (p-1)/2;
  Print["  ", p, ": (p-1)/2 = ", halfMinus, " ≡ ", Mod[halfMinus, 4], " (mod 4)"];
  ,
  {p, diffNeg1}
];

Print["\nDone!"];
