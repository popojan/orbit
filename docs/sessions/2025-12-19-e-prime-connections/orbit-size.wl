(* Analyze orbit size and relationship to divisibility *)

Print["=== ORBIT SIZE ANALYSIS ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

data = {};
Do[
  orbitVals = DeleteDuplicates[Table[Mod[s[n], p], {n, 0, 2 p - 1}]];
  orbitSize = Length[orbitVals];
  hasZero = MemberQ[orbitVals, 0];
  ratio = N[orbitSize/p, 4];
  AppendTo[data, {p, orbitSize, hasZero, ratio}];
, {p, Prime[Range[2, 50]]}];

Print["p | |orbit| | divides | ratio | analysis"];
Print["--+---------+---------+-------+---------"];
Do[
  {p, sz, div, r} = data[[i]];
  divStr = If[div, "YES", "no"];
  (* Check if orbit size is related to (p-1)/2 or (p+1)/2 *)
  halfP = (p - 1)/2;
  Print[p, " | ", sz, " | ", divStr, " | ", r, " | (p-1)/2=", halfP];
, {i, Length[data]}];

(* Separate analysis *)
dividing = Select[data, #[[3]] &];
nonDividing = Select[data, ! #[[3]] &];

Print["\n=== STATISTICS ==="];
Print["Dividing primes: ", Length[dividing]];
Print["  Orbit sizes: ", dividing[[All, 2]]];
Print["  Mean ratio: ", Mean[dividing[[All, 4]]]];

Print["\nNon-dividing primes: ", Length[nonDividing]];
Print["  Orbit sizes: ", nonDividing[[All, 2]]];
Print["  Mean ratio: ", Mean[nonDividing[[All, 4]]]];

(* Is orbit size related to order of some element mod p? *)
Print["\n=== ORDER ANALYSIS ==="];
Print["Checking if orbit size relates to multiplicative order of 2 or 7 mod p:"];

Do[
  {p, sz, div, r} = data[[i]];
  If[i <= 15,
    ord2 = MultiplicativeOrder[2, p];
    ord7 = If[GCD[7, p] == 1, MultiplicativeOrder[7, p], 0];
    Print["p=", p, ": |orbit|=", sz, ", ord(2)=", ord2, ", ord(7)=", ord7,
          ", divides? ", div];
  ];
, {i, Length[data]}];

(* Check if non-dividing primes have special multiplicative order *)
Print["\n=== MULTIPLICATIVE ORDER FOR NON-DIVIDING ==="];
nonDivP = Select[Prime[Range[2, 30]], !MemberQ[data[[All, 1]], #] ||
                 !Select[data, #[[1]] == # &][[1, 3]] &];
(* Actually just use the data *)
nonDivPrimes = Select[data, !#[[3]] &][[All, 1]];
Print["Non-dividing primes: ", Take[nonDivPrimes, Min[15, Length[nonDivPrimes]]]];

Do[
  p = nonDivPrimes[[i]];
  ord2 = MultiplicativeOrder[2, p];
  ord7 = MultiplicativeOrder[7, p];
  Print["p=", p, ": ord(2)=", ord2, " [", ord2/(p-1)//N, "], ord(7)=", ord7, " [", ord7/(p-1)//N, "]"];
, {i, Min[10, Length[nonDivPrimes]]}];
