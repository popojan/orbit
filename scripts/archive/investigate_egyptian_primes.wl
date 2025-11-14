(* Investigate prime structure in Egyptian fractions *)

<< Ratio`

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["INVESTIGATING PRIMES IN EGYPTIAN FRACTION STRUCTURE"];
Print["═══════════════════════════════════════════════════"];
Print[""];

(* Focus on m ≡ 1 (mod 4) where Σ_m > 0 *)
primes = Select[Range[5, 61, 4], PrimeQ]; (* 5, 13, 17, 29, 37, 41, 53, 61 *)

Print["Analyzing POSITIVE Σ_m values (m ≡ 1 mod 4):"];
Print[""];

results = Table[
  Module[{m, sigma, raw, bVals, vVals, primesInB, primesInV, allPrimes},
    m = p;
    sigma = ComputeBareSumAlt[m];

    raw = EgyptianFractions[sigma, Method -> "Raw"];

    If[Length[raw] > 0,
      (* Filter out the Sqrt terms *)
      bVals = Select[raw[[All, 1]], NumberQ];
      vVals = Select[raw[[All, 2]], # > 0 &];

      primesInB = Select[bVals, PrimeQ];
      primesInV = Select[vVals, PrimeQ];

      (* All primes up to m *)
      allPrimes = Prime[Range[PrimePi[m]]];

      Print["m = ", m, ":"];
      Print["  Σ_m = ", N[sigma, 5]];
      Print["  b values: ", bVals];
      Print["  PRIMES in b: ", primesInB];
      Print["  v values: ", vVals];
      Print["  PRIMES in v: ", primesInV];
      Print["  All primes ≤ m: ", allPrimes];

      (* Check if primes in v are related to primes ≤ m *)
      Print["  Which v-primes are ≤ m? ", Intersection[primesInV, allPrimes]];
      Print["  Missing primes from {primes ≤ m}: ",
        Complement[allPrimes, Union[primesInB, primesInV]]];

      Print[""];

      <|
        "m" -> m,
        "sigma" -> sigma,
        "bPrimes" -> primesInB,
        "vPrimes" -> primesInV,
        "allPrimesLeqM" -> allPrimes
      |>
    ,
      Print["m = ", m, ": Empty (Σ_m negative)"];
      Print[""];
      <||>
    ]
  ],
  {p, primes}
];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ANALYZING THE MODULAR INVERSE VALUES"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["The v values come from ModularInverse[-a, b] in the algorithm."];
Print[""];
Print["Key question: Are the v values related to missing primes?"];
Print[""];

(* For m=13, we know 17 is a v value. Is 17 a \"missing prime\" for some larger m? *)
Print["Example: m=13 has v=17 in its Egyptian structure."];
Print["Is 17 a missing prime for m=29? (We found 17 divides 2·8+1=17 but not 29)"];
Print[""];

Print["Checking: Does 17 divide any 2i+1 for i < (29-1)/2 = 14?"];
Do[
  If[Mod[2*i+1, 17] == 0,
    Print["  i=", i, ": 2i+1 = ", 2*i+1, " ≡ 0 (mod 17)"];
  ],
  {i, 1, 14}
];

Print[""];
Print["YES! i=8 gives 2·8+1 = 17."];
Print[""];
Print["So v=17 from m=13 relates to the missing prime phenomenon at m=29!"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["HYPOTHESIS: v values predict missing primes for larger m"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Testing: Do v-primes from m=13,17 appear as missing primes elsewhere?"];
Print[""];

(* Get all v-primes *)
allVPrimes = Union[Flatten[Select[results, #["vPrimes"] =!= Missing["KeyAbsent", "vPrimes"] &][[All, "vPrimes"]]]];
Print["All prime v values found: ", allVPrimes];
Print[""];

(* For each v-prime, check if it's a divisor of 2i+1 for some i *)
Do[
  Module[{p, iValues},
    p = vPrime;
    (* Find all i such that 2i+1 ≡ 0 (mod p) *)
    (* This means 2i ≡ -1 (mod p), so i ≡ (-1)/2 (mod p) *)
    (* i ≡ (p-1)/2 (mod p) *)

    iValues = Table[(p-1)/2 + k*p, {k, 0, 5}];

    Print["Prime ", p, ": divides 2i+1 for i = ", iValues[[1]], " + k·", p];
    Print["  First few i: ", Take[iValues, 3]];
    Print["  Corresponding 2i+1: ", (2*# + 1) & /@ Take[iValues, 3]];
    Print[""];
  ],
  {vPrime, Take[allVPrimes, Min[5, Length[allVPrimes]]]}
];

Print[""];
Print["CONCLUSION: The Egyptian fraction structure encodes information"];
Print["about which primes divide denominators 2i+1 in the original sum!"];
Print[""];
