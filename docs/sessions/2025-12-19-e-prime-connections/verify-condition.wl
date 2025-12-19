(* Verify necessary condition on larger dataset *)

Print["=== VERIFYING NECESSARY CONDITION ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

isDividing[p_] := MemberQ[Table[Mod[s[n], p], {n, 0, 2 p - 1}], 0];

(* Test primes up to 2000, excluding 7, 11, 13 *)
testPrimes = Select[Prime[Range[PrimePi[2000]]], !MemberQ[{7, 11, 13}, #] &];
Print["Testing ", Length[testPrimes], " primes up to 2000\n"];

nDiv = 0; nNonDiv = 0;
divFails = {};
halfDiv = 0; halfNonDiv = 0;

Do[
  p = testPrimes[[i]];
  div = isDividing[p];
  ord7 = MultiplicativeOrder[7, p];
  ord11 = MultiplicativeOrder[11, p];
  ord13 = MultiplicativeOrder[13, p];
  lcm3 = LCM[ord7, ord11, ord13];
  threshold = (p - 1) / 2;

  If[div,
    nDiv++;
    If[lcm3 < threshold, AppendTo[divFails, p]];
    If[lcm3 == threshold, halfDiv++],
    (* else *)
    nNonDiv++;
    If[lcm3 == threshold, halfNonDiv++]
  ];

  If[Mod[i, 100] == 0, Print["Progress: ", i, "/", Length[testPrimes]]];
, {i, Length[testPrimes]}];

Print["\n=== FINAL RESULTS (up to 2000) ==="];
Print["Dividing primes: ", nDiv];
Print["Non-dividing primes: ", nNonDiv];
Print["Density: ", N[nDiv / Length[testPrimes], 4]];

Print["\n=== NECESSARY CONDITION: lcm >= (p-1)/2 ==="];
Print["Dividing with lcm < (p-1)/2: ", Length[divFails]];
If[Length[divFails] > 0,
  Print["COUNTEREXAMPLES: ", divFails],
  Print["*** NECESSARY CONDITION VERIFIED ***"]
];

Print["\n=== BORDERLINE CASES: lcm = (p-1)/2 ==="];
Print["Dividing: ", halfDiv];
Print["Non-dividing: ", halfNonDiv];
