(* Check if the sequence of dividing primes is in OEIS *)

Print["=== OEIS LOOKUP PREPARATION ===\n"];

(* Dividing primes we found *)
divPrimes = {7, 11, 13, 31, 41, 71, 79, 97, 101, 103, 107, 157, 173, 181, 199};

Print["Primes that divide some s_n (where s_n = e-convergent denominators):"];
Print[divPrimes];

(* Extend to more primes *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

findFirst[p_, maxN_] := SelectFirst[Range[0, maxN], Mod[s[#], p] == 0 &];

extended = {};
Do[
  first = findFirst[p, 400];
  If[!MissingQ[first], AppendTo[extended, p]];
, {p, Prime[Range[PrimePi[500]]]}];

Print["\nExtended to p < 500:"];
Print[extended];
Print["Count: ", Length[extended]];

(* Non-dividing primes *)
nonDiv = Complement[Prime[Range[PrimePi[500]]], extended];
Print["\nNon-dividing primes < 500:"];
Print[nonDiv];
Print["Count: ", Length[nonDiv]];

(* Density *)
Print["\nDensity: ", Length[extended], "/", PrimePi[500], " = ",
      N[Length[extended]/PrimePi[500], 4]];

(* Try to find pattern - check if these are in OEIS *)
Print["\n=== SEQUENCE TO SEARCH IN OEIS ==="];
Print["Dividing: ", Take[extended, Min[15, Length[extended]]]];
Print["Non-dividing: ", Take[nonDiv, Min[15, Length[nonDiv]]]];

(* Check relationship to other known sequences *)
Print["\n=== CHECKING KNOWN SEQUENCES ==="];

(* Primes p such that p | some Bessel polynomial at -2 *)
(* This is essentially what s_n is *)

(* The sequence s_n = y_{n+1}(-2) where y_n is Bessel polynomial *)
(* OEIS A002119 is s_n itself *)

Print["\nNote: s_n = (-1)^{n+1} * y_{n+1}(-2) where y_n is Bessel polynomial"];
Print["OEIS A002119 = s_n"];

(* Check if dividing primes have any quadratic character pattern *)
Print["\n=== DETAILED CHARACTERIZATION ATTEMPT ==="];

(* Maybe related to splitting in cyclotomic fields? *)
(* Or to the discriminant of the recurrence? *)

(* The recurrence is s_n = (4n+2) s_{n-1} + s_{n-2} *)
(* This is related to continued fraction [0; 6, 10, 14, ...] *)

Print["\nRecurrence: s_n = (4n+2) s_{n-1} + s_{n-2}"];
Print["CF: [0; 6, 10, 14, ...]"];
Print["General term in CF: 4n + 2 = 2(2n+1)"];

(* Check if dividing primes are related to primes in arithmetic progression *)
Print["\nDividing primes mod 8:"];
Do[Print["  p ≡ ", r, " (mod 8): ",
         Select[extended, Mod[#, 8] == r &]], {r, {1, 3, 5, 7}}];
