(* Formula based on parity of (a1 + a2 + a3) *)
(* Σsigns = #odd - #even where parity = (a1 + a2 + a3) mod 2 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Count primitive CRT signatures by parity of their sum *)
countByParity[p1_, p2_, p3_] := Module[
  {k = p1 p2 p3, c1, c2, c3, odd = 0, even = 0, n, a1, a2, a3},

  c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
  c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
  c3 = p1 p2 * PowerMod[p1 p2, -1, p3];

  Do[
    (* GCD(n, k) = 1 means GCD(ai, pi) = 1 for each i *)
    If[GCD[a1, p1] == 1 && GCD[a2, p2] == 1 && GCD[a3, p3] == 1,
      n = Mod[a1 c1 + a2 c2 + a3 c3, k];
      (* Check primitive: also need GCD(n-1, k) = 1 *)
      If[GCD[n - 1, k] == 1,
        If[OddQ[n], odd++, even++]
      ]
    ],
    {a1, 1, p1 - 1},
    {a2, 1, p2 - 1},
    {a3, 1, p3 - 1}
  ];

  {odd, even, odd - even}
];

Print["=== Testing parity formula ===\n"];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    {odd, even, diff} = countByParity[p1, p2, p3];
    match = (ss == diff);
    If[!match,
      Print["FAIL: 5*", p2, "*", p3, " ss=", ss, " formula=", diff]
    ];
    AppendTo[data, <|"k" -> k, "ss" -> ss, "diff" -> diff, "match" -> match|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 12]]},
  {p3, Prime[Range[5, 15]]}
];

matches = Count[data, d_ /; d["match"]];
Print["Matches: ", matches, " / ", Length[data]];

If[matches == Length[data],
  Print["\nSUCCESS! Formula confirmed:"];
  Print["Σsigns = #{odd primitive} - #{even primitive}"];
  Print["where parity determined by n = a1*c1 + a2*c2 + a3*c3 mod k"];
];

(* Show some examples *)
Print["\n=== Examples ==="];
Do[
  d = data[[i]];
  Print["k=", d["k"], ": ss=", d["ss"], " formula=", d["diff"]],
  {i, Min[10, Length[data]]}
];
