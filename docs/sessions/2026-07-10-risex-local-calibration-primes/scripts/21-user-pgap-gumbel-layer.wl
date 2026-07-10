(* 21: the "upward" Gumbel layer on the user's own pgap implementation.
   User's code (verbatim, exact C2 via PrimeZetaP, exclusive product via h-1/2):  *)

C2 = Exp[-Sum[(2^k - 2)/k (PrimeZetaP[k] - 2^-k), {k, 2, 220}]] // N[#, 40] &;
sHL[h_] := If[OddQ@h, 0,
   2 C2 Times @@ (((# - 1)/(# - 2)) & /@
       Select[FactorInteger[h][[All, 1]], # > 2 &])];
pgap[p_, h_] := sHL[h]/Log@p Product[1 - sHL[i]/Log@p, {i, 2, h - 1/2, 2}];

(* ---- the Gumbel layer: four lines ---- *)
survHL[p_, G_] := Product[1 - sHL[i]/Log[N@p], {i, 2, G, 2}];          (* P(gap > G) *)
tailCount[p_, W_, G_, kappa_ : 1] := kappa (W/Log[N@p]) survHL[p, G];  (* E #(gaps > G) in width-W window *)
maxGapCDF[p_, W_, G_, kappa_ : 1] := Exp[-tailCount[p, W, G, kappa]];  (* P(max gap <= G) *)
maxGapQuantile[p_, W_, alpha_ : 1/2, kappa_ : 1] := Module[
   {q = Log[N@p], s = 1., h = 0, tgt},
   tgt = -Log[alpha] q/(kappa W);
   While[s > tgt, h += 2; s *= 1 - sHL[h]/q];
   h];

(* ---- validation against scripts 18-20 ---- *)
Print["pgap normalizes: Sum over h = ", Total[Table[pgap[10^9, h], {h, 2, 2000, 2}]] // N];
Print["pgap[10^9, 6] per mille = ", N[1000 pgap[10^9, 6], 4], "   (script 18 empirical: 114.5, model: 111.7)"];
Print[""];
Print["maxGapQuantile[10^9, 10^6] (median, kappa=1) = ", maxGapQuantile[10^9, 10^6],
  "   (script 19 HL-comb Gumbel median: 222)"];
Print["quartiles kappa=1: ", {maxGapQuantile[10^9, 10^6, 1/4], maxGapQuantile[10^9, 10^6, 3/4]}];
Print[""];
Print["with the measured finite-height tail thinning kappa ~ 0.55 (script 20, relative to HL chain):"];
Do[Module[{x0 = pr[[1]], obs = pr[[2]]},
   Print["   height ", N[x0, 2], ": median-max prediction ", maxGapQuantile[x0, 10^6, 1/2, 0.55],
    ", IQR ", {maxGapQuantile[x0, 10^6, 1/4, 0.55], maxGapQuantile[x0, 10^6, 3/4, 0.55]},
    "   observed max: ", obs]],
  {pr, {{5 10^8, 204}, {10^9, 176}, {4 10^9, 232}}}];
Print[""];
Print["expected tail counts at 10^9, W=10^6, kappa=1 vs 0.55 vs observed (script 20):"];
Do[Module[{t = pr[[1]], obs = pr[[2]], q = Log[N[10^9]]},
   Print["   g >= ", t, "q: kappa=1: ", N[tailCount[10^9, 10^6, Ceiling[t q, 2]], 3],
    "  kappa=0.55: ", N[tailCount[10^9, 10^6, Ceiling[t q, 2], 0.55], 3],
    "  observed: ", obs]],
  {pr, {{5, 149}, {6, 43}, {7, 17}}}];
Print[""];
Print["record-Mersenne worked example: median MAX gap among ALL primes below P = 2^136279841 - 1"];
Print["   (pure exponential suffices: comb tooth-spacing 2 << q; N = pi(P) ~ P/q gaps)"];
qM = 136279841 Log[2.];
Print["   median max ~ q (ln P - ln ln P - ln ln 2) = qM (qM - ", N[Log[qM] + Log[Log[2.]] // N, 3],
  ") ~ ", N[qM (qM - Log[qM] - Log[Log[2.]]), 4], "  (log^2 P scale, Cramer-Granville territory)"];
