(* Spojení Bessel funkcí s exponenciálou *)

Print["=== Connection: K_ν and exponential ==="];

(* Asymptotika K_ν(x) pro velké x *)
Print["\nAsymptotic: K_ν(x) ~ √(π/2x) e^{-x} for large x"];

(* Speciální hodnoty K pro poloceločíselné řády *)
Print["\n=== K_{n+1/2}(x) - closed form via exponentials ==="];
Table[
  Print["K_{", n, "+1/2}(x) = ", FullSimplify[BesselK[n + 1/2, x]]];
  , {n, -2, 3}
];

(* K_{1/2}(x) = √(π/2x) e^{-x} *)
Print["\nVerify K_{1/2}(x) = √(π/2x) e^{-x}: ", 
  FullSimplify[BesselK[1/2, x] - Sqrt[Pi/(2x)] Exp[-x]]];

(* Naše suma pro e *)
Print["\n=== Our sum for e ==="];
Print["e = Σ_{n=0}^∞ p_n/q_n where convergents come from CF"];

(* Rekurentní vztah pro convergenty *)
Print["\n=== Trying to connect recurrence to ODE ==="];

(* Definujme f(ν) = K_ν(-1/2) *)
Print["\nLet f(ν) = K_ν(-1/2)"];
Print["Then g(z) = -16πe·z / [f(2z-1)·f(2z+1)]"];

(* Derivace f podle ν *)
Print["\n∂f/∂ν evaluated symbolically:"];
dfdnu = D[BesselK[nu, -1/2], nu];
Print["∂K_ν(-1/2)/∂ν = ", dfdnu];

(* Wronskián *)
Print["\n=== Wronskian of I_ν, K_ν ==="];
Print["W[I_ν, K_ν](x) = I_ν K'_ν - I'_ν K_ν = -1/x"];
wronskian = BesselI[nu, x] D[BesselK[nu, x], x] - D[BesselI[nu, x], x] BesselK[nu, x];
Print["Check: ", FullSimplify[wronskian]];

(* Spojení s e přes I a K *)
Print["\n=== Connection via I_ν and K_ν at x = 1/2 ==="];
Print["I_0(1/2) = ", N[BesselI[0, 1/2], 20]];
Print["K_0(1/2) = ", N[BesselK[0, 1/2], 20]];
Print["I_0(1/2) / K_0(1/2) = ", N[BesselI[0, 1/2]/BesselK[0, 1/2], 20]];

(* coth(1/2) = (e+1)/(e-1) *)
Print["\ncoth(1/2) = (e+1)/(e-1) = ", N[Coth[1/2], 20]];
Print["e = ", N[E, 20]];

