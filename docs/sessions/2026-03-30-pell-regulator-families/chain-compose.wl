n0 = 127;
{xf, yf} = {x, y} /. First@FindInstance[x x - 127 y y == 1, {x, y}, PositiveIntegers];

compose[{P1_,Y1_,r1_}, {P2_,Y2_,r2_}] := Module[{P3,Y3,r3,g},
  P3 = P1*P2 + n0*Y1*Y2;
  Y3 = P1*Y2 + P2*Y1;
  r3 = r1*r2;
  g = GCD[P3, Y3, r3];
  {P3/g, Y3/g, r3/g}
]

seeds = {
  {248, 22, 6}, {227, 20, 27}, {191, 16, 63},
  {176, 14, 78}, {163, 12, 91}, {128, 2, 126}
};

(* Strategy: compose pairs to reduce rc, then compose results *)
Print["=== SYSTEMATIC PAIRWISE COMPOSITION ===\n"];

pairs = {};
Do[Do[
  {Pc, Yc, rc} = compose[seeds[[i]], seeds[[j]]];
  AppendTo[pairs, {i, j, Pc, Yc, rc, FactorInteger[rc]}];
  Print["  s", i, " ⊕ s", j, " → rc = ", rc, " = ", FactorInteger[rc]],
{j, i+1, Length[seeds]}], {i, 1, Length[seeds]}];

Print["\n=== COMPOSE PAIRS WITH PAIRS ===\n"];

(* Find two pairs whose rc multiply to a square *)
pairResults = Select[pairs, #[[5]] > 1 &]; (* non-trivial *)
Do[Do[
  {i1,j1,P1,Y1,r1,f1} = pairResults[[a]];
  {i2,j2,P2,Y2,r2,f2} = pairResults[[b]];
  {Pc,Yc,rc} = compose[{P1,Y1,r1}, {P2,Y2,r2}];
  If[rc == 1,
    k = Round[Log[N[Pc+Yc*Sqrt[n0],30]]/Log[N[xf+yf*Sqrt[n0],30]]];
    Print["  (s",i1,"⊕s",j1,") ⊕ (s",i2,"⊕s",j2,") → rc=1!",
      " x=",Pc," y=",Yc," k=",k, If[k==1," FUND!",""]]],
{b, a+1, Length[pairResults]}], {a, 1, Length[pairResults]}];

(* Also try: compose a pair with a single seed *)
Print["\n=== PAIR ⊕ SEED ===\n"];
Do[Do[
  {i1,j1,P1,Y1,r1,f1} = pairResults[[a]];
  {P2,Y2,r2} = seeds[[s]];
  {Pc,Yc,rc} = compose[{P1,Y1,r1}, {P2,Y2,r2}];
  If[rc == 1,
    k = Round[Log[N[Pc+Yc*Sqrt[n0],30]]/Log[N[xf+yf*Sqrt[n0],30]]];
    Print["  (s",i1,"⊕s",j1,") ⊕ s",s," → rc=1!",
      " x=",Pc," y=",Yc," k=",k, If[k==1," FUND!",""]]],
{s, 1, Length[seeds]}], {a, 1, Length[pairResults]}];
