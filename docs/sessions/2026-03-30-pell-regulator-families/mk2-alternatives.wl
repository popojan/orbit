pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]
sqfree[n_] := Times @@ (Power @@@ ({#1, Mod[#2, 2]} & @@@ FactorInteger[n]))

(* For m/k=2 cases: does an alternative R-D decomposition exist
   that would give m=1 (hence k=1, the fundamental solution directly)? *)

Print["=== m/k = 2 CASES: alternative decompositions ===\n"];

mk2cases = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  nsf = sqfree[n0];
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
          If[k != 0 && m/k == 2,
            AppendTo[mk2cases, {n0, c, k, m, a0, r, z, nsf}]];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 10}],
{n0, 2, 500}];

Print["Found ", Length[mk2cases], " m/k=2 cases.\n"];

(* For each: check ALL possible decompositions c²n = a0'^2 + r' *)
Do[
  {n0, c0, k0, m0, a0used, rused, zused, nsf} = cas;
  cn = c0^2 * n0;
  {xf, yf} = pslv[n0];
  
  (* Find all a0 values giving delta <= 2 *)
  altDecomps = {};
  a0max = Floor[Sqrt[cn]];
  Do[
    r = cn - a0^2;
    If[r > 0,
      z = (2a0^2+r)/r; delta = Denominator[z];
      If[delta <= 2,
        (* What m would this need? *)
        Catch[Do[
          xc = ChebyshevT[mm, z]; Yc = (2a0/r)*ChebyshevU[mm-1, z];
          If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
            yn = c0*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
            kk = Round[Rc / Log[N[xf + yf*Sqrt[n0], 50]]];
            AppendTo[altDecomps, {a0, r, delta, mm, kk, z}];
            Throw[True]],
        {mm, 1, 10}]]
      ]],
  {a0, a0max, Max[1, a0max - 2*a0max], -1}]; (* try several a0 values *)
  
  (* Show results *)
  If[Length[altDecomps] > 0 && c0 <= 3 && n0 <= 200,
    bestK = Min[#[[5]] & /@ altDecomps];
    Print["n=", n0, " c=", c0, " c²n=", cn, " n_sf=", nsf,
      "  USED: a₀=", a0used, " r=", rused, " m=", m0, " k=", k0];
    Do[
      {a0, r, d, mm, kk, zz} = ad;
      flag = If[kk == 1, " *** FUNDAMENTAL ***",
        If[kk < k0, " (better!)", ""]];
      Print["    ALT: a₀=", a0, " r=", r, " δ=", d,
        " z=", zz, " m=", mm, " k=", kk, flag],
    {ad, altDecomps}];
    Print[]],
{cas, mk2cases}];

(* Statistics: how often does an alternative give k=1 (fundamental)? *)
Print["=== STATISTICS ===\n"];

fundFound = 0; betterFound = 0;
Do[
  {n0, c0, k0, m0, a0used, rused, zused, nsf} = cas;
  cn = c0^2 * n0;
  {xf, yf} = pslv[n0];
  
  bestK = k0;
  a0max = Floor[Sqrt[cn]];
  Do[
    r = cn - a0^2;
    If[r > 0,
      z = (2a0^2+r)/r; delta = Denominator[z];
      If[delta <= 2,
        Catch[Do[
          xc = ChebyshevT[mm, z]; Yc = (2a0/r)*ChebyshevU[mm-1, z];
          If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
            yn = c0*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
            kk = Round[Rc / Log[N[xf + yf*Sqrt[n0], 50]]];
            If[kk < bestK, bestK = kk];
            Throw[True]],
        {mm, 1, 10}]]]],
  {a0, a0max, Max[1, a0max - 50], -1}];
  
  If[bestK == 1, fundFound++];
  If[bestK < k0, betterFound++],
{cas, mk2cases}];

Print["Out of ", Length[mk2cases], " m/k=2 cases:"];
Print["  Alternative gives k=1 (fundamental): ", fundFound];
Print["  Alternative gives better k < original: ", betterFound];
Print["  No improvement: ", Length[mk2cases] - betterFound];
