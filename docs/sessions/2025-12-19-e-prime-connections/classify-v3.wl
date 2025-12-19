(* Fixed script - using proper loop structure *)

Print["=== Finding primes that divide s_n ===\n"];

(* Compute s_n explicitly *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

(* For each prime, find first n where p | s_n *)
(* Using SelectFirst instead of Do with Return *)
findFirst[p_, maxN_] := Module[{result},
  result = SelectFirst[Range[0, maxN], Mod[s[#], p] == 0 &];
  If[MissingQ[result], -1, result]
];

(* Test primes 2-200 *)
Print["Prime | First n | Comment"];
Print["------+---------+--------"];

dividingPrimes = {};
Do[
  first = findFirst[p, 300];
  If[first >= 0,
    AppendTo[dividingPrimes, {p, first}];
    Print[p, "     | n = ", first];
  ];
, {p, Prime[Range[PrimePi[200]]]}];

Print["\n=== DIVIDING PRIMES up to 200 ==="];
Print["Count: ", Length[dividingPrimes]];
Print[dividingPrimes];

Print["\n=== Primes only ==="];
divP = dividingPrimes[[All, 1]];
Print[divP];

Print["\n=== Analysis ==="];

(* Mod 3 *)
Print["\nMod 3:"];
Print["  p ≡ 1 (mod 3): ", Select[divP, Mod[#, 3] == 1 &]];
Print["  p ≡ 2 (mod 3): ", Select[divP, Mod[#, 3] == 2 &]];

(* Mod 4 *)
Print["\nMod 4:"];
Print["  p ≡ 1 (mod 4): ", Select[divP, Mod[#, 4] == 1 &]];
Print["  p ≡ 3 (mod 4): ", Select[divP, Mod[#, 4] == 3 &]];

(* Mod 7 *)
Print["\nMod 7 (since s_1 = 7):"];
Do[
  sel = Select[divP, Mod[#, 7] == r &];
  If[Length[sel] > 0, Print["  p ≡ ", r, " (mod 7): ", sel]];
, {r, 0, 6}];

(* Quadratic character *)
Print["\n(2|p):"];
Print["  (2|p) = +1: ", Select[divP, JacobiSymbol[2, #] == 1 &]];
Print["  (2|p) = -1: ", Select[divP, JacobiSymbol[2, #] == -1 &]];

Print["\n(7|p):"];
Print["  (7|p) = +1: ", Select[divP, JacobiSymbol[7, #] == 1 &]];
Print["  (7|p) = -1: ", Select[divP, JacobiSymbol[7, #] == -1 &]];

(* Density *)
Print["\n=== Density ==="];
Print["Dividing / Total: ", Length[divP], "/", PrimePi[200], " = ",
      N[Length[divP]/PrimePi[200], 4]];
