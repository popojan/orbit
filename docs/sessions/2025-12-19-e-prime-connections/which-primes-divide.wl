(* Which primes divide s_n? Is there a pattern? *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["   WHICH PRIMES DIVIDE THE E-CONVERGENT SEQUENCE?                  "];
Print["═══════════════════════════════════════════════════════════════════\n"];

(* Define s_n sequence *)
s[0] = 1; s[-1] = 1;
Do[s[n] = (4 n + 2) s[n - 1] + s[n - 2], {n, 1, 1000}];

(* Check if prime p ever divides s_n for n in range *)
primeAppearsIn[p_, maxN_: 1000] :=
  AnyTrue[Range[maxN], Divisible[s[#], p] &];

(* Classify first 200 primes *)
primes200 = Prime[Range[200]];
divides = Select[primes200, primeAppearsIn[#, 500] &];
neverDivides = Complement[primes200, divides];

Print["Primes p < ", Prime[200], " that DIVIDE some s_n:"];
Print[divides, "\n"];

Print["Count: ", Length[divides], " out of 200 primes\n"];

Print["Primes p < ", Prime[200], " that NEVER divide any s_n (n ≤ 500):"];
Print[neverDivides, "\n"];

Print["Count: ", Length[neverDivides], " out of 200 primes\n"];

(* === Look for pattern === *)
Print["═══ PATTERN ANALYSIS ═══\n"];

Print["Dividing primes mod 7:"];
Print[Counts[Mod[divides, 7]], "\n"];

Print["Non-dividing primes mod 7:"];
Print[Counts[Mod[neverDivides, 7]], "\n"];

Print["Dividing primes mod 11:"];
Print[Counts[Mod[divides, 11]], "\n"];

Print["Non-dividing primes mod 11:"];
Print[Counts[Mod[neverDivides, 11]], "\n"];

(* Check mod 77 *)
Print["Dividing primes mod 77:"];
div77 = Sort[Union[Mod[divides, 77]]];
Print[div77, "\n"];

Print["Non-dividing primes mod 77:"];
nondiv77 = Sort[Union[Mod[neverDivides, 77]]];
Print[nondiv77, "\n"];

(* === Check if related to quadratic character === *)
Print["═══ QUADRATIC CHARACTER ANALYSIS ═══\n"];

(* Legendre symbol (p/7) and (p/11) *)
Print["Dividing primes by Legendre symbol:"];
Print["  (p|7) = 1: ", Select[divides, JacobiSymbol[#, 7] == 1 &] // Length];
Print["  (p|7) = -1: ", Select[divides, JacobiSymbol[#, 7] == -1 &] // Length];
Print["  (p|7) = 0: ", Select[divides, JacobiSymbol[#, 7] == 0 &] // Length];
Print[""];

Print["  (p|11) = 1: ", Select[divides, JacobiSymbol[#, 11] == 1 &] // Length];
Print["  (p|11) = -1: ", Select[divides, JacobiSymbol[#, 11] == -1 &] // Length];
Print["  (p|11) = 0: ", Select[divides, JacobiSymbol[#, 11] == 0 &] // Length];
Print[""];

Print["Non-dividing primes by Legendre symbol:"];
Print["  (p|7) = 1: ", Select[neverDivides, JacobiSymbol[#, 7] == 1 &] // Length];
Print["  (p|7) = -1: ", Select[neverDivides, JacobiSymbol[#, 7] == -1 &] // Length];
Print["  (p|7) = 0: ", Select[neverDivides, JacobiSymbol[#, 7] == 0 &] // Length];
Print[""];

Print["  (p|11) = 1: ", Select[neverDivides, JacobiSymbol[#, 11] == 1 &] // Length];
Print["  (p|11) = -1: ", Select[neverDivides, JacobiSymbol[#, 11] == -1 &] // Length];
Print["  (p|11) = 0: ", Select[neverDivides, JacobiSymbol[#, 11] == 0 &] // Length];
Print[""];

(* === Combined character (p|77) via Jacobi symbol === *)
Print["═══ JACOBI SYMBOL (p|77) ═══\n"];

Print["Dividing primes:"];
Print["  (p|77) = 1: ", Select[divides, JacobiSymbol[#, 77] == 1 &] // Length];
Print["  (p|77) = -1: ", Select[divides, JacobiSymbol[#, 77] == -1 &] // Length];
Print[""];

Print["Non-dividing primes:"];
Print["  (p|77) = 1: ", Select[neverDivides, JacobiSymbol[#, 77] == 1 &] // Length];
Print["  (p|77) = -1: ", Select[neverDivides, JacobiSymbol[#, 77] == -1 &] // Length];
Print[""];

(* === Check specific residue classes === *)
Print["═══ RESIDUE CLASS ANALYSIS ═══\n"];

(* For primes in (Z/77Z)*, check residue class *)
Print["Hypothesis: Does p mod 77 determine if p divides s_n?\n"];

(* Group dividing primes by residue mod 77 *)
divByRes = GroupBy[divides, Mod[#, 77] &];
nondivByRes = GroupBy[neverDivides, Mod[#, 77] &];

(* Find residues that appear in both or only one *)
allResidues = Union[Keys[divByRes], Keys[nondivByRes]];
mixedResidues = Intersection[Keys[divByRes], Keys[nondivByRes]];

Print["Residues with ONLY dividing primes: ",
  Complement[Keys[divByRes], Keys[nondivByRes]]];
Print["Residues with ONLY non-dividing primes: ",
  Complement[Keys[nondivByRes], Keys[divByRes]]];
Print["Residues with BOTH: ", Length[mixedResidues], " classes"];
Print[""];

(* So it's not purely determined by residue class - need more analysis *)

(* === Check period of s_n mod p === *)
Print["═══ PERIODS OF s_n MOD p ═══\n"];

periodModP[p_, maxN_: 300] := Module[{seq, pairs, first},
  seq = Table[Mod[s[n], p], {n, 0, maxN}];
  pairs = Table[{seq[[n]], seq[[n + 1]]}, {n, 1, maxN}];
  first = pairs[[1]];
  SelectFirst[Range[2, maxN], pairs[[#]] == first &, "none"] - 1
];

Print["Period of s_n mod p for dividing primes:"];
Do[
  p = divides[[i]];
  per = periodModP[p];
  If[per =!= "none",
    Print["  p = ", p, ": period = ", per, " = ", FactorInteger[per]];
  ];
, {i, 1, Min[15, Length[divides]]}];

Print["\nPeriod of s_n mod p for non-dividing primes (sample):"];
Do[
  p = neverDivides[[i]];
  per = periodModP[p];
  If[per =!= "none",
    Print["  p = ", p, ": period = ", per, " = ", FactorInteger[per]];
  ];
, {i, 1, Min[10, Length[neverDivides]]}];
