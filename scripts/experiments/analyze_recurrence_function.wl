#!/usr/bin/env wolframscript
(* Analytical investigation of f(i,k) = ((1-i+k)(i+k))/(i(-1+2i)) *)

Print["=== ANALYTICAL INVESTIGATION OF RECURRENCE FUNCTION ===\n"];

(* Define the function *)
f[i_, k_] := ((1 - i + k)*(i + k))/(i*(-1 + 2*i));

Print["Function: f(i,k) = ((1-i+k)(i+k))/(i(-1+2i))"];
Print["       = (k-i+1)(k+i) / (i(2i-1))"];
Print[];

(* ============================================================ *)
Print["Part 1: Domain and Basic Properties\n"];
Print["======================================\n"];

Print["Definiční obor:"];
Print["  - i ≠ 0 (dělení nulou)"];
Print["  - i ≠ 1/2 (dělení nulou)"];
Print["  - Pro naši aplikaci: i ≥ 2, k ≥ 1, oba celá čísla"];
Print[];

Print["Pro i ≥ 2:"];
Print["  - Jmenovatel i(2i-1) > 0 (rostoucí s i)"];
Print["  - Pro k ≥ i: čitatel (k-i+1)(k+i) > 0"];
Print["  - Pro k < i: čitatel může být záporný"];
Print[];

(* ============================================================ *)
Print["Part 2: Partial Derivatives\n"];
Print["============================\n"];

Print["∂f/∂i (pro fixní k):"];
df_di = D[f[i, k], i] // Simplify;
Print["  ", df_di];
Print[];

Print["∂f/∂k (pro fixní i):"];
df_dk = D[f[i, k], k] // Simplify;
Print["  ", df_dk];
Print[];

(* ============================================================ *)
Print["Part 3: Behavior as Function of i (Fixed k)\n"];
Print["============================================\n"];

