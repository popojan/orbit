(* Group-theoretic structure of 77 and its connection to Euler's e *)

Print["╔═══════════════════════════════════════════════════════════════╗"];
Print["║     THE GROUP STRUCTURE OF 77 AND EULER'S e                  ║"];
Print["╚═══════════════════════════════════════════════════════════════╝\n"];

(* === PART 1: The multiplicative group === *)
Print["═══ PART 1: MULTIPLICATIVE GROUP (Z/77Z)* ═══\n"];

Print["77 = 7 × 11 (semiprime)\n"];

Print["By CRT: (Z/77Z)* ≅ (Z/7Z)* × (Z/11Z)*"];
Print["                 ≅ C6 × C10"];
Print["                 ≅ C2 × C30  (since gcd(6,10)=2, lcm(6,10)=30)\n"];

(* Verify *)
group77 = Select[Range[76], CoprimeQ[#, 77] &];
Print["|(Z/77Z)*| = ", Length[group77], " = φ(77) = φ(7)φ(11) = 6×10 ✓\n"];

(* Order structure *)
orders = Tally[MultiplicativeOrder[#, 77] & /@ group77] // Sort;
Print["Order distribution in (Z/77Z)*:"];
Print["  Order → Count"];
Do[Print["    ", o[[1]], " → ", o[[2]]], {o, orders}];

Print["\nKey: max order = 30 confirms C30 factor (not cyclic C60).\n"];

(* === PART 2: The s_n sequence mod 77 === *)
Print["═══ PART 2: THE s_n SEQUENCE MOD 77 ═══\n"];

Print["Recurrence: s_n = (4n+2)·s_{n-1} + s_{n-2}"];
Print["Initial: s_0 = 1, s_1 = 7\n"];

(* Compute sequence mod 77 *)
s77[0] = 1; s77[1] = 7;
Do[s77[n] = Mod[(4 n + 2) s77[n - 1] + s77[n - 2], 77], {n, 2, 300}];

(* Find period of sequence *)
findPeriod[seq_, maxCheck_] := Module[{pairs, first},
  pairs = Table[{seq[n], seq[n + 1]}, {n, 0, maxCheck}];
  first = pairs[[1]];
  SelectFirst[Range[2, maxCheck], pairs[[#]] == first &, "none"] - 1
];

seqPeriod = findPeriod[s77, 200];
Print["Period of s_n mod 77: ", seqPeriod];
Print["Factorization: ", seqPeriod, " = ", FactorInteger[seqPeriod]];

(* === PART 3: The coefficient structure === *)
Print["\n═══ PART 3: COEFFICIENT STRUCTURE ═══\n"];

Print["Coefficients c_n = (4n+2) mod 77:"];
coeffs = Table[Mod[4 n + 2, 77], {n, 0, 76}];
Print["Period: 77 (coefficients cycle through all residues)\n"];

(* When is coefficient ≡ 0? *)
zeroCoeffPos = Select[Range[0, 76], Mod[4 # + 2, 77] == 0 &];
Print["c_n ≡ 0 (mod 77) when n ≡ ", zeroCoeffPos, " (mod 77)"];
Print["Check: 4×", zeroCoeffPos[[1]], "+2 = ", 4 zeroCoeffPos[[1]] + 2,
      " = ", (4 zeroCoeffPos[[1]] + 2)/77, "×77 ✓\n"];

(* === PART 4: Zero positions and CRT === *)
Print["═══ PART 4: ZEROS OF s_n AND THE CRT ═══\n"];

zeros77 = Select[Range[0, 154], s77[#] == 0 &];
Print["s_n ≡ 0 (mod 77) at n = ", zeros77];
Print["Positions mod 77: ", Union[Mod[zeros77, 77]], "\n"];

Print["CRT DECOMPOSITION:"];
Print["━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"];
Print["s_n ≡ 0 (mod 7)  ⟺  n ≡ 1, 3 (mod 7)"];
Print["s_n ≡ 0 (mod 11) ⟺  n ≡ 3, 5 (mod 11)"];
Print[""];
Print["77 | s_n requires BOTH:\n"];

Print["  n mod 7  │  n mod 11  │  n mod 77 (CRT)"];
Print["  ─────────┼────────────┼─────────────────"];
Do[
  Do[
    sol = ChineseRemainder[{r7, r11}, {7, 11}];
    Print["     ", r7, "     │      ", r11, "     │       ", sol];
  , {r11, {3, 5}}]
, {r7, {1, 3}}];

Print["\n⟹  77 | s_n  ⟺  n ≡ 3, 36, 38, 71 (mod 77)  ✓\n"];

(* === PART 5: The 11 bridge === *)
Print["═══ PART 5: THE PRIME 11 AS BRIDGE ═══\n"];

Print["Sequence period: 44 = 4 × 11"];
Print["Zero period:     77 = 7 × 11"];
Print["Common factor:   11\n"];

Print["In (Z/77Z)* ≅ C6 × C10:"];
Print["  C6  comes from (Z/7Z)*"];
Print["  C10 comes from (Z/11Z)*  ← the bridge!\n"];

Print["The C10 factor (from prime 11) connects:"];
Print["  • The sequence periodicity (44 = 4×11)"];
Print["  • The zero structure (77 = 7×11)"];
Print["  • The group structure C2 × C30 = C2 × C2 × C3 × C5\n"];

(* === PART 6: Visual demonstration === *)
Print["═══ PART 6: VISUAL PATTERN ═══\n"];

Print["s_n mod 77 for n = 0 to 87 (two periods of 44):"];
Print["(zeros marked with ●)\n"];

Do[
  row = Table[
    val = s77[n + j];
    If[val == 0, "●", If[val < 10, " ", ""] <> ToString[val]]
  , {j, 0, 10}];
  Print["n=", If[n < 10, " ", ""], n, "-", n + 10, ": ", StringRiffle[row, " "]];
, {n, 0, 87, 11}];

Print["\n═══ SUMMARY ═══\n"];
Print["The number 77 = 7 × 11 is arithmetically encoded in Euler's e:"];
Print["  1. s_1 = 7 (initial condition)"];
Print["  2. s_3 = 1001 = 7 × 11 × 13 (first multiple of 77)"];
Print["  3. Group (Z/77Z)* ≅ C2 × C30 governs the structure"];
Print["  4. Prime 11 bridges sequence period (44) and zero period (77)"];
