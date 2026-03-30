(* ::Package:: *)

(* Pell Regulator via Infrastructure BSGS *)
(* Sublinear O(sqrt(L)) computation of log(fundamental unit) *)
(* Two-pass: discover collision at pp=50, refine at pp=R/ln10+50 *)

BeginPackage["Orbit`"];

PellRegulator::usage = "PellRegulator[n] computes the regulator R = Log[x + y Sqrt[n]] where x^2 - n y^2 = 1.
Returns <|\"R\" -> regulator, \"Digits\" -> precision, \"Steps\" -> baby+giant count|>.
Uses infrastructure BSGS (Buchmann-Williams) with O(Sqrt[L]) steps where L is the CF period.";

PellRegulatorInteger::usage = "PellRegulatorInteger[n] computes Round[R] where R is the Pell regulator.
Single-pass BSGS at pp=50, minimal disambiguation. Fastest variant.
Returns <|\"R\" -> Round[R], \"Steps\" -> count|>.";

PellRegulatorPARI::usage = "PellRegulatorPARI[n] computes the Pell regulator via PARI/GP quadunit(4n). Requires gp on PATH.";

Begin["`Private`"]

(* --- Binary quadratic forms {a, b, c, dist} of discriminant delta --- *)

pellStartForm[delta_, pp_] := Module[{sqd, b0, c0},
  sqd = N[Sqrt[delta], pp];
  b0 = Floor[sqd];
  If[Mod[b0, 2] != Mod[delta, 2], b0--];
  c0 = (b0^2 - delta)/4;
  {sqd, {1, b0, c0, N[0, pp]}}]

pellRho[sqd_, delta_, {a_, b_, c_, dist_}, pp_] :=
  Module[{ac = Abs[c], q, b2, c2, dd},
  If[ac == 0, Return[{a, b, c, dist}]];
  q = Floor[(sqd + b)/(2 ac)];
  b2 = 2 ac q - b;
  c2 = (b2^2 - delta)/(4 ac);
  dd = N[Log[Abs[(b + sqd)/(2 ac)]], pp];
  {ac, b2, c2, dist + dd}]

pellIsReduced[sqd_, {a_, b_, _, _}] :=
  a > 0 && b > 0 && sqd - b < 2 a < sqd + b

pellReduce[sqd_, delta_, form_, pp_] := Module[{f = form},
  Do[If[pellIsReduced[sqd, f], Return[f, Module]];
    f = pellRho[sqd, delta, f, pp], {500}]; f]

(* --- Gauss composition with corrected distance: d3 = d1 + d2 + Log[g] --- *)

pellCompose[sqd_, delta_, f1_, f2_, pp_] :=
  Module[{a1, b1, c1, d1, a2, b2, c2, d2,
          g1, u1, v1, g, p, q, lam, a3, b3, c3},
  {a1, b1, c1, d1} = f1;
  {a2, b2, c2, d2} = f2;
  {g1, {u1, v1}} = ExtendedGCD[a1, a2];
  {g, {p, q}} = ExtendedGCD[g1, (b1 + b2)/2];
  a3 = (a1 a2)/g^2;
  lam = Mod[v1 p (b1 - b2)/2 - q c2, a1/g];
  b3 = b2 + 2 (a2/g) lam;
  b3 = Mod[b3 - Mod[delta, 2], 2 a3] + Mod[delta, 2];
  Module[{sd = Floor[sqd]},
    While[b3 < sd - a3, b3 += 2 a3];
    While[b3 > sd + a3, b3 -= 2 a3]];
  c3 = (b3^2 - delta)/(4 a3);
  If[!IntegerQ[c3], Return[$Failed]];
  pellReduce[sqd, delta, {a3, b3, c3, d1 + d2 + N[Log[g], pp]}, pp]]

(* --- Two-pass BSGS --- *)

bsgsPass[n_, pp_] := Module[
  {delta = 4 n, sqd, f0, b0, f, bigB,
   babyTab, genForm, curForm, found = False,
   reg, giantSteps = 0, babySteps, babyCollisionIndex = 0},

  {sqd, f0} = pellStartForm[delta, pp];
  b0 = f0[[2]];
  bigB = Max[3, Ceiling[N[n]^(1/4)]];

  f = f0; babyTab = <||>;
  Do[
    f = pellRho[sqd, delta, f, pp];
    If[f[[1]] == 1 && f[[2]] == b0, found = True; reg = f[[4]]; babySteps = i; Break[]];
    babyTab[f[[1]]] = {f[[2]], f[[4]], i};
  , {i, 1, bigB}];
  If[!found, babySteps = bigB];

  If[!found,
    genForm = f; curForm = genForm;
    Do[
      curForm = pellCompose[sqd, delta, curForm, genForm, pp];
      giantSteps++;
      If[curForm === $Failed, Continue[]];
      If[curForm[[1]] == 1 && curForm[[2]] == b0,
        found = True; reg = curForm[[4]]; Break[]];
      If[KeyExistsQ[babyTab, curForm[[1]]] &&
         babyTab[curForm[[1]]][[1]] == curForm[[2]],
        babyCollisionIndex = babyTab[curForm[[1]]][[3]];
        reg = curForm[[4]] - babyTab[curForm[[1]]][[2]];
        found = True; Break[]];
    , {k, 1, 10 bigB}]];

  If[!found, Return[$Failed]];
  {reg, babySteps, giantSteps, babyCollisionIndex}]