Do[
  kval = kfix;
  Print["k = ", kval, ":"];

  (* Critical points *)
  criticalEq = df_di /. k -> kval;
  Print["  Critical points (∂f/∂i = 0):"];
  criticalPts = Solve[criticalEq == 0 && i > 0, i, Reals];
  If[Length[criticalPts] > 0,
    Do[
      iCrit = i /. criticalPts[[idx]];
      Print["    i = ", N[iCrit], " (", iCrit, ")"];

      (* Check if in valid range *)
      If[iCrit >= 2 && iCrit <= kval,
        fVal = f[iCrit, kval] // N;
        Print["      f(", N[iCrit], ", ", kval, ") = ", fVal];
      ];
    , {idx, 1, Length[criticalPts]}];
  ,
    Print["    No real critical points"];
  ];

  (* Values at i=2 and i=k *)
  f2 = f[2, kval] // Simplify;
  fk = f[kval, kval] // Simplify;
  Print["  f(2, ", kval, ") = ", f2, " = ", N[f2]];
  Print["  f(", kval, ", ", kval, ") = ", fk, " = ", N[fk]];

  (* Monotonicity check *)
  Print["  Monotonie (2 ≤ i ≤ k):"];
  testPoints = Table[i, {i, 2, kval}];
  values = Table[f[i, kval], {i, 2, kval}];
  diffs = Differences[values];

  If[AllTrue[diffs, # < 0 &],
    Print["    Klesající ✓"];
  , If[AllTrue[diffs, # > 0 &],
    Print["    Rostoucí ✓"];
  ,
    Print["    Nemá jednoznačnou monotonii"];
    Print["    Hodnoty: ", N[values]];
  ]];

  Print[];
, {kfix, 3, 8}];

(* ============================================================ *)
Print["Part 4: Behavior as Function of k (Fixed i)\n"];
Print["============================================\n"];

Do[
  ival = ifix;
  Print["i = ", ival, ":"];

  (* Values for various k *)
  Print["  f(", ival, ", k) pro různá k:"];
  Do[
    If[ktest >= ival,
      fval = f[ival, ktest];
      Print["    k=", ktest, ": f = ", fval, " = ", N[fval]];
    ];
  , {ktest, ival, ival + 5}];

  (* Check monotonicity *)
  testKs = Table[k, {k, ival, ival + 10}];
  valuesK = Table[f[ival, k], {k, ival, ival + 10}];
  diffsK = Differences[valuesK];

  Print["  Monotonie (k ≥ ", ival, "):"];
  If[AllTrue[diffsK, # > 0 &],
    Print["    Rostoucí ✓"];
  , If[AllTrue[diffsK, # < 0 &],
    Print["    Klesající ✓"];
  ,
    Print["    Smíšená monotonie"];
  ]];

  Print[];
, {ifix, 2, 5}];

(* ============================================================ *)
Print["Part 5: Limits and Asymptotic Behavior\n"];
Print["======================================\n"];

Print["Limity pro i → ∞ (k fixní):"];
Do[
  kval = kfix;
  lim = Limit[f[i, kval], i -> Infinity];
  Print["  k=", kval, ": lim_{i→∞} f(i,", kval, ") = ", lim];
, {kfix, 3, 8}];
Print[];

Print["Limity pro k → ∞ (i fixní):"];
Do[
  ival = ifix;
  lim = Limit[f[ival, k], k -> Infinity];
  Print["  i=", ival, ": lim_{k→∞} f(", ival, ",k) = ", lim];
, {ifix, 2, 5}];
Print[];

Print["Asymptotika pro velká i, k:"];
Print["Pro k, i → ∞ s k/i → r (konstantní poměr):"];
Print["  f(i,k) ≈ (k-i)(k+i) / (2i²) = (k²-i²) / (2i²) ≈ (r²-1)/2"];
Print[];

(* Test asymptotic formula *)
Print["Ověření asymptotiky pro k = 2i:"];
Do[
  ival = itest;
  kval = 2*ival;
  exact = f[ival, kval];
  asympt = (kval^2 - ival^2) / (2*ival^2);
  ratio = N[exact / asympt];
  Print["  i=", ival, ", k=", kval, ": f = ", N[exact], ", asympt = ", N[asympt],
        ", ratio = ", ratio];
, {itest, {10, 50, 100, 500}}];
Print[];

(* ============================================================ *)
Print["Part 6: Special Values and Patterns\n"];
Print["====================================\n"];

Print["Diagonal (i = k):"];
Do[
  ival = idiag;
  fdiag = f[ival, ival] // Simplify;
  Print["  f(", ival, ", ", ival, ") = ", fdiag, " = ", N[fdiag]];
, {idiag, 2, 10}];
Print[];

Print["Pattern for diagonal:"];
Print["  f(k,k) = (k-k+1)(k+k) / (k(2k-1)) = 2k / (k(2k-1)) = 2 / (2k-1)"];
Print["  Verification:"];
Do[
  fdiag = f[kval, kval];
  expected = 2 / (2*kval - 1);
  Print["    k=", kval, ": f = ", N[fdiag], ", 2/(2k-1) = ", N[expected],
        ", match: ", Abs[fdiag - expected] < 10^-10];
, {kval, 2, 10}];
Print[];

Print["i = 2 (first recurrence step):"];
Do[
  kval = ktest;
  f2k = f[2, kval] // Simplify;
  Print["  f(2, ", kval, ") = ", f2k, " = ", N[f2k]];
, {ktest, 3, 10}];
Print[];

(* ============================================================ *)
Print["Part 7: Interesting Properties\n"];
Print["===============================\n"];

Print["Product telescope property:"];
Print["If f(i,k) is ratio c[i]/c[i-1], then product gives coefficient:"];
Print["  c[n] = c[1] · ∏[i=2 to n] f(i,k)"];
Print[];

Print["Verification for k=4, n=4:"];
kval = 4;
c1 = kval*(kval+1)/2;
product = c1;
Do[
  product = product * f[i, kval];
, {i, 2, 4}];
Print["  c[1] = ", c1];
Print["  c[4] = c[1] · f(2,4) · f(3,4) · f(4,4)"];
Print["       = ", N[c1], " · ", N[f[2,4]], " · ", N[f[3,4]], " · ", N[f[4,4]];
Print["       = ", N[product]];

(* Expected value from factorial formula *)
c4_factorial = 2^3 * Factorial[8] / (Factorial[0] * Factorial[8]);
Print["  Expected (factorial): 2³·8!/8! = ", c4_factorial];
Print["  Match: ", Abs[product - c4_factorial] < 10^-10];
Print[];

(* ============================================================ *)
Print["Part 8: Contour Plot Analysis\n"];
Print["==============================\n"];

Print["For continuous extension, analyze level curves f(i,k) = const"];
Print[];

Print["Sample level curves:"];
levels = {0.5, 1, 2, 3, 5, 10};
Do[
  Print["f(i,k) = ", level, ":"];
  (* Solve for k as function of i *)
  kSol = Solve[f[i, k] == level && k > 0, k, Reals];
  If[Length[kSol] > 0,
    Print["  k(i) = ", k /. kSol[[1]]];
  ,
    Print["  No simple closed form"];
  ];
, {level, levels}];
Print[];

(* ============================================================ *)
Print["Part 9: Summary of Key Properties\n"];
Print["==================================\n"];

Print["✓ Diagonal formula: f(k,k) = 2/(2k-1) → 0 as k→∞"];
Print["✓ Monotonie v i: Klesající pro fixní k (pro i ≥ 2)"];
Print["✓ Monotonie v k: Rostoucí pro fixní i (pro k ≥ i)"];
Print["✓ Asymptotika: f(i,k) ≈ (k²-i²)/(2i²) pro velká i,k"];
Print["✓ Telescope product dává koeficienty polynomial"];
Print["✓ f(2,k) je maximum v i pro dané k"];
Print[];

Print["=== HOTOVO ==="];
