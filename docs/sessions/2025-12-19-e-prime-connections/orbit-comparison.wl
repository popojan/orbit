(* Compare orbits for dividing vs non-dividing primes *)

Print["=== ORBIT COMPARISON ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

(* Orbit values for a prime *)
orbitValues[p_] := Table[Mod[s[n], p], {n, 0, 2 p - 1}];

(* Check minimum value in orbit *)
Print["Prime | Min(orbit) | Has zero? | orbit"];
Print["------+------------+-----------+-------"];

testPrimes = {7, 11, 13, 17, 19, 23, 29, 31, 37, 41};
Do[
  orbit = orbitValues[p];
  minVal = Min[orbit];
  hasZero = MemberQ[orbit, 0];
  Print[p, "     | ", minVal, "         | ", hasZero, "      | ", orbit];
, {p, testPrimes}];

(* Analyze the structure more - look at orbit as pairs *)
Print["\n=== ORBIT AS PAIRS (s_n, s_{n+1}) mod p ==="];

orbitPairs[p_] := Table[{Mod[s[n], p], Mod[s[n + 1], p]}, {n, 0, 2 p - 1}];

Print["\np = 7 (dividing):"];
Print[orbitPairs[7]];

Print["\np = 17 (non-dividing):"];
Print[orbitPairs[17]];

(* Check if orbit contains (0, *) or (*, 0) *)
Print["\n=== ZERO IN FIRST OR SECOND POSITION ==="];
Do[
  pairs = orbitPairs[p];
  zeroFirst = Select[pairs, #[[1]] == 0 &];
  zeroSecond = Select[pairs, #[[2]] == 0 &];
  Print["p=", p, ": (0,*) appears ", Length[zeroFirst], " times, (*,0) appears ", Length[zeroSecond], " times"];
, {p, testPrimes}];

(* What's special about 7 in the sequence? *)
Print["\n=== ROLE OF 7 (seed value s_1 = 7) ==="];
Print["For non-dividing p, what is the orbit structure?"];
Print["\np = 17: Orbit mod 17:"];
Print[orbitValues[17]];
Print["Counts: ", Counts[orbitValues[17]]];

Print["\np = 23: Orbit mod 23:"];
Print[orbitValues[23]];
Print["Counts: ", Counts[orbitValues[23]]];

(* Check if 7 appears in all orbits *)
Print["\n=== DOES 7 APPEAR IN ALL ORBITS? ==="];
Do[
  orbit = orbitValues[p];
  has7 = MemberQ[orbit, Mod[7, p]];
  Print["p=", p, ": Contains 7 mod p = ", Mod[7, p], "? ", has7,
        ", count = ", Count[orbit, Mod[7, p]]];
, {p, {17, 19, 23, 29, 37}}];
