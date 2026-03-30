(* ::Package:: *)

(* GoldilocksEncoding.wl *)
(* Dual-stream encoding with near-uniform distribution *)
(* Authors: Jan Popelka, Claude Sonnet 4.5 *)
(* Date: January 10-15, 2026 *)

BeginPackage["Orbit`"];

(* Public symbols *)
GoldilocksParameters::usage =
  "GoldilocksParameters[k, δ, p] computes m = kp - 1 + δ where δ ∈ {-1, +1}.
GoldilocksParameters[k, δ, predicate] finds p values where predicate[kp - 1 + δ] is True.
Options: \"MaxResults\" -> n (default 1), \"SearchRange\" -> max (default 1000).";

GoldilocksEncoder::usage =
  "GoldilocksEncoder[modulus] returns a function that encodes {position, residue} → n.
Valid modulus: either p or k from GoldilocksParameters (not arbitrary values).
Example: enc = GoldilocksEncoder[3]; enc[{2, 1}] → 7";

GoldilocksDecoder::usage =
  "GoldilocksDecoder[modulus] returns a function that decodes n → {position, residue}.
Valid modulus: either p or k from GoldilocksParameters (not arbitrary values).
Uses QuotientRemainder[n, modulus] so residue ∈ [0, modulus-1].
Example: dec = GoldilocksDecoder[3]; dec[7] → {2, 1}";

GoldilocksAnalyze::usage =
  "GoldilocksAnalyze[{m, p}] returns detailed analysis of the encoding parameters.";

IsGoldilocks::usage =
  "IsGoldilocks[{m, p}] returns True if {m, p} satisfies the Goldilocks condition \
(m+1) ≡ ±1 (mod p), i.e., exactly one residue class differs by ±1.";

Begin["`Private`"];

(* Core predicate: does {m, p} satisfy Goldilocks condition? *)
IsGoldilocks[{m_Integer, p_Integer}] /; p >= 2 :=
  With[{r = Mod[m + 1, p]},
    r == 1 || r == p - 1
  ]

(* Options for GoldilocksParameters *)
Options[GoldilocksParameters] = {
  "MaxResults" -> 1,
  "SearchRange" -> 1000
};

(* Direct computation: given k, δ, p → compute m *)
GoldilocksParameters[k_Integer, δ:(-1|1), p_Integer] /; k >= 1 && p >= 2 :=
  k * p - 1 + δ

(* Search for p satisfying predicate *)
GoldilocksParameters[k_Integer, δ:(-1|1), predicate_, opts:OptionsPattern[]] /; k >= 1 :=
  Module[{maxResults, searchRange, results, p, m},
    maxResults = OptionValue["MaxResults"];
    searchRange = OptionValue["SearchRange"];

    results = {};
    p = 2;

    While[p <= searchRange && (maxResults === All || Length[results] < maxResults),
      m = k * p - 1 + δ;
      If[predicate[m],
        AppendTo[results, {m, p}]
      ];
      p++
    ];

    (* Return format depends on MaxResults *)
    If[maxResults === 1 && Length[results] > 0,
      First[results],  (* Single result: {m, p} *)
      results          (* Multiple or All: {{m1,p1}, {m2,p2}, ...} *)
    ]
  ]

(* Encoder: curry function returning encoder with fixed modulus *)
GoldilocksEncoder[modulus_Integer] /; modulus >= 2 :=
  Function[positionResidue,
    modulus * First[positionResidue] + Last[positionResidue]
  ]

(* Decoder: curry function returning decoder with fixed modulus *)
GoldilocksDecoder[modulus_Integer] /; modulus >= 2 :=
  Function[n,
    QuotientRemainder[n, modulus]
  ]

(* Detailed analysis *)
GoldilocksAnalyze[{m_Integer, p_Integer}] /; m >= p >= 2 := Module[
  {counts, sd, isGold, structure, kHigh, kLow, nHigh, nLow},

  counts = Last /@ Tally[Mod[Range[0, m], p]];
  sd = StandardDeviation[counts];
  isGold = IsGoldilocks[{m, p}];

  (* Determine structure from actual counts *)
  {kLow, kHigh} = MinMax[counts];
  nHigh = Count[counts, kHigh];
  nLow = Count[counts, kLow];

  structure = If[isGold,
    If[kHigh == kLow,
      "All " <> ToString[p] <> " classes have " <> ToString[kHigh],
      ToString[nLow] <> " class(es) have " <> ToString[kLow] <>
        ", " <> ToString[nHigh] <> " have " <> ToString[kHigh]
    ],
    "Multiple count values (not Goldilocks)"
  ];

  <|
    "m" -> m,
    "p" -> p,
    "states" -> m + 1,
    "k" -> kHigh,  (* The majority count *)
    "distribution" -> counts,
    "SD" -> sd,
    "expectedSD" -> 1/Sqrt[p],
    "isGoldilocks" -> isGold,
    "structure" -> structure,
    "entropyStream1" -> N[Log2[p]],
    "entropyStream2" -> N[Log2[(m + 1)/p]],
    "totalEntropy" -> N[Log2[m + 1]],
    "efficiency" -> N[100 * (Log2[p] + Log2[(m + 1)/p]) / Log2[m + 1]]
  |>
]

End[];
EndPackage[];
