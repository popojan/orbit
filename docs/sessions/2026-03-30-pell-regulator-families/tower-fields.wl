pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* The field is Q(sqrt(squarefree(n'))) where n' = k^2 + 2^{a-2}.
   For a odd, s=(a-3)/2: n' = 2^{a-3}(j^2+2). Field = Q(sqrt(sqfree(j^2+2))).
   For a even, s=(a-2)/2: n' = 2^{a-2}(j^2+1). Field = Q(sqrt(sqfree(j^2+1))). *)

sqfree[n_] := Times @@ (Power @@@ ({#1, Mod[#2, 2]} & @@@ FactorInteger[n]))

Print["=== TOWER FIELDS by j (odd) ===\n"];
Print["  j | a odd:  sqfree(j^2+2) → field | a even: sqfree(j^2+1) → field"];
Print["  --+-----------------------------+-------------------------------"];
Do[
  f1 = sqfree[j^2+2]; f2 = sqfree[j^2+1];
  Print["  ",StringPadRight[ToString[j],3],
    "| j^2+2=",StringPadRight[ToString[j^2+2],6],
    " sqfree=",StringPadRight[ToString[f1],4]," Q(√",f1,")",
    "   | j^2+1=",StringPadRight[ToString[j^2+1],6],
    " sqfree=",StringPadRight[ToString[f2],4]," Q(√",f2,")"],
{j, 1, 25, 2}];

Print["\n=== WHICH FIELDS APPEAR? ===\n"];

(* Collect all fields for j=1..99 odd *)
fieldsOdd = Union[Table[sqfree[j^2+2], {j, 1, 99, 2}]];
fieldsEven = Union[Table[sqfree[j^2+1], {j, 1, 99, 2}]];
Print["Odd tower fields (sqfree(j^2+2), j=1..99 odd): ", Length[fieldsOdd], " distinct"];
Print["  ", fieldsOdd];
Print[];
Print["Even tower fields (sqfree(j^2+1), j=1..99 odd): ", Length[fieldsEven], " distinct"];
Print["  ", fieldsEven];

Print["\n=== COINCIDENCES: which j share a field? ===\n"];

Do[
  jvals = Select[Range[1, 99, 2], sqfree[#^2+2] == f &];
  If[Length[jvals] >= 2,
    Print["  Q(√",f,"): odd tower for j = ", jvals]],
{f, Union[Table[sqfree[j^2+2], {j, 1, 99, 2}]]}];

Print[];
Do[
  jvals = Select[Range[1, 99, 2], sqfree[#^2+1] == f &];
  If[Length[jvals] >= 2,
    Print["  Q(√",f,"): even tower for j = ", jvals]],
{f, Union[Table[sqfree[j^2+1], {j, 1, 99, 2}]]}];

Print["\n=== PRIMES AS TOWER FIELDS ===\n"];

(* Which primes p appear as sqfree(j^2+2) for some odd j ≤ 999? *)
primesOdd = Select[Union[Table[sqfree[j^2+2], {j, 1, 999, 2}]], PrimeQ];
primesEven = Select[Union[Table[sqfree[j^2+1], {j, 1, 999, 2}]], PrimeQ];
Print["Primes in odd towers (j^2+2): ", primesOdd[[;;Min[20,Length[primesOdd]]]], "..."];
Print["  count: ", Length[primesOdd], " primes out of ", PrimePi[1000], " primes ≤ 1000"];
Print[];
Print["Primes in even towers (j^2+1): ", primesEven[[;;Min[20,Length[primesEven]]]], "..."];
Print["  count: ", Length[primesEven], " primes out of ", PrimePi[1000], " primes ≤ 1000"];

(* Which primes are MISSING? *)
Print["\nMissing primes from odd towers (≤100): ",
  Select[Prime[Range[PrimePi[100]]], !MemberQ[primesOdd, #]&]];
Print["Missing primes from even towers (≤100): ",
  Select[Prime[Range[PrimePi[100]]], !MemberQ[primesEven, #]&]];

Print["\n=== THE KEY INSIGHT ===\n"];
Print["Each odd j gives TWO towers (one for a odd, one for a even)."];
Print["The base field is Q(√sqfree(j^2+2)) resp. Q(√sqfree(j^2+1))."];
Print["j=1 gives √3 and √2 (the ones we found first)."];
Print["j=3 gives √11 and √10."];
Print["j=5 gives √3 again (since 27=3·9) and √26."];
Print["Most primes appear, but some are missing!"];