PellRegulator[n_] := Module[
  {pass1, reg1, babySteps, giantSteps, babyIdx,
   ppFinal, pass2, reg, R, digits, xr, yr, norm},

  (* Pass 1: discover collision at pp=50 *)
  pass1 = bsgsPass[n, 50];
  If[pass1 === $Failed, Return[$Failed]];
  {reg1, babySteps, giantSteps, babyIdx} = pass1;

  (* Pass 2: replay at full precision *)
  ppFinal = Ceiling[Abs[reg1]/Log[10]] + 50;
  pass2 = Module[{delta = 4 n, sqd, f0, f, genForm, curForm, fb},
    {sqd, f0} = pellStartForm[delta, ppFinal];
    f = f0;
    Do[f = pellRho[sqd, delta, f, ppFinal], {babySteps}];
    If[giantSteps > 0,
      genForm = f; curForm = genForm;
      Do[curForm = pellCompose[sqd, delta, curForm, genForm, ppFinal], {giantSteps}];
      If[babyIdx > 0,
        fb = f0;
        Do[fb = pellRho[sqd, delta, fb, ppFinal], {babyIdx}];
        curForm[[4]] - fb[[4]],
        curForm[[4]]],
      f[[4]]]];
  reg = pass2;

  (* Disambiguation: norm check via cosh *)
  R = reg;
  Do[
    xr = Round[N[Cosh[c], ppFinal]];
    yr = Round[N[Sinh[c]/Sqrt[n], ppFinal]];
    norm = xr^2 - n yr^2;
    If[norm == 1 && xr > 1, R = c; Break[]];
    If[norm == -1 && xr > 1, R = 2 c; Break[]];
  , {c, Select[{reg/3, reg/2, reg}, # > 0.5 &]}];

  digits = Max[1, Floor[ppFinal - Ceiling[Abs[R]/Log[10]]] - 2];

  <|"R" -> R,
    "Digits" -> digits,
    "Steps" -> babySteps + giantSteps,
    "BabySteps" -> babySteps,
    "GiantSteps" -> giantSteps|>]

(* --- Integer regulator: single pass, minimal disambiguation --- *)

PellRegulatorInteger[n_] := Module[
  {pass1, reg1, babySteps, giantSteps, babyIdx,
   ppD, reg, R, xr, yr, norm},

  (* Pass 1: discover collision at pp=50 *)
  pass1 = bsgsPass[n, 50];
  If[pass1 === $Failed, Return[$Failed]];
  {reg1, babySteps, giantSteps, babyIdx} = pass1;

  (* Pass 2: replay at just enough precision for cosh norm check.
     cosh(reg) has ceil(reg/ln10) integer digits.
     Need ~5 extra digits past decimal for Round to work. *)
  ppD = Ceiling[Abs[reg1]/Log[10]] + 5;
  If[ppD <= 50,
    reg = reg1, (* pp=50 already sufficient *)
    (* Replay at ppD *)
    reg = Module[{delta = 4 n, sqd, f0, f, genForm, curForm, fb},
      {sqd, f0} = pellStartForm[delta, ppD];
      f = f0;
      Do[f = pellRho[sqd, delta, f, ppD], {babySteps}];
      If[giantSteps > 0,
        genForm = f; curForm = genForm;
        Do[curForm = pellCompose[sqd, delta, curForm, genForm, ppD], {giantSteps}];
        If[babyIdx > 0,
          fb = f0;
          Do[fb = pellRho[sqd, delta, fb, ppD], {babyIdx}];
          curForm[[4]] - fb[[4]],
          curForm[[4]]],
        f[[4]]]]];

  (* Disambiguate via cosh norm check *)
  R = reg;
  Do[
    xr = Round[N[Cosh[c], ppD]];
    yr = Round[N[Sinh[c]/Sqrt[n], ppD]];
    norm = xr^2 - n yr^2;
    If[norm == 1 && xr > 1, R = c; Break[]];
    If[norm == -1 && xr > 1, R = 2 c; Break[]];
  , {c, Select[{reg/3, reg/2, reg}, # > 0.5 &]}];

  <|"R" -> Round[R],
    "Rfloat" -> R,
    "Steps" -> babySteps + giantSteps|>]

(* --- PARI oracle --- *)

PellRegulatorPARI[n_] := Module[{cmd, raw},
  cmd = "echo 'print(my(u=quadunit(4*" <> ToString[n] <>
    "),a=component(u,2),b=component(u,3),R=log(abs(a+b*sqrt(" <>
    ToString[n] <> ".))));if(a^2-" <> ToString[n] <>
    "*b^2==-1,R=2*R);R)' | gp -q 2>/dev/null";
  raw = StringTrim[RunProcess[{"bash", "-c", cmd}, "StandardOutput"]];
  If[StringLength[raw] > 0, ToExpression[raw], $Failed]]

End[]

EndPackage[]
