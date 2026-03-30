pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["=== SCALING TRICK: solve c²n instead of n ===\n"];
Print["If (x, Y) solves x² - c²n·Y² = 1 and c|Y, then (x, Y/c) solves x²-n·y²=1\n"];

(* For a given n, try various c to see if c²n = a₀² + r with δ ≤ 2 *)
analyzeN[n0_] := Module[{results = {}},
  Do[
    cn = c^2 * n0;
    a0 = Floor[Sqrt[cn]];
    r = cn - a0^2;
    If[r > 0,
      z = (2a0^2 + r)/r;
      delta = Denominator[z];
      If[delta <= 2,
        AppendTo[results, {c, cn, a0, r, delta, z}]]],
  {c, 1, 50}];
  results
];

(* Test on hard cases: n that are NOT directly solvable *)
hardN = {7, 13, 19, 29, 37, 41, 43, 53, 61, 67, 71, 73, 79, 83, 89, 97};

Print["Hard n (not directly δ≤2):\n"];
Do[
  res = analyzeN[n0];
  If[Length[res] > 0,
    {c, cn, a0, r, delta, z} = res[[1]]; (* smallest c *)
    (* Compute Pell for c²n via Chebyshev *)
    w = 2a0/r;
    (* Find m *)
    mFound = 0; xSol = 0; ySol = 0;
    Do[
      xc = ChebyshevT[m, z];
      yc = w * ChebyshevU[m-1, z];
      If[IntegerQ[xc] && IntegerQ[yc],
        (* Check if c | yc *)
        If[Mod[yc, c] == 0,
          mFound = m; xSol = xc; ySol = yc/c; Break[]]],
    {m, 1, 30}];
    (* Verify *)
    {xa, ya} = pslv[n0];
    Print["  n=", StringPadRight[ToString[n0], 4],
      " c=", StringPadRight[ToString[c], 3],
      " c²n=", StringPadRight[ToString[cn], 7],
      " a₀=", StringPadRight[ToString[a0], 5],
      " r=", StringPadRight[ToString[r], 4],
      " δ=", delta,
      " m=", StringPadRight[ToString[mFound], 3],
      If[mFound > 0,
        " x=" <> ToString[xSol] <>
        " y=" <> ToString[ySol] <>
        If[xSol == xa && ySol == ya, " ✓", " (not fund, fund=" <> ToString[{xa,ya}] <> ")"],
        " no m found"]],
    Print["  n=", n0, " NO c ≤ 50 gives δ ≤ 2"]],
{n0, hardN}];

Print["\n=== COVERAGE BOOST ===\n"];

(* Count: for n ≤ N, how many are solvable with c ≤ C? *)
Nmax = 10000;
Do[
  solvable = 0;
  Do[
    If[!IntegerQ[Sqrt[n0]],
      found = False;
      Do[
        cn = c^2 * n0;
        a0 = Floor[Sqrt[cn]];
        r = cn - a0^2;
        If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
          found = True; Break[]],
      {c, 1, cmax}];
      If[found, solvable++]],
  {n0, 2, Nmax}];
  total = Nmax - 1 - Floor[Sqrt[Nmax]];
  Print["  c ≤ ", StringPadRight[ToString[cmax], 4],
    ": ", solvable, "/", total, " = ",
    Round[100. solvable/total, 0.1], "%"],
{cmax, {1, 2, 3, 5, 10, 20, 50}}];

Print["\n=== WHAT DOES c BUY? ===\n"];
Print["c=1: direct (n = a₀²+r, δ≤2)"];
Print["c=2: try 4n = a₀²+r (n near quarter-square)"];
Print["c=3: try 9n = a₀²+r (n near ninth-square)"];
Print["c=p: try p²n = a₀²+r"];
Print["Each c adds n values that are near (a₀/c)² — i.e., near rational squares.\n"];

(* What n ≤ 100 are STILL uncovered even with c ≤ 50? *)
Print["Uncovered n ≤ 200 even with c ≤ 50:"];
uncov = {};
Do[
  If[!IntegerQ[Sqrt[n0]],
    found = False;
    Do[cn = c^2*n0; a0=Floor[Sqrt[cn]]; r=cn-a0^2;
      If[r>0 && Denominator[(2a0^2+r)/r]<=2, found=True; Break[]],
    {c, 1, 50}];
    If[!found, AppendTo[uncov, n0]]],
{n0, 2, 200}];
Print[uncov];
Print["Count: ", Length[uncov], " out of ", 200 - 1 - Floor[Sqrt[200]]];
