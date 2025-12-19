(* Analyze relationship between p and first n where p | s_n *)

Print["=== FIRST-N ANALYSIS ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

findFirst[p_, maxN_] := SelectFirst[Range[0, maxN], Mod[s[#], p] == 0 &];

(* Collect (p, first_n) pairs *)
data = {};
Do[
  first = findFirst[p, 500];
  If[!MissingQ[first], AppendTo[data, {p, first}]];
, {p, Prime[Range[PrimePi[500]]]}];

Print["(p, first n where p | s_n):"];
Print[data];

(* Analyze ratio first_n / p *)
Print["\n=== RATIO first_n / p ==="];
ratios = {#[[1]], #[[2]], N[#[[2]]/#[[1]], 4]} & /@ data;
Print["p | first_n | ratio = first_n/p"];
Do[Print[ratios[[i]]], {i, Min[25, Length[ratios]]}];

(* Check if first_n relates to p mod something *)
Print["\n=== first_n mod p ==="];
Do[
  {p, first} = data[[i]];
  Print["p=", p, ": first_n=", first, " ≡ ", Mod[first, p], " (mod p)"];
, {i, Min[30, Length[data]]}];

(* Check if there are two values mod p for each p (as we claimed) *)
Print["\n=== ALL n where p | s_n (first 5 primes) ==="];
testPrimes = Take[data[[All, 1]], 5];
Do[
  allN = Select[Range[0, 3 p], Mod[s[#], p] == 0 &];
  mods = Mod[allN, p];
  Print["p=", p, ": n ∈ ", allN, " → n mod p ∈ ", DeleteDuplicates[mods]];
, {p, testPrimes}];

(* Period of orbit mod p *)
Print["\n=== ORBIT PERIOD MOD p ==="];
Print["For small primes, find period of (s_n mod p) orbit:"];

orbitPeriod[p_] := Module[{seen, state, n, period},
  (* State = (s_{n-1} mod p, s_n mod p, n mod p) *)
  seen = <||>;
  n = 0;
  While[n < 5 p^2,
    state = {Mod[s[n], p], Mod[s[n + 1], p], Mod[n, p]};
    If[KeyExistsQ[seen, state],
      Return[{n - seen[state], seen[state]}]];
    seen[state] = n;
    n++;
  ];
  {-1, -1}
];

Do[
  {period, start} = orbitPeriod[p];
  Print["p=", p, ": period = ", period, " (starting at n=", start, ")"];
, {p, {7, 11, 13, 17, 19, 23}}];
