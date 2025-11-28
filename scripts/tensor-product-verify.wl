(* Ověření tensorového produktu pro involuce *)

Print["=== Tensorový produkt σ_m ⊗ σ_n ===\n"];

Print["Pro gcd(m,n) = 1: σ_mn ≅ σ_m ⊗ σ_n\n"];

Print["Vlastní hodnoty tensorového produktu:"];
Print["  (+1)(+1) = +1  →  V_m^+ ⊗ V_n^+ ⊂ V_mn^+"];
Print["  (-1)(-1) = +1  →  V_m^- ⊗ V_n^- ⊂ V_mn^+"];
Print["  (+1)(-1) = -1  →  V_m^+ ⊗ V_n^- ⊂ V_mn^-"];
Print["  (-1)(+1) = -1  →  V_m^- ⊗ V_n^+ ⊂ V_mn^-\n"];

Print["Tedy:"];
Print["  dim V_mn^+ = dim V_m^+ · dim V_n^+ + dim V_m^- · dim V_n^-"];
Print["  dim V_mn^- = dim V_m^+ · dim V_n^- + dim V_m^- · dim V_n^+\n"];

(* Pomocné funkce *)
dimPlus[n_] := (DivisorSigma[0, n] + If[IntegerQ[Sqrt[n]], 1, 0])/2
dimMinus[n_] := (DivisorSigma[0, n] - If[IntegerQ[Sqrt[n]], 1, 0])/2
P[n_] := Floor[DivisorSigma[0, n]/2]

Print["=== Ověření vzorce ===\n"];

Print["P(mn) = dim V_m^+ · P(n) + P(m) · dim V_n^+\n"];

testPairs = {{2, 3}, {2, 5}, {3, 4}, {4, 3}, {3, 5}, {4, 9}, {2, 9}, {5, 7}};

Print["| m | n | dim V_m^+ | dim V_m^- | dim V_n^+ | dim V_n^- | P(mn) vzorec | P(mn) přímé |"];
Print["|---|---|-----------|-----------|-----------|-----------|--------------|-------------|"];

Do[
  {m, n} = pair;
  If[GCD[m, n] == 1,
    dmp = dimPlus[m];
    dmm = dimMinus[m];
    dnp = dimPlus[n];
    dnm = dimMinus[n];
    pmnFormula = dmp * dnm + dmm * dnp;
    pmnDirect = P[m * n];
    ok = If[pmnFormula == pmnDirect, "✓", "✗"];
    Print["| ", m, " | ", n, " | ", dmp, " | ", dmm, " | ", dnp, " | ", dnm,
          " | ", pmnFormula, " | ", pmnDirect, " ", ok, " |"];
  ];
, {pair, testPairs}];

Print["\n=== Speciální případy ===\n"];

Print["Pro m, n OBA nečtverce:"];
Print["  dim V_m^+ = τ(m)/2 = P(m)"];
Print["  dim V_m^- = τ(m)/2 = P(m)"];
Print["  P(mn) = P(m)·P(n) + P(m)·P(n) = 2·P(m)·P(n)\n"];

(* Ověření *)
Print["Ověření pro nečtverce:"];
noncubes = {{2, 3}, {2, 5}, {3, 5}, {5, 7}, {2, 7}};
Do[
  {m, n} = pair;
  pm = P[m]; pn = P[n];
  formula = 2 pm pn;
  direct = P[m n];
  ok = If[formula == direct, "✓", "✗"];
  Print["  P(", m, "·", n, ") = 2·", pm, "·", pn, " = ", formula, " vs ", direct, " ", ok];
, {pair, noncubes}];

Print["\nPro m čtverec, n nečtverec:"];
Print["  dim V_m^+ = (τ(m)+1)/2"];
Print["  dim V_m^- = (τ(m)-1)/2 = P(m)"];
Print["  P(mn) = (τ(m)+1)/2 · P(n) + P(m) · τ(n)/2\n"];

(* Ověření *)
Print["Ověření:"];
mixedPairs = {{4, 3}, {9, 2}, {4, 5}, {9, 5}, {16, 3}};
Do[
  {m, n} = pair;
  dmp = dimPlus[m]; dmm = dimMinus[m];
  dnp = dimPlus[n]; dnm = dimMinus[n];
  formula = dmp dnm + dmm dnp;
  direct = P[m n];
  ok = If[formula == direct, "✓", "✗"];
  Print["  P(", m, "·", n, ") = ", dmp, "·", dnm, " + ", dmm, "·", dnp,
        " = ", formula, " vs ", direct, " ", ok];
, {pair, mixedPairs}];

Print["\n=== Obecný vzorec ===\n"];

Print["Pro gcd(m,n) = 1:"];
Print[""];
Print["  P(mn) = [(τ(m) + χ_□(m))/2] · [(τ(n) - χ_□(n))/2]"];
Print["        + [(τ(m) - χ_□(m))/2] · [(τ(n) + χ_□(n))/2]"];
Print[""];
Print["  = [τ(m)τ(n) - χ_□(m)χ_□(n)] / 2"];
Print[""];
Print["  = [τ(mn) - χ_□(mn)] / 2  =  P(mn)  ✓"];
