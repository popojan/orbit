(* Debug why factorization fails for 3*5*11 *)

Print["=== Debugging 3*5*11 ===\n"];

p1 = 3; p2 = 5; p3 = 11;
k = p1 p2 p3;

(* CRT coefficients *)
c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
c3 = p1 p2 * PowerMod[p1 p2, -1, p3];

Print["c1 = ", c1, " (mod 2 = ", Mod[c1, 2], ")"];
Print["c2 = ", c2, " (mod 2 = ", Mod[c2, 2], ")"];
Print["c3 = ", c3, " (mod 2 = ", Mod[c3, 2], ")"];

b1 = Mod[c1, 2];
b2 = Mod[c2, 2];
b3 = Mod[c3, 2];
Print["b = (", b1, ", ", b2, ", ", b3, ")\n"];

(* Direct computation of Σsigns *)
isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;

primitiveLobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
Print["Number of primitive lobes: ", Length[primitiveLobes]];
Print["First few: ", primitiveLobes[[;;Min[20, Length[primitiveLobes]]]]];

signSumDirect = Total[(-1)^(# - 1) & /@ primitiveLobes];
Print["Σsigns (direct): ", signSumDirect, "\n"];

(* Via CRT signatures *)
Print["=== CRT signature analysis ===\n"];

oddCount = 0;
evenCount = 0;
details = {};

Do[
  n = Mod[a1 c1 + a2 c2 + a3 c3, k];
  s = a1 b1 + a2 b2 + a3 b3;
  sMod2 = Mod[s, 2];
  nMod2 = Mod[n, 2];
  sign = (-1)^(n - 1);

  AppendTo[details, {a1, a2, a3, n, s, sMod2, nMod2, sign}];

  If[OddQ[n], oddCount++, evenCount++],
  {a1, 2, p1 - 1},
  {a2, 2, p2 - 1},
  {a3, 2, p3 - 1}
];

Print["Total primitive signatures: ", Length[details]];
Print["Odd n: ", oddCount, ", Even n: ", evenCount];
Print["Σsigns (via count): ", oddCount - evenCount, "\n"];

(* Check parity prediction *)
Print["=== Checking parity prediction ===\n"];

parityErrors = 0;
Do[
  {a1, a2, a3, n, s, sMod2, nMod2, sign} = d;
  If[sMod2 != nMod2,
    parityErrors++;
    If[parityErrors <= 5,
      Print["Parity mismatch: a=(", a1, ",", a2, ",", a3, ") n=", n,
            " s=", s, " s mod 2=", sMod2, " n mod 2=", nMod2]
    ]
  ],
  {d, details}
];
Print["Parity errors: ", parityErrors, "\n"];

(* So why doesn't factorization work? *)
Print["=== Factorization analysis ===\n"];

(* Expected from factorization: *)
f1 = If[b1 == 0, p1 - 2, Total[(-1)^Range[2, p1-1]]];
f2 = If[b2 == 0, p2 - 2, Total[(-1)^Range[2, p2-1]]];
f3 = If[b3 == 0, p3 - 2, Total[(-1)^Range[2, p3-1]]];

Print["f1 (b1=", b1, "): ", f1];
Print["f2 (b2=", b2, "): ", f2];
Print["f3 (b3=", b3, "): ", f3];
Print["Product: ", f1 f2 f3];
Print["Expected Σsigns = -product = ", -f1 f2 f3];
Print["Actual Σsigns = ", signSumDirect, "\n"];

(* The sum via exponential *)
Print["=== Computing sum directly ===\n"];

sumViaExp = Total[
  (-1)^(a1 b1 + a2 b2 + a3 b3)
  /. {{a1, a2, a3} -> #} & /@
  Tuples[{Range[2, p1-1], Range[2, p2-1], Range[2, p3-1]}]
];

Print["Σ (-1)^(a1*b1 + a2*b2 + a3*b3) = ", sumViaExp];
Print["-sumViaExp = ", -sumViaExp];

(* Let's see... the factorization assumes independence *)
Print["\n=== Why factorization should work ===\n"];

(* Σ (-1)^(a1*b1 + a2*b2 + a3*b3)
   = Σ (-1)^(a1*b1) * (-1)^(a2*b2) * (-1)^(a3*b3)
   = [Σ_a1 (-1)^(a1*b1)] * [Σ_a2 (-1)^(a2*b2)] * [Σ_a3 (-1)^(a3*b3)]
*)

factor1 = Total[(-1)^(# b1) & /@ Range[2, p1 - 1]];
factor2 = Total[(-1)^(# b2) & /@ Range[2, p2 - 1]];
factor3 = Total[(-1)^(# b3) & /@ Range[2, p3 - 1]];

Print["Σ_{a1} (-1)^(a1*b1) = ", factor1];
Print["Σ_{a2} (-1)^(a2*b2) = ", factor2];
Print["Σ_{a3} (-1)^(a3*b3) = ", factor3];
Print["Product = ", factor1 * factor2 * factor3];

If[sumViaExp == factor1 * factor2 * factor3,
  Print["\n→ Factorization IS correct!"],
  Print["\n→ Factorization FAILS! sumViaExp=", sumViaExp,
        " product=", factor1 * factor2 * factor3]
];

(* But then why doesn't the closed form work? *)
Print["\n=== Check: is Σsigns = -sumViaExp? ==="];
Print["Σsigns = ", signSumDirect];
Print["-sumViaExp = ", -sumViaExp];
If[signSumDirect == -sumViaExp,
  Print["→ YES, Σsigns = -sumViaExp"],
  Print["→ NO! Something wrong with sign derivation!"]
];

(* Maybe the issue is in converting between CRT and lobe index? *)
Print["\n=== Verify CRT reconstruction ===\n"];

(* Check that primitive signatures biject with primitive lobes *)
crtLobes = {};
Do[
  n = Mod[a1 c1 + a2 c2 + a3 c3, k];
  AppendTo[crtLobes, n],
  {a1, 2, p1 - 1},
  {a2, 2, p2 - 1},
  {a3, 2, p3 - 1}
];
crtLobes = Sort[crtLobes];

Print["CRT lobes: ", Length[crtLobes], " values"];
Print["Primitive lobes: ", Length[primitiveLobes], " values"];
Print["Match: ", crtLobes == primitiveLobes];

If[crtLobes != primitiveLobes,
  Print["Missing in CRT: ", Complement[primitiveLobes, crtLobes]];
  Print["Extra in CRT: ", Complement[crtLobes, primitiveLobes]];
];
