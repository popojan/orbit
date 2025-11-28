(* Theoretical exploration: Why does (q|p) correlate with parity of p⁻¹ mod q? *)

Print["=== Exploring the (q|p) vs ε connection ===\n"];

(* Key question: p⁻¹ mod q is a value in {1, ..., q-1}
   ε = 1 iff this value is even
   (q|p) depends on whether q is a QR mod p

   These seem unrelated - one is about structure in Z_q, other in Z_p
   But there's a correlation. Why? *)

Print["=== Hypothesis 1: Distribution of p⁻¹ mod q ===\n"];

(* For fixed q, how is p⁻¹ distributed as p varies over primes? *)
q = 101;  (* Fix a prime q *)
primes = Select[Prime[Range[2, 200]], # < q &];

inverses = Table[PowerMod[p, -1, q], {p, primes}];
Print["For q = ", q, ", inverses of primes p < q:"];
Print["Distribution mod 2: ", Counts[Mod[inverses, 2]]];
Print["Distribution mod 4: ", Counts[Mod[inverses, 4]]];

(* The inverses should be uniformly distributed in Z_q* *)
Print["\nExpected if uniform: ~50% even, ~50% odd"];
Print["Observed: ", N[100*Count[inverses, _?EvenQ]/Length[inverses], 3], "% even\n"];

(* But we're conditioning on (q|p)! *)
Print["=== Hypothesis 2: Conditioning on (q|p) ===\n"];

qrPrimes = Select[primes, JacobiSymbol[q, #] == 1 &];
nrPrimes = Select[primes, JacobiSymbol[q, #] == -1 &];

qrInverses = Table[PowerMod[p, -1, q], {p, qrPrimes}];
nrInverses = Table[PowerMod[p, -1, q], {p, nrPrimes}];

Print["Primes p where (q|p) = +1: ", Length[qrPrimes]];
Print["  Even inverses: ", Count[qrInverses, _?EvenQ], " (",
      N[100*Count[qrInverses, _?EvenQ]/Length[qrInverses], 3], "%)"];

Print["Primes p where (q|p) = -1: ", Length[nrPrimes]];
Print["  Even inverses: ", Count[nrInverses, _?EvenQ], " (",
      N[100*Count[nrInverses, _?EvenQ]/Length[nrInverses], 3], "%)"];

(* Try multiple q values *)
Print["\n=== Testing multiple q values ===\n"];

testQ[q_] := Module[{ps, qrP, nrP, qrInv, nrInv, qrEven, nrEven},
  ps = Select[Prime[Range[2, 500]], # != q &];
  qrP = Select[ps, JacobiSymbol[q, #] == 1 &];
  nrP = Select[ps, JacobiSymbol[q, #] == -1 &];
  qrInv = PowerMod[#, -1, q] & /@ qrP;
  nrInv = PowerMod[#, -1, q] & /@ nrP;
  qrEven = N[Count[qrInv, _?EvenQ]/Length[qrInv], 4];
  nrEven = N[Count[nrInv, _?EvenQ]/Length[nrInv], 4];
  {q, Mod[q, 8], Length[qrP], qrEven, Length[nrP], nrEven, nrEven - qrEven}
];

Print["q\tq%8\t#QR\t%even(QR)\t#NR\t%even(NR)\tΔ"];
Do[
  result = testQ[Prime[i]];
  Print[result[[1]], "\t", result[[2]], "\t", result[[3]], "\t",
        NumberForm[100*result[[4]], {4, 1}], "%\t\t",
        result[[5]], "\t", NumberForm[100*result[[6]], {4, 1}], "%\t\t",
        NumberForm[100*result[[7]], {4, 1}], "%"],
  {i, {10, 20, 30, 40, 50, 60, 70, 80, 90, 100}}
];

(* Deeper: what's special about the structure? *)
Print["\n=== Hypothesis 3: Connection via primitive roots ===\n"];

(* Let g be a primitive root mod q. Then:
   - p = g^a for some a
   - p⁻¹ = g^{-a} = g^{q-1-a}
   - p⁻¹ is even iff g^{q-1-a} is even

   (q|p) = (q|g^a) = (q|g)^a

   If (q|g) = -1 (g is a non-residue, which is always true for primitive roots):
   (q|p) = (-1)^a

   So (q|p) = 1 iff a is even
   And p⁻¹ = g^{q-1-a}

   Is there a pattern in when g^k is even? *)

q = 101;
g = PrimitiveRoot[q];
Print["For q = ", q, ", primitive root g = ", g];

(* Compute g^k mod q for all k, track parity *)
powers = Table[{k, PowerMod[g, k, q], EvenQ[PowerMod[g, k, q]]}, {k, 0, q - 2}];
evenPowers = Select[powers, #[[3]] &][[All, 1]];
oddPowers = Select[powers, !#[[3]] &][[All, 1]];

Print["Powers k where g^k is even: ", Length[evenPowers], "/", q - 1];
Print["Powers k where g^k is odd: ", Length[oddPowers], "/", q - 1];

(* Check if even powers have any pattern *)
Print["\nEven powers mod 2: ", Counts[Mod[evenPowers, 2]]];
Print["Odd powers mod 2: ", Counts[Mod[oddPowers, 2]]];

(* The key insight: for prime p ≠ 2, q:
   p = g^a where a = discrete log of p
   p⁻¹ = g^{q-1-a}
   (q|p) = (-1)^a

   So (q|p) = 1 means a is even
   And ε = 1 means g^{q-1-a} is even

   The correlation asks: is there a relationship between
   "a is even" and "g^{q-1-a} is even"?

   Since q-1 is even (q is odd prime > 2):
   If a is even, q-1-a is even
   If a is odd, q-1-a is odd

   So (q|p) = 1 ⟹ q-1-a is even
      (q|p) = -1 ⟹ q-1-a is odd

   Question: Does parity of k affect whether g^k is more likely even or odd? *)

Print["\n=== Key test: Does parity of exponent k affect parity of g^k? ===\n"];

evenK = Select[Range[0, q - 2], EvenQ];
oddK = Select[Range[0, q - 2], OddQ];

evenKEvenValue = Count[evenK, k_ /; EvenQ[PowerMod[g, k, q]]];
oddKEvenValue = Count[oddK, k_ /; EvenQ[PowerMod[g, k, q]]];

Print["k even → g^k even: ", evenKEvenValue, "/", Length[evenK], " = ",
      N[100*evenKEvenValue/Length[evenK], 4], "%"];
Print["k odd → g^k even: ", oddKEvenValue, "/", Length[oddK], " = ",
      N[100*oddKEvenValue/Length[oddK], 4], "%"];

Print["\nDifference: ", N[100*(oddKEvenValue/Length[oddK] - evenKEvenValue/Length[evenK]), 4], "%"];

Print["\n=== This explains the correlation! ===\n"];
Print["(q|p) = 1 ⟺ a even ⟺ q-1-a even"];
Print["(q|p) = -1 ⟺ a odd ⟺ q-1-a odd"];
Print[""];
Print["If g^{odd k} is more/less likely to be even than g^{even k},"];
Print["then (q|p) correlates with ε!"];
