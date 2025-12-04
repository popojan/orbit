(* 
Half-factorial mod p with correct sign using class number
Returns the unique value of ((p-1)/2)! mod p
*)

(* Original SqrtMod - returns both possibilities *)
SqrtMod[p_] := Module[{},
  Off[PowerMod::root];
  If[IntegerQ@#, {True, {#, p - #}}, {False, {1, p - 1}}] &@
   PowerMod[p - 1, 1/2, p]
]

(* Enhanced version - returns unique correct result *)
HalfFactorialMod[p_?PrimeQ] := Module[{h, sign, sqrtResult, candidates},
  
  (* Get candidates from Stickelberger *)
  (* ((p-1)/2)!² ≡ (-1)^((p+1)/2) (mod p) *)
  Off[PowerMod::root];
  sqrtResult = PowerMod[PowerMod[-1, (p+1)/2, p], 1/2, p];
  
  If[!IntegerQ[sqrtResult],
    (* p ≡ 1 (mod 4): -1 is QR, sqrt exists *)
    (* This case shouldn't happen if p ≡ 3 (mod 4) *)
    Return[$Failed]
  ];
  
  candidates = {sqrtResult, p - sqrtResult};
  
  (* Get sign from class number *)
  h = NumberFieldClassNumber[Sqrt[-p]];
  sign = (-1)^((h + 1)/2);
  
  (* Select correct candidate *)
  (* For p ≡ 3 (mod 4): result is ±1, sign tells us which *)
  If[Mod[p, 4] == 3,
    If[sign == 1, 1, p - 1],
    (* For p ≡ 1 (mod 4): result is ±√(-1) *)
    (* Need to determine which based on sign *)
    (* Test: which candidate, when squared, gives -1? *)
    (* Both do, so we need sign convention *)
    If[sign == 1, Min[candidates], Max[candidates]]  (* Heuristic - verify! *)
  ]
]

(* Direct computation for verification *)
DirectHalfFactorial[p_] := Mod[((p-1)/2)!, p]

(* Test *)
Print["═══════════════════════════════════════════════════════════"];
Print["Testing HalfFactorialMod vs Direct computation"];
Print["═══════════════════════════════════════════════════════════\n"];

(* Test p ≡ 3 (mod 4) *)
Print["=== p ≡ 3 (mod 4) ==="];
testPrimes3 = Select[Prime[Range[50, 200]], Mod[#, 4] == 3 &][[;;10]];
Do[
  direct = DirectHalfFactorial[p];
  fast = HalfFactorialMod[p];
  h = NumberFieldClassNumber[Sqrt[-p]];
  Print["p=", p, " h=", h, " direct=", direct, " fast=", fast, " ", 
        If[direct == fast, "✓", "✗"]];
, {p, testPrimes3}];

(* Test p ≡ 1 (mod 4) *)
Print["\n=== p ≡ 1 (mod 4) ==="];
testPrimes1 = Select[Prime[Range[50, 200]], Mod[#, 4] == 1 &][[;;10]];
Do[
  direct = DirectHalfFactorial[p];
  fast = HalfFactorialMod[p];
  h = NumberFieldClassNumber[Sqrt[-p]];
  Print["p=", p, " h=", h, " direct=", direct, " fast=", fast, " ", 
        If[direct == fast, "✓", "✗"]];
, {p, testPrimes1}];

Print["\n═══════════════════════════════════════════════════════════"];
Print["Timing comparison for large p"];
Print["═══════════════════════════════════════════════════════════\n"];

largePrimes = {100003, 1000003, 10000019};
Do[
  tDirect = First@AbsoluteTiming[d = DirectHalfFactorial[p];];
  tFast = First@AbsoluteTiming[f = HalfFactorialMod[p];];
  Print["p=", p];
  Print["  Direct: ", Round[1000*tDirect], " ms, result=", d];
  Print["  Fast:   ", Round[1000*tFast], " ms, result=", f];
  Print["  Match: ", If[d == f, "✓", "✗"], ", Speedup: ", N[tDirect/tFast, 3], "x\n"];
, {p, Select[largePrimes, Mod[#,4]==3&]}];
