#!/usr/bin/env wolframscript
(* TEST L_M(s) AT RIEMANN ZETA ZEROS *)

Print[StringRepeat["=", 80]];
Print["L_M(s) EVALUATION AT RIEMANN ZETA ZEROS"];
Print[StringRepeat["=", 80]];
Print[];

(* M(n) = count of divisors d where 2 <= d <= sqrt(n) *)
M[n_] := Module[{sqrtN, count},
  sqrtN = Floor[Sqrt[n]];
  count = 0;
  Do[
    If[Mod[n, d] == 0, count++];
    ,
    {d, 2, sqrtN}
  ];
  count
]

(* L_M(s) = Sum M(n)/n^s for n=2..N *)
LM[s_, N_] := Module[{sum},
  sum = 0;
  Do[
    sum += M[n] / n^s;
    ,
    {n, 2, N}
  ];
  sum
]

(* First 10 non-trivial Riemann zeros (on critical line) *)
(* s = 1/2 + i*t *)
riemannZeros = {
  14.134725141734693790,   (* ζ(1/2 + 14.134...i) = 0 *)
  21.022039638771554993,
  25.010857580145688763,
  30.424876125859513210,
  32.935061587739189691,
  37.586178158825671257,
  40.918719012147495187,
  43.327073280914999519,
  48.005150881167159728,
  49.773832477672302500
};

Print["First 10 Riemann zeros (imaginary parts):"];
Print[riemannZeros];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Evaluate L_M at critical line points *)
Print["EVALUATION AT RIEMANN ZEROS:"];
Print[StringRepeat["-", 70]];
Print["Computing L_M(1/2 + i*t) for t = Riemann zeros..."];
Print[];

(* Use N=1000 for reasonable approximation *)
NMax = 1000;
Print["Using N = ", NMax, " terms"];
Print[];

Print["t         Re[L_M]      Im[L_M]      |L_M|      arg(L_M)"];
Print[StringRepeat["-", 70]];

results = Table[
  t = riemannZeros[[i]];
  s = 0.5 + I*t;

  LMval = LM[s, NMax];

  {t, Re[LMval], Im[LMval], Abs[LMval], Arg[LMval]},
  {i, Length[riemannZeros]}
];

Do[
  {t, re, im, mag, phase} = results[[i]];
  Print[
    StringPadRight[ToString[N[t, 6]], 10],
    StringPadRight[ToString[N[re, 6]], 14],
    StringPadRight[ToString[N[im, 6]], 13],
    StringPadRight[ToString[N[mag, 6]], 13],
    N[phase, 6]
  ];
  ,
  {i, Length[results]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Compare to nearby points *)
Print["COMPARISON TO NEARBY NON-ZERO POINTS:"];
Print[StringRepeat["-", 70]];
Print[];

(* Pick first zero and test nearby *)
t0 = riemannZeros[[1]];
Print["Testing near t = ", N[t0, 6]];
Print[];

nearby = Table[
  t = t0 + dt;
  s = 0.5 + I*t;
  LMval = LM[s, NMax];
  {dt, Abs[LMval]},
  {dt, -0.5, 0.5, 0.1}
];

Print["dt      |L_M(1/2 + i*(t0+dt))|"];
Print[StringRepeat["-", 40]];
Do[
  {dt, mag} = nearby[[i]];
  Print[
    StringPadRight[ToString[N[dt, 2]], 8],
    N[mag, 6]
  ];
  ,
  {i, Length[nearby]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Check for patterns *)
Print["STATISTICAL ANALYSIS:"];
Print[StringRepeat["-", 60]];

mags = results[[All, 4]];
meanMag = Mean[mags];
maxMag = Max[mags];
minMag = Min[mags];

Print["Magnitude |L_M(1/2 + i*t)| at Riemann zeros:"];
Print["  Mean:   ", N[meanMag, 6]];
Print["  Max:    ", N[maxMag, 6]];
Print["  Min:    ", N[minMag, 6]];
Print["  Std:    ", N[StandardDeviation[mags], 6]];
Print[];

(* Compare to random points on critical line *)
Print["Comparison to random points on critical line:"];
randomTs = Table[Random[Real, {14, 50}], {10}];
randomMags = Table[
  s = 0.5 + I*t;
  Abs[LM[s, NMax]],
  {t, randomTs}
];

meanRandomMag = Mean[randomMags];
Print["  Mean |L_M| at random t:  ", N[meanRandomMag, 6]];
Print["  Mean |L_M| at zeros:     ", N[meanMag, 6]];
Print["  Ratio (zero/random):     ", N[meanMag/meanRandomMag, 3]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["INTERPRETATION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Question: Does L_M(s) = 0 at Riemann zeros?"];
Print[];

If[meanMag < 0.1,
  Print["POSSIBLE: Magnitudes are very small at zeros!"];
  Print["  → L_M might vanish at Riemann zeros"];
  Print["  → Suggests deep connection to ζ(s)"];
  ,
  Print["UNLIKELY: Magnitudes not particularly small"];
  Print["  Mean |L_M| at zeros: ", N[meanMag, 4]];
  Print["  → L_M does NOT vanish at Riemann zeros"];
  Print["  → But may have other special properties"];
];

Print[];
Print["Next steps:"];
Print["  - Test with larger N (more terms)"];
Print["  - Check phase behavior at zeros"];
Print["  - Test functional equation hypothesis"];
Print[];

Print[StringRepeat["=", 80]];
