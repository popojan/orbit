pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]
sqfree[n_] := Times @@ (Power @@@ ({#1, Mod[#2, 2]} & @@@ FactorInteger[n]))

(* Find the 5% failures: k/m = 1/3 but n_sf NOT ≡ 1 mod 4 *)
Print["=== k/m = 1/3 where n_sf ≢ 1 mod 4 (predictor FAILS) ===\n"];

failures = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  {xf, yf} = pslv[n0]; Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          nsf = sqfree[n0];
          If[Abs[k/m - 1/3] < 0.02 && Mod[nsf, 4] != 1,
            AppendTo[failures, {n0, c, k, m, nsf, Mod[nsf,4], r, z, Denominator[z]}]];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 15}],
{n0, 2, 1000}];

Print["Found ", Length[failures], " failures:\n"];
Do[
  {n0, c0, k0, m0, nsf, nm4, r0, z0, d0} = f;
  (* Detailed analysis *)
  cn = c0^2*n0;
  cf = ContinuedFraction[Sqrt[n0]];
  Ln = If[Length[cf]==2, Length[cf[[2]]], -1];
  {xf, yf} = pslv[n0];
  
  Print["n = ", n0, " = ", FactorInteger[n0],
    "  n_sf = ", nsf, " ≡ ", nm4, " mod 4"];
  Print["  c = ", c0, "  c²n = ", cn, " = ", FactorInteger[cn]];
  Print["  m = ", m0, "  k = ", k0, "  k/m = ", k0, "/", m0];
  Print["  r = ", r0, "  z = ", z0, "  δ = ", d0];
  Print["  L(n) = ", Ln, If[OddQ[Ln], " (odd)", " (even)"]];
  Print["  fund = (", xf, ", ", yf, ")"];
  
  (* WHY is k = m/3 despite n_sf ≢ 1 mod 4? *)
  (* Check: is c²n squarefree part ≡ 1 mod 4? *)
  cnsf = sqfree[cn];
  Print["  sqfree(c²n) = ", cnsf, " ≡ ", Mod[cnsf, 4], " mod 4"];
  
  (* Check maximal order *)
  If[Mod[nsf, 4] == 1,
    Print["  O_K = Z[(1+√", nsf, ")/2]  (larger than Z[√", nsf, "])"],
    Print["  O_K = Z[√", nsf, "]  (same as our order!)"]];
  Print[];
, {f, failures}];

(* Also: the CONVERSE failures — n_sf ≡ 1 mod 4 but k/m = 1 (not 1/3) *)
Print["=== CONVERSE: n_sf ≡ 1 mod 4, m=3, but k = m (not k/m=1/3) ===\n"];

converseF = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  nsf = sqfree[n0]; If[Mod[nsf, 4] != 1, Continue[]];
  {xf, yf} = pslv[n0]; Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          If[m == 3 && k == 3,  (* n_sf ≡ 1 mod 4 but k/m = 1, not 1/3 *)
            AppendTo[converseF, {n0, c, nsf, r, z}]];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 5}],  (* small c for speed *)
{n0, 2, 500}];

Print["Found ", Length[converseF], " converse failures:"];
Do[
  {n0, c0, nsf, r0, z0} = f;
  Print["  n=", n0, " c=", c0, " n_sf=", nsf, "≡1(4)",
    " r=", r0, " z=", z0,
    "  BUT k=m=3 (not k/m=1/3)"];
, {f, converseF[[;;Min[20, Length[converseF]]]]}];

If[Length[converseF] > 0,
  Print["\nWhat makes these different?"];
  Print["  c values: ", Tally[#[[2]] & /@ converseF]];
  Print["  r values: ", Tally[#[[4]] & /@ converseF]];
];
