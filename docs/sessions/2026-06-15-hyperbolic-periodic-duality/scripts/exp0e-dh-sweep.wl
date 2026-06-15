(* Clean attribution: sweep the Weil-form min-eigenvalue vs the basis center t,
   with a fixed moderately-conditioned basis. Off-line DH zeros (t=85.699,
   sigma=0.808; t=114.163, sigma=0.651/0.349) must appear as sharp NEGATIVE
   spikes; on-line stretches stay >= ~0. Arithmetic side only (no zeros used). *)

$MaxExtraPrecision = 2000;
w     = 3/2;
offs  = {-4/5, -2/5, 0, 2/5, 4/5};          (* spread 1.6, spacing 0.4 *)
mB    = Length[offs];
kappa = N[(Sqrt[10 - 2 Sqrt[5]] - 2)/(Sqrt[5] - 1), 50];
cc[n_] := {1, kappa, -kappa, -1, 0}[[Mod[n - 1, 5] + 1]];

Nmax = 4000;
Print["building Lambda_f to ", Nmax, " ..."];
lamf = ConstantArray[0, Nmax];
Do[lamf[[n]] = N[cc[n] Log[n] - Sum[lamf[[d]] cc[n/d], {d, Most[Divisors[n]]}], 40],
   {n, 2, Nmax}];

(* precompute vectors for the prime/Lambda_f cosine-sum *)
ns    = Range[2, Nmax];
logn  = N[Log[ns], 30];
Wvec  = N[lamf[[2 ;; Nmax]] ns^(-1/2) Exp[-logn^2/(4 w^2)], 30];
cosSum[c_] := Wvec . Cos[c logn];           (* = sum_n Lambda_f(n) n^-.5 e^... cos(c log n) *)

Bamp[a_, b_] := 2 Pi w^2 Exp[-w^2 (a - b)^2/4];
Acon = Log[5/Pi];
archC[c_, B_] := (1/(2 Pi)) NIntegrate[
    B Exp[-w^2 (r - c)^2] (Re[PolyGamma[0, 3/4 + I r/2]] + Acon),
    {r, c - 18, c + 18}, WorkingPrecision -> 30, AccuracyGoal -> 18];
entry[a_, b_] := Module[{c = (a + b)/2, B = Bamp[a, b]},
   archC[c, B] - 2 w Sqrt[Pi] Exp[-w^2 (a - b)^2/4] cosSum[c]];

minEig[ctr_] := Module[{nu = ctr + offs, M},
  M = Table[entry[nu[[j]], nu[[k]]], {j, mB}, {k, mB}];
  M = (M + Transpose[M])/2;
  Min[Eigenvalues[N[M, 30]]]];

Print["\n=== sweep min-eig vs center t (step 1.0; refine near spikes) ==="];
centers = Range[42, 120, 1];
vals = Table[{ct, minEig[ct]}, {ct, centers}];
Print[" center : minEig"];
Do[Print["  ", PaddedForm[N[v[[1]], 4], {5, 1}], " : ",
     ScientificForm[N[v[[2]], 5]], If[v[[2]] < -0.01, "   <== NEGATIVE SPIKE", ""]],
  {v, vals}];

negs = Select[vals, #[[2]] < -0.01 &];
Print["\n  negative-spike centers (minEig < -0.01): ", N[negs[[All, 1]], 5]];
Print["  baseline (on-line) min over t in [42,80]: ",
   ScientificForm[N[Min[Select[vals, #[[1]] <= 80 &][[All, 2]]], 5]]];

Print["\nDONE."];
