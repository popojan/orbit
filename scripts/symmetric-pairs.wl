(* Dvojice ζ(-p/q) a ζ(+p/q) *)

Print["=== Dvojice ζ(-p/q) a ζ(+p/q) ===\n"];

(* Funkcionální rovnice *)
f[s_] := 2^s Pi^(s-1) Sin[Pi s/2] Gamma[1-s]

(* L_P funkce *)
LP[s_] := (Zeta[s]^2 - Zeta[2s])/2

Print["Pro s = p/q ∈ (0,1):\n"];
Print["  ζ(-p/q) = f(-p/q) · ζ(1+p/q)  [FR → konvergentní]"];
Print["  ζ(+p/q) = řetězec zdvojování  [kombinatorická struktura]\n"];

(* Speciální bod s = 1/3 *)
Print["=== Příklad: s = 1/3 ===\n"];

s = 1/3;
Print["--- ζ(-1/3) přes FR ---"];
Print["ζ(-1/3) = f(-1/3) · ζ(4/3)"];
Print["  f(-1/3) = ", N[f[-s], 10]];
Print["  ζ(4/3) = ", N[Zeta[1+s], 10], " (konvergentní řada)"];
Print["  ζ(-1/3) = ", N[Zeta[-s], 10]];
Print["  Ověření: ", N[f[-s] Zeta[1+s], 10]];

Print["\n--- ζ(+1/3) přes kombinatoriku ---"];
Print["ζ(1/3)² = 2·L_P(1/3) + ζ(2/3)"];
Print["ζ(2/3) = f(1/3) · ζ(1/3)  [FR uzavírá řetězec!]"];
Print["  ζ(1/3) = ", N[Zeta[s], 10]];
Print["  ζ(2/3) = ", N[Zeta[2s], 10]];
Print["  f(1/3) = ", N[f[s], 10]];
Print["  L_P(1/3) = ", N[LP[s], 10]];

Print["\n--- Kombinace ---"];
Print["ζ(1/3)² - f(1/3)·ζ(1/3) = 2·L_P(1/3)"];
lhs = Zeta[s]^2 - f[s] Zeta[s];
rhs = 2 LP[s];
Print["  LHS = ", N[lhs, 10]];
Print["  RHS = ", N[rhs, 10]];

Print["\n=== Vztah mezi ζ(-s) a ζ(s) ===\n"];

(* Pro speciální body *)
specialS = {1/3, 1/5, 1/9};

Do[
  Print["--- s = ", s, " ---"];

  (* ζ(-s) *)
  zetaNeg = Zeta[-s];
  zetaNegViaFR = f[-s] Zeta[1+s];

  (* ζ(s) *)
  zetaPos = Zeta[s];

  (* Poměr *)
  ratio = zetaNeg / zetaPos;

  Print["ζ(-", s, ") = ", N[zetaNeg, 10]];
  Print["ζ(+", s, ") = ", N[zetaPos, 10]];
  Print["ζ(-s)/ζ(s) = ", N[ratio, 10]];

  (* Teoretický poměr z FR *)
  (* ζ(-s) = f(-s) ζ(1+s), ζ(s) = f(s) ζ(1-s) *)
  (* ζ(-s)/ζ(s) = [f(-s) ζ(1+s)] / [f(s) ζ(1-s)] *)
  theoreticalRatio = f[-s] Zeta[1+s] / (f[s] Zeta[1-s]);
  Print["Teoreticky: f(-s)ζ(1+s) / f(s)ζ(1-s) = ", N[theoreticalRatio, 10]];
  Print[];
, {s, specialS}];

Print["=== L_P pro záporné vs kladné argumenty ===\n"];

s = 1/3;
Print["s = ", s, ":\n"];

(* L_P(-s) *)
LPneg = LP[-s];
Print["L_P(-1/3) = (ζ(-1/3)² - ζ(-2/3))/2"];
Print["  ζ(-1/3) = f(-1/3)·ζ(4/3) = ", N[f[-s] Zeta[1+s], 8]];
Print["  ζ(-2/3) = f(-2/3)·ζ(5/3) = ", N[f[-2s] Zeta[1+2s], 8]];
Print["  L_P(-1/3) = ", N[LPneg, 10]];

