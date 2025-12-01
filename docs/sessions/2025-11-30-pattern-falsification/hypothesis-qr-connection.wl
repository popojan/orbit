(* Test hypothesis: signedDist encodes quadratic residue information *)

signedDist[p_] := Module[{s = Floor[Sqrt[p]], d},
  d = p - s^2;
  If[d <= s, d, d - 2*s - 1]
];

Print["=== HYPOTHESIS: signedDist mod 4 encodes (2/p) ==="];
Print[""];

(* (2/p) = 1 iff p ≡ ±1 mod 8
   (2/p) = -1 iff p ≡ ±3 mod 8 *)

primes = Select[Range[3, 100], PrimeQ];

Print["Testing: signedDist mod 2 vs (2/p)"];
Print[""];

correct = 0;
total = 0;
Do[
  sd = signedDist[p];
  sdMod2 = Mod[sd, 2];
  qr2 = JacobiSymbol[2, p];  (* 1 or -1 *)
  expected = If[qr2 == 1, 0, 1];  (* conjecture: sd mod 2 = 0 if 2 is QR, 1 if NQR *)

  match = (sdMod2 == expected);
  If[match, correct++];
  total++;

  Print[p, ": sd=", sd, " mod2=", sdMod2, " (2/p)=", qr2,
        " expected=", expected, If[match, " ✓", " ✗"]];
  ,
  {p, Take[primes, 25]}
];
Print[""];
Print["Accuracy: ", correct, "/", total];
Print[""];

(* Alternative: check defect mod 2 *)
Print["=== Alternative: defect mod 2 vs (2/p) ==="];
defect[p_] := p - Floor[Sqrt[p]]^2;

correct2 = 0;
Do[
  d = defect[p];
  dMod2 = Mod[d, 2];
  qr2 = JacobiSymbol[2, p];
  expected = If[qr2 == 1, 1, 0];  (* different hypothesis *)

  match = (dMod2 == expected);
  If[match, correct2++];

  Print[p, ": defect=", d, " mod2=", dMod2, " (2/p)=", qr2,
        " match=", match];
  ,
  {p, Take[primes, 15]}
];
Print["Accuracy: ", correct2, "/15"];
Print[""];

(* Check: is floor(√p) mod 4 related to something? *)
Print["=== floor(√p) mod 4 patterns ==="];
Print[""];

(* Group by floor(√p) mod 4 *)
groups = GroupBy[primes, Mod[Floor[Sqrt[#]], 4] &];

Do[
  ps = groups[r];
  Print["floor(√p) ≡ ", r, " (mod 4): primes = ", Take[ps, Min[10, Length[ps]]]];
  Print["  p mod 8 distribution: ", Tally[Mod[Take[ps, Min[10, Length[ps]]], 8]]];
  ,
  {r, {0, 1, 2, 3}}
];
Print[""];

(* Key test: for two prime sets with same 22-bit pattern,
   does sum of floor(√p) mod 4 differ when SS differs? *)

Print["=== CORE TEST: Does sum(floor(√p)) mod 4 determine SS? ==="];
Print[""];

(* Known conflicts *)
conflicts = {
  {{{3, 5, 11, 19}, {13, 17, 23, 79}}, {1, 5}},
  {{{3, 7, 11, 29}, {3, 31, 47, 71}}, {1, 9}},
  {{{7, 13, 23, 71}, {7, 13, 37, 71}}, {-7, 5}},
  {{{3, 13, 79, 181}, {7, 29, 59, 197}}, {-7, -11}},
  {{{3, 5, 11, 17}, {3, 29, 59, 89}, {7, 41, 83, 97}}, {-11, -11, -15}},
  {{{3, 7, 11, 17}, {7, 71, 83, 97}}, {1, 5}},
  {{{3, 13, 17, 53}, {5, 11, 29, 89}}, {1, 5}},
  {{{3, 19, 29, 43}, {5, 47, 59, 71}}, {1, 5}},
  {{{3, 29, 31, 97}, {7, 41, 47, 73}}, {1, -3}},
  {{{5, 7, 11, 41}, {7, 17, 29, 43}}, {5, 13}}
};

floorSqrtSum[ps_] := Total[Floor[Sqrt[#]] & /@ ps];

Print["Conflict | SS values | sum(floor√p) | sum mod 4 | DIST?"];
Print[StringJoin[Table["-", 60]]];

Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];
  sums = floorSqrtSum /@ psets;
  sumsMod4 = Mod[sums, 4];
  dist = Length[DeleteDuplicates[sumsMod4]] > 1;

  Print[i, " | ", ssVals, " | ", sums, " | ", sumsMod4, " | ", If[dist, "YES", "no"]];
  ,
  {i, Length[conflicts]}
];

Print[""];
Print["=== COMBINED: signedDist4 + floorSqrt4 ==="];
Print[""];

signedDistSum4[ps_] := Mod[Total[signedDist /@ ps], 4];
floorSqrt4[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 4];

Print["Conflict | SS | signedDist4 | floorSqrt4 | COVERED?"];
Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];
  sd4 = signedDistSum4 /@ psets;
  fs4 = floorSqrt4 /@ psets;
  coveredSD = Length[DeleteDuplicates[sd4]] > 1;
  coveredFS = Length[DeleteDuplicates[fs4]] > 1;

  Print[i, " | ", ssVals, " | ", sd4, If[coveredSD, " ✓", ""], " | ", fs4, If[coveredFS, " ✓", ""], " | ",
        If[coveredSD || coveredFS, "YES", "NO"]];
  ,
  {i, Length[conflicts]}
];
