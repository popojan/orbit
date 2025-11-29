(* Analyze the 129 conflicting cases - what additional info resolves them? *)

data = Import["omega4-data.mx"];
Print["Loaded ", Length[data], " entries"];

computeResidual[entry_] := Module[
  {pattern, sumL2, sumL3, sumL4, base, f},
  pattern = entry["pattern"];
  sumL2 = Total[pattern["level2"]];
  sumL3 = Total[pattern["level3"]];
  sumL4 = Total[pattern["level4"]];
  base = sumL2 - sumL3 + sumL4;
  f = entry["f"];
  f - base
];

enrichedData = Table[
  Module[{primes, residual, legendres, mod8s, p1, p2, p3, p4},
    primes = entry["primes"];
    {p1, p2, p3, p4} = primes;
    residual = computeResidual[entry];
    
    legendres = {
      JacobiSymbol[p1, p2], JacobiSymbol[p1, p3], JacobiSymbol[p1, p4],
      JacobiSymbol[p2, p3], JacobiSymbol[p2, p4], JacobiSymbol[p3, p4]
    };
    
    mod8s = Mod[primes, 8];
    
    (* Additional potential discriminators *)
    (* Maybe it's about mod 4 relationships? *)
    mod4s = Mod[primes, 4];
    
    (* Quadratic character relationship *)
    qChar = JacobiSymbol[p1*p2, p3*p4];
    
    (* Product of all Legendres *)
    prodLeg = Times @@ legendres;
    
    (* Sum of products of consecutive pairs *)
    pairProds = legendres[[1]]*legendres[[6]] + legendres[[2]]*legendres[[5]] + legendres[[3]]*legendres[[4]];
    
    <|
      "primes" -> primes,
      "f" -> entry["f"],
      "residual" -> residual,
      "legendres" -> legendres,
      "mod8s" -> mod8s,
      "mod4s" -> mod4s,
      "qChar" -> qChar,
      "pairProds" -> pairProds
    |>
  ],
  {entry, data}
];

(* Group by (legendres, mod8) and find conflicts *)
grouped = GroupBy[enrichedData, {#["legendres"], #["mod8s"]} &];
conflictGroups = Select[grouped, Length[DeleteDuplicates[#[[All, "residual"]]]] > 1 &];

Print["\n=== ANALYZING ", Length[conflictGroups], " CONFLICT GROUPS ===\n"];

(* For each conflict, what distinguishes the cases? *)
conflictDetails = {};
Do[
  group = conflictGroups[[i]];
  key = Keys[conflictGroups][[i]];
  residuals = group[[All, "residual"]];
  
  (* What differs between cases with different residuals? *)
  subByRes = GroupBy[group, #["residual"] &];
  
  (* Check if mod4 pattern distinguishes *)
  mod4Patterns = Table[{r, DeleteDuplicates[subByRes[r][[All, "mod4s"]]]}, {r, Keys[subByRes]}];
  
  (* Check if qChar distinguishes *)
  qCharPatterns = Table[{r, DeleteDuplicates[subByRes[r][[All, "qChar"]]]}, {r, Keys[subByRes]}];
  
  (* Check pairProds *)
  pairProdPatterns = Table[{r, DeleteDuplicates[subByRes[r][[All, "pairProds"]]]}, {r, Keys[subByRes]}];
  
  AppendTo[conflictDetails, <|
    "legendres" -> key[[1]],
    "mod8s" -> key[[2]],
    "residuals" -> Union[residuals],
    "mod4Patterns" -> mod4Patterns,
    "qCharPatterns" -> qCharPatterns,
    "pairProdPatterns" -> pairProdPatterns,
    "examples" -> group[[All, "primes"]]
  |>];
, {i, Length[conflictGroups]}];

Print["Sample conflict analysis:"];
Do[
  c = conflictDetails[[i]];
  Print["\nConflict ", i, ":"];
  Print["  Legendres: ", c["legendres"]];
  Print["  Mod8: ", c["mod8s"]];
  Print["  Residuals: ", c["residuals"]];
  Print["  Mod4 patterns: ", c["mod4Patterns"]];
  Print["  qChar patterns: ", c["qCharPatterns"]];
  Print["  Examples: ", Take[c["examples"], UpTo[3]]];
, {i, Min[5, Length[conflictDetails]]}];

(* Key question: does mod 4 + Legendres + mod 8 fully resolve? *)
Print["\n\n=== TEST: (Legendres, mod8, mod4) ==="];
fullGroups = GroupBy[enrichedData, {#["legendres"], #["mod8s"], #["mod4s"]} &];
fullConflicts = Select[fullGroups, Length[DeleteDuplicates[#[[All, "residual"]]]] > 1 &];
Print["Conflicts with mod4 added: ", Length[fullConflicts]];

(* Try qChar *)
Print["\n=== TEST: (Legendres, mod8, qChar) ==="];
qGroups = GroupBy[enrichedData, {#["legendres"], #["mod8s"], #["qChar"]} &];
qConflicts = Select[qGroups, Length[DeleteDuplicates[#[[All, "residual"]]]] > 1 &];
Print["Conflicts with qChar added: ", Length[qConflicts]];

(* Try pairProds *)
Print["\n=== TEST: (Legendres, mod8, pairProds) ==="];
ppGroups = GroupBy[enrichedData, {#["legendres"], #["mod8s"], #["pairProds"]} &];
ppConflicts = Select[ppGroups, Length[DeleteDuplicates[#[[All, "residual"]]]] > 1 &];
Print["Conflicts with pairProds added: ", Length[ppConflicts]];
