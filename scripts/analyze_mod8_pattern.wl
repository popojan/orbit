#!/usr/bin/env wolframscript
(*
Analyze mod 8 pattern for special vs regular primes
*)

Print["=" <> StringRepeat["=", 69]];
Print["MOD 8 PATTERN ANALYSIS"];
Print["=" <> StringRepeat["=", 69]];
Print[];

specialPrimes = {7, 23, 31, 47, 71, 79, 103, 127, 151, 167, 191, 199, 223};
regularPrimes = {3, 11, 19, 43, 59, 67, 83, 107, 131, 139, 163, 179, 211, 227};

Print["SPECIAL primes (p ≡ 3 mod 4, x ≡ +1 mod p):"];
Print["p\tmod 8\t(p-3)/4\t(p-7)/8"];
Print[StringRepeat["-", 60]];
Do[
  Print[p, "\t", Mod[p, 8], "\t", (p-3)/4, "\t", (p-7)/8],
  {p, specialPrimes}
];
Print[];

Print["REGULAR primes (p ≡ 3 mod 4, x ≡ -1 mod p):"];
Print["p\tmod 8\t(p-3)/4\t(p-3)/8"];
Print[StringRepeat["-", 60]];
Do[
  Print[p, "\t", Mod[p, 8], "\t", (p-3)/4, "\t", N[(p-3)/8, 5]],
  {p, regularPrimes}
];
Print[];

Print[StringRepeat["=", 69]];
Print["MOD 8 CLASSIFICATION"];
Print[StringRepeat["=", 69]];
Print[];

(* Check if there's a clean mod 8 split *)
specialMod8 = Mod[specialPrimes, 8];
regularMod8 = Mod[regularPrimes, 8];

Print["Special primes mod 8: ", DeleteDuplicates[specialMod8]];
Print["Regular primes mod 8: ", DeleteDuplicates[regularMod8]];
Print[];

(* Count by mod 8 *)
Print["Special primes:"];
Print["  p ≡ 7 (mod 8): ", Count[specialMod8, 7]];
Print["  p ≡ 3 (mod 8): ", Count[specialMod8, 3]];
Print[];

Print["Regular primes:"];
Print["  p ≡ 7 (mod 8): ", Count[regularMod8, 7]];
Print["  p ≡ 3 (mod 8): ", Count[regularMod8, 3]];
Print[];

Print[StringRepeat["=", 69]];
Print["HYPOTHESIS TEST"];
Print[StringRepeat["=", 69]];
Print[];

Print["HYPOTHESIS: p ≡ 7 (mod 8) ⟹ x ≡ +1 (mod p) (SPECIAL)"];
Print["           p ≡ 3 (mod 8) ⟹ x ≡ -1 (mod p) (REGULAR)"];
Print[];

specialMod7 = Count[specialMod8, 7];
specialMod3 = Count[specialMod8, 3];
regularMod7 = Count[regularMod8, 7];
regularMod3 = Count[regularMod8, 3];

Print["Verification:"];
Print["  Special with p ≡ 7 (mod 8): ", specialMod7, "/", Length[specialPrimes],
      " = ", N[100.0 * specialMod7 / Length[specialPrimes], 4], "%"];
Print["  Regular with p ≡ 3 (mod 8): ", regularMod3, "/", Length[regularPrimes],
      " = ", N[100.0 * regularMod3 / Length[regularPrimes], 4], "%"];
Print[];

If[specialMod3 > 0,
  Print["COUNTEREXAMPLES (special but p ≡ 3 mod 8):"];
  Print["  ", Select[specialPrimes, Mod[#, 8] == 3 &]];
];

If[regularMod7 > 0,
  Print["COUNTEREXAMPLES (regular but p ≡ 7 mod 8):"];
  Print["  ", Select[regularPrimes, Mod[#, 8] == 7 &]];
];

Print[];
Print[StringRepeat["=", 69]];
Print["TESTING WITH MORE PRIMES"];
Print[StringRepeat["=", 69]];
Print[];

(* Test with more primes to verify hypothesis *)
testPrimes = Select[Prime[Range[1, 100]], Mod[#, 4] == 3 &];

Print["Testing ", Length[testPrimes], " primes p ≡ 3 (mod 4)..."];
Print[];

verified = Table[
  Module[{sol, x, xMod, isSpecial, mod8, expectedSpecial},
    sol = Solve[x^2 - p*y^2 == 1 && x > 0 && y > 0 && x < 10^50, {x, y}, Integers];
    If[Length[sol] > 0,
      x = x /. sol[[1]][[1]];
      xMod = Mod[x, p];
      isSpecial = (xMod == 1);
      mod8 = Mod[p, 8];
      expectedSpecial = (mod8 == 7);

      {p, mod8, isSpecial, expectedSpecial, isSpecial == expectedSpecial}
    ,
      {p, Mod[p, 8], "N/A", "N/A", "N/A"}
    ]
  ],
  {p, testPrimes}
];

Print["p\tmod8\tSpecial?\tExpected?\tMatch?"];
Print[StringRepeat["-", 60]];
Do[
  Print[row[[1]], "\t", row[[2]], "\t", row[[3]], "\t\t", row[[4]], "\t\t", row[[5]]],
  {row, verified}
];
Print[];

matches = Count[verified, {_, _, _, _, True}];
total = Length[verified];
Print["SUCCESS RATE: ", matches, "/", total, " = ", N[100.0 * matches / total, 5], "%"];

Print[];
Print[StringRepeat["=", 69]];
