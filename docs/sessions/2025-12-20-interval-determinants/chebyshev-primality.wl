(* Chebyshev-Primality Connection Scripts
   Session: 2025-12-20

   These scripts demonstrate the connection between:
   - Chebyshev polynomials T_n, U_n
   - Lucas sequences V_n, U_n
   - Primality testing (Lucas-Lehmer, Baillie-PSW)
*)

(* ============================================ *)
(* CHEBYSHEV "FERMAT" THEOREM                   *)
(* ============================================ *)

(* For prime p: T_p(a) ≡ a (mod p) *)
(* This is the Chebyshev analog of Fermat's little theorem *)

ChebyshevFermatTest[n_, a_] := Mod[ChebyshevT[n, a], n] == Mod[a, n]

(* Chebyshev pseudoprimes for base a *)
ChebyshevPseudoprimes[a_, max_] :=
  Select[Range[4, max], !PrimeQ[#] && ChebyshevFermatTest[#, a] &]

(* Example: *)
(* ChebyshevPseudoprimes[8, 1000] *)
(* {9, 21, 35, 63, 85, 119, 253, 323, 385, 595, 665, 805, 889, 935} *)

(* Fermat pseudoprimes (for comparison) *)
FermatPseudoprimes[a_, max_] :=
  Select[Range[4, max], !PrimeQ[#] && PowerMod[a, # - 1, #] == 1 &]

(* Key finding: Chebyshev and Fermat pseudoprimes are DISJOINT *)
(* Intersection[ChebyshevPseudoprimes[8, 1000], FermatPseudoprimes[2, 1000]] = {} *)

(* ============================================ *)
(* LUCAS-LEHMER = CHEBYSHEV ITERATION           *)
(* ============================================ *)

(* Lucas-Lehmer sequence: S_n = S_{n-1}² - 2, S_0 = 4 *)
(* This is exactly: S_n = 2 × T_{2^n}(2) *)

(* Proof: T_2(x) = 2x² - 1, so 2×T_2(x/2) = x² - 2 *)

LucasLehmerSequence[n_] := NestList[#^2 - 2 &, 4, n]

(* Verify equivalence to Chebyshev *)
LucasLehmerViaChebyshev[n_] := Table[2 ChebyshevT[2^k, 2], {k, 0, n}]

(* Lucas-Lehmer test for Mersenne M_p = 2^p - 1 *)
LucasLehmerTest[p_] := Module[{Mp = 2^p - 1, s = 4},
  Do[s = Mod[s^2 - 2, Mp], {p - 2}];
  s == 0
]

(* Trig interpretation: S_n = 2 cos(2^n θ) where θ = arccos(2) *)
(* Test asks if 2^{p-2} θ reaches zero of cosine (mod M_p) *)

(* ============================================ *)
(* LUCAS SEQUENCES = GENERALIZED CHEBYSHEV      *)
(* ============================================ *)

(* Lucas V_n(P, Q) and U_n(P, Q) *)
LucasV[0, P_, Q_] := 2
LucasV[1, P_, Q_] := P
LucasV[n_, P_, Q_] := P LucasV[n-1, P, Q] - Q LucasV[n-2, P, Q]

LucasU[0, P_, Q_] := 0
LucasU[1, P_, Q_] := 1
LucasU[n_, P_, Q_] := P LucasU[n-1, P, Q] - Q LucasU[n-2, P, Q]

(* KEY RELATIONSHIP (when Q = 1):
   V_n(2x, 1) = 2 T_n(x)     (Chebyshev 1st kind)
   U_n(2x, 1) = U_{n-1}(x)   (Chebyshev 2nd kind)
*)

(* Trig form (when Q = 1, P = 2 cos θ):
   V_n = 2 cos(n θ)
   U_n = sin(n θ) / sin(θ)
*)

(* ============================================ *)
(* BAILLIE-PSW TEST                             *)
(* ============================================ *)

(* The practical standard for primality testing combines:
   1. Fermat test (base 2)
   2. Lucas test with D chosen so Jacobi(D|n) = -1

   NO composite has ever been found that passes both!
*)

(* Find D for Lucas test *)
FindLucasD[n_] := Module[{D = 5},
  While[JacobiSymbol[D, n] != -1,
    D = If[D > 0, -D - 2, -D + 2]
  ];
  D
]

(* Lucas U test: U_{n+1} ≡ 0 (mod n) *)
LucasUTest[n_] := Module[{D, P, Q, u0, u1, u, k},
  D = FindLucasD[n];
  P = 1; Q = (1 - D)/4;
  u0 = 0; u1 = 1;
  Do[
    u = Mod[P u1 - Q u0, n];
    u0 = u1; u1 = u,
    {k, 2, n + 1}
  ];
  u1 == 0
]

(* Combined Baillie-PSW *)
BailliePSW[n_] := And[
  n > 1,
  PowerMod[2, n - 1, n] == 1,  (* Fermat base 2 *)
  LucasUTest[n]                 (* Lucas test *)
]

(* ============================================ *)
(* FAST CHEBYSHEV MOD n                         *)
(* ============================================ *)

(* Matrix multiplication mod m *)
MatMulMod[a_, b_, m_] := Mod[a . b, m]

(* Matrix power mod m via binary exponentiation - O(log n) *)
MatPowMod[mat_, n_, m_] := Module[{result, base, k},
  result = IdentityMatrix[2];
  base = Mod[mat, m];
  k = n;
  While[k > 0,
    If[OddQ[k], result = MatMulMod[result, base, m]];
    base = MatMulMod[base, base, m];
    k = Quotient[k, 2]
  ];
  result
]

(* T_n(a) mod m in O(log n) time *)
FastChebyshevTMod[n_, a_, m_] := Module[{mat, result},
  If[n == 0, Return[Mod[1, m]]];
  If[n == 1, Return[Mod[a, m]]];
  mat = {{Mod[2 a, m], Mod[-1, m]}, {1, 0}};
  result = MatPowMod[mat, n - 1, m];
  Mod[a result[[1, 1]] + result[[1, 2]], m]
]

(* ============================================ *)
(* VERIFICATION                                  *)
(* ============================================ *)

VerifyLucasChebyshev[] := Module[{},
  Print["=== Verifying Lucas-Chebyshev connection ==="];

  (* V_n(2x, 1) = 2 T_n(x) *)
  Print["\nV_n(6, 1) vs 2 T_n(3):"];
  Print[Table[{n, LucasV[n, 6, 1], 2 ChebyshevT[n, 3]}, {n, 0, 6}] // TableForm];

  (* Lucas-Lehmer = Chebyshev *)
  Print["\nLucas-Lehmer vs Chebyshev:"];
  Print["S_n: ", LucasLehmerSequence[5]];
  Print["2T_{2^n}(2): ", LucasLehmerViaChebyshev[5]];

  (* Disjoint pseudoprimes *)
  Print["\nPseudoprimes < 1000:"];
  Print["Chebyshev(8): ", ChebyshevPseudoprimes[8, 1000]];
  Print["Fermat(2): ", FermatPseudoprimes[2, 1000]];
  Print["Intersection: ", Intersection[ChebyshevPseudoprimes[8, 1000], FermatPseudoprimes[2, 1000]]];
]

(* Run with: VerifyLucasChebyshev[] *)
