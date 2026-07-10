(* 19: combining the rigorous gap theorems with the HL hazard model.
   Claim A (no-op): the theorems (CMS/RH ceiling 0.88 sqrt(p) log p, etc.) constrain
   only a tail where the hazard model has mass ~exp(-0.88 sqrt(p)) -- truncating the
   distribution there changes nothing measurable.  Claim B (the real combination):
   the hazard model + extreme-value theory predicts the MAXIMAL gap in a window
   (Gumbel layer, few lines); theorems are the support rails the model never touches.
   Hypothesis before running: empirical max gap in [1e9, 1e9+1e6] falls within the
   predicted Gumbel interquartile range; comb-corrected and pure-exponential
   predictions differ by less than the Gumbel scale q. *)

c2 = 0.6601618158468695739;
sHL[h_] := 2 c2 Times @@ (((# - 1)/(# - 2)) & /@ Select[FactorInteger[h][[All, 1]], # > 2 &]);

Print["A) mass the hazard model places beyond the CMS/RH certificate 0.88 sqrt(p) log p:"];
Do[
  q = Log[N[p]];
  logmass = -0.88 Sqrt[N[p]]/Log[10];   (* log10 P(g > 0.88 sqrt(p) q) ~ -0.88 sqrt(p)/ln10 *)
  Print["   p ~ 10^", Round[Log10[N[p]]], ":  log10(tail mass) ~ ", Round[logmass]],
  {p, {10^9, 10^18}}];
Print["   (for the record Mersenne: log10(tail mass) ~ -10^20512000 -- truncation is a no-op)"];

Print[""];
Print["B) Gumbel layer: predicted maximal gap in [10^9, 10^9 + 10^6]"];
x0 = 10^9; W = 10^6;
q = Log[N[x0]];
Nest0 = W/q;   (* expected number of gaps *)
(* pure exponential: median of max = q Log[N/ln 2] *)
gExpMed = q Log[Nest0/Log[2]];
gExpQ1 = q Log[Nest0/Log[4]]; (* P(max<=G)=1/4 -> N e^{-G/q} = ln 4 *)
gExpQ3 = q Log[Nest0/Log[4/3]];
(* HL-comb: survival S(G) = prod_{h even <= G} (1 - sHL(h)/q); solve S = ln2/N etc. *)
survTab = FoldList[Times, 1., Table[1 - sHL[h]/q, {h, 2, 2000, 2}]];
solveG[target_] := 2 (LengthWhile[survTab, # > target &]);
gHLMed = solveG[Log[2]/Nest0];
gHLQ1 = solveG[Log[4]/Nest0];
gHLQ3 = solveG[Log[4/3]/Nest0];
Print["   pure exponential:  Q1 ", Round[gExpQ1], "  median ", Round[gExpMed], "  Q3 ", Round[gExpQ3]];
Print["   HL-comb hazard  :  Q1 ", gHLQ1, "  median ", gHLMed, "  Q3 ", gHLQ3];

(* empirical scan *)
p = NextPrime[x0]; gmax = 0; ngaps = 0; pmaxat = 0;
While[p < x0 + W,
  pn = NextPrime[p];
  If[pn - p > gmax, gmax = pn - p; pmaxat = p];
  ngaps++;
  p = pn];
Print["   empirical: ", ngaps, " gaps, max gap = ", gmax, " (after ", pmaxat, ")"];
Print["   (expected count was ", Round[Nest0], ")"];

Print[""];
Print["C) scale comparison at this height: model-predicted max ~ ", Round[gExpMed],
  " ; Cramer-Granville asymptotic worst-case scale 1.12 q^2 ~ ", Round[1.12 q^2],
  " ; CMS/RH certificate ~ ", Round[0.88 Sqrt[N[x0]] q // N], "."];
