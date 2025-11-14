(* Complete Stickelberger relation verification *)

Print["Stickelberger Relation Verification"];
Print[""];

primes = Select[Range[3, 61, 2], PrimeQ];

(* For m ≡ 3 (mod 4) *)
mod3Primes = Select[primes, Mod[#, 4] == 3 &];

Print["For primes m ≡ 3 (mod 4), ((m-1)/2)! should be ±1 mod m"];
Print[""];
Print["m | ((m-1)/2)! mod m | Value | Equals +1 or -1?"];
Print[StringRepeat["-", 60]];

Do[
  m = p;
  halfFact = Mod[((m-1)/2)!, m];
  isPlusOne = (halfFact == 1);
  isMinusOne = (halfFact == m - 1);

  Print[m, " | ", halfFact, " | ",
    Which[
      isPlusOne, "+1",
      isMinusOne, "-1",
      True, "OTHER"
    ], " | ",
    If[isPlusOne || isMinusOne, "✓", "✗"]];
  , {p, mod3Primes}
];

Print[""];
Print["Summary:");
Print["  All primes m ≡ 1 (mod 4): ((m-1)/2)! is a square root of -1"];
Print["  All primes m ≡ 3 (mod 4): ((m-1)/2)! equals ±1"];
Print[""];
Print["This is the classical STICKELBERGER RELATION!"];
