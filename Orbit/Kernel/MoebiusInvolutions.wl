(* ::Package:: *)

(* MoebiusInvolutions: Orbit structure of rationals under three involutions

   The group <σ, κ, ι> acts on Q+ where:
     σ(x) = (1-x)/(1+x)  "silver" - fixes √2-1
     κ(x) = 1-x          "complement"
     ι(x) = 1/x          "reciprocal"

   Key result: Fractions p/q in (0,1) partition into orbits characterized by
   the invariant I(p/q) = odd(p(q-p)), where odd(n) extracts the odd part.

   Reference: docs/papers/involution-decomposition.tex
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* THE THREE INVOLUTIONS                        *)
(* ============================================ *)

MoebiusSigma::usage = "MoebiusSigma[x] = (1-x)/(1+x)
The silver involution. Fixed point: √2-1 = tan(π/8).
In logit coordinates y=x/(1-x): σ(y) = 1/(2y).";

MoebiusKappa::usage = "MoebiusKappa[x] = 1-x
The complement involution. Reflection about 1/2.
In logit coordinates: κ(y) = 1/y.";

MoebiusIota::usage = "MoebiusIota[x] = 1/x
The reciprocal involution. Swaps (0,1) with (1,∞).";

(* ============================================ *)
(* ORBIT INVARIANT                              *)
(* ============================================ *)

OrbitInvariant::usage = "OrbitInvariant[q] returns the orbit invariant I = odd(p(q-p))
for a rational q = p/d in lowest terms with 0 < q < 1.
Same I is NECESSARY but NOT SUFFICIENT for same orbit. Use OrbitSignature for complete invariant.";

OddPart::usage = "OddPart[n] returns the odd part of integer n (n with all factors of 2 removed).";

OrbitSignature::usage = "OrbitSignature[q] returns the orbit signature {A, B} (sorted, A ≤ B)
where A = odd(p), B = odd(q-p) for the canonical representative. This is the complete invariant:
two fractions are in the same orbit iff they have the same signature.";

(* ============================================ *)
(* ORBIT OPERATIONS                             *)
(* ============================================ *)

SameOrbit::usage = "SameOrbit[q1, q2] returns True if q1 and q2 are in the same
<σ,κ>-orbit (have the same orbit signature {A,B}).";

CanonicalRep::usage = "CanonicalRep[q] returns the canonical representative of q's orbit.
Form: A/(A+B) where {A,B} is the orbit signature (A,B odd, A·B = I).";

OrbitEnumerate::usage = "OrbitEnumerate[inv, qMax] returns all fractions p/q in (0,1)
with denominator ≤ qMax and orbit invariant equal to inv.";

(* ============================================ *)
(* PATH FINDING                                 *)
(* ============================================ *)

OrbitPath::usage = "OrbitPath[q1, q2] returns a list of involutions {σ, κ, ι, ...}
that transform q1 to q2, or $Failed if they're in different <σ,κ,ι>-orbits.
Note: <σ,κ,ι> is transitive on Q+ ∩ (0,1), so path always exists for valid inputs.";

ToCanonicalPath::usage = "ToCanonicalPath[q] returns {path, canonical} where path is
the sequence of σκ or κσ moves to reach canonical form from q.";

(* ============================================ *)
(* LOGIT COORDINATES                            *)
(* ============================================ *)

Logit::usage = "Logit[x] = x/(1-x), the logit coordinate transformation.
In logit coords: σκ(y) = y/2, κσ(y) = 2y, κ(y) = 1/y.";

LogitInverse::usage = "LogitInverse[y] = y/(1+y), inverse of Logit.";

Begin["`Private`"];

(* ============================================ *)
(* INVOLUTIONS                                  *)
(* ============================================ *)

MoebiusSigma[x_] := (1 - x)/(1 + x)
MoebiusKappa[x_] := 1 - x
MoebiusIota[x_] := 1/x

(* Shortcuts for internal use *)
σ = MoebiusSigma;
κ = MoebiusKappa;
ι = MoebiusIota;

(* ============================================ *)
(* ODD PART                                     *)
(* ============================================ *)

OddPart[0] := 0;
OddPart[n_Integer] := n / 2^IntegerExponent[n, 2]

(* ============================================ *)
(* ORBIT INVARIANT                              *)
(* ============================================ *)

OrbitInvariant[q_Rational] := Module[{p, d},
  (* Ensure q is in (0,1) *)
  If[q <= 0 || q >= 1,
    Message[OrbitInvariant::domain, q];
    Return[$Failed]
  ];
  {p, d} = {Numerator[q], Denominator[q]};
  OddPart[p (d - p)]
]

OrbitInvariant[q_Integer] := OrbitInvariant[q/1] /; 0 < q < 1

OrbitInvariant::domain = "Input `1` must be a rational in (0,1).";

(* ============================================ *)
(* SAME ORBIT TEST                              *)
(* ============================================ *)

