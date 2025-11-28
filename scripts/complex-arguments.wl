(* Obecné komplexní argumenty s = a + bi *)

Print["=== Komplexní argumenty s = a + bi ===\n"];

Print["Klíčové pozorování: Re(2^k · s) = 2^k · Re(s) = 2^k · a\n"];

Print["Případy podle a = Re(s):"];
Print["  a > 1:   Konverguje hned"];
Print["  a = 1:   Hranice, ale 2s má Re = 2 > 1"];
Print["  0 < a < 1: Po k krocích kde 2^k·a > 1"];
Print["  a = 0:   Nikdy (ryze imaginární)"];
Print["  a < 0:   Jde do -∞\n"];

(* Kolik kroků potřebujeme pro vstup do oblasti konvergence? *)
stepsToConvergence[a_] := If[a <= 0, Infinity,
  If[a > 1, 0, Ceiling[Log[2, 1/a]]]
]

Print["=== Počet kroků k pro 2^k·a > 1 ===\n"];
testA = {2, 1, 3/4, 1/2, 1/3, 1/4, 1/5, 1/10, 0, -1/3};
Do[
  k = stepsToConvergence[a];
  If[k === Infinity,
    Print["a = ", a, ": nikdy (Re ≤ 0)"],
    Print["a = ", a, ": k = ", k, " kroků (2^k·a = ", 2^k a, ")"]
  ];
, {a, testA}];

Print["\n=== Příklad: s = 1 + ti ===\n"];

t = 2;
s = 1 + t I;

Print["s = ", s];
Print["Re(s) = 1 (hranice konvergence)\n"];

Print["Řetězec zdvojování:"];
chain = Table[
  {k, 2^k s, Re[2^k s], N[Zeta[2^k s], 8]},
  {k, 0, 4}
];
Do[
  Print["  k=", row[[1]], ": 2^k·s = ", row[[2]],
        ", Re = ", row[[3]],
        If[row[[3]] > 1, " ✓", " (hranice)"],
        ", ζ = ", row[[4]]];
, {row, chain}];

Print["\nPro k ≥ 1: Re(2^k·s) = 2^k > 1 → konverguje!"];

Print["\n=== Příklad: s = 1/2 + ti (kritická přímka) ===\n"];

s = 1/2 + 14.134725 I;  (* blízko první nuly *)

Print["s = ", N[s, 8]];
Print["Re(s) = 1/2 (kritická přímka)\n"];

chain = Table[
  {k, N[2^k s, 6], N[Re[2^k s], 4], N[Zeta[2^k s], 8]},
  {k, 0, 3}
];
Do[
  re = row[[3]];
  Print["  k=", row[[1]], ": Re = ", re,
        If[re > 1, " ✓ konverguje", ""]];
, {row, chain}];

Print["\nPro k = 1: Re = 1 (hranice)"];
Print["Pro k ≥ 2: Re > 1 → konverguje"];

Print["\n=== Uzavření řetězce pro komplexní s ===\n"];

Print["Podmínka: 2^k·s = 1 - s"];
Print["Pro s = a + bi:"];
Print["  Reálná část:  2^k·a = 1 - a  →  a = 1/(2^k + 1)"];
Print["  Imag. část:   2^k·b = -b    →  b(2^k + 1) = 0  →  b = 0"];
Print["\n→ Uzavření POUZE pro reálná s = 1/(2^k + 1)!"];
Print["→ Pro komplexní s se řetězec NIKDY neuzavře."];

Print["\n=== Ale: řetězec se 'otevře' do konvergence ===\n"];

(* Pro a > 0 se dostaneme do konvergence *)
testS = {1/3 + I, 1/2 + 2 I, 1/4 + 3 I, 1/5 + I};

Do[
  a = Re[s]; b = Im[s];
  k = stepsToConvergence[a];
  Print["s = ", s];
  Print["  Re(s) = ", a];
  Print["  Kroků do konvergence: k = ", k];
  Print["  2^k·s = ", 2^k s, ", Re = ", 2^k a];
  Print["  ζ(2^k·s) = ", N[Zeta[2^k s], 8], " (konverguje)"];
  Print[];
, {s, testS}];

Print["=== L_P identita pro komplexní argumenty ===\n"];

LP[s_] := (Zeta[s]^2 - Zeta[2s])/2;

s = 1/3 + I;
Print["Pro s = ", s, ":\n"];

(* Řetězec *)
Print["Řetězec:"];
chain = Table[{k, 2^k s, Re[2^k s]}, {k, 0, 4}];
Do[
  re = row[[3]];
  conv = If[re > 1, "konverguje", "nekonverguje"];
  Print["  k=", row[[1]], ": 2^k·s = ", row[[2]], ", Re = ", re, " → ", conv];
, {row, chain}];

Print["\nL_P hodnoty:"];
Do[
  arg = 2^k s;
  re = Re[arg];
  If[re > 1,
    Print["  L_P(", arg, "): Re = ", re, " > 1 → Dirichletova řada konverguje"],
    Print["  L_P(", arg, "): Re = ", re, " ≤ 1 → potřebuje anal. pokračování"]
  ];
, {k, 0, 3}];

Print["\n=== Shrnutí pro komplexní s = a + bi ===\n"];
Print["1. Uzavření řetězce: POUZE pro reálná s = 1/(2^n+1)"];
Print["2. Pro a > 0: řetězec vstoupí do konvergence po ⌈log₂(1/a)⌉ krocích"];
Print["3. Pro a = 0: nikdy nevstoupí (ryze imaginární)"];
Print["4. Pro a < 0: funkcionální rovnice dává přímou cestu"];
Print["\n5. Kritická přímka Re(s) = 1/2:"];
Print["   - k=0: Re = 1/2 (nekonverguje)"];
Print["   - k=1: Re = 1 (hranice)"];
Print["   - k≥2: Re ≥ 2 (konverguje)"];
