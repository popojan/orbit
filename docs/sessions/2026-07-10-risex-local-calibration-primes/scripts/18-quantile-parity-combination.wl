(* 18: combining the alpha-quantile continuum with parity/divisibility.
   The user's ngap[p, alpha] = (NextPrime[p]-p)/(Log[1/(1-alpha)] Log[p]) is the
   quantile-normalized gap: model P(ngap <= t) = 1 - (1-alpha)^t, = alpha at t=1.
   Its histogram is discrete: atoms at even g, with singular-series weights
   (x2 for 6|g etc.).  The principled combination of continuum + discreteness:
   1. calibration check of ngap;
   2. the comb: empirical gap frequencies vs even-geometric vs HL hazard
      P(g=h) = (S(h)/q) Prod_{h'<h}(1 - S(h')/q),  S(h) = 2 C2 prod_{r|h, r>2} (r-1)/(r-2);
   3. conditioning on the KNOWN p mod 3: half the teeth vanish deterministically;
   4. randomized probability integral transform through each model's discrete CDF:
      the right model makes U uniform (chi^2/dof -> 1). *)

SeedRandom[6];
c2 = 0.6601618158468695739;
sHL[h_] := 2 c2 Times @@ (((# - 1)/(# - 2)) & /@ Select[FactorInteger[h][[All, 1]], # > 2 &]);

height = 10^9; n = 6000;
gapsP = Table[Module[{p},
    p = NextPrime[height + RandomInteger[{0, Round[height/50]}]];
    p = NextPrime[p]; p = NextPrime[p];
    {p, NextPrime[p] - p}], {n}];
q0 = Log[N[height]];

Print["1) calibration of ngap:  empirical fraction(ngap <= 1) vs alpha  (height 10^9, n=", n, "):"];
Do[
  frac = N[Count[gapsP, {p_, g_} /; g <= Log[1/(1 - a)] Log[N[p]]]/n];
  Print["   alpha = ", N[a], ":  ", N[frac, 3]],
  {a, {0.25, 0.5, 0.75, 0.9}}];

Print[""];
Print["2) small-gap frequencies, per mille  (q ~ ", N[q0, 4], "):"];
tal = SortBy[Tally[gapsP[[All, 2]]], First];
freq[g_] := With[{c = Cases[tal, {g, k_} :> k]}, If[c === {}, 0, First[c]]]/N[n];
geo[g_] := (2/q0) (1 - 2/q0)^(g/2 - 1);
hmax = 300;
haz = Table[Min[sHL[h]/q0, 1], {h, 2, hmax, 2}];
surv = FoldList[Times, 1, 1 - Most[haz]];
pHL = surv haz;
Print["   g | empirical | even-geometric | HL-hazard"];
Do[Print["   ", g, " | ", N[1000 freq[g], 3], " | ", N[1000 geo[g], 3], " | ",
   N[1000 pHL[[g/2]], 3]], {g, 2, 30, 2}];

Print[""];
Print["3) conditioning on the KNOWN p: gap residues mod 6 split by p mod 3 (deterministic teeth):"];
Do[
  sub = Select[gapsP, Mod[#[[1]], 3] == r &];
  Print["   p = ", r, " mod 3 (n=", Length[sub], "): gap mod 6 tally: ",
    SortBy[Tally[Mod[sub[[All, 2]], 6]], First]],
  {r, {1, 2}}];

Print[""];
Print["4) randomized PIT -> uniformity, chi^2/dof over 20 bins (1 = perfect fit):"];
chi2[us_] := Module[{cnt = BinCounts[us, {0, 1, 1/20}], e = Length[us]/20.},
   Total[(cnt - e)^2/e]/19.];
uExp = Table[Module[{q = Log[N[gp[[1]]]]}, 1 - Exp[-gp[[2]]/q]], {gp, gapsP}];
uGeo = Table[Module[{q = Log[N[gp[[1]]]], k = gp[[2]]/2, pk, Fk1},
    pk = (2/q) (1 - 2/q)^(k - 1);
    Fk1 = 1 - (1 - 2/q)^(k - 1);
    Fk1 + RandomReal[] pk], {gp, gapsP}];
uHL = Table[Module[{q = Log[N[gp[[1]]]], g = gp[[2]], hz, sv, k},
    k = g/2;
    hz = Table[sHL[h]/q, {h, 2, g, 2}];
    sv = FoldList[Times, 1, 1 - Most[hz]];
    (1 - sv[[k]]) + RandomReal[] sv[[k]] hz[[k]]], {gp, gapsP}];
Print["   continuous exponential : ", N[chi2[uExp], 3]];
Print["   even-geometric (parity): ", N[chi2[uGeo], 3]];
Print["   HL singular-series     : ", N[chi2[uHL], 3]];
