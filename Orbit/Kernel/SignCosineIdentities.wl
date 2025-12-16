(* ::Package:: *)

(* Sign-Cosine Identities and Class Number Connections *)
(* Implements the sign-cosine sums A(p) and W(p) and their relation to *)
(* class numbers of imaginary quadratic fields Q(Sqrt[-p]) *)

BeginPackage["Orbit`"];

(* Usage messages *)
SignCosineA::usage = "SignCosineA[p] computes the sum A(p) = Sum[Sign[Cos[(2k-1)Pi/p]], {k, 1, p-1}] for odd prime p. Returns -2 if p == 1 (mod 4), 0 if p == 3 (mod 4).";

SignCosineW::usage = "SignCosineW[p] computes the character-weighted sum W(p) = Sum[JacobiSymbol[k,p] * Sign[Cos[(2k-1)Pi/p]], {k, 1, p-1}] for odd prime p. Equals 2*h(-p) - 2 for p == 1 (mod 4) and 2 for p == 3 (mod 4), where h(-p) is the class number.";

SignCosinePartition::usage = "SignCosinePartition[p] returns an Association with counts of quadratic residues and non-residues in each sign region: \"QR+\" (QR with sign +1), \"QR-\" (QR with sign -1), \"NQR+\", \"NQR-\".";

SignCosineVerifyIdentities::usage = "SignCosineVerifyIdentities[p] verifies the identities connecting A(p), W(p), h(-p), and the partition counts. Returns Association with computed values and identity verification.";

SignCosineTable::usage = "SignCosineTable[pmax] generates a table of sign-cosine values and class numbers for primes up to pmax.";

LissajousClassSum::usage = "LissajousClassSum[p] computes Sum[chi(x) * sign(cos((2k-1)Pi/p))] where k = p - ModularInverse[x,p]. For p == 1 (mod 4), this equals W(p) = 2h(-p) - 2. For p == 3 (mod 4), equals -2.";

LissajousClosestCrossing::usage = "LissajousClosestCrossing[x, y] returns {k, x_coord} for the Lissajous x-axis crossing closest to origin, where k = y - ModularInverse[x, y].";

LissajousVerify::usage = "LissajousVerify[p] verifies that LissajousClassSum[p] == chi(-1) * W(p).";

Begin["`Private`"];

(* Sign of cosine at odd multiples of Pi/p *)
signCos[k_, p_] := Sign[Cos[Pi/p (2 k - 1)]];

(* Unweighted sum: A(p) = Sum[sign(cos((2k-1)Pi/p)), k=1..p-1] *)
SignCosineA[p_?PrimeQ] /; p > 2 := Sum[signCos[k, p], {k, 1, p - 1}];

(* Character-weighted sum: W(p) = Sum[chi(k) * sign(cos), k=1..p-1] *)
SignCosineW[p_?PrimeQ] /; p > 2 := Sum[
  JacobiSymbol[k, p] signCos[k, p],
  {k, 1, p - 1}
];

(* Partition counts: classify each k by (chi(k), sign(k)) *)
SignCosinePartition[p_?PrimeQ] /; p > 2 := Module[{data, counts},
  data = Table[
    {JacobiSymbol[k, p], signCos[k, p]},
    {k, 1, p - 1}
  ];
  counts = Counts[data];
  <|
    "QR+" -> Lookup[counts, Key[{1, 1}], 0],
    "QR-" -> Lookup[counts, Key[{1, -1}], 0],
    "NQR+" -> Lookup[counts, Key[{-1, 1}], 0],
    "NQR-" -> Lookup[counts, Key[{-1, -1}], 0]
  |>
];

(* Class number of Q(Sqrt[-p]) *)
classNumber[p_?PrimeQ] := NumberFieldClassNumber[Sqrt[-p]];

(* Verify all identities *)
SignCosineVerifyIdentities[p_?PrimeQ] /; p > 2 := Module[
  {a, w, h, part, id1, id2a, id2b, idA, idW},

  a = SignCosineA[p];
  w = SignCosineW[p];
  h = classNumber[p];
  part = SignCosinePartition[p];

  (* Main identity: W = 2 - A*(h - 2) *)
  id1 = w == 2 - a (h - 2);

  (* Partition identities *)
  id2a = (a + w)/2 == part["QR+"] - part["QR-"];
  id2b = (a - w)/2 == part["NQR+"] - part["NQR-"];

  (* Closed forms for A and W *)
  idA = If[Mod[p, 4] == 1,
    a == -2,
    a == 0
  ];

  idW = If[Mod[p, 4] == 1,
    w == 2 h - 2,
    w == 2
  ];

  <|
    "p" -> p,
    "p mod 4" -> Mod[p, 4],
    "A(p)" -> a,
    "W(p)" -> w,
    "h(-p)" -> h,
    "Partition" -> part,
    "Identities" -> <|
      "W = 2 - A*(h-2)" -> id1,
      "(A+W)/2 = QR+ - QR-" -> id2a,
      "(A-W)/2 = NQR+ - NQR-" -> id2b,
      "A closed form" -> idA,
      "W closed form" -> idW
    |>,
    "AllValid" -> And[id1, id2a, id2b, idA, idW]
  |>
];

(* Generate table for multiple primes *)
SignCosineTable[pmax_Integer] := Module[{primes},
  primes = Select[Range[3, pmax], PrimeQ];
  Dataset[SignCosineVerifyIdentities /@ primes]
];

(* Lissajous connection: closest crossing to origin *)
LissajousClosestCrossing[x_Integer, y_Integer] /; CoprimeQ[x, y] := Module[
  {modInv, k, xCoord},
  modInv = PowerMod[x, -1, y];
  k = y - modInv;
  xCoord = Sin[Pi x k / y];
  {k, N[xCoord]}
];

(* Lissajous sum that equals chi(-1) * W(p) *)
LissajousClassSum[p_?PrimeQ] /; p > 2 := Module[{k},
  Sum[
    k = p - PowerMod[x, -1, p];
    JacobiSymbol[x, p] signCos[k, p],
    {x, 1, p - 1}
  ]
];

(* Verify Lissajous-class number connection *)
LissajousVerify[p_?PrimeQ] /; p > 2 := Module[
  {lSum, w, chiMinus1, expected},
  lSum = LissajousClassSum[p];
  w = SignCosineW[p];
  chiMinus1 = JacobiSymbol[-1, p];
  expected = chiMinus1 * w;
  <|
    "p" -> p,
    "LissajousSum" -> lSum,
    "chi(-1)" -> chiMinus1,
    "W(p)" -> w,
    "chi(-1)*W(p)" -> expected,
    "Match" -> lSum == expected
  |>
];

End[];
EndPackage[];
