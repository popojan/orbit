(* h[n] = Wildberger seed = first convergent whose "distance" to sqrt(n)
   has integer 4/(n/h - h). Compare its denominator with our c. *)

h[n_] := First@Select[Drop[Convergents[ContinuedFraction[Sqrt[n], 50]], -1],
  IntegerQ[4/(n/# - #)] &, 1]

Get["/home/jan/github/orbit/Orbit/Kernel/PellChebyshevSolve.wl"];

Print["=== SEED DENOMINATOR vs CHEBYSHEV c ===\n"];
Print[StringPadRight["n", 5],
  StringPadRight["h[n]", 12],
  StringPadRight["denom(h)", 10],
  StringPadRight["c", 5],
  "match?"];
Print[StringJoin[Table["-", {50}]]];

Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  seed = Quiet[h[n0]];
  If[seed === Null || !NumericQ[seed], Continue[]];
  seedDenom = Denominator[seed];
  res = PellChebyshevSolve[n0];
  cVal = If[res =!= $Failed, res["c"], "-"];
  match = If[res =!= $Failed && seedDenom == cVal, "YES",
    If[res =!= $Failed, "no (c=" <> ToString[cVal] <> ")", "HARD"]];
  Print[StringPadRight[ToString[n0], 5],
    StringPadRight[ToString[seed], 12],
    StringPadRight[ToString[seedDenom], 10],
    StringPadRight[ToString[cVal], 5],
    match],
{n0, {2, 3, 5, 7, 8, 10, 12, 13, 17, 20, 21, 28, 29, 37, 41, 44,
      52, 53, 61, 67, 73, 83, 89, 97, 109, 127, 193, 916}}];

(* Broader test *)
Print["\n=== BATCH n = 2..200 ===\n"];
matchCount = 0; divCount = 0; totalCount = 0;
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  seed = Quiet[h[n0]];
  If[seed === Null || !NumericQ[seed], Continue[]];
  seedDenom = Denominator[seed];
  res = PellChebyshevSolve[n0];
  If[res =!= $Failed,
    totalCount++;
    cVal = res["c"];
    If[seedDenom == cVal, matchCount++];
    If[Mod[seedDenom, cVal] == 0 || Mod[cVal, seedDenom] == 0, divCount++]],
{n0, 2, 200}];

Print["Exact match (denom(h) = c): ", matchCount, "/", totalCount,
  " = ", Round[100. matchCount/totalCount, 0.1], "%"];
Print["Divisibility (one divides other): ", divCount, "/", totalCount,
  " = ", Round[100. divCount/totalCount, 0.1], "%"];
