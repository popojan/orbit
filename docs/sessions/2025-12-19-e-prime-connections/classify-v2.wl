(* Simpler, more explicit script to find dividing primes *)

Print["=== Finding primes that divide s_n ===\n"];

(* Compute s_n explicitly *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

(* Verify first few values *)
Print["s_n for n=0..6: ", Table[s[n], {n, 0, 6}]];
Print["s_2 = ", s[2], " = ", FactorInteger[s[2]]];
Print["s_3 = ", s[3], " = ", FactorInteger[s[3]], "\n"];

(* For each prime, find first n where p | s_n *)
findFirst[p_, maxN_] := Module[{},
  Do[
    If[Mod[s[n], p] == 0, Return[n]];
  , {n, 0, maxN}];
  -1
];

(* Test primes 2-100 *)
Print["Prime | First n | s_n mod p = 0"];
Print["------+--------+---------------"];

dividingPrimes = {};
Do[
  first = findFirst[p, 300];
  If[first >= 0,
    AppendTo[dividingPrimes, p];
    Print[p, "     | n = ", first, "   | s_", first, " = ", s[first]];
  ];
, {p, Prime[Range[PrimePi[100]]]}];

Print["\n=== DIVIDING PRIMES up to 100 ==="];
Print[dividingPrimes];

Print["\n=== NON-DIVIDING PRIMES up to 100 ==="];
nonDiv = Complement[Prime[Range[PrimePi[100]]], dividingPrimes];
Print[nonDiv];

(* Check if 71 really divides s_2 *)
Print["\n=== VERIFICATION ==="];
Print["s_2 = ", s[2]];
Print["71 | s_2? ", Mod[s[2], 71] == 0];
Print["s_3 = ", s[3]];
Print["7 | s_3? ", Mod[s[3], 7] == 0];
Print["11 | s_3? ", Mod[s[3], 11] == 0];
Print["13 | s_3? ", Mod[s[3], 13] == 0];
Print["1001 / 7 = ", 1001/7];
Print["1001 / 11 = ", 1001/11];
Print["1001 / 13 = ", 1001/13];
