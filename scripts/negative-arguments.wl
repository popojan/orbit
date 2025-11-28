(* Záporné argumenty zeta funkce *)

Print["=== Záporné argumenty — přímá cesta ===\n"];

(* Funkcionální rovnice *)
f[s_] := 2^s Pi^(s-1) Sin[Pi s/2] Gamma[1-s]

(* Příklady záporných racionálních argumentů *)
testArgs = {-1/3, -7/11, -2/5, -3/7, -1/2};

Print["Pro s < 0: ζ(s) = f(s) · ζ(1-s), kde 1-s > 1\n"];

Do[
  s = arg;
  complementS = 1 - s;
  zetaS = Zeta[s];
  zetaComplement = Zeta[complementS];
  fVal = f[s];
  Print["ζ(", s, "):"];
  Print["  1 - s = ", complementS, " > 1 ✓"];
  Print["  ζ(", complementS, ") = ", N[zetaComplement, 10], " (konvergentní řada)"];
  Print["  f(", s, ") = ", N[fVal, 10]];
  Print["  ζ(", s, ") = ", N[zetaS, 10]];
  Print["  Ověření: f·ζ(1-s) = ", N[fVal * zetaComplement, 10]];
  Print[];
, {arg, testArgs}];

Print["=== Speciální hodnoty — Bernoulliho čísla ===\n"];

(* Pro záporná celá čísla *)
Print["ζ(-n) = -B_{n+1}/(n+1):\n"];
Do[
  Print["ζ(", -n, ") = ", Zeta[-n], " = -B_", n+1, "/(", n+1, ") = ",
        -BernoulliB[n+1]/(n+1)];
, {n, 0, 6}];

Print["\n=== L_P identita pro záporné argumenty ===\n"];

LP[s_] := (Zeta[s]^2 - Zeta[2s])/2

s = -7/11;
Print["Pro s = ", s, ":"];
Print["  ζ(s) = ζ(", s, ") = ", N[Zeta[s], 10]];
Print["  ζ(2s) = ζ(", 2s, ") = ", N[Zeta[2s], 10]];
Print["  L_P(s) = ", N[LP[s], 10]];
Print[];
Print["Všechny hodnoty přes funkcionální rovnici:"];
Print["  ζ(", s, ") = f(", s, ") · ζ(", 1-s, ")"];
Print["  ζ(", 2s, ") = f(", 2s, ") · ζ(", 1-2s, ")"];
Print["  kde ζ(", 1-s, ") a ζ(", 1-2s, ") jsou konvergentní řady"];

Print["\n=== Řetězec zdvojování pro záporné s ===\n"];

s = -1/3;
Print["Pro s = ", s, ":\n"];
chain = Table[{k, 2^k s, N[2^k s, 5]}, {k, 0, 5}];
Print[Grid[Prepend[chain, {"k", "2^k·s", "hodnota"}], Frame -> All]];
Print["\nVšechny členy záporné → nikdy nepřejdeme do oblasti konvergence."];
Print["ALE: Funkcionální rovnice dává přímou cestu pro KAŽDÝ člen:"];
Print["  ζ(2^k·s) = f(2^k·s) · ζ(1 - 2^k·s)"];

Print["\n=== Shrnutí ===\n"];
Print["Pro s < 0: Nepotřebujeme řetězec ani uzavření."];
Print["Funkcionální rovnice přímo spojuje ζ(s) s konvergentní ζ(1-s)."];
Print["Kombinatorická struktura z paperu je relevantní pouze pro s ∈ (0,1)."];
