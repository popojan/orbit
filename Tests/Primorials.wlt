BeginTestSection["Primorials"]

(* ============================================ *)
(* Primorial0: edge cases and built-in checks   *)
(* ============================================ *)

VerificationTest[
  Primorial0[2],
  2,
  TestID -> "Primorial0-m2-edge"
]

VerificationTest[
  Primorial0[3],
  Times @@ Prime @ Range @ PrimePi[3],
  TestID -> "Primorial0-m3-vs-builtin"
]

VerificationTest[
  Primorial0[7],
  210,
  TestID -> "Primorial0-m7-vs-builtin"
]

VerificationTest[
  Primorial0[13],
  Times @@ Prime @ Range @ PrimePi[13],
  TestID -> "Primorial0-m13-vs-builtin"
]

(* ============================================ *)
(* Sieve method                                 *)
(* ============================================ *)

VerificationTest[
  PrimorialFromState[SieveState[7]],
  210,
  TestID -> "Sieve-m7-vs-builtin"
]

VerificationTest[
  PrimorialFromState[SieveState[11]],
  Times @@ Prime @ Range @ PrimePi[11],
  TestID -> "Sieve-m11-vs-builtin"
]

(* ============================================ *)
(* Cross-method consistency                     *)
(* ============================================ *)

VerificationTest[
  Primorial0[11],
  PrimorialFromState[SieveState[11]],
  TestID -> "Primorial0-vs-Sieve-m11"
]

(* ============================================ *)
(* Batch verification                           *)
(* ============================================ *)

VerificationTest[
  BatchVerifyPrimorial[20]["All match"],
  True,
  TestID -> "BatchVerify-to-20"
]

EndTestSection[]
