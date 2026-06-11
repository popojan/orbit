(* 13b_exact_J32.wl -- exact algebraic J(3/2) via Root objects (2026-06-11).
   Note: the reduced quartic for slope 3/2 is t^4+t^3+t^2-3t+1
   (the paper's t^4+2t^3-2t^2-2t+1 is an erratum: it vanishes at t=1 and
   factors as (t^2+2t-1)(t^2-1), unrelated to the master equation).
   Check: t^5-4t^2+4t-1 = (t-1)(t^4+t^3+t^2-3t+1). *)

quart = #^4 + #^3 + #^2 - 3 # + 1 &;
Print["division check: ",
  Expand[(tVar - 1) (tVar^4 + tVar^3 + tVar^2 - 3 tVar + 1) -
    (tVar^5 - 4 tVar^2 + 4 tVar - 1)]];

allR = Table[Root[quart, i], {i, 1, 4}];
sub = Select[allR, Abs[N[#]] < 1 &];
Print["sub-unit roots (numeric): ", N[sub, 12]];

rise = {1, 2}; s0 = 1; j0 = 1;
amps = Table[
  If[j == 0, 1, Product[(2 sub[[i]] - 1)/sub[[i]]^(rise[[m + 1]] + 1),
    {m, 0, j - 1}]], {j, 0, 1}, {i, 2}];
matStd = Table[amps[[j + 1, i]]/sub[[i]], {j, 0, 1}, {i, 2}];
matMod = Table[If[j == 0, amps[[1, i]], amps[[j + 1, i]]/sub[[i]]],
  {j, 0, 1}, {i, 2}];
cS = LinearSolve[matStd, {1, 1}];
cM = LinearSolve[matMod, {1, 1}];
cVal = (1 - Sum[cS[[i]] amps[[j0 + 1, i]] sub[[i]]^s0, {i, 2}])/2;
cLeft = (1 - Sum[cM[[i]] amps[[j0 + 1, i]] sub[[i]]^s0, {i, 2}])/2;
Print["C(3/2)  numeric: ", N[RootReduce[cVal], 20], "  (ref 0.2518481658)"];
Print["C-(3/2) numeric: ", N[RootReduce[cLeft], 20], "  (ref 0.2245558818)"];
jEx = RootReduce[cVal - cLeft];
Print["J(3/2) exact: ", jEx];
Print["J(3/2) numeric: ", N[jEx, 20]];
Print["MinimalPolynomial[J(3/2)]: ", MinimalPolynomial[jEx, x]];
Print["MinimalPolynomial[C-(3/2)]: ", MinimalPolynomial[RootReduce[cLeft], x]];
