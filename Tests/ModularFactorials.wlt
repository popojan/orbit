BeginTestSection["ModularFactorials"]

(* ============================================ *)
(* FactorialMod vs BUILT-IN                     *)
(* ============================================ *)

VerificationTest[
  FactorialMod[5, 7],
  Mod[5!, 7],
  TestID -> "FactorialMod-5-7"
]

VerificationTest[
  FactorialMod[9, 11],
  Mod[9!, 11],
  TestID -> "FactorialMod-9-11"
]

VerificationTest[
  FactorialMod[20, 23],
  Mod[20!, 23],
  TestID -> "FactorialMod-20-23"
]

(* ============================================ *)
(* WILSON'S THEOREM                             *)
(* ============================================ *)

VerificationTest[
  WilsonFactorialMod[6, 7],
  Mod[-1, 7],
  TestID -> "Wilson-p-1-factorial"
]

VerificationTest[
  WilsonFactorialMod[5, 7],
  Mod[5!, 7],
  TestID -> "WilsonFactorialMod-5-7"
]

VerificationTest[
  WilsonFactorialMod[9, 11],
  Mod[9!, 11],
  TestID -> "WilsonFactorialMod-9-11"
]

(* ============================================ *)
(* FastFactorialMod vs BUILT-IN                 *)
(* ============================================ *)

VerificationTest[
  FastFactorialMod[5, 7],
  Mod[5!, 7],
  TestID -> "FastFactorialMod-5-7"
]

VerificationTest[
  FastFactorialMod[20, 23],
  Mod[20!, 23],
  TestID -> "FastFactorialMod-20-23"
]

(* ============================================ *)
(* STICKELBERGER'S THEOREM                      *)
(* ============================================ *)

(* For prime p: ((p-1)/2)!^2 ≡ (-1)^((p+1)/2) (mod p) *)
VerificationTest[
  Module[{p = 7, h},
    h = HalfFactorialMod[p];
    Mod[h^2, p] === Mod[(-1)^((p + 1)/2), p]
  ],
  True,
  TestID -> "HalfFactorial-Stickelberger-p7"
]

VerificationTest[
  Module[{p = 23, h},
    h = HalfFactorialMod[p];
    Mod[h^2, p] === Mod[(-1)^((p + 1)/2), p]
  ],
  True,
  TestID -> "HalfFactorial-Stickelberger-p23"
]

(* ============================================ *)
(* LEGENDRE EXPONENT                            *)
(* ============================================ *)

VerificationTest[
  LegendreExponent[10, 2],
  8,
  TestID -> "Legendre-10-2"
]

(* ============================================ *)
(* FACTORIAL RECOVER                            *)
(* ============================================ *)

VerificationTest[
  FactorialRecover[10],
  10!,
  TestID -> "FactorialRecover-10"
]

EndTestSection[]
