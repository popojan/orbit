waveX[p_, t_] := -(I/Pi) Log[1 - p^(-(1/2) + I t)] // Re

(* Step 1: turn Re[Log[...]] into elementary real functions using ComplexExpand under p>1 assumption *)
elem = Assuming[p > 1 && t \[Element] Reals, ComplexExpand[waveX[p, t], TargetFunctions -> {Re, Im}]];
Print["Elementary form: ", elem // Simplify];

(* Step 2: also derive by hand: waveX == (1/Pi) Arg[1 - p^(-1/2+I t)] *)
handForm = ArcTan[1 - p^(-1/2) Cos[t Log[p]], -p^(-1/2) Sin[t Log[p]]]/Pi;
Print["Hand-derived Arg form matches numerically: ",
  Table[Abs[(elem /. p -> pp /. t -> tt) - (handForm /. p -> pp /. t -> tt)] < 10^-10,
   {pp, {2, 5, 10}}, {tt, {0.3, 1.1, -0.7, 2.9}}] // Flatten // Union];

(* Step 3: find critical points of elem wrt t *)
deriv = D[elem, t] // Simplify;
Print["Derivative: ", deriv];

crit = Solve[deriv == 0 && 0 <= t Log[p] < 2 Pi, t, Reals];
Print["Critical points (symbolic, general p): ", crit];

(* Step 4: direct approach via the theta substitution cos(theta)=1/Sqrt[p] *)
thetaStar = -ArcCos[1/Sqrt[p]];
maxVal = handForm /. t -> thetaStar/Log[p] // Simplify;
Print["Value at theta* = -ArcCos[1/Sqrt[p]]: ", maxVal];
Print["Compare to ArcSin[1/Sqrt[p]]/Pi: ", Simplify[maxVal - ArcSin[1/Sqrt[p]]/Pi]];

(* Step 5: numeric check that this really is the GLOBAL max over one period, for a few p values *)
Do[
  tstar = -ArcCos[1/Sqrt[pp]]/Log[pp];
  numMax = NMaximize[{waveX[pp, t], 0 <= t <= 2 Pi/Log[pp]}, t];
  Print["p=", pp, "  candidate t*=", N[tstar], " value=", N[waveX[pp, tstar]],
        "   NMaximize -> ", numMax],
  {pp, {2, 3, 7, 50}}
]

(* follow-up: confirm the ArcTan two-arg value equals ArcSin[1/Sqrt[p]] for p>1 *)
expr = ArcTan[(-1 + p)/p, Sqrt[(-1 + p)/p]/Sqrt[p]];
Print[FullSimplify[expr - ArcSin[1/Sqrt[p]], p > 1]];
Print[Table[N[expr /. p -> pp] - N[ArcSin[1/Sqrt[pp]]], {pp, {2, 3, 7, 50, 1.5}}]];

(* also confirm the period *)
Print["Period T = 2 Pi/Log[p]"];

(* full closed-form summary *)
Print["MAX VALUE = ArcSin[1/Sqrt[p]]/Pi"];
Print["ARGMAX (principal, within one period) t* = -ArcCos[1/Sqrt[p]]/Log[p]  (mod 2 Pi/Log[p])"];
Print["equivalently t* = (2 Pi - ArcCos[1/Sqrt[p]])/Log[p] within [0, period)"];
