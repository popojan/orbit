BeginTestSection["ChebyshevIntegralTheorem"]

(* ============================================ *)
(* POLYGON FUNCTION DEFINITION                  *)
(* ============================================ *)

VerificationTest[
  ChebyshevPolygonFunction[x, 3] // Expand,
  (ChebyshevT[4, x] - x ChebyshevT[3, x]) // Expand,
  TestID -> "PolygonFunction-def-k3"
]

(* ============================================ *)
(* LOBE AREA SUM = 1 (PROVEN THEOREM)           *)
(* ============================================ *)

VerificationTest[
  Sum[ChebyshevLobeArea[4, k], {k, 1, 4}],
  1,
  TestID -> "LobeAreaSum-n4"
]

VerificationTest[
  Sum[ChebyshevLobeArea[7, k], {k, 1, 7}] // FullSimplify,
  1,
  TestID -> "LobeAreaSum-n7"
]

VerificationTest[
  Sum[ChebyshevLobeArea[12, k], {k, 1, 12}] // Simplify,
  1,
  TestID -> "LobeAreaSum-n12"
]

(* ============================================ *)
(* KNOWN LOBE AREAS                             *)
(* ============================================ *)

VerificationTest[
  Table[ChebyshevLobeArea[4, k], {k, 1, 4}],
  {1/12, 5/12, 5/12, 1/12},
  TestID -> "LobeAreas-n4-known"
]

(* ============================================ *)
(* CLOSED FORM vs NUMERIC INTEGRAL              *)
(* ============================================ *)

(* Symbolic integral: (-1)^(n-k) * ∫ Sin[n θ] Sin[θ]^2 dθ *)
VerificationTest[
  Module[{closedForm, symbolic, n = 5, k = 2},
    closedForm = ChebyshevLobeArea[n, k];
    symbolic = (-1)^(n - k) * Integrate[
      Sin[n t] Sin[t]^2, {t, (n - k) Pi/n, (n - k + 1) Pi/n}
    ];
    FullSimplify[closedForm - symbolic] === 0
  ],
  True,
  TestID -> "LobeArea-vs-Integrate"
]

(* ============================================ *)
(* REFLECTION SYMMETRY                          *)
(* ============================================ *)

VerificationTest[
  ChebyshevLobeArea[7, 2] // Simplify,
  ChebyshevLobeArea[7, 6] // Simplify,
  TestID -> "LobeArea-reflection-symmetry"
]

(* ============================================ *)
(* LOBE CLASSIFICATION                          *)
(* ============================================ *)

VerificationTest[
  ChebyshevLobeClass[7, 1],
  "Universal",
  TestID -> "LobeClass-Universal"
]

VerificationTest[
  ChebyshevLobeClass[7, 3],
  "Primitive",
  TestID -> "LobeClass-Primitive-prime"
]

(* For prime n=7, all interior lobes are Primitive *)
VerificationTest[
  AllTrue[Range[2, 6], ChebyshevLobeClass[7, #] === "Primitive" &],
  True,
  TestID -> "LobeClass-prime-all-interior"
]

EndTestSection[]
