(* Pell DNA Database Generator - Hybrid Storage *)
(* Uses raw (x,y) for small solutions, Zeckendorf for large ones *)

fibs = Module[{f = {1, 2}}, While[Last[f] < 10^100, AppendTo[f, f[[-1]] + f[[-2]]]]; f];

zeckendorf[n_Integer] := Module[{result = {}, remaining = n, idx},
  idx = Length[Select[fibs, # <= n &]];
  While[remaining > 0 && idx >= 1,
    If[fibs[[idx]] <= remaining, AppendTo[result, idx]; remaining -= fibs[[idx]]; idx -= 2, idx--]
  ]; result
];

pellFundamental[d_] := Module[{cf, n, p, q},
  If[IntegerQ[Sqrt[d]], Return[{0, 0}]];
  cf = ContinuedFraction[Sqrt[d], 2000];
  For[n = 2, n <= Length[cf], n++,
    {p, q} = {Numerator[#], Denominator[#]} &@ FromContinuedFraction[Take[cf, n]];
    If[p^2 - d*q^2 == 1, Return[{p, q}]];
    If[p^2 - d*q^2 == -1, Return[{p^2 + d*q^2, 2*p*q}]];
  ];
  {0, 0}
];

cfPeriod[d_] := Module[{cf},
  If[IntegerQ[Sqrt[d]], Return[0]];
  cf = ContinuedFraction[Sqrt[d]];
  If[ListQ[cf] && Length[cf] >= 2 && ListQ[cf[[2]]], Length[cf[[2]]], 0]
];

(* Estimate bits for storage *)
rawBits[x_, y_] := Ceiling[Log2[x + 1]] + Ceiling[Log2[y + 1]];
zeckBits[zeck_] := If[Length[zeck] > 0, Length[zeck] * Ceiling[Log2[Max[zeck] + 1]], 999];

(* Generate entries *)
maxD = 10000;  (* Start with 10000, adjust based on size *)
Print["Generating Pell DNA for D <= ", maxD, "..."];

entries = {};
totalRaw = 0; totalOpt = 0;
Do[
  If[!IntegerQ[Sqrt[d]],
    {x, y} = pellFundamental[d];
    If[x > 0,
      period = cfPeriod[d];
      zx = zeckendorf[x];
      zy = zeckendorf[y];

      rb = rawBits[x, y];
      zb = zeckBits[zx] + zeckBits[zy];  (* Store both x and y as zeck *)

      (* Choose smaller representation *)
      useZeck = zb < rb;

      AppendTo[entries, <|
        "D" -> d,
        "period" -> period,
        "x" -> x,
        "y" -> y,
        "zx" -> zx,
        "zy" -> zy,
        "rawBits" -> rb,
        "zeckBits" -> zb,
        "useZeck" -> useZeck
      |>];

      totalRaw += rb;
      totalOpt += Min[rb, zb];
    ]
  ],
  {d, 2, maxD}
];

(* Summary *)
Print["\n=== SUMMARY ==="];
Print["Entries: ", Length[entries]];
Print["Total raw bits: ", totalRaw, " (", N[totalRaw/8000, 4], " KB)"];
Print["Total optimal bits: ", totalOpt, " (", N[totalOpt/8000, 4], " KB)"];
Print["Using Zeckendorf: ", Count[entries, e_ /; e["useZeck"]]];
Print["Using Raw: ", Count[entries, e_ /; !e["useZeck"]]];

(* Export compact format *)
Print["\n=== JSON OUTPUT (first 50) ==="];
Do[
  e = entries[[i]];
  If[e["useZeck"],
    Print["{d:", e["D"], ",p:", e["period"], ",z:[", StringRiffle[e["zx"], ","], "]},"],
    Print["{d:", e["D"], ",p:", e["period"], ",x:\"", e["x"], "\",y:\"", e["y"], "\"},"]
  ],
  {i, Min[50, Length[entries]]}
];
