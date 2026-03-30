Get["/home/jan/github/orbit/Orbit/Kernel/PellChebyshevSolve.wl"];

(* Load PARI regulators as ground truth *)
regs = ToExpression /@ ReadList["/home/jan/github/zzz/build/reg100k.csv", String];

Nmax = 100000;
solved = 0; hard = 0; wrong = 0; fundCount = 0;
timeChebyshev = 0; timePslv = 0;
errLog = {};

(* Batch: PellChebyshevSolve on n = 2..Nmax *)
Print["Running PellChebyshevSolve on n = 2..", Nmax, "...\n"];

t0 = AbsoluteTime[];
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  res = PellChebyshevSolve[n0];
  If[res =!= $Failed,
    solved++;
    (* Verify via regulator *)
    Rcomputed = Log[N[res["x"] + res["y"] * Sqrt[n0], 30]];
    Rexpected = regs[[n0]];
    (* PARI returns field regulator: if norm-1 exists, R_pari = R_pell/2 *)
    ratio = Rcomputed / Rexpected;
    If[Abs[ratio - 1] < 0.001, fundCount++,
      If[Abs[ratio - 2] < 0.001, fundCount++, (* norm-1: our R = 2*R_pari *)
        AppendTo[errLog, {n0, Round[ratio, 0.001], res["c"], res["m"]}]]],
    hard++],
{n0, 2, Nmax}];
tTotal = AbsoluteTime[] - t0;

Print["=== RESULTS: n = 2..", Nmax, " ===\n"];
Print["Solved:      ", solved, " / ", Nmax - Floor[Sqrt[Nmax]] - 1];
Print["Coverage:    ", Round[100. solved / (Nmax - Floor[Sqrt[Nmax]] - 1), 0.1], "%"];
Print["Fundamental: ", fundCount, " (", Round[100. fundCount / Max[solved, 1], 0.1], "% of solved)"];
Print["Mismatches:  ", Length[errLog]];
Print["Hard:        ", hard];
Print["Total time:  ", Round[tTotal, 0.1], "s"];
Print["Per n:       ", Round[1000 tTotal / Nmax, 0.01], "ms"];

If[Length[errLog] > 0,
  Print["\nFirst 20 mismatches (n, R_ours/R_pari, c, m):"];
  Print[errLog[[;;Min[20, Length[errLog]]]]];
];

(* Timing comparison on a subset *)
Print["\n=== TIMING COMPARISON (sample) ===\n"];
sample = Select[Range[2, 10000], !IntegerQ[Sqrt[#]] &][[;;500]];
tCheb = 0; tPslv = 0; nCheb = 0;
Do[
  {tc, rc} = AbsoluteTiming[PellChebyshevSolve[n0]];
  If[rc =!= $Failed,
    nCheb++;
    tCheb += tc;
    {tp, rp} = AbsoluteTiming[
      {x, y} /. First@FindInstance[x x - n0 y y == 1, {x, y}, PositiveIntegers]];
    tPslv += tp],
{n0, sample}];

Print["On ", nCheb, " solvable n out of ", Length[sample], ":"];
Print["  PellChebyshevSolve total: ", Round[1000 tCheb, 0.1], "ms"];
Print["  FindInstance total:       ", Round[1000 tPslv, 0.1], "ms"];
Print["  Speedup:                  ", Round[tPslv / Max[tCheb, 0.001], 1], "x"];
