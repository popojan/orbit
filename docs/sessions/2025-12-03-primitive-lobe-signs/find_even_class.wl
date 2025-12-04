(* Find primes p ≡ 3 (mod 4) with EVEN class number *)

classNumberMinus[p_?PrimeQ] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}]/p /; Mod[p, 4] == 3

(* Search for even h(-p) *)
primes3mod4 = Select[Prime[Range[10, 5000]], Mod[#, 4] == 3 &];

Print["Searching for p ≡ 3 (mod 4) with EVEN h(-p)...\n"];

evenHPrimes = {};
oddHPrimes = {};

Do[
  h = classNumberMinus[p];
  If[EvenQ[h], 
    AppendTo[evenHPrimes, {p, h}];
    Print["EVEN: p = ", p, ", h(-p) = ", h],
    AppendTo[oddHPrimes, {p, h}]
  ],
  {p, primes3mod4}
];

Print["\n=== Summary ==="];
Print["Total primes tested: ", Length[primes3mod4]];
Print["Primes with ODD h(-p): ", Length[oddHPrimes]];
Print["Primes with EVEN h(-p): ", Length[evenHPrimes]];

If[Length[evenHPrimes] > 0,
  Print["\nFirst 20 primes with even h(-p):"];
  Print[evenHPrimes[[;;Min[20, Length[evenHPrimes]]]]];
];

(* Distribution of h(-p) mod 2 *)
Print["\n=== h(-p) mod 2 distribution ==="];
Print["Even: ", Length[evenHPrimes], " (", N[100*Length[evenHPrimes]/Length[primes3mod4]], "%)"];
Print["Odd: ", Length[oddHPrimes], " (", N[100*Length[oddHPrimes]/Length[primes3mod4]], "%)"];
