(* Hustota jmenovatelů m pro které se řetězec uzavře *)
(* Podmínka: existuje k takové, že 2^k ≡ -1 (mod m) *)

closesQ[m_] := Module[{ord},
  If[EvenQ[m], Return[False]];  (* m musí být liché *)
  If[m == 1, Return[False]];
  ord = MultiplicativeOrder[2, m];
  EvenQ[ord] && PowerMod[2, ord/2, m] == m - 1
]

(* Spočítej pro m až do různých hranic *)
limits = {100, 500, 1000, 5000, 10000};

Print["=== Hustota 'dobrých' jmenovatelů ===\n"];

Do[
  good = Select[Range[3, n, 2], closesQ];  (* jen lichá m >= 3 *)
  total = Length[Range[3, n, 2]];
  density = N[Length[good] / total, 5];
  Print["m ≤ ", n, ": ", Length[good], "/", total, " lichých = ",
        NumberForm[density * 100, {5, 2}], "%"];
, {n, limits}];

(* Detail pro malá m *)
Print["\n=== Detail pro m ≤ 50 ===\n"];
smallGood = Select[Range[3, 50, 2], closesQ];
Print["Uzavírající se: ", smallGood];

smallBad = Select[Range[3, 50, 2], Not@*closesQ];
Print["Neuzavírající se: ", smallBad];

(* Počet kroků pro uzavírající se *)
Print["\n=== Počet kroků k ===\n"];
stepsTable = Table[
  {m, MultiplicativeOrder[2, m]/2},
  {m, Select[Range[3, 100, 2], closesQ]}
];
Print[Grid[Prepend[stepsTable, {"m", "kroků k"}], Frame -> All]];

(* Asymptotická analýza - prvočísla vs složená *)
Print["\n=== Prvočísla vs složená čísla ===\n"];

n = 10000;
oddPrimes = Select[Range[3, n], PrimeQ];
oddComposites = Select[Range[3, n, 2], !PrimeQ[#] &];

goodPrimes = Select[oddPrimes, closesQ];
goodComposites = Select[oddComposites, closesQ];

Print["Prvočísla ≤ ", n, ": ", Length[goodPrimes], "/", Length[oddPrimes],
      " = ", NumberForm[N[100 Length[goodPrimes]/Length[oddPrimes], 4], {4, 2}], "%"];
Print["Složená lichá ≤ ", n, ": ", Length[goodComposites], "/", Length[oddComposites],
      " = ", NumberForm[N[100 Length[goodComposites]/Length[oddComposites], 4], {4, 2}], "%"];

(* Které prvočísla NEUZAVÍRAJÍ? *)
Print["\n=== Prvočísla kde se řetězec NEUZAVŘE (ord_p(2) liché) ===\n"];
badPrimes = Select[Range[3, 200], PrimeQ[#] && !closesQ[#] &];
Print["p ≤ 200: ", badPrimes];
Print["Počet: ", Length[badPrimes], " z ", PrimePi[200] - 1, " lichých prvočísel"];
