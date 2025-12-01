(* Deep analysis: defect vs p mod 8 *)

defect[p_] := p - Floor[Sqrt[p]]^2;
signedDist[p_] := Module[{s = Floor[Sqrt[p]], d},
  d = p - s^2;
  If[d <= s, d, d - 2*s - 1]  (* = -(s+1)² + p if closer to upper *)
];

Print["=== Defect pattern by p mod 8 ==="];
Print[""];

primes = Select[Range[3, 200], PrimeQ];

(* Group by p mod 8 *)
groups = GroupBy[primes, Mod[#, 8] &];

Do[
  ps = groups[r];
  Print["p ≡ ", r, " (mod 8): ", Length[ps], " primes"];
  Print["  Examples: ", Take[ps, Min[8, Length[ps]]]];
  defects = defect /@ Take[ps, Min[8, Length[ps]]];
  Print["  Defects: ", defects];
  Print["  Defects mod 4: ", Mod[defects, 4]];
  sds = signedDist /@ Take[ps, Min[8, Length[ps]]];
  Print["  SignedDist: ", sds];
  Print["  SignedDist mod 4: ", Mod[sds, 4]];
  Print[""];
  ,
  {r, {1, 3, 5, 7}}
];

(* Hypothesis: is there a formula? *)
Print["=== Checking: Is defect(p) predictable from p mod something? ==="];
Print[""];

(* For p = s² + d where 0 < d < 2s+1
   We have s = floor(sqrt(p))
   p mod 4 doesn't determine s mod 4 *)

Print["Testing correlation: s mod 4 vs p mod 8"];
Do[
  ps = groups[r];
  sVals = Floor[Sqrt[#]] & /@ ps;
  sMod4 = Mod[sVals, 4];
  Print["p ≡ ", r, " (mod 8): s mod 4 distribution = ", Tally[sMod4]];
  ,
  {r, {1, 3, 5, 7}}
];
Print[""];

(* Key insight: sqrt(p) mod 4 is related to p via quadratic character *)
Print["=== Quadratic residue connection ==="];
Print[""];

(* For p = s² + d:
   If d is small, p ≈ s², so √p ≈ s
   The "error" d determines how far from perfect square *)

Print["Checking: defect mod 4 vs Legendre symbol"];
Do[
  p = primes[[i]];
  s = Floor[Sqrt[p]];
  d = defect[p];
  leg2 = JacobiSymbol[2, p];  (* 2 is QR mod p iff p ≡ ±1 mod 8 *)
  legMinus1 = JacobiSymbol[-1, p];  (* -1 is QR mod p iff p ≡ 1 mod 4 *)
  Print[p, ": s=", s, ", d=", d, ", d mod 4=", Mod[d, 4],
        ", (2/p)=", leg2, ", (-1/p)=", legMinus1,
        ", p mod 8=", Mod[p, 8]];
  ,
  {i, 1, 20}
];
Print[""];

(* The Pell equation x² - py² = 1 has fundamental solution (x₁, y₁)
   with x₁ = floor(√p) initially, then CF convergents *)

Print["=== Pell connection: CF convergents ==="];
Print[""];

Do[
  p = primes[[i]];
  If[p < 100,
    cf = ContinuedFraction[Sqrt[p]];
    convs = Convergents[Sqrt[p], 5];
    Print[p, ": CF = ", cf];
    Print["   Convergents: ", convs];
    Print["   First conv num mod 4: ", Mod[Numerator[convs[[1]]], 4]];
  ];
  ,
  {i, 1, 10}
];
Print[""];

(* The sum of signedDist might capture:
   Sum of "offsets from perfect squareness" *)

Print["=== Sum analysis on conflicts ==="];
Print[""];

conflicts = {
  {{3, 5, 11, 19}, {13, 17, 23, 79}},
  {{3, 7, 11, 29}, {3, 31, 47, 71}},
  {{7, 13, 23, 71}, {7, 13, 37, 71}}
};

Do[
  ps1 = conflicts[[i, 1]];
  ps2 = conflicts[[i, 2]];

  Print["--- Conflict ", i, " ---"];
  Print["Set 1: ", ps1];
  Print["  p mod 8: ", Mod[ps1, 8]];
  Print["  defects: ", defect /@ ps1];
  Print["  s values: ", Floor[Sqrt[#]] & /@ ps1];
  Print["  s mod 4: ", Mod[Floor[Sqrt[#]] & /@ ps1, 4]];

  Print["Set 2: ", ps2];
  Print["  p mod 8: ", Mod[ps2, 8]];
  Print["  defects: ", defect /@ ps2];
  Print["  s values: ", Floor[Sqrt[#]] & /@ ps2];
  Print["  s mod 4: ", Mod[Floor[Sqrt[#]] & /@ ps2, 4]];

  (* Check: does sum of (s mod 4) differ? *)
  sumS1 = Total[Mod[Floor[Sqrt[#]] & /@ ps1, 4]];
  sumS2 = Total[Mod[Floor[Sqrt[#]] & /@ ps2, 4]];
  Print["Sum(s mod 4): ", {sumS1, sumS2}, If[sumS1 != sumS2, " DIFFERENT!", ""]];
  Print[""];
  ,
  {i, 3}
];

(* Theoretical insight *)
Print["=== THEORETICAL INSIGHT ==="];
Print[""];
Print["For prime p:"];
Print["  s = floor(√p)"];
Print["  p = s² + d where 0 < d ≤ 2s"];
Print["  signedDist = d if d ≤ s, else d - 2s - 1"];
Print[""];
Print["Key: The 22-bit pattern captures modular inverse structure,"];
Print["but NOT the 'distance to perfect square' of individual primes."];
Print[""];
Print["signedDist adds orthogonal information about p's position"];
Print["relative to nearby perfect squares."];