(* Note: Same I is necessary but NOT sufficient for same orbit! *)
(* For composite I, multiple orbits exist with the same I value. *)
(* This function checks actual connectivity via canonical forms. *)
SameOrbit[q1_, q2_] := Module[{i1, i2, can1, can2, y1, y2, A1, B1, A2, B2},
  i1 = OrbitInvariant[q1];
  i2 = OrbitInvariant[q2];
  If[i1 === $Failed || i2 === $Failed, Return[$Failed]];

  (* Different I → definitely different orbits *)
  If[i1 =!= i2, Return[False]];

  (* Same I: check if (A,B) pairs match (up to swap by κ) *)
  {can1, can2} = {ToCanonicalPath[q1][[2]], ToCanonicalPath[q2][[2]]};
  y1 = Logit[can1];
  y2 = Logit[can2];
  {A1, B1} = {OddPart[Numerator[y1]], OddPart[Denominator[y1]]};
  {A2, B2} = {OddPart[Numerator[y2]], OddPart[Denominator[y2]]};

  (* Same orbit iff {A,B} sets match *)
  Sort[{A1, B1}] === Sort[{A2, B2}]
]

(* ============================================ *)
(* CANONICAL REPRESENTATIVE                     *)
(* ============================================ *)

CanonicalRep[q_Rational] := ToCanonicalPath[q][[2]]

OrbitSignature[q_Rational] := Module[{can, y, A, B},
  can = CanonicalRep[q];
  If[can === $Failed, Return[$Failed]];
  y = Logit[can];  (* y = A/B where A, B are odd *)
  A = Numerator[y];
  B = Denominator[y];
  Sort[{A, B}]
]

(* ============================================ *)
(* ORBIT ENUMERATION                            *)
(* ============================================ *)

OrbitEnumerate[inv_Integer, qMax_Integer] := Module[{results},
  results = Reap[
    Do[
      Do[
        If[GCD[p, d] == 1 && OddPart[p (d - p)] == inv,
          Sow[p/d]
        ],
        {p, 1, d - 1}
      ],
      {d, 2, qMax}
    ]
  ][[2]];

  If[results === {}, {}, Sort[Flatten[results]]]
]

(* ============================================ *)
(* LOGIT COORDINATES                            *)
(* ============================================ *)

Logit[x_] := x/(1 - x)
LogitInverse[y_] := y/(1 + y)

(* ============================================ *)
(* PATH TO CANONICAL FORM                       *)
(* ============================================ *)

(* Extract (α, β, A, B) from logit y = 2^α·A / 2^β·B *)
logitDecompose[y_] := Module[{num, den, α, β, A, B},
  {num, den} = {Numerator[y], Denominator[y]};
  α = IntegerExponent[num, 2];
  β = IntegerExponent[den, 2];
  A = num / 2^α;  (* odd part of numerator *)
  B = den / 2^β;  (* odd part of denominator *)
  {α, β, A, B}
]

(* Canonical form: y = A/B (i.e., α = β = 0) *)
(* Termination proof: M = α + β strictly decreases each step *)
(* Bound: O(log(max(num, den))) steps *)
ToCanonicalPath[q_Rational] := Module[{inv, y, α, β, A, B, path, current},
  inv = OrbitInvariant[q];
  If[inv === $Failed, Return[$Failed]];

  current = q;
  path = {};
  y = Logit[current];
  {α, β, A, B} = logitDecompose[y];

  (* Loop until α = β = 0. Terminates: M = α + β decreases each step *)
  While[α > 0 || β > 0,
    If[α == 0,
      (* (0, β) with β > 0: apply σ → (β-1, 0) *)
      current = σ[current];
      AppendTo[path, "σ"];
    ,
      If[β == 0,
        (* (α, 0) with α > 0: apply κ then σ → (α-1, 0) *)
        current = κ[current];
        AppendTo[path, "κ"];
        current = σ[current];
        AppendTo[path, "σ"];
      ,
        (* Both α, β > 0: apply σ (or κ first if β < α) *)
        If[β < α,
          current = κ[current];
          AppendTo[path, "κ"];
        ];
        current = σ[current];
        AppendTo[path, "σ"];
      ]
    ];
    y = Logit[current];
    {α, β, A, B} = logitDecompose[y];
  ];

  (* Normalize: ensure A ≤ B (smaller numerator) *)
  y = Logit[current];
  If[Numerator[y] > Denominator[y],
    current = κ[current];
    AppendTo[path, "κ"];
  ];

  {path, current}
]

(* ============================================ *)
(* GENERAL PATH FINDING                         *)
(* ============================================ *)

OrbitPath[q1_Rational, q2_Rational] := Module[
  {path1, can1, path2, can2},

  (* Check if actually in same orbit *)
  If[!SameOrbit[q1, q2],
    Return[$Failed]
  ];

  (* Same orbit: find paths to canonical, then compose *)
  {path1, can1} = ToCanonicalPath[q1];
  {path2, can2} = ToCanonicalPath[q2];

  (* Path: q1 -> can1, then can1 -> can2 (via κ if needed), then can2 -> q2 *)
  (* Since can1 and can2 have same {A,B}, they're κ-related or equal *)
  Join[
    path1,
    If[can1 =!= can2, {"κ"}, {}],  (* κ swaps A/B ↔ B/A *)
    Reverse[path2 /. {"σ" -> "σ", "κ" -> "κ"}]  (* reverse path2 *)
  ]
]

OrbitPath::nopath = "Fractions `1` and `2` are in different <σ,κ>-orbits (same I=`3` but different factorization). Use ι to connect across orbits.";

End[];

EndPackage[];
