Get["/home/jan/github/orbit/Orbit/Kernel/PellChebyshevSolve.wl"];
regs = ToExpression /@ ReadList["/home/jan/github/zzz/build/reg100k.csv", String];

(* Find blue points with largest R/log(n) — these are "above" the pack *)
outliers = {};
Do[
  If[IntegerQ[Sqrt[n0]] || regs[[n0]] == 0, Continue[]];
  R = regs[[n0]];
  res = PellChebyshevSolve[n0];
  If[res =!= $Failed,
    ratio = R / Log[n0];
    AppendTo[outliers, {n0, R, ratio, res["c"], res["m"], res["r"], res["z"]}]],
{n0, 2, 10000}];

(* Sort by R/log(n) descending — biggest outliers first *)
outliers = Reverse@SortBy[outliers, #[[3]] &];

Print["=== TOP 30 BLUE OUTLIERS (highest R/log(n)) ===\n"];
Print[StringPadRight["n",6], StringPadRight["R",10],
  StringPadRight["R/ln(n)",8], StringPadRight["c",4],
  StringPadRight["m",4], StringPadRight["r",8], "z"];
Print[StringJoin[Table["-",{55}]]];
Do[
  {n0, R, rat, c, m, r, z} = outliers[[i]];
  Print[StringPadRight[ToString[n0],6],
    StringPadRight[ToString[Round[R,0.1]],10],
    StringPadRight[ToString[Round[rat,0.01]],8],
    StringPadRight[ToString[c],4],
    StringPadRight[ToString[m],4],
    StringPadRight[ToString[r],8],
    If[IntegerQ[z], ToString[z], ToString[N[z,4]]]],
{i, 1, 30}];

Print["\n=== WHAT MAKES THEM SPECIAL? ===\n"];
Print["m distribution of top 50 outliers: ",
  Tally[#[[5]] & /@ outliers[[;;50]]] // SortBy[-#[[2]]&]];
Print["c distribution: ",
  Tally[#[[4]] & /@ outliers[[;;50]]] // SortBy[-#[[2]]&]];
Print[];

(* The max R we can reach at each m level *)
Print["Max R/log(n) by m:"];
Do[
  sub = Select[outliers, #[[5]] == mm &];
  If[Length[sub] > 0,
    Print["  m=", mm, ": max R/log(n) = ", Round[sub[[1, 3]], 0.01],
      " at n=", sub[[1,1]], " (c=", sub[[1,4]], " r=", sub[[1,6]], ")"]],
{mm, {1, 2, 3, 4, 5, 6}}];

Print["\n=== CAN WE PUSH HIGHER? ===\n"];
Print["Theoretical max R/log(n) ~ m (Chebyshev degree)."];
Print["m=1: R/log(n) ~ 1.  m=2: ~2.  m=3: ~3."];
Print["The outliers with R/log(n) > 3 must have m ≥ 3 with large z.\n"];

(* Find the n with absolute largest R that we solve *)
maxR = First[outliers];
Print["Largest R solved: n=", maxR[[1]], " R=", Round[maxR[[2]], 0.1],
  " c=", maxR[[4]], " m=", maxR[[5]], " r=", maxR[[6]]];
