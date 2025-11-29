(* Try to find direct formula for Σsigns(p1*p2*p3) *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Theoretical: #primLobes = φ(k) - φ(k/p1) - φ(k/p2) - φ(k/p3) + ... (inclusion-exclusion)
   For squarefree k = p1*p2*p3: #primLobes = (p1-2)(p2-2)(p3-2)
*)

Print["=== Verify #primLobes formula ==="];
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    expected = (p1 - 2)(p2 - 2)(p3 - 2);
    actual = Length[Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
    If[expected != actual,
      Print["MISMATCH: ", k, " expected ", expected, " got ", actual]
    ]
  ],
  {p1, {3}}, {p2, Prime[Range[3, 8]]}, {p3, Prime[Range[4, 12]]}
];
Print["Formula verified: #primLobes = (p1-2)(p2-2)(p3-2)"];

(* For sign sum, we need to count even vs odd primitive lobes *)
(* n is primitive lobe iff:
   - n ≢ 0, 1 (mod pi) for all i
   - n ∈ [2, k-1]
   But for squarefree k, exactly one representative per CRT class in [0,k)
   And n=0, n=1 are excluded, so [2, k-1] has all (p1-2)(p2-2)(p3-2) classes
*)

(* Sign of n: (-1)^(n-1) = -1 if n even, +1 if n odd *)
(* So signSum = #odd - #even primitive lobes *)

Print["\n=== Count odd vs even primitive lobes ==="];

(* For a CRT class with residues (a1, a2, a3) mod (p1, p2, p3),
   the unique n ∈ [0, k) has parity determined by the CRT reconstruction.

   n ≡ a1 (mod p1), n ≡ a2 (mod p2), n ≡ a3 (mod p3)
   n = a1 * M1 * (M1^-1 mod p1) + a2 * M2 * (M2^-1 mod p2) + a3 * M3 * (M3^-1 mod p3)
   where Mi = k/pi
*)

parityOfCRT[a1_, a2_, a3_, p1_, p2_, p3_] := Module[
  {M1 = p2 p3, M2 = p1 p3, M3 = p1 p2, n},
  n = Mod[a1 * M1 * PowerMod[M1, -1, p1] +
          a2 * M2 * PowerMod[M2, -1, p2] +
          a3 * M3 * PowerMod[M3, -1, p3], p1 p2 p3];
  Mod[n, 2]
];

(* Count odd primitive lobes for a given (p1, p2, p3) *)
countOdd[p1_, p2_, p3_] := Module[{count = 0},
  Do[
    If[a1 >= 2 && a2 >= 2 && a3 >= 2 &&
       parityOfCRT[a1, a2, a3, p1, p2, p3] == 1,
      count++
    ],
    {a1, 2, p1 - 1}, {a2, 2, p2 - 1}, {a3, 2, p3 - 1}
  ];
  count
];

countEven[p1_, p2_, p3_] := (p1 - 2)(p2 - 2)(p3 - 2) - countOdd[p1, p2, p3];

Print["Testing formula: signSum = #odd - #even"];
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    nOdd = countOdd[p1, p2, p3];
    nEven = countEven[p1, p2, p3];
    predicted = nOdd - nEven;
    If[ss != predicted,
      Print["MISMATCH: ", k, " ss=", ss, " predicted=", predicted],
      Print[k, " = ", p1, "×", p2, "×", p3, ": ss=", ss, " = ", nOdd, " - ", nEven, " ✓"]
    ]
  ],
  {p1, {3}}, {p2, Prime[Range[3, 6]]}, {p3, Prime[Range[4, 8]]}
];

(* Now: can we find a formula for nOdd? *)
Print["\n=== Look for pattern in nOdd ==="];
data = {};
Do[
  If[p1 < p2 < p3,
    nOdd = countOdd[p1, p2, p3];
    total = (p1 - 2)(p2 - 2)(p3 - 2);
    AppendTo[data, {p1, p2, p3, nOdd, total, nOdd - total/2}]
  ],
  {p1, {3}}, {p2, Prime[Range[3, 8]]}, {p3, Prime[Range[4, 12]]}
];

Print["(p1, p2, p3, nOdd, total, nOdd - total/2):"];
Do[Print[row], {row, data}];
