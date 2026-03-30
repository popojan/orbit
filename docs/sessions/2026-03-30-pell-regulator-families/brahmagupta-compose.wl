n0 = 127;
{xf, yf} = {x, y} /. First@FindInstance[x x - 127 y y == 1, {x, y}, PositiveIntegers];
Print["n = 127, fund = (", xf, ", ", yf, ")\n"];

(* All smooth rational seeds: P² - 127Y² = r², so (P/r, Y/r) is rational Pell *)
seeds = {
  {248, 22, 6},    (* a₀=11 *)
  {227, 20, 27},   (* a₀=10 *)
  {191, 16, 63},   (* a₀=8 *)
  {176, 14, 78},   (* a₀=7 *)
  {163, 12, 91},   (* a₀=6 *)
  {128, 2, 126}    (* a₀=1 *)
};

Print["Seeds (P, Y, r) with P²-127Y²=r²:"];
Do[{P,Y,r} = s; Print["  ", P, "²-127·", Y, "² = ", P^2-127*Y^2, " = ", r, "²  ✓"],
{s, seeds}];

(* Brahmagupta self-composition: (P,Y,r) → (P²+nY², 2PY, r²) *)
(* Then check if r² | numerators *)

Print["\n=== SELF-COMPOSITION (squaring) ===\n"];

Do[
  {P, Y, r} = seed;
  (* Square: ε² where ε = P/r + (Y/r)√n *)
  P2 = P^2 + n0*Y^2;
  Y2 = 2*P*Y;
  r2 = r^2;
  (* Check divisibility *)
  gP = GCD[P2, r2]; gY = GCD[Y2, r2];
  Print["Seed (", P, ",", Y, ",", r, "):"];
  Print["  ε² = ", P2, "/", r2, " + ", Y2, "/", r2, "·√127"];
  Print["  r²|P2: ", Mod[P2,r2]==0, "  r²|Y2: ", Mod[Y2,r2]==0,
    "  GCD(P2,r²)=", gP, "  GCD(Y2,r²)=", gY];
  
  (* Reduce by GCD *)
  g = GCD[P2, Y2, r2];
  Print["  After /", g, ": (", P2/g, ", ", Y2/g, ") norm-denom = ", r2/g];
  
  (* Keep squaring: ε⁴ *)
  P4 = P2^2 + n0*Y2^2;
  Y4 = 2*P2*Y2;
  r4 = r2^2;
  g4 = GCD[P4, Y4, r4];
  Print["  ε⁴: after /", g4, ": norm-denom = ", r4/g4];
  
  (* ε⁸ *)
  P8 = P4^2 + n0*Y4^2;
  Y8 = 2*P4*Y4;
  r8 = r4^2;
  g8 = GCD[P8, Y8, r8];
  Print["  ε⁸: after /", g8, ": norm-denom = ", r8/g8];
  Print[],
{seed, seeds[[;;3]]}];

(* Now: CROSS-composition of different seeds *)
Print["=== CROSS-COMPOSITION ===\n"];

compose[{P1_,Y1_,r1_}, {P2_,Y2_,r2_}] := Module[{P3,Y3,r3,g},
  P3 = P1*P2 + n0*Y1*Y2;
  Y3 = P1*Y2 + P2*Y1;
  r3 = r1*r2;
  g = GCD[P3, Y3, r3];
  {P3/g, Y3/g, r3/g}
]

(* Try composing seed 1 with each other *)
s1 = seeds[[1]]; (* (248, 22, 6) *)
Do[
  s2 = seeds[[j]];
  {Pc, Yc, rc} = compose[s1, s2];
  Print["  (248,22,6) ⊕ ", s2, " → (", Pc, ",", Yc, ",", rc, ")",
    "  norm-check: ", Pc^2-n0*Yc^2, "=", rc, "²? ", Pc^2-n0*Yc^2==rc^2];
  
  (* Is rc = 1? Then we have Pell! *)
  If[rc == 1, 
    Print["  *** PELL SOLUTION: x=", Pc, " y=", Yc, " ***"];
    k = Round[Log[N[Pc+Yc*Sqrt[n0],30]]/Log[N[xf+yf*Sqrt[n0],30]]];
    Print["  k = ", k, If[k==1, " FUNDAMENTAL!", ""]]],
{j, 2, Length[seeds]}];

(* Chain: keep composing with seed 1 until rc = 1 *)
Print["\n=== CHAIN COMPOSITION: repeated ⊕ with seed 1 ===\n"];
current = seeds[[1]]; (* (248, 22, 6) *)
Do[
  current = compose[current, seeds[[1]]];
  {Pc, Yc, rc} = current;
  Print["  step ", step, ": rc = ", rc,
    If[rc == 1, " *** PELL! x=" <> ToString[Pc] <> " y=" <> ToString[Yc] <> " ***",
      "  rc factors: " <> ToString[FactorInteger[rc]]]];
  If[rc == 1,
    k = Round[Log[N[Pc+Yc*Sqrt[n0],30]]/Log[N[xf+yf*Sqrt[n0],30]]];
    Print["    k = ", k, If[k==1, " FUNDAMENTAL!", ""]];
    Break[]],
{step, 1, 20}];
