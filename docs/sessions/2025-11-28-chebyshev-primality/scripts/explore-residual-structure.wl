(* Explore what the 4-valued residual depends on *)
(* Key insight: maybe Legendre symbols or mod 8 classes explain the residual *)

(* Load data *)
data = Import["omega4-data.mx"];
Print["Loaded ", Length[data], " entries"];

(* Core formula that gives 4-valued residual *)
computeResidual[entry_] := Module[
  {pattern, sumL2, sumL3, sumL4, base, f},
  pattern = entry["pattern"];
  sumL2 = Total[pattern["level2"]];
  sumL3 = Total[pattern["level3"]];
  sumL4 = Total[pattern["level4"]];
  base = sumL2 - sumL3 + sumL4;
  f = entry["f"];
  f - base  (* This is in {-1, 0, 1, 2} *)
];

(* Add residual and Legendre info to data *)
enrichedData = Table[
  Module[{primes, residual, legendres, mod8s},
    primes = entry["primes"];
    residual = computeResidual[entry];
    
    (* All 6 pairwise Legendre symbols *)
    legendres = {
      JacobiSymbol[primes[[1]], primes[[2]]],
      JacobiSymbol[primes[[1]], primes[[3]]],
      JacobiSymbol[primes[[1]], primes[[4]]],
      JacobiSymbol[primes[[2]], primes[[3]]],
      JacobiSymbol[primes[[2]], primes[[4]]],
      JacobiSymbol[primes[[3]], primes[[4]]]
    };
    
    (* Mod 8 classes *)
    mod8s = Mod[primes, 8];
    
    <|
      "primes" -> primes,
      "f" -> entry["f"],
      "residual" -> residual,
      "legendres" -> legendres,
      "sumLegendre" -> Total[legendres],
      "prodLegendre" -> Times @@ legendres,
      "mod8s" -> mod8s
    |>
  ],
  {entry, data}
];

Print["\n=== RESIDUAL DISTRIBUTION ==="];
Print[Counts[enrichedData[[All, "residual"]]]];

Print["\n=== RESIDUAL vs PRODUCT OF LEGENDRES ==="];
grouped = GroupBy[enrichedData, #["prodLegendre"] &];
Table[
  Module[{residuals},
    residuals = grp[[All, "residual"]];
    Print["prodLegendre = ", key, ": ", Counts[residuals], " mean=", N[Mean[residuals], 3]]
  ],
  {key, {-1, 1}}, {grp, {grouped[key]}}
];

Print["\n=== RESIDUAL vs SUM OF LEGENDRES ==="];
grouped = GroupBy[enrichedData, #["sumLegendre"] &];
Do[
  Module[{residuals},
    residuals = grp[[All, "residual"]];
    Print["sumLegendre = ", key, ": ", Counts[residuals], " mean=", N[Mean[residuals], 3]]
  ],
  {key, Sort[Keys[grouped]]}, {grp, {grouped[key]}}
];

Print["\n=== KEY QUESTION: Is residual DETERMINED by Legendres? ==="];
(* Group by full Legendre pattern and check if residual is unique *)
legendreGroups = GroupBy[enrichedData, #["legendres"] &];
Print["Number of distinct Legendre patterns: ", Length[legendreGroups]];

conflicts = 0;
uniquelyDetermined = 0;
Do[
  Module[{residuals},
    residuals = DeleteDuplicates[grp[[All, "residual"]]];
    If[Length[residuals] == 1,
      uniquelyDetermined++,
      conflicts++
    ]
  ],
  {grp, Values[legendreGroups]}
];
Print["Legendres uniquely determine residual: ", uniquelyDetermined, "/", Length[legendreGroups]];
Print["Conflicts: ", conflicts];

(* If conflicts, maybe mod8 classes help? *)
If[conflicts > 0,
  Print["\n=== ADDING MOD 8 CLASSES ==="];
  fullGroups = GroupBy[enrichedData, {#["legendres"], #["mod8s"]} &];
  Print["Distinct (Legendre, mod8) patterns: ", Length[fullGroups]];
  
  fullConflicts = 0;
  fullUnique = 0;
  Do[
    Module[{residuals},
      residuals = DeleteDuplicates[grp[[All, "residual"]]];
      If[Length[residuals] == 1,
        fullUnique++,
        fullConflicts++;
        If[fullConflicts <= 3,
          Print["Conflict example: ", grp[[1, "primes"]], " vs ", grp[[2, "primes"]], 
                " residuals: ", grp[[All, "residual"]]]
        ]
      ]
    ],
    {grp, Values[fullGroups]}
  ];
  Print["(Legendre, mod8) uniquely determine residual: ", fullUnique, "/", Length[fullGroups]];
  Print["Conflicts: ", fullConflicts];
];
