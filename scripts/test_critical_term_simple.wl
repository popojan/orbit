#!/usr/bin/env wolframscript
(* Simple test of critical term dominance *)

Print["Critical Term Test for Primorial Formula\n"]
Print[StringRepeat["=", 70], "\n"]

primes = {3, 5, 7, 11, 13, 17, 19, 23}

Do[
  m = p
  k = (m-1)/2

  (* Unreduced numerator with common denominator *)
  D = 2 * Product[2*j+1, {j, 1, k}]
  N = Sum[(-1)^j * j! * D/(2*j+1), {j, 1, k}]

  (* L = D/m should be coprime to m *)
  L = D/m

  (* Other terms (j < k) should be ≡ 0 (mod m) *)
  otherTerms = Sum[(-1)^j * j! * D/(2*j+1), {j, 1, k-1}]

  (* Critical term at j=k *)
  criticalTerm = (-1)^k * Factorial[k] * L

  Print["m = ", p, " (prime), k = ", k]
  Print["  gcd(L,m) = ", GCD[L,m]]
  Print["  Other terms mod m = ", Mod[otherTerms, m], " (should be 0)"]
  Print["  N mod m = ", Mod[N, m]]
  Print["  Critical term mod m = ", Mod[criticalTerm, m]]
  Print["  Match? ", Mod[N, m] == Mod[criticalTerm, m]]

  (* Wilson check *)
  halfFactSq = Mod[Factorial[k]^2, m]
  wilsonPred = Mod[(-1)^((m+1)/2), m]
  Print["  (k!)² mod m = ", halfFactSq, ", (-1)^((m+1)/2) = ", wilsonPred]
  Print["  Wilson match? ", halfFactSq == wilsonPred]

  Print[]
  ,
  {p, primes}
]

Print[StringRepeat["=", 70]]
Print["Testing the mod (m-1)! operation:\n"]

Do[
  m = p
  k = (m-1)/2

  (* Compute reduced form *)
  sum = Sum[(-1)^j * j!/(2*j+1), {j, 1, k}]/2
  A = Numerator[sum]
  B = Denominator[sum]

  (* Compute A · (m-1)! / B *)
  prod = A * Factorial[m-1]
  quotient = prod / B

  Print["m = ", p]
  Print["  A/B = ", A, "/", B]
  Print["  A · (m-1)! = ", prod]
  Print["  A · (m-1)!/B = ", quotient]
  Print["  Is integer? ", IntegerQ[quotient]]

  If[!IntegerQ[quotient],
    flr = Floor[quotient]
    rem = quotient - flr
    Print["  Floor = ", flr]
    Print["  Remainder = ", rem]
    Print["  Num(remainder) = ", Numerator[rem]]
    Print["  Den(remainder) = ", Denominator[rem]]
    Print["  Num = 1? ", Numerator[rem] == 1]
    Print["  m | Den? ", Divisible[Denominator[rem], m]]
  ]

  Print[]
  ,
  {p, {3, 5, 7, 11, 13}}
]
