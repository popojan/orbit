(* Chebyshev bias mod 77 and RiemannR at e-convergents *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["   CHEBYSHEV BIAS MOD 77 AND RIEMANN R                             "];
Print["═══════════════════════════════════════════════════════════════════\n"];

(* === PART 1: Prime distribution mod 77 === *)
Print["═══ PART 1: PRIME DISTRIBUTION MOD 77 ═══\n"];

(* Count primes in each residue class mod 77 *)
maxPrime = 10^6;
primes = Prime[Range[PrimePi[maxPrime]]];
Print["Analyzing ", Length[primes], " primes up to ", maxPrime, "\n"];

(* 60 coprime residue classes *)
coprimeClasses = Select[Range[77], CoprimeQ[#, 77] &];
Print["Number of coprime residue classes: ", Length[coprimeClasses], "\n"];

(* Count primes in each class *)
counts = Counts[Mod[primes, 77]];
coprimeCountsList = Table[{c, counts[c]}, {c, coprimeClasses}];
coprimeCountsList = SortBy[coprimeCountsList, -#[[2]] &];

Print["Top 10 residue classes (most primes):"];
Do[Print["  ", coprimeCountsList[[i, 1]], " mod 77: ",
         coprimeCountsList[[i, 2]], " primes"], {i, 1, 10}];

Print["\nBottom 10 residue classes (fewest primes):"];
Do[Print["  ", coprimeCountsList[[-i, 1]], " mod 77: ",
         coprimeCountsList[[-i, 2]], " primes"], {i, 10, 1, -1}];

(* Expected count per class *)
expected = Length[primes] / 60.0;
Print["\nExpected per class (uniform): ", N[expected, 6]];
Print["Max count: ", Max[Values[counts]]];
Print["Min count: ", Min[counts[#] & /@ coprimeClasses]];

(* === PART 2: Quadratic residue bias === *)
Print["\n═══ PART 2: QUADRATIC RESIDUE BIAS ═══\n"];

(* Quadratic residues mod 7 *)
qr7 = Select[Range[6], JacobiSymbol[#, 7] == 1 &];
nqr7 = Select[Range[6], JacobiSymbol[#, 7] == -1 &];
Print["QR mod 7: ", qr7];
Print["NQR mod 7: ", nqr7, "\n"];

(* Quadratic residues mod 11 *)
qr11 = Select[Range[10], JacobiSymbol[#, 11] == 1 &];
nqr11 = Select[Range[10], JacobiSymbol[#, 11] == -1 &];
Print["QR mod 11: ", qr11];
Print["NQR mod 11: ", nqr11, "\n"];

(* Count primes by QR/NQR status *)
primesQR7 = Select[primes, JacobiSymbol[#, 7] == 1 &];
primesNQR7 = Select[primes, JacobiSymbol[#, 7] == -1 &];
Print["Primes with (p|7) = 1: ", Length[primesQR7]];
Print["Primes with (p|7) = -1: ", Length[primesNQR7]];
Print["Bias (QR - NQR): ", Length[primesQR7] - Length[primesNQR7], "\n"];

primesQR11 = Select[primes, JacobiSymbol[#, 11] == 1 &];
primesNQR11 = Select[primes, JacobiSymbol[#, 11] == -1 &];
Print["Primes with (p|11) = 1: ", Length[primesQR11]];
Print["Primes with (p|11) = -1: ", Length[primesNQR11]];
Print["Bias (QR - NQR): ", Length[primesQR11] - Length[primesNQR11], "\n"];

(* Combined Jacobi symbol mod 77 *)
primesQR77 = Select[primes, JacobiSymbol[#, 77] == 1 &];
primesNQR77 = Select[primes, JacobiSymbol[#, 77] == -1 &];
Print["Primes with (p|77) = 1: ", Length[primesQR77]];
Print["Primes with (p|77) = -1: ", Length[primesNQR77]];
Print["Bias (QR - NQR): ", Length[primesQR77] - Length[primesNQR77]];

(* === PART 3: RiemannR at e-convergents === *)
Print["\n═══ PART 3: RIEMANN R AT E-CONVERGENTS ═══\n"];

(* Define s_n *)
s[0] = 1; s[-1] = 1;
Do[s[n] = (4 n + 2) s[n - 1] + s[n - 2], {n, 1, 20}];

Print["e-convergent denominators s_n:"];
Print[Table[s[n], {n, 0, 10}], "\n"];

(* RiemannR function *)
Print["RiemannR(s_n) vs π(s_n):\n"];
Print["n   s_n                  π(s_n)           R(s_n)           π - R"];
Print["─────────────────────────────────────────────────────────────────"];
Do[
  sn = s[n];
  If[sn < 10^12,
    piSn = PrimePi[sn];
    RSn = RiemannR[sn] // N;
    diff = piSn - RSn;
    Print[n, "   ", sn,
          StringJoin[Table[" ", Max[0, 20 - IntegerLength[sn]]]],
          piSn,
          StringJoin[Table[" ", Max[0, 17 - IntegerLength[piSn]]]],
          NumberForm[RSn, 10],
          "   ", NumberForm[diff, 6]];
  ];
, {n, 0, 12}];

(* === PART 4: Error term pattern === *)
Print["\n═══ PART 4: ERROR TERM ANALYSIS ═══\n"];

Print["π(s_n) - RiemannR(s_n) normalized by √(s_n)/ln(s_n):\n"];
Do[
  sn = s[n];
  If[sn < 10^12 && sn > 1,
    piSn = PrimePi[sn];
    RSn = RiemannR[sn] // N;
    diff = piSn - RSn;
    (* Normalize by expected error size under RH *)
    normalized = diff / (Sqrt[sn] / Log[sn]);
    Print["n = ", n, ": normalized error = ", NumberForm[normalized, 6]];
  ];
, {n, 1, 12}];

(* === PART 5: π(s_n) mod 77 === *)
Print["\n═══ PART 5: π(s_n) MOD 77 ═══\n"];

Print["Is there a pattern in π(s_n) mod 77?\n"];
Do[
  sn = s[n];
  If[sn < 10^12,
    piSn = PrimePi[sn];
    Print["π(s_", n, ") = ", piSn, " ≡ ", Mod[piSn, 77], " (mod 77)"];
  ];
, {n, 0, 12}];

(* Check for periodicity *)
piMod77 = Table[Mod[PrimePi[s[n]], 77], {n, 0, 12}];
Print["\nSequence π(s_n) mod 77: ", piMod77];

(* === PART 6: s_n mod 77 and primes === *)
Print["\n═══ PART 6: THE ZEROS MOD 77 ═══\n"];

Print["Recall: 77 | s_n ⟺ n ≡ 3, 36, 38, 71 (mod 77)\n"];

Print["At these special positions:"];
specialN = {3, 36, 38, 71};
Do[
  sn = s[n];
  Print["s_", n, " = ", sn, " = ", FactorInteger[sn]];
, {n, specialN}];

Print["\nPrime factors of s_n at zero positions mod 77:"];
Do[
  sn = s[n];
  factors = FactorInteger[sn][[All, 1]];
  Print["s_", n, " has ", Length[factors], " distinct prime factors"];
  Print["  Smallest: ", Min[factors], ", Largest: ", Max[factors]];
, {n, specialN}];
