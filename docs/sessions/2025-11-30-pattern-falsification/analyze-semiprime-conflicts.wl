(* Analyze why semiprimes have systematic SS = {-3, 1} conflicts *)
(* While 4-products have no conflicts *)

(* SignSum for semiprime p*q *)
signSumSemiprime[p_, q_] := Module[{k = p*q, valid},
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  Total[If[OddQ[#], 1, -1] & /@ valid]
];

(* Distribution of SignSum values for semiprimes *)
Print["=== SignSum Distribution for Semiprimes ===\n"];

semiprimesSS = {};
Do[
  ss = signSumSemiprime[Prime[i], Prime[j]];
  AppendTo[semiprimesSS, {Prime[i], Prime[j], ss}],
  {i, 2, 30}, {j, i + 1, 50}
];

ssValues = semiprimesSS[[All, 3]];
Print["Unique SS values: ", Union[ssValues]];
Print["Distribution: ", Tally[ssValues] // Sort];

(* Key observation: for semiprimes p*q with p,q > 2, SS is always ±1 or ±3 *)
Print["\n=== Modular Structure of SignSum for Semiprimes ==="];
Print["SS mod 4: ", Tally[Mod[ssValues, 4]] // Sort];
Print["SS mod 8: ", Tally[Mod[ssValues, 8]] // Sort];

(* Now understand WHY *)
Print["\n=== Why SS = ±1 or ±3 for odd semiprimes? ==="];

(* For semiprime k = p*q:
   valid m must have gcd(m,k)=1 AND gcd(m-1,k)=1
   - gcd(m,k)=1: m not divisible by p or q
   - gcd(m-1,k)=1: m-1 not divisible by p or q
   This means m ≢ 0,1 (mod p) and m ≢ 0,1 (mod q)
*)

(* For p=3, q=5 (k=15), let's enumerate manually *)
k = 15;
valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
Print["\nk=15: valid m = ", valid];
Print["Parities: ", If[OddQ[#], "odd", "even"] & /@ valid];
Print["SignSum = ", Total[If[OddQ[#], 1, -1] & /@ valid]];

(* Count by residue class *)
Print["\n=== Residue Class Analysis ==="];
Do[
  Print["\np = ", Prime[i], ", q = ", Prime[j], " => k = ", Prime[i]*Prime[j]];
  k = Prime[i]*Prime[j];
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  Print["Valid count: ", Length[valid], " (expected: (p-2)(q-2) = ", (Prime[i]-2)*(Prime[j]-2), ")"];
  oddCount = Count[valid, _?OddQ];
  evenCount = Length[valid] - oddCount;
  Print["Odd: ", oddCount, ", Even: ", evenCount, ", SS = ", oddCount - evenCount],
  {i, 2, 4}, {j, i + 1, 6}
];

(* The formula for SignSum of semiprime *)
Print["\n=== Testing Formula: SS(p*q) = (p mod 4) * (q mod 4) - 2 ? ==="];
testData = {};
Do[
  p = Prime[i]; q = Prime[j];
  ss = signSumSemiprime[p, q];
  formula = Mod[p, 4] * Mod[q, 4] - 2;
  AppendTo[testData, {p, q, ss, formula, ss == formula}],
  {i, 2, 20}, {j, i + 1, 30}
];
Print["Formula matches: ", Count[testData[[All, 5]], True], "/", Length[testData]];

(* Try other formulas *)
Print["\n=== Systematic Formula Search ==="];
correctFormulas = {};
Do[
  p = Prime[i]; q = Prime[j];
  ss = signSumSemiprime[p, q];

  (* Various candidate formulas *)
  f1 = (-1)^((p-1)/2 + (q-1)/2);
  f2 = (-1)^((p-1)/2) * (-1)^((q-1)/2);
  f3 = JacobiSymbol[-1, p*q];

  If[ss == f3 || ss == -3*f3 || ss == f3 - 4 || ss == f3 + 4,
    AppendTo[correctFormulas, {p, q, ss, f3}]
  ],
  {i, 2, 10}, {j, i + 1, 15}
];
Print["Jacobi relationship found: ", Length[correctFormulas], " cases"];
If[Length[correctFormulas] > 0, Print["Examples: ", Take[correctFormulas, Min[5, Length[correctFormulas]]]]];

(* THE KEY: SignSum for semiprime depends on p,q mod 4 *)
Print["\n=== SignSum by (p mod 4, q mod 4) ==="];
byMod4 = GroupBy[semiprimesSS, {Mod[#[[1]], 4], Mod[#[[2]], 4]} &];
Do[
  key = {a, b};
  If[KeyExistsQ[byMod4, key],
    ssInGroup = byMod4[key][[All, 3]];
    Print["(p mod 4, q mod 4) = ", key, ": SS values = ", Union[ssInGroup]]
  ],
  {a, 1, 3, 2}, {b, 1, 3, 2}
];
