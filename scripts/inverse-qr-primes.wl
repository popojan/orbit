(* The key insight: we only care about k where g^k mod q is PRIME *)

Print["=== Filtering to primes only ===\n"];

analyzeQ[q_] := Module[{g, allK, primeK, evenPrimeK, oddPrimeK,
                         evenKEvenInv, oddKEvenInv},
  g = PrimitiveRoot[q];

  (* Find k where g^k mod q is a prime (and not q itself) *)
  primeK = Select[Range[0, q - 2], PrimeQ[PowerMod[g, #, q]] &];

  evenPrimeK = Select[primeK, EvenQ];
  oddPrimeK = Select[primeK, OddQ];

  (* For these k, check parity of g^{q-1-k} (which is the inverse) *)
  evenKEvenInv = Count[evenPrimeK, k_ /; EvenQ[PowerMod[g, q - 1 - k, q]]];
  oddKEvenInv = Count[oddPrimeK, k_ /; EvenQ[PowerMod[g, q - 1 - k, q]]];

  {q, Mod[q, 8], g, Length[primeK],
   Length[evenPrimeK], evenKEvenInv,
   Length[oddPrimeK], oddKEvenInv}
];

Print["q\tq%8\tg\t#primes\t#even_k\teven_inv\t#odd_k\todd_inv\tΔ%"];
Print["--------------------------------------------------------------------"];

Do[
  q = Prime[i];
  If[q > 500, Break[]];
  result = analyzeQ[q];
  {q, qMod, g, nPrimes, nEvenK, evenKEven, nOddK, oddKEven} = result;

  If[nEvenK > 0 && nOddK > 0,
    pctEven = N[100*evenKEven/nEvenK, 4];
    pctOdd = N[100*oddKEven/nOddK, 4];
    delta = pctOdd - pctEven;

    If[Abs[delta] > 5,
      Print[q, "\t", qMod, "\t", g, "\t", nPrimes, "\t",
            nEvenK, "\t", NumberForm[pctEven, {4, 1}], "%\t\t",
            nOddK, "\t", NumberForm[pctOdd, {4, 1}], "%\t\t",
            NumberForm[delta, {4, 1}], "% ***"]
    ]
  ],
  {i, 3, 100}
];

Print["\n=== Aggregate over many q ===\n"];

totalEvenK = 0; totalEvenKEven = 0;
totalOddK = 0; totalOddKEven = 0;

Do[
  q = Prime[i];
  result = analyzeQ[q];
  {q, qMod, g, nPrimes, nEvenK, evenKEven, nOddK, oddKEven} = result;
  totalEvenK += nEvenK;
  totalEvenKEven += evenKEven;
  totalOddK += nOddK;
  totalOddKEven += oddKEven,
  {i, 3, 200}
];

Print["Aggregate over primes 5 to ", Prime[200], ":"];
Print["Even k (QR primes): ", totalEvenKEven, "/", totalEvenK,
      " = ", N[100*totalEvenKEven/totalEvenK, 5], "% have even inverse"];
Print["Odd k (NR primes): ", totalOddKEven, "/", totalOddK,
      " = ", N[100*totalOddKEven/totalOddK, 5], "% have even inverse"];
Print["Difference: ", N[100*(totalOddKEven/totalOddK - totalEvenKEven/totalEvenK), 4], "%"];

(* Is the difference significant? *)
n1 = totalEvenK; p1 = totalEvenKEven/totalEvenK;
n2 = totalOddK; p2 = totalOddKEven/totalOddK;
pooledP = (totalEvenKEven + totalOddKEven)/(totalEvenK + totalOddK);
se = Sqrt[pooledP*(1 - pooledP)*(1/n1 + 1/n2)];
z = (p2 - p1)/se;
Print["\nz-score: ", N[z, 4], " (|z| > 1.96 is significant at p<0.05)"];

(* Now the key question: WHY does this happen? *)
Print["\n=== Investigating the mechanism ===\n"];

(* Hypothesis: it's related to how primes distribute in residue classes mod 8 *)
Print["Distribution of primes by residue class:"];

primesTo1000 = Prime[Range[3, 200]];  (* Skip 2 and 3 *)
Print["Primes ≡ 1 (mod 8): ", Count[primesTo1000, p_ /; Mod[p, 8] == 1]];
Print["Primes ≡ 3 (mod 8): ", Count[primesTo1000, p_ /; Mod[p, 8] == 3]];
Print["Primes ≡ 5 (mod 8): ", Count[primesTo1000, p_ /; Mod[p, 8] == 5]];
Print["Primes ≡ 7 (mod 8): ", Count[primesTo1000, p_ /; Mod[p, 8] == 7]];

(* By Dirichlet, these should be roughly equal *)
Print["\n(By Dirichlet's theorem, these should be ~equal in the limit)"];
