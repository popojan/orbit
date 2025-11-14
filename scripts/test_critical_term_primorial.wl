#!/usr/bin/env wolframscript
(* Test if critical term dominates in primorial formula *)

Print["Testing Critical Term Dominance in Primorial Formula\n"]
Print[StringRepeat["=", 70], "\n"]

TestCriticalTerm[m_] := Module[{k, h, D, N, L, criticalTerm, otherTerms,
                                 halfFactSq, wilsonPred},
  If[!PrimeQ[m], Return["Skipping composite ", m]]

  k = (m-1)/2
  h = k

  (* Compute unreduced numerator and denominator *)
  D = 2 * Product[2*j+1, {j, 1, k}]
  N = Sum[(-1)^j * j! * D/(2*j+1), {j, 1, k}]

  Print["m = ", m, " (prime), k = h = ", k]
  Print["Unreduced: N/D where D = ", D]
  Print["  D contains m at position 2k+1 = ", 2*k+1, " = m"]

  (* Check if D/m is coprime to m *)
  L = D/m
  Print["  L = D/m = ", L]
  Print["  gcd(L,m) = ", GCD[L,m], " (should be 1)"]

  (* Critical term: j=h gives denominator m *)
  criticalTerm = (-1)^h * h! * L
  Print["\nCritical term (j=h): (-1)^h · h! · L"]
  Print["  = ", (-1)^h, " · ", h!, " · ", L]
  Print["  = ", criticalTerm]

  (* Other terms should be ≡ 0 (mod m) since they have factor m *)
  otherTerms = Sum[(-1)^j * j! * D/(2*j+1), {j, 1, k-1}]
  Print["\nOther terms (j<h): sum = ", otherTerms]
  Print["  sum mod m = ", Mod[otherTerms, m], " (should be 0)"]

  (* Check N ≡ critical term (mod m) *)
  Print["\nFull numerator N = ", N]
  Print["  N mod m = ", Mod[N, m]]
  Print["  Critical term mod m = ", Mod[criticalTerm, m]]
  Print["  Match? ", Mod[N, m] == Mod[criticalTerm, m]]

  (* Wilson's theorem: (h!)² ≡ (-1)^((m+1)/2) (mod m) *)
  halfFactSq = Mod[h!^2, m]
  wilsonPred = Mod[(-1)^((m+1)/2), m]
  Print["\nWilson half-factorial check:"]
  Print["  (h!)² mod m = ", halfFactSq]
  Print["  (-1)^((m+1)/2) mod m = ", wilsonPred]
  Print["  Match? ", halfFactSq == wilsonPred]

  (* Now the key: what is N · (m-1)! / primorial(m) ? *)
  primorial = Product[Prime[i], {i, 1, PrimePi[m]}]
  reduced = primorial/2  (* This is B_m *)

  Print["\nReduced form:"]
  sum = Sum[(-1)^k * k!/(2*k+1), {k, 1, h}]/2
  A = Numerator[sum]
  B = Denominator[sum]
  Print["  A/B = ", A, "/", B]
  Print["  B = primorial/2? ", B == primorial/2]

  (* Compute A · (m-1)! / B *)
  quotient = A * Factorial[m-1] / B
  Print["\nTesting mod operation:"]
  Print["  A · (m-1)! / B = ", quotient]
  Print["  Floor = ", Floor[quotient]]
  Print["  Is integer? ", IntegerQ[quotient]]

  If[!IntegerQ[quotient],
    remainder = quotient - Floor[quotient]
    Print["  Remainder = ", remainder]
    Print["  Numerator of remainder = ", Numerator[remainder]]
    Print["  Denominator of remainder = ", Denominator[remainder]]
    Print["  Numerator = 1? ", Numerator[remainder] == 1]
    Print["  m divides denominator? ", Divisible[Denominator[remainder], m]]
  ]

  Print["\n", StringRepeat["-", 70], "\n"]
]

(* Test several primes *)
primes = {3, 5, 7, 11, 13, 17, 19, 23, 29, 31}

Do[TestCriticalTerm[p], {p, primes}]

Print[StringRepeat["=", 70]]
Print["CONCLUSION:\n"]
Print["If the pattern holds, N ≡ (-1)^h · h! · L (mod m) for all primes,"]
Print["matching the structure from the semiprime proof!"]
