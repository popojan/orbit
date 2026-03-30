pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["══════════════════════════════════════════════════════════════"];
Print["  ELEGANT PARAMETERIZATION of R-D families"];
Print["══════════════════════════════════════════════════════════════\n"];

(* For even r = 2s: n = s²t² + 2s, x = st² + 1, y = t *)
Print["EVEN r = 2s:  n = s²t² + 2s,   x = st² + 1,   y = t\n"];
Do[
  fails = 0;
  Do[
    n = s^2*t^2 + 2s;
    If[!IntegerQ[Sqrt[n]],
      {xa, ya} = pslv[n];
      If[xa != s*t^2+1 || ya != t, fails++];
    ],
  {t, 1, 50}];
  Print["  r=", 2s, " (s=", s, "):  n = ", s^2, "t²+", 2s,
    ",  x = ", s, "t²+1,  y = t",
    "     verified t=1..50  ", If[fails==0, "✓", "✗ ("<>ToString[fails]<>" fails)"]];
, {s, {1, 2, 3, 4, 5, 6, 7, 8}}];

Print[];

(* For odd r: n = r²u² + r, x = 2ru² + 1, y = 2u *)
Print["ODD r:  n = r²u² + r,   x = 2ru² + 1,   y = 2u\n"];
Do[
  fails = 0;
  Do[
    n = r^2*u^2 + r;
    If[!IntegerQ[Sqrt[n]],
      {xa, ya} = pslv[n];
      If[xa != 2r*u^2+1 || ya != 2u, fails++];
    ],
  {u, 1, 50}];
  Print["  r=", r, ":  n = ", r^2, "u²+", r,
    ",  x = ", 2r, "u²+1,  y = 2u",
    "     verified u=1..50  ", If[fails==0, "✓", "✗ ("<>ToString[fails]<>" fails)"]];
, {r, {1, 3, 5, 7, 9, 11, 13, 15}}];

Print[];
Print["══════════════════════════════════════════════════════════════"];
Print["  PROOF (algebraic identity)"];
Print["══════════════════════════════════════════════════════════════\n"];

Print["Even r=2s:"];
Print["  x² - n·y² = (st²+1)² - (s²t²+2s)·t²"];
Print["           = s²t⁴ + 2st² + 1 - s²t⁴ - 2st² = 1  ■\n"];

Print["Odd r:"];
Print["  x² - n·y² = (2ru²+1)² - (r²u²+r)·4u²"];
Print["           = 4r²u⁴ + 4ru² + 1 - 4r²u⁴ - 4ru² = 1  ■\n"];

Print["══════════════════════════════════════════════════════════════"];
Print["  ASYMPTOTIC R/log(n)"];
Print["══════════════════════════════════════════════════════════════\n"];

Print["R = log(x + y√n) = log((2a₀²+r)/r + (2a₀/r)·√(a₀²+r))"];
Print["  ≈ log(4a₀²/r) = log(n) + log(4/r)   as a₀ → ∞\n"];
Print["  R/log(n) → 1 + log(4/r)/(2·log a₀) → 1\n"];

Do[
  ratios = Table[
    n = If[EvenQ[r],
      With[{s=r/2}, s^2*t^2 + 2s],
      r^2*t^2 + r];
    x0 = If[EvenQ[r],
      With[{s=r/2}, s*t^2 + 1],
      2r*t^2 + 1];
    y0 = If[EvenQ[r], t, 2t];
    Log[N[x0 + y0*Sqrt[n], 30]] / Log[N[n, 30]],
  {t, 5, 200}];
  Print["  r=", StringPadRight[ToString[r],3],
    "  R/log(n) → ", Round[Mean[ratios], 0.001],
    "   correction ≈ log(4/", r, ")/2 = ", Round[N[Log[4/r]/2], 0.001]];
, {r, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 16}}];

Print[];
Print["══════════════════════════════════════════════════════════════"];
Print["  COVERAGE: how much of n ≤ N falls into R-D families?"];
Print["══════════════════════════════════════════════════════════════\n"];

(* For each N, count how many non-square n have an R-D representation *)
Do[
  rdSet = {};
  (* Even r=2s, s=1..8 *)
  Do[Do[
    n = s^2*t^2 + 2s;
    If[n <= nmax && !IntegerQ[Sqrt[n]], AppendTo[rdSet, n]],
  {t, 1, Ceiling[Sqrt[nmax]]}], {s, 1, 8}];
  (* Odd r, r=1..15 *)
  Do[Do[
    n = r^2*u^2 + r;
    If[n <= nmax && !IntegerQ[Sqrt[n]], AppendTo[rdSet, n]],
  {u, 1, Ceiling[Sqrt[nmax]]}], {r, 1, 15, 2}];
  rdSet = Union[rdSet];
  total = nmax - Floor[Sqrt[nmax]]; (* non-squares up to nmax *)
  Print["  n ≤ ", nmax, ":  ", Length[rdSet], "/", total, " = ",
    Round[100. Length[rdSet]/total, 0.1], "% in R-D (r ≤ 16)"];
, {nmax, {100, 1000, 10000, 100000}}];

Print[];
Print["══════════════════════════════════════════════════════════════"];
Print["  FINAL COMPACT TABLE"];
Print["══════════════════════════════════════════════════════════════\n"];

Print["┌─────┬────────────────────┬──────────────┬───────┬───────────┐"];
Print["│  r  │  n                 │  x           │  y    │ R−log(n)  │"];
Print["├─────┼────────────────────┼──────────────┼───────┼───────────┤"];
Do[
  If[EvenQ[r],
    With[{s=r/2},
      Print["│ ", StringPadRight[ToString[r],3],
        " │  ", StringPadRight[ToString[s^2]<>"t²+"<>ToString[2s], 18],
        " │  ", StringPadRight[ToString[s]<>"t²+1", 12],
        " │  ", StringPadRight["t", 5],
        " │ ", StringPadRight[ToString@Round[N@Log[4/r],0.001], 9], " │"]
    ],
    Print["│ ", StringPadRight[ToString[r],3],
      " │  ", StringPadRight[ToString[r^2]<>"u²+"<>ToString[r], 18],
      " │  ", StringPadRight[ToString[2r]<>"u²+1", 12],
      " │  ", StringPadRight["2u", 5],
      " │ ", StringPadRight[ToString@Round[N@Log[4/r],0.001], 9], " │"]
  ],
{r, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 16}}];
Print["└─────┴────────────────────┴──────────────┴───────┴───────────┘"];
Print["  R ≈ log(n) + log(4/r) = log(4n/r)"];
