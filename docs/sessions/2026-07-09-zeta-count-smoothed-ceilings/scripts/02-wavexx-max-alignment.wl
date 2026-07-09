waveX[p_, t_] := -(I/Pi) Log[1 - p^(-(1/2) + I t)] // Re
waveXX[x_, p_, r_] := ArcCot[Cot[x Log[p]] - Csc[x Log[p]]/r]

(* Step 0: sanity numeric check that waveXX matches Arg[1 - r Exp[i theta]] for 0<r<1 *)
argForm[x_, p_, r_] := ArcTan[1 - r Cos[x Log[p]], -r Sin[x Log[p]]]
Print["waveXX vs Arg(1-r e^{i theta}) numeric match: ",
 Table[
   Abs[waveXX[xx, pp, rr] - argForm[xx, pp, rr]] < 10^-9,
   {pp, {2, 5, 10}}, {rr, {0.2, 0.5, 0.8}}, {xx, {0.3, 1.7, -0.9, 3.1, 5.0}}
 ] // Flatten // Union]

(* Step 1: find critical points of waveXX wrt x for general 0<r<1, symbolically *)
deriv = D[argForm[x, p, r], x] // Simplify;
Print["derivative: ", deriv];
crit = Solve[deriv == 0 && 0 <= x Log[p] < 2 Pi, x, Reals];
Print["critical x (general p,r): ", crit];

(* Step 2: evaluate at the candidate maximum and simplify *)
thetaStarXX = -ArcCos[r];
maxValXX = argForm[thetaStarXX/Log[p], p, r] // Simplify;
Print["waveXX max value at theta=-ArcCos[r]: ", maxValXX];
Print["Compare to ArcSin[r]: ", Simplify[maxValXX - ArcSin[r], 0 < r < 1]];

(* Step 3: THE KEY QUESTION -- does r = 1/Sqrt[p] make (1/Pi) waveXX identical to waveX for ALL x, not just at the max? *)
identityCheck = Table[
   Abs[(1/Pi) waveXX[xx, pp, 1/Sqrt[pp]] - waveX[pp, xx]] < 10^-9,
   {pp, {2, 3, 5, 7, 20}}, {xx, RandomReal[{-10, 10}, 8]}
  ] // Flatten // Union;
Print["(1/Pi) waveXX[x,p,1/Sqrt[p]] == waveX[p,x] for all x? ", identityCheck]

(* Step 4: confirm argmax alignment condition r = 1/Sqrt[p] is the UNIQUE solution among 0<r<1 *)
Print["waveX argmax (in x): x* = -ArcCos[1/Sqrt[p]]/Log[p]"];
Print["waveXX argmax (in x): x* = -ArcCos[r]/Log[p]"];
Print["Equal iff ArcCos[r] == ArcCos[1/Sqrt[p]] iff r == 1/Sqrt[p] (ArcCos injective on (0,1))"];
