(* Checking when orbit hits zero *)

Print["=== ZERO CONDITION ANALYSIS ===\n"];

matM[n_] := {{4 n + 2, 1}, {1, 0}};

(* P_n = M_{n-1} ... M_0 *)
(* [s_n; s_{n-1}] = P_n [1; 1] since s_0 = 1, s_{-1} = 1 *)
(* s_n = 0 iff P_n[[1,1]] + P_n[[1,2]] = 0 mod p *)

checkZeroCondition[p_] := Module[{prod, zeroN},
  prod = IdentityMatrix[2];
  zeroN = {};
  Do[
    prod = Mod[matM[n] . prod, p];
    If[Mod[prod[[1, 1]] + prod[[1, 2]], p] == 0,
      AppendTo[zeroN, n + 1]];
  , {n, 0, 2 p - 1}];
  zeroN
];

Print["n where s_n = 0 (mod p):"];
Print["Dividing primes:"];
Do[
  zeroN = checkZeroCondition[p];
  Print["  p = ", p, ": n in ", zeroN, " (mod ", p, ": ", Mod[zeroN, p], ")"];
, {p, {7, 11, 13, 31, 41}}];

Print["\nNon-dividing primes:"];
Do[
  zeroN = checkZeroCondition[p];
  Print["  p = ", p, ": n in ", zeroN];
, {p, {17, 19, 23, 29, 37}}];

(* The question: what property of p determines if zero is hit? *)

(* Let's look at the eigenvalues of the product matrix *)
Print["\n=== EIGENVALUE ANALYSIS ==="];

(* For a single M_n, eigenvalues are (4n+2 ± sqrt((4n+2)^2 + 4))/2 *)
(* This is messy because n varies *)

(* Try a different approach: look at the orbit as a group action *)
Print["\n=== ORBIT STRUCTURE ==="];

(* Values hit by orbit for p *)
orbitSet[p_] := DeleteDuplicates[Table[Mod[s, p], {s, Table[
  With[{prod = Fold[Dot, IdentityMatrix[2],
    Table[Mod[matM[k], p], {k, 0, n}]]},
    Mod[prod[[1, 1]] + prod[[1, 2]], p]
  ], {n, 0, 2 p - 1}]}]];

(* Compute s[n] directly *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

Print["Size of orbit (distinct values) mod p:"];
Do[
  orbitVals = DeleteDuplicates[Table[Mod[s[n], p], {n, 0, 2 p - 1}]];
  hasZero = MemberQ[orbitVals, 0];
  Print["p = ", p, ": |orbit| = ", Length[orbitVals], "/", p,
        ", has 0? ", hasZero];
, {p, Prime[Range[2, 15]]}];

(* Check if non-dividing primes avoid 0 in a specific pattern *)
Print["\n=== ORBIT VALUES FOR NON-DIVIDING PRIMES ==="];
Do[
  orbitVals = Sort[DeleteDuplicates[Table[Mod[s[n], p], {n, 0, 2 p - 1}]]];
  missing = Complement[Range[0, p - 1], orbitVals];
  Print["p = ", p, ": missing values = ", missing];
, {p, {17, 19, 23, 29, 37}}];

(* Check symmetry - is orbit symmetric around p/2? *)
Print["\n=== ORBIT SYMMETRY ==="];
Do[
  orbitVals = Sort[DeleteDuplicates[Table[Mod[s[n], p], {n, 0, 2 p - 1}]]];
  (* Check if v in orbit => p-v in orbit *)
  symmetric = AllTrue[orbitVals, MemberQ[orbitVals, Mod[p - #, p]] &];
  Print["p = ", p, ": orbit symmetric mod p? ", symmetric];
, {p, Prime[Range[2, 12]]}];