(* Vyjádření L_P(-s) čistě přes konvergentní hodnoty *)
LPnegExpanded = (f[-s]^2 Zeta[1+s]^2 - f[-2s] Zeta[1+2s])/2;
Print["  = (f(-1/3)²·ζ(4/3)² - f(-2/3)·ζ(5/3))/2 = ", N[LPnegExpanded, 10]];

Print["\nL_P(+1/3) = (ζ(1/3)² - ζ(2/3))/2"];
LPpos = LP[s];
Print["  L_P(+1/3) = ", N[LPpos, 10]];

Print["\nPoměr L_P(-s)/L_P(s) = ", N[LPneg/LPpos, 10]];

Print["\n=== Symetrická tabulka ===\n"];

Print["| s | ζ(-s) | ζ(+s) | L_P(-s) | L_P(+s) |"];
Print["|---|-------|-------|---------|---------|"];
testS = {1/3, 1/5, 1/9, 1/17, 2/5, 3/7};
Do[
  zN = N[Zeta[-s], 6];
  zP = N[Zeta[s], 6];
  lpN = N[LP[-s], 6];
  lpP = N[LP[s], 6];
  Print["| ", s, " | ", zN, " | ", zP, " | ", lpN, " | ", lpP, " |"];
, {s, testS}];

Print["\n=== Explicitní vyjádření pro s_n = 1/(2^n+1) ===\n"];

(* Pro speciální body máme uzavřený systém *)
Print["Pro s = 1/3 = 1/(2¹+1):\n"];

s = 1/3;
Print["ζ(-1/3):"];
Print["  = f(-1/3) · ζ(4/3)"];
Print["  = ", N[f[-s], 6], " · ", N[Zeta[4/3], 6]];
Print["  = ", N[Zeta[-s], 10]];

Print["\nζ(+1/3):"];
Print["  ζ(1/3)² = 2·L_P(1/3) + f(1/3)·ζ(1/3)"];
Print["  ζ(1/3)·(ζ(1/3) - f(1/3)) = 2·L_P(1/3)"];
Print["  kde L_P(1/3) = (ζ(1/3)² - f(1/3)·ζ(1/3))/2  [tautologie]"];

Print["\n--- Ale můžeme vyjádřit vzájemně! ---"];

(* ζ(-s) / ζ(s) *)
Print["\nζ(-1/3) / ζ(1/3) = f(-1/3)·ζ(4/3) / ζ(1/3)"];
ratio = Zeta[-s] / Zeta[s];
Print["  = ", N[ratio, 10]];

(* Pomocí FR pro ζ(1/3) *)
Print["\nζ(1/3) = ζ(2/3) / f(1/3) = f(1/3)·ζ(1/3) / f(1/3) [kruhové]"];
Print["ALE: ζ(1/3)·ζ(2/3) lze vyjádřit!");

prod = Zeta[s] Zeta[2s];
Print["ζ(1/3)·ζ(2/3) = ", N[prod, 10]];
Print["             = ζ(1/3) · f(1/3) · ζ(1/3) = f(1/3)·ζ(1/3)²"];

Print["\n=== Součin ζ(-s)·ζ(s) ===\n"];

Do[
  prod = Zeta[-s] Zeta[s];
  Print["ζ(-", s, ")·ζ(", s, ") = ", N[prod, 10]];
, {s, {1/3, 1/5, 1/9}}];

Print["\n=== Reflexní formule ===\n"];

Print["Z FR: ζ(s)·ζ(1-s) = ζ(s) · f(s)·ζ(s) / ... [komplikované]"];
Print["\nAle existuje elegantní vztah přes Γ funkci:"];
Print["ζ(s)·ζ(1-s) souvisí s Γ(s)·Γ(1-s) = π/sin(πs)"];

s = 1/3;
Print["\nPro s = 1/3:"];
Print["Γ(1/3)·Γ(2/3) = π/sin(π/3) = ", N[Pi/Sin[Pi/3], 10]];
Print["             = 2π/√3 = ", N[2 Pi/Sqrt[3], 10]];
