(* C disambiguation (optimized: vectorized potential + compiled transfer loop).
   Is the EXACT integer-lattice {log p} special, or was L_prime>L_generic just
   density/a single-draw fluke?  Control: omega = log p + Uniform[-0.25,0.25]
   (same density/magnitudes, BROKEN additive lattice log p+log q=log pq).
   L_prime outlier (z>>2) => integrality dynamically special; within spread =>
   humble fallback to A/B. *)

SeedRandom[7];
nprimes = 25;
prs    = Prime[Range[nprimes]];
freqP  = N[Log[prs]];
phases = N[RandomReal[{0, 2 Pi}, nprimes]];
ampl[sig_] := N[Log[prs]/prs^sig];
nst = 10000;
ns  = N[Range[nst]];
ens = {0., 1.};

potential[freqs_, sig_] := Cos[Outer[Times, ns, freqs] + ConstantArray[phases, nst]] . ampl[sig];

lyapC = Compile[{{Vv, _Real, 1}, {en, _Real}},
  Module[{v1 = 1., v2 = 0., s = 0., w, nr},
   Do[w = (en - Vv[[n]]) v1 - v2; v2 = v1; v1 = w;
      nr = Sqrt[v1^2 + v2^2]; s += Log[nr]; v1 = v1/nr; v2 = v2/nr,
    {n, Length[Vv]}];
   s/Length[Vv]],
  CompilationTarget -> "C", RuntimeOptions -> "Speed"];

Lavg[freqs_, sig_] := Module[{Vv = potential[freqs, sig]}, Mean[lyapC[Vv, #] & /@ ens]];

ndraw = 20;
Print["L_prime (exact log p) vs ensemble of ", ndraw,
   " broken-lattice controls (log p + U[-.25,.25]); L avg over en=", ens,
   ", nst=", nst, "\n"];
Print[" sigma | L_prime | <L_ctrl> +- std | z | verdict"];
Do[Module[{lp, ctrls, mu, sd, z},
   lp = Lavg[freqP, sig];
   ctrls = Table[Lavg[freqP + RandomReal[{-1/4, 1/4}, nprimes], sig], {ndraw}];
   mu = Mean[ctrls]; sd = StandardDeviation[ctrls];
   z = (lp - mu)/sd;
   Print["  ", PaddedForm[N[sig, 3], {4, 2}], " | ", PaddedForm[N[lp, 5], {8, 5}],
     " | ", PaddedForm[N[mu, 5], {8, 5}], " +- ", PaddedForm[N[sd, 3], {6, 4}],
     " | z=", PaddedForm[N[z, 3], {6, 2}], " | ",
     Which[Abs[z] > 3, "OUTLIER (integrality special)",
           Abs[z] > 2, "marginal", True, "within spread (fluke/density)"]]],
  {sig, {0.6, 0.7, 0.8, 0.9, 1.0}}];

Print["\nPRE-REGISTERED: z within ~[-2,2] across sigma => exact lattice NOT",
   " special => earlier L_prime>L_generic was density/fluke => C no mechanism =>",
   " humble to A/B. Persistent z>3 => integrality dynamically special."];
Print["DONE."];
