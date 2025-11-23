#!/usr/bin/env wolframscript
(* Deep dive into circi/circj structure *)

circi[k_, Rational[a_, b_]] := (1 + I) ((a + I b)^4)^k (a^2 + b^2)^(-2 k)
circj[k_, Rational[a_, b_]] := (a - I b)^(4 k) (a^2 + b^2)^(-2 k)

Print["=== WHY EXPONENT 4k? ===\n"];

(* Let's decompose the construction *)
Print["For circj[k, a/b], the base step is:"];
Print["  z₁ = (a - Ib)^4 / (a² + b²)²"];
Print[""];

rat = 1/2;
{a, b} = {1, 2};

(* Single step *)
z1 = (a - I*b)^4 / (a^2 + b^2)^2;
Print["With a/b = ", rat, " (a=", a, ", b=", b, "):"];
Print["  z₁ = ", z1];
Print["  |z₁| = ", Abs[z1]];
Print["  arg(z₁) = ", N[Arg[z1]], " rad = ", N[Arg[z1]*180/Pi], "°"];
Print[""];

(* What if we used exponent 1 instead of 4? *)
z1_alt = (a - I*b)^1 / (a^2 + b^2)^(1/2);
Print["If we used exponent 1: z₁ = (a-Ib)/√(a²+b²)"];
Print["  z₁ = ", z1_alt];
Print["  |z₁| = ", Abs[z1_alt]];
Print["  arg(z₁) = ", N[Arg[z1_alt]], " rad = ", N[Arg[z1_alt]*180/Pi], "°"];
Print[""];

(* What about exponent 2? *)
z1_exp2 = (a - I*b)^2 / (a^2 + b^2);
Print["If we used exponent 2: z₁ = (a-Ib)²/(a²+b²)"];
Print["  z₁ = ", z1_exp2];
Print["  |z₁| = ", Abs[z1_exp2]];
Print["  arg(z₁) = ", N[Arg[z1_exp2]], " rad = ", N[Arg[z1_exp2]*180/Pi], "°"];
Print[""];

Print["Observation: exponent n gives angle rotation by n·arctan(b/a)"];
Print["For a=1, b=2: arctan(2) = ", N[ArcTan[2]], " rad"];
Print["With exponent 4: 4·arctan(2) = ", N[4*ArcTan[2]], " rad = ", N[4*ArcTan[2]*180/Pi], "°"];
Print[""];

Print["\n=== SEARCHING FOR INTEGER PERIODS ===\n"];

(* For integer period, we need 4k·θ = 2πm for some integers k, m *)
(* θ = arctan(b/a) *)
(* So: 4k·arctan(b/a) = 2πm *)
(* arctan(b/a) = πm/(2k) *)
(* b/a = tan(πm/(2k)) *)

Print["For integer period T, we need: 4T·arctan(b/a) = 2π·n"];
Print["So: arctan(b/a) = π·n/(2T)"];
Print["Or: b/a = tan(π·n/(2T))"];
Print[""];

Print["Testing special values (similar to AlgebraicCirclePoint):"];
Print[""];

specialCases = {
  {3, 1, "T=3, n=1"},
  {6, 1, "T=6, n=1"},
  {12, 1, "T=12, n=1"},
  {12, 2, "T=12, n=2"}
};

Do[
  {T, n, label} = testCase;

  targetAngle = Pi*n/(2*T);
  targetTan = Tan[targetAngle];

  Print[label, ": b/a = tan(π·", n, "/(2·", T, ")) = ", N[targetTan, 6]];

  (* Try to rationalize *)
  ratApprox = Rationalize[targetTan, 0.0001];
  If[Abs[ratApprox - targetTan] < 0.0001,
    Print["  Rational approximation: ", ratApprox];

    (* Test period *)
    z0 = circj[0, ratApprox];
    foundPeriod = False;
    Do[
      zk = circj[k, ratApprox];
      If[Abs[zk - z0] < 10^-6 && k > 0,
        Print["  Period found at k = ", k];
        foundPeriod = True;
        Break[];
      ];
    , {k, 1, 2*T}];
    If[!foundPeriod, Print["  No period found in range [1,", 2*T, "]"]];
  ,
    Print["  Not rational, exact value: ", targetTan];
  ];
  Print[""];
, {testCase, specialCases}];

Print["\n=== USING SPECIAL ALGEBRAIC VALUES ===\n"];

(* Use the same values as in AlgebraicCirclePoint *)
Print["Testing a = Cot[π/(2n)] values:"];
Print[""];

algebraicCases = {
  {3, Sqrt[3], "√3"},
  {6, 2 + Sqrt[3], "2+√3"},
  {12, 2 + Sqrt[2] + Sqrt[3] + Sqrt[6], "2+√2+√3+√6"}
};

Do[
  {n, a, aStr} = testCase;

  (* For circj, we have a/b parametrization, but a is Cot *)
  (* Cot = a/b if we think of complex a + Ib *)
  (* So if Cot = c, then a/b = c, meaning a=c, b=1? *)
  (* Or more likely: we should use 1/a? *)

  Print["n = ", n, ", a = ", aStr, " = ", N[a, 6]];
  Print["  Using ratio 1/a (since Cot = a/b inverted):"];

  rat = 1/a;
  Print["  Rational form would be: ", N[rat, 6]];

  (* This won't be rational, but let's test period anyway *)
  (* We need to modify circj to accept algebraic numbers *)

  Print["  (Skipping - circj requires Rational input)"];
  Print[""];
, {testCase, algebraicCases}];

Print["\n=== GENERALIZING TO ALGEBRAIC NUMBERS ===\n"];

(* Define versions that work with algebraic a *)
circjAlg[k_, a_] := (a - I)^(4 k) (a^2 + 1)^(-2 k);
circiAlg[k_, a_] := (1 + I) ((a + I)^4)^k (a^2 + 1)^(-2 k);

Print["Modified versions for algebraic a (assuming b=1):"];
Print["  circjAlg[k, a] = (a-I)^(4k) / (a²+1)^(2k)"];
Print["  circiAlg[k, a] = (1+I)·((a+I)^4)^k / (a²+1)^(2k)"];
Print[""];

Print["Testing with a = Cot[π/24] = 2+√2+√3+√6:"];
a24 = 2 + Sqrt[2] + Sqrt[3] + Sqrt[6];

z0 = circjAlg[0, a24];
Print["z₀ = ", N[z0, 5]];
Print["Testing period:");

Do[
  zk = circjAlg[k, a24];
  dist = Abs[N[zk - z0, 20]];
  If[dist < 10^-8 && k > 0,
    Print["  k = ", k, ": RETURNS! Distance = ", dist];
  ];
  If[k <= 15 || Mod[k, 3] == 0,
    Print["  k = ", k, ": distance = ", N[dist, 5]];
  ];
, {k, 1, 30}];

Print["\n=== COMPARISON: circjAlg vs My AlgebraicCirclePoint ===\n"];

(* My original construction *)
AlgebraicCirclePoint[k_, a_] := Module[{z},
  z = (a - I)^(4*k) / (1 + a^2)^(2*k);
  {Re[z], Im[z]}
];

Print["My construction: z = (a-I)^(4k) / (1+a²)^(2k)"];
Print["circjAlg:        z = (a-I)^(4k) / (a²+1)^(2k)"];
Print[""];
Print["THESE ARE IDENTICAL! Just different ordering of a²+1"];
Print[""];

Print["So circj[k, Rational[a,b]] with b=1 is exactly my construction!"];
Print[""];

Print["Verification with a = 2+√2+√3+√6:"];
Do[
  myZ = AlgebraicCirclePoint[k, a24];
  theirZ = circjAlg[k, a24];

  match = Abs[myZ[[1]] - Re[theirZ]] < 10^-10 && Abs[myZ[[2]] - Im[theirZ]] < 10^-10;

  Print["k = ", k, ": Match = ", match];
, {k, 0, 5}];

Print["\n=== SO WHAT IS circi? ===\n"];

Print["circi[k, a/b] = (1+I) · circj[k, a/b]"];
Print[""];
Print["This is just scaling by (1+I) = √2·e^(iπ/4)"];
Print["- Scales radius by √2"];
Print["- Rotates by 45°"];
Print[""];

Print["Testing with a = 2+√2+√3+√6:"];
Do[
  zj = circjAlg[k, a24];
  zi = circiAlg[k, a24];

  ratio = zi/zj;

  Print["k = ", k, ":"];
  Print["  circjAlg = ", N[zj, 4]];
  Print["  circiAlg = ", N[zi, 4]];
  Print["  ratio = ", N[ratio, 6], " (should be 1+I)"];
  Print["  |ratio| = ", N[Abs[ratio], 6], " (should be √2)"];
, {k, 0, 3}];
