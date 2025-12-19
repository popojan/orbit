(* Extended test - more primes *)

Print["=== EXTENDED COMBINED ORDERS TEST ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

isDividing[p_] := MemberQ[Table[Mod[s[n], p], {n, 0, 2 p - 1}], 0];

(* Test primes up to 1000 *)
testPrimes = Select[Prime[Range[PrimePi[1000]]], !MemberQ[{7, 11, 13}, #] &];
Print["Testing ", Length[testPrimes], " primes up to 1000\n"];

dividing = {};
nonDividing = {};
dividingNotFull = {};
nonDividingNotFull = {};

Do[
  div = isDividing[p];
  ord7 = MultiplicativeOrder[7, p];
  ord11 = MultiplicativeOrder[11, p];
  ord13 = MultiplicativeOrder[13, p];
  lcm3 = LCM[ord7, ord11, ord13];
  isFull = (lcm3 == p - 1);

  If[div,
    AppendTo[dividing, p];
    If[!isFull, AppendTo[dividingNotFull, {p, lcm3, p - 1}]],
    AppendTo[nonDividing, p];
    If[!isFull, AppendTo[nonDividingNotFull, {p, lcm3, p - 1}]]
  ];
, {p, testPrimes}];

Print["=== RESULTS ===\n"];
Print["Dividing primes: ", Length[dividing]];
Print["Non-dividing primes: ", Length[nonDividing]];
Print["Density: ", N[Length[dividing] / Length[testPrimes], 4]];

Print["\n=== LCM CONDITION ==="];
Print["Dividing with full LCM: ", Length[dividing] - Length[dividingNotFull], "/", Length[dividing]];
Print["Dividing WITHOUT full LCM: ", Length[dividingNotFull]];

If[Length[dividingNotFull] > 0,
  Print["\n*** COUNTEREXAMPLES TO NECESSARY CONDITION ***"];
  Do[Print["  p = ", dividingNotFull[[i]]], {i, Length[dividingNotFull]}],
  Print["\n*** NO COUNTEREXAMPLES - NECESSARY CONDITION HOLDS ***"]
];

Print["\nNon-dividing with full LCM: ", Length[nonDividing] - Length[nonDividingNotFull], "/", Length[nonDividing]];
Print["Non-dividing WITHOUT full LCM: ", Length[nonDividingNotFull]];

(* Show dividing primes *)
Print["\n=== DIVIDING PRIMES (up to 1000) ==="];
Print[dividing];

(* Analyze non-dividing with non-full LCM *)
Print["\n=== NON-DIVIDING WITH LCM < p-1 ==="];
Print["These definitely don't divide (necessary condition fails):"];
Do[
  {p, lcm, pm1} = nonDividingNotFull[[i]];
  Print["  p = ", p, ": lcm = ", lcm, " = ", pm1, " * ", N[lcm/pm1, 3]];
, {i, Min[20, Length[nonDividingNotFull]]}];
If[Length[nonDividingNotFull] > 20,
  Print["  ... and ", Length[nonDividingNotFull] - 20, " more"]];

(* Summary statistics *)
Print["\n=== SUMMARY ==="];
Print["Necessary condition (lcm = p-1):"];
Print["  Dividing: ", Length[dividing] - Length[dividingNotFull], "/",
      Length[dividing], " = ",
      N[100 (Length[dividing] - Length[dividingNotFull]) / Length[dividing], 4], "%"];
Print["  Non-dividing: ", Length[nonDividing] - Length[nonDividingNotFull], "/",
      Length[nonDividing], " = ",
      N[100 (Length[nonDividing] - Length[nonDividingNotFull]) / Length[nonDividing], 4], "%"];
