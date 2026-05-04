(* ::Package:: *)

(* Verification of T_n(x+1) - 1 factorization conjecture
   ======================================================

   Conjecture (refined 2026-05-04):
   For n with 4 NOT dividing n, the polynomial T_n(x+1) - 1 has exactly
   Omega(n) distinct irreducible factors over Q[x] of degree >= 1 whose
   constant term is a prime, and the multiset of those primes equals the
   prime factorization multiset of n.

   For n with 4 | n, the bijection partially fails: cyclotomic polynomials
   psi_{2^k} for k >= 2 have 0 as a root of psi_d(y) (since 2cos(2pi/2^k)
   passes through 0 at y=2cos(pi/2)=0 for k=2 etc.), so after the shift
   y -> x+1 the "2" predicted by Phi_d(1)=2 gets absorbed into the
   leading coefficient of the polynomial rather than the constant of
   the irreducible factor in Q[x].

   This script:
   1. Factors T_n(x+1) - 1 over Q for n = 2..50
   2. For each distinct irreducible factor of degree >= 1, extracts the
      constant term and multiplicity
   3. Compares the multiset of prime constants to the prime factorization
      multiset of n
   4. Reports match/mismatch and tabulates by n mod 4
*)

(* ---- helpers ----------------------------------------------------------- *)

primePowerQ[d_Integer] := d > 1 && PrimePowerQ[d];

(* Expected prime constants per the conjecture: one prime p for each
   prime power divisor p^k > 1 of n *)
expectedPrimes[n_Integer] := Module[{ppDivs},
  ppDivs = Select[Divisors[n], primePowerQ];
  Sort[FactorInteger[#][[1, 1]] & /@ ppDivs]
];

(* Factorize T_n(x+1) - 1 and extract structure *)
factorStructure[n_Integer] := Module[{poly, fl},
  poly = ChebyshevT[n, x + 1] - 1;
  fl = FactorList[poly];
  Table[
    With[{f = fl[[i, 1]], m = fl[[i, 2]]},
      <|"factor" -> f,
        "constant" -> (f /. x -> 0),
        "mult" -> m,
        "degree" -> Exponent[f, x]|>],
    {i, 1, Length[fl]}]
];

primeConstQ[c_] := IntegerQ[c] && PrimeQ[Abs[c]];

(* Multiset of |constant| for distinct degree>=1 factors with prime constant *)
primeConstantMultiset[items_List] := Module[{primeFactors},
  primeFactors = Select[items, primeConstQ[#["constant"]] && #["degree"] >= 1 &];
  Sort[Abs[#["constant"]] & /@ primeFactors]
];

verifyOne[n_Integer] := Module[{items, expected, actual, ok},
  items = factorStructure[n];
  expected = expectedPrimes[n];
  actual = primeConstantMultiset[items];
  ok = (expected === actual);
  <|"n" -> n,
    "Omega" -> PrimeOmega[n],
    "v2" -> IntegerExponent[n, 2],
    "expectedPrimes" -> expected,
    "actualPrimes" -> actual,
    "match" -> ok,
    "factors" -> ({#["constant"], #["mult"], #["degree"]} & /@ items)|>
];

(* ---- run ---------------------------------------------------------------- *)

results = Table[verifyOne[n], {n, 2, 50}];

(* ---- summary by n mod 4 ----------------------------------------------- *)

Print["=== T_n(x+1) - 1 factorization, n = 2..50 ==="];
Print["counting distinct irreducible factors over Q of degree >= 1 with prime constant"];
Print[];
Print[StringJoin[StringPadRight[#, 8] & /@ {"n", "v2(n)", "Omega", "expect", "actual", "match"}]];
Print[StringRepeat["-", 70]];

Do[
  With[{r = results[[i]]},
    Print[StringJoin[StringPadRight[#, 8] & /@ {
      ToString[r["n"]],
      ToString[r["v2"]],
      ToString[r["Omega"]],
      ToString[r["expectedPrimes"]],
      ToString[r["actualPrimes"]],
      If[r["match"], "OK", "FAIL"]
    }]]],
  {i, Length[results]}];

Print[];
Print["=== summary ==="];
matches = Select[results, #["match"] &];
mismatches = Select[results, ! #["match"] &];
Print["match: ", Length[matches], " / ", Length[results]];

(* Group by 2-adic valuation *)
Do[
  group = Select[results, #["v2"] === v &];
  groupMatch = Select[group, #["match"] &];
  Print["v2(n) = ", v, ": ", Length[groupMatch], " / ", Length[group], " match  (n in ",
    StringTake[ToString[#["n"] & /@ group], UpTo[60]], ")"],
  {v, 0, 5}];

Print[];
Print["mismatches:"];
Do[Print["  n=", m["n"], "  v2=", m["v2"], "  expected ", m["expectedPrimes"], "  got ", m["actualPrimes"]],
  {m, mismatches}];

(* ---- verification of refined conjecture ------------------------------- *)

Print[];
Print["=== refined conjecture: bijection holds iff 4 does NOT divide n ==="];
refinedConjectureHolds = AllTrue[results,
  If[Mod[#["n"], 4] != 0, #["match"], True] &];
Print["For all n with 4 NOT | n in [2,50], bijection matches: ", refinedConjectureHolds];

mismatchN4 = Select[mismatches, Mod[#["n"], 4] === 0 &];
mismatchOther = Select[mismatches, Mod[#["n"], 4] != 0 &];
Print["Mismatches with 4 | n:        ", Length[mismatchN4]];
Print["Mismatches with 4 NOT | n:    ", Length[mismatchOther]];

(* ---- detailed factor dump for representative cases -------------------- *)

Print[];
Print["=== detailed structure for n in {6, 9, 12, 15, 18, 27, 36, 45} ==="];
Do[
  With[{r = First[Select[results, #["n"] === n &]]},
    Print[];
    Print["n = ", n, "  v2 = ", r["v2"], "  Omega = ", r["Omega"],
      "  T_n(x+1)-1 factorization:"];
    Do[
      With[{c = f[[1]], m = f[[2]], d = f[[3]]},
        tag = Which[
          d === 0, "(leading const)",
          c === 0, "(x)",
          primeConstQ[c] && d >= 1, "<-- PRIME const " <> ToString[Abs[c]],
          Abs[c] === 1, "(extraneous, |c|=1)",
          True, "(other)"];
        Print["  const=", StringPadRight[ToString[c], 4],
          "  mult=", m, "  deg=", d, "  ", tag]],
      {f, r["factors"]}]],
  {n, {6, 9, 12, 15, 18, 27, 36, 45}}];
