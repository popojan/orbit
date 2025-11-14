#!/usr/bin/env wolframscript
(* Verify all claims from the complete semiprime proof *)

Print["Verification of Complete Semiprime Factorization Proof\n"];
Print[StringRepeat["=", 70], "\n"];

VerifyAllClaims[n_] := Module[{p, q, m, i0, D, N, L, A, B, gcd,
                                 h, halfFactSq, wilsonPred, pochProd,
                                 allPass = True},
  {p, q} = FactorInteger[n][[All, 1]];
  m = Floor[(Sqrt[n] - 1)/2];
  i0 = (p-1)/2;
  h = i0;

  Print["n = ", n, " = ", p, " × ", q, "  (m = ", m, ")\n"];

  (* Claim 1: m >= (p-1)/2 *)
  Print["CLAIM 1: m >= (p-1)/2"];
  Print["  m = ", m, ", (p-1)/2 = ", i0];
  Print["  m >= (p-1)/2? ", m >= i0];
  If[m < i0, allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Claim 2: ν_p(D) = 1 (exactly one multiple of p in denominators) *)
  D = LCM @@ Table[2*i+1, {i, 1, m}];
  Print["CLAIM 2: Exactly one denominator divisible by p"];
  Print["  Unreduced D = ", D];
  Print["  ν_p(D) = ", IntegerExponent[D, p], " (should be 1)"];
  If[IntegerExponent[D, p] != 1, allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Claim 3: ν_p(N) = 0 (numerator has no factor of p) *)
  N = Sum[(-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] * D/(2*i+1),
          {i, 1, m}];
  Print["CLAIM 3: Numerator has no factor of p"];
  Print["  Unreduced N = ", N];
  Print["  ν_p(N) = ", IntegerExponent[N, p], " (should be 0)"];
  If[IntegerExponent[N, p] != 0, allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Claim 4: Reduced denominator is p *)
  sum = Sum[(-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] / (2*i+1),
            {i, 1, m}];
  A = Numerator[sum];
  B = Denominator[sum];
  Print["CLAIM 4: Reduced denominator is p"];
  Print["  Reduced: A/B = ", A, "/", B];
  Print["  B = p? ", B == p];
  If[B != p, allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Claim 5: A ≡ (p-1) mod p *)
  Print["CLAIM 5: Reduced numerator A ≡ (p-1) mod p"];
  Print["  A mod p = ", Mod[A, p]];
  Print["  p-1 = ", p-1];
  Print["  A ≡ (p-1) mod p? ", Mod[A, p] == p-1];
  If[Mod[A, p] != p-1, allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Claim 6: Wilson's theorem: ((p-1)/2)!² ≡ (-1)^((p+1)/2) mod p *)
  halfFactSq = Mod[Factorial[h]^2, p];
  wilsonPred = Mod[(-1)^((p+1)/2), p];
  Print["CLAIM 6: Wilson half-factorial formula"];
  Print["  ((p-1)/2)! = ", Factorial[h]];
  Print["  ((p-1)/2)!² mod p = ", halfFactSq];
  Print["  (-1)^((p+1)/2) mod p = ", wilsonPred];
  Print["  Match? ", halfFactSq == wilsonPred];
  If[halfFactSq != wilsonPred, allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Claim 7: Pochhammer products ≡ (h!)² mod p at i=i₀ *)
  pochProd = Pochhammer[1-n, i0] * Pochhammer[1+n, i0];
  Print["CLAIM 7: Pochhammer product ≡ ((p-1)/2)!² mod p"];
  Print["  Poch(1-n,i₀)·Poch(1+n,i₀) mod p = ", Mod[pochProd, p]];
  Print["  ((p-1)/2)!² mod p = ", halfFactSq];
  Print["  Match? ", Mod[pochProd, p] == halfFactSq];
  If[Mod[pochProd, p] != halfFactSq, allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Claim 8: N ≡ -L mod p where D = p·L *)
  gcd = GCD[N, D];
  L = D/p;
  Print["CLAIM 8: N ≡ -L mod p where D = p·L"];
  Print["  gcd(N,D) = ", gcd];
  Print["  L = D/p = ", L];
  Print["  N mod p = ", Mod[N, p]];
  Print["  -L mod p = ", Mod[-L, p]];
  Print["  N ≡ -L mod p? ", Mod[N, p] == Mod[-L, p]];
  If[Mod[N, p] != Mod[-L, p], allPass = False; Print["  ❌ FAILED"]];
  Print[];

  (* Summary *)
  Print[StringRepeat["-", 70]];
  If[allPass,
    Print["✓ ALL CLAIMS VERIFIED for n=", n],
    Print["❌ SOME CLAIMS FAILED for n=", n]
  ];
  Print[StringRepeat["-", 70], "\n"];

  allPass
];

(* Test multiple semiprimes *)
semiprimes = {15, 21, 35, 55, 77, 91, 143, 221};

results = Table[VerifyAllClaims[n], {n, semiprimes}];

Print[StringRepeat["=", 70]];
Print["FINAL SUMMARY\n"];
Print["Tested ", Length[semiprimes], " semiprimes"];
Print["All passed: ", And @@ results];
If[And @@ results,
  Print["\n✓ The complete proof is verified by computational evidence!"],
  Print["\n❌ Some tests failed - proof may need revision"]
];
