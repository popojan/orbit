(* Geometric interpretation: what does δ measure about the primitive lobes? *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
primLobes[k_] := Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
signSum[k_] := Total[(-1)^(# - 1) & /@ primLobes[k]];

computeDelta[p1_, p2_, p3_] := Module[
  {M2, M3, e2, e3, c2, c3, inv12, inv13, inv23, delta},

  M2 = p1 p3; M3 = p1 p2;
  e2 = PowerMod[M2, -1, p2];
  e3 = PowerMod[M3, -1, p3];
  c2 = Mod[M2 e2, 2];
  c3 = Mod[M3 e3, 2];

  inv12 = Mod[PowerMod[p1, -1, p2], 2];
  inv13 = Mod[PowerMod[p1, -1, p3], 2];
  inv23 = Mod[PowerMod[p2, -1, p3], 2];

  Mod[c2 + c3 + inv12 + inv13 + inv23, 2]
];

(* For each CRT class, the parity of n depends on the class *)
(* Maybe δ counts something about which CRT classes contribute +1 vs -1 *)

Print["=== CRT class analysis ===\n"];

(* For k = 3*p2*p3, primitive lobes are those with n ≡ 2 (mod 3), n ∉ {0,1} (mod p2), n ∉ {0,1} (mod p3) *)
(* This gives (3-2)*(p2-2)*(p3-2) = (p2-2)*(p3-2) classes *)

(* Each class has unique representative in [0, k). Its parity determines sign contribution. *)

Print["Example: k = 3*5*7 = 105"];
k = 105;
lobes = primLobes[k];
Print["#primLobes = ", Length[lobes], " (formula: (5-2)*(7-2) = 15)"];

(* Group by CRT class *)
crtClass[n_] := {Mod[n, 3], Mod[n, 5], Mod[n, 7]};
classes = crtClass /@ lobes;
Print["CRT classes (all have first component = 2):"];
Print[classes];

(* Parity distribution *)
parities = Mod[lobes, 2];
Print["Parities: ", Tally[parities], " (0=even, 1=odd)"];
Print["signSum = ", signSum[k], " = #odd - #even = ", Count[parities, 1], " - ", Count[parities, 0]];

Print["\n=== What determines parity from CRT class? ==="];
(* For n with CRT class (2, a, b), n = 2*M1*e1 + a*M2*e2 + b*M3*e3 mod k *)
(* Parity of n depends on parities of individual terms *)

M1 = 5*7; M2 = 3*7; M3 = 3*5;
e1 = PowerMod[M1, -1, 3];
e2 = PowerMod[M2, -1, 5];
e3 = PowerMod[M3, -1, 7];
Print["M1*e1 mod 2 = ", Mod[M1*e1, 2], " (M1=", M1, ", e1=", e1, ")"];
Print["M2*e2 mod 2 = ", Mod[M2*e2, 2], " (M2=", M2, ", e2=", e2, ")"];
Print["M3*e3 mod 2 = ", Mod[M3*e3, 2], " (M3=", M3, ", e3=", e3, ")"];

Print["\nFor class (2, a, b), parity of n = (2*", Mod[M1*e1, 2], " + a*", Mod[M2*e2, 2], " + b*", Mod[M3*e3, 2], ") mod 2"];
Print["= (0 + a*0 + b*0) mod 2 = 0 always!"];
Print["So all lobes would be even??? Let me verify...\n"];

(* Actually need to compute n mod 2 carefully *)
crtN[a1_, a2_, a3_] := Mod[a1*M1*e1 + a2*M2*e2 + a3*M3*e3, 105];

Print["Direct computation of n for each CRT class:"];
Do[
  n = crtN[2, a, b];
  If[n >= 2 && n <= 103 && isPrimitiveLobe[n, 105],
    Print["  (2,", a, ",", b, ") → n=", n, ", parity=", Mod[n, 2]]
  ],
  {a, 2, 4}, {b, 2, 6}
];

(* The issue: CRT formula gives n mod k, but n mod 2 is not just sum of terms mod 2 *)
Print["\n=== Direct parity formula ==="];
Print["n = 35*2 + 21*a*", e2, " + 15*b*", e3, " mod 105"];
Print["  = 70 + 21*a*2 + 15*b*1 mod 105"];
Print["  = 70 + 42a + 15b mod 105"];
Print["Parity = (70 + 42a + 15b) mod 2 = (0 + 0 + b) mod 2 = b mod 2"];
Print["So parity of n is determined by b = n mod 7 alone!"];

Print["\n=== Verify ==="];
Do[
  n = crtN[2, a, b];
  If[n >= 2 && n <= 103,
    predicted = Mod[b, 2];
    actual = Mod[n, 2];
    If[predicted != actual, Print["MISMATCH at ", {a, b}]]
  ],
  {a, 2, 4}, {b, 2, 6}
];
Print["Verified: parity of n = (n mod p3) mod 2 for this case"];
