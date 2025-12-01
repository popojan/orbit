(* Deep analysis of semiprime SignSum - what's the hidden structure? *)

signSumSemiprime[p_, q_] := Module[{k = p*q, valid},
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  Total[If[OddQ[#], 1, -1] & /@ valid]
];

(* Look at specific conflict pairs from find-collisions output *)
(* Conflict #1: {3,41} has SS=-3, {3,37} has SS=1 *)

Print["=== Detailed Conflict Analysis ===\n"];

conflicts = {
  {{3, 41}, {3, 37}},   (* Conflict #1 *)
  {{3, 47}, {3, 43}},   (* Conflict #2 *)
  {{3, 71}, {3, 67}},   (* Conflict #3 *)
  {{5, 43}, {5, 47}},   (* Conflict #20 *)
  {{11, 13}, {7, 17}},  (* Conflict #37 - different small prime! *)
  {{7, 67}, {7, 71}}    (* Conflict #38 *)
};

Do[
  {neg, pos} = c;
  pNeg = neg[[1]]; qNeg = neg[[2]];
  pPos = pos[[1]]; qPos = pos[[2]];

  ssNeg = signSumSemiprime[pNeg, qNeg];
  ssPos = signSumSemiprime[pPos, qPos];

  Print["Pair: {", pNeg, ",", qNeg, "} (SS=", ssNeg, ") vs {", pPos, ",", qPos, "} (SS=", ssPos, ")"];
  Print["  q mod 8: ", Mod[qNeg, 8], " vs ", Mod[qPos, 8]];
  Print["  q mod 12: ", Mod[qNeg, 12], " vs ", Mod[qPos, 12]];
  Print["  q mod 24: ", Mod[qNeg, 24], " vs ", Mod[qPos, 24]];
  Print["  Prime index of q: ", PrimePi[qNeg], " vs ", PrimePi[qPos]];
  Print["  Legendre(q,p): ", JacobiSymbol[qNeg, pNeg], " vs ", JacobiSymbol[qPos, pPos]];
  Print[""],
  {c, conflicts}
];

(* Let's check: for fixed p, what determines SS(p,q)? *)
Print["\n=== For p=3, mapping q -> SS ==="];
p = 3;
data3 = Table[{Prime[j], signSumSemiprime[3, Prime[j]]}, {j, 3, 50}];
Print["q: ", data3[[All, 1]]];
Print["SS: ", data3[[All, 2]]];

(* Pattern: check if q mod 12 matters *)
Print["\nSS by q mod 12 (for p=3):"];
byMod12 = GroupBy[data3, Mod[#[[1]], 12] &];
Do[
  If[KeyExistsQ[byMod12, m],
    Print["q ≡ ", m, " (mod 12): SS values = ", Union[byMod12[m][[All, 2]]]]
  ],
  {m, {1, 5, 7, 11}}
];

(* The real pattern: class number or something deeper? *)
Print["\n=== Quadratic Forms Connection ==="];

(* For semiprime k = p*q, SignSum counts solutions related to quadratic forms *)
(* Let's check if it relates to representation theory *)

Print["\nFor p=3, checking representation x² + xy + y² ≡ q (mod something):"];
Do[
  q = Prime[j];
  ss = signSumSemiprime[3, q];
  (* Does q have rep as x² + 3y²? *)
  hasRep3 = Length[FindInstance[x^2 + 3*y^2 == q && x > 0 && y >= 0, {x, y}, Integers]] > 0;
  (* Does q have rep as x² + xy + y²? (discriminant -3) *)
  hasRepDisc3 = Length[FindInstance[x^2 + x*y + y^2 == q && x >= 0 && y >= 0, {x, y}, Integers]] > 0;
  Print["q=", q, ": SS=", ss, ", x²+3y²: ", hasRep3, ", x²+xy+y²: ", hasRepDisc3],
  {j, 3, 25}
];

(* For primes q, x² + xy + y² = q iff q ≡ 1 (mod 3) *)
(* For primes q, x² + 3y² = q iff q ≡ 1 (mod 3) *)
(* But all our q ≢ 0 (mod 3) since they're different primes from p=3 *)

Print["\n=== Prime Index Parity ==="];
(* Maybe it's simpler - does prime index matter? *)
Do[
  q = Prime[j];
  ss = signSumSemiprime[3, q];
  Print["q=", q, " (π=", j, ", π mod 2=", Mod[j, 2], "): SS=", ss],
  {j, 3, 30}
];

(* Count correct predictions by prime index parity *)
correct = 0;
Do[
  q = Prime[j];
  ss = signSumSemiprime[3, q];
  predicted = If[OddQ[j], -3, 1];  (* hypothesis *)
  If[predicted == ss, correct++],
  {j, 3, 100}
];
Print["\nPrime index parity hypothesis: ", correct, "/97 correct"];

(* Try q's position in residue class *)
Print["\n=== Position in Arithmetic Progression ==="];
(* For p=3, all q ≡ 1 or 2 (mod 3) *)
(* Within each class, what's the pattern? *)

qMod3eq1 = Select[Prime /@ Range[3, 50], Mod[#, 3] == 1 &];
qMod3eq2 = Select[Prime /@ Range[3, 50], Mod[#, 3] == 2 &];

Print["q ≡ 1 (mod 3):", Table[{q, signSumSemiprime[3, q]}, {q, Take[qMod3eq1, 15]}]];
Print["q ≡ 2 (mod 3):", Table[{q, signSumSemiprime[3, q]}, {q, Take[qMod3eq2, 15]}]];
