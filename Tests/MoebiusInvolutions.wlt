BeginTestSection["MoebiusInvolutions"]

(* ============================================ *)
(* INVOLUTION PROPERTY: f(f(x)) = x             *)
(* ============================================ *)

VerificationTest[
  MoebiusSigma[MoebiusSigma[3/7]],
  3/7,
  TestID -> "Sigma-involution"
]

VerificationTest[
  MoebiusKappa[MoebiusKappa[3/7]],
  3/7,
  TestID -> "Kappa-involution"
]

VerificationTest[
  MoebiusIota[MoebiusIota[3/7]],
  3/7,
  TestID -> "Iota-involution"
]

(* ============================================ *)
(* INVARIANT PRESERVED                          *)
(* ============================================ *)

VerificationTest[
  OrbitInvariant[MoebiusSigma[3/7]],
  OrbitInvariant[3/7],
  TestID -> "Invariant-preserved-sigma"
]

VerificationTest[
  OrbitInvariant[MoebiusKappa[3/7]],
  OrbitInvariant[3/7],
  TestID -> "Invariant-preserved-kappa"
]

(* ============================================ *)
(* SAME ORBIT                                   *)
(* ============================================ *)

VerificationTest[
  SameOrbit[3/7, MoebiusSigma[3/7]],
  True,
  TestID -> "SameOrbit-sigma-related"
]

VerificationTest[
  SameOrbit[1/3, 2/7],
  False,
  TestID -> "SameOrbit-different"
]

(* ============================================ *)
(* CANONICAL REPRESENTATIVE                     *)
(* ============================================ *)

VerificationTest[
  Module[{can = CanonicalRep[3/7]},
    0 < can < 1
  ],
  True,
  TestID -> "CanonicalRep-valid"
]

(* ============================================ *)
(* PATH FINDING                                 *)
(* ============================================ *)

VerificationTest[
  Module[{q1 = 3/7, q2 = MoebiusSigma[MoebiusKappa[3/7]],
          path, result},
    path = OrbitPath[q1, q2];
    result = Fold[
      Switch[#2,
        "σ", MoebiusSigma[#1],
        "κ", MoebiusKappa[#1],
        "ι", MoebiusIota[#1]
      ] &, q1, path];
    result === q2
  ],
  True,
  TestID -> "OrbitPath-reaches-target"
]

(* ============================================ *)
(* UTILITY                                      *)
(* ============================================ *)

VerificationTest[
  OddPart[24],
  3,
  TestID -> "OddPart-24"
]

EndTestSection[]
