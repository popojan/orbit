(* Součin ζ(-s)·ζ(s) a jeho limit *)

Print["=== Součin ζ(-s)·ζ(s) → 1/4 ? ===\n"];

f[s_] := 2^s Pi^(s-1) Sin[Pi s/2] Gamma[1-s]

(* Zdá se, že ζ(-s)·ζ(s) → 1/4 pro s → 0 *)
testS = Table[1/(2^n + 1), {n, 1, 10}];

Print["| s | ζ(-s)·ζ(s) | odchylka od 1/4 |"];
Print["|---|------------|-----------------|"];
Do[
  prod = Zeta[-s] Zeta[s];
  diff = prod - 1/4;
  Print["| ", s, " | ", N[prod, 10], " | ", N[diff, 6], " |"];
, {s, testS}];

Print["\n=== Limit pro s → 0 ===\n"];

(* ζ(0) = -1/2, ζ(-0) = ζ(0) = -1/2 *)
Print["ζ(0) = ", Zeta[0], " = -1/2"];
Print["ζ(0)² = ", Zeta[0]^2, " = 1/4  ✓\n"];

Print["Takže ζ(-s)·ζ(s) → ζ(0)² = 1/4 pro s → 0.\n"];

Print["=== Klíčový vztah ===\n"];

Print["Ověřeno numericky:"];
Print["  ζ(-s)·ζ(1-s) / (ζ(s)·ζ(1+s)) = f(-s)/f(s)\n"];

s = 1/3;
lhs = Zeta[-s] Zeta[1-s] / (Zeta[s] Zeta[1+s]);
rhs = f[-s] / f[s];
Print["Pro s = 1/3:"];
Print["  LHS = ", N[lhs, 12]];
Print["  RHS = f(-1/3)/f(1/3) = ", N[rhs, 12]];
Print["  Rozdíl = ", N[lhs - rhs, 6]];

Print["\n=== Přeformulování ===\n"];

Print["Z ζ(-s) = f(-s)·ζ(1+s) a ζ(s) = f(s)·ζ(1-s):\n"];
Print["  ζ(-s)/ζ(s) = [f(-s)/f(s)] · [ζ(1+s)/ζ(1-s)]\n"];

Print["Definujme R(s) = ζ(1+s)/ζ(1-s) [poměr KONVERGENTNÍCH hodnot]\n"];

Do[
  R = Zeta[1+s] / Zeta[1-s];
  fRatio = f[-s] / f[s];
  zetaRatio = Zeta[-s] / Zeta[s];
  Print["s = ", s, ":"];
  Print["  R(s) = ζ(1+s)/ζ(1-s) = ", N[R, 10]];
  Print["  f(-s)/f(s) = ", N[fRatio, 10]];
  Print["  ζ(-s)/ζ(s) = ", N[zetaRatio, 10]];
  Print["  Ověření: (f(-s)/f(s))·R(s) = ", N[fRatio R, 10]];
  Print[];
, {s, {1/3, 1/5, 1/9}}];

Print["=== Explicitní vzorec pro ζ(s) ===\n"];

Print["Máme: ζ(-s)/ζ(s) = [f(-s)/f(s)] · R(s)"];
Print["A:    ζ(-s) = f(-s)·ζ(1+s)\n"];
Print["Tedy: ζ(s) = ζ(-s) / {[f(-s)/f(s)]·R(s)}"];
Print["           = f(-s)·ζ(1+s) / {[f(-s)/f(s)]·R(s)}"];
Print["           = f(s)·ζ(1+s) / R(s)"];
Print["           = f(s)·ζ(1+s)·ζ(1-s) / ζ(1+s)"];
Print["           = f(s)·ζ(1-s)\n"];
Print["To je jen FR! Stále kruhové.\n"];

Print["=== Alternativa: Vztah mezi L_P(-s) a L_P(s) ===\n"];

LP[s_] := (Zeta[s]^2 - Zeta[2s])/2

(* L_P(-s) je nezávislé, L_P(s) závisí na ζ(s) *)
(* Existuje vztah? *)

Do[
  lpNeg = LP[-s];
  lpPos = LP[s];

  (* L_P(-s) = (f(-s)²ζ(1+s)² - f(-2s)ζ(1+2s))/2 *)
  lpNegExplicit = (f[-s]^2 Zeta[1+s]^2 - f[-2s] Zeta[1+2s])/2;

  (* L_P(s) pro speciální body: ζ(2s) = f(s)ζ(s) *)
  (* L_P(s) = (ζ(s)² - f(s)ζ(s))/2 = ζ(s)(ζ(s)-f(s))/2 *)

  Print["s = ", s, ":"];
  Print["  L_P(-s) = ", N[lpNeg, 10], " [nezávislé]"];
  Print["  L_P(+s) = ", N[lpPos, 10], " [závisí na ζ(s)]"];
  Print["  L_P(-s)/L_P(s) = ", N[lpNeg/lpPos, 10]];

  (* Existuje vzorec pro L_P(-s)/L_P(s)? *)
  (* L_P(-s)/L_P(s) = [f(-s)²ζ(1+s)² - f(-2s)ζ(1+2s)] / [ζ(s)² - ζ(2s)] *)
  Print[];
, {s, {1/3, 1/5, 1/9}}];

Print["=== Hledání vztahu L_P(-s) = g(s) · L_P(s) ===\n"];

(* Pro speciální body kde ζ(2s) = f(s)ζ(s): *)
(* L_P(s) = ζ(s)(ζ(s) - f(s))/2 *)
(* L_P(-s) = (f(-s)²ζ(1+s)² - f(-2s)ζ(1+2s))/2 *)

(* Poměr: *)
(* L_P(-s)/L_P(s) = [f(-s)²ζ(1+s)² - f(-2s)ζ(1+2s)] / [ζ(s)(ζ(s) - f(s))] *)

(* Použijme ζ(s) = f(s)ζ(1-s): *)
(* L_P(-s)/L_P(s) = [f(-s)²ζ(1+s)² - f(-2s)ζ(1+2s)] / [f(s)ζ(1-s)(f(s)ζ(1-s) - f(s))] *)
(*                = [f(-s)²ζ(1+s)² - f(-2s)ζ(1+2s)] / [f(s)²ζ(1-s)(ζ(1-s) - 1)] *)

s = 1/3;
numerator = f[-s]^2 Zeta[1+s]^2 - f[-2s] Zeta[1+2s];
denominator = f[s]^2 Zeta[1-s] (Zeta[1-s] - 1);

Print["Pro s = 1/3:"];
Print["  Čitatel = f(-s)²ζ(1+s)² - f(-2s)ζ(1+2s) = ", N[numerator, 10]];
Print["  Jmenovatel = f(s)²ζ(1-s)(ζ(1-s)-1) = ", N[denominator, 10]];
Print["  Poměr = ", N[numerator/denominator, 10]];
Print["  Skutečný L_P(-s)/L_P(s) = ", N[LP[-s]/LP[s], 10]];

Print["\n=== Závěr ===\n"];

Print["Relace existují, ale jsou TAUTOLOGICKÉ - vždy se vrátí k FR."];
Print[""];
Print["Možná alternativa:"];
Print["1. Integrální reprezentace (numericky nestabilní, ale teoreticky platná)"];
Print["2. Eta funkce: η(s) = (1-2^{1-s})ζ(s) konverguje pro Re(s) > 0"];
Print["3. Alternující zeta: konverguje v širší oblasti"];
