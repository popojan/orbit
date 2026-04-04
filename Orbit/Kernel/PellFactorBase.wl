(* ::Package:: *)

(* PellFactorBase: Pell regulator via smooth factor base + ideal arithmetic *)
(* Uses PARI/GP backend for correct ideal factorization *)

BeginPackage["Orbit`"];

PellFactorBase::usage = "PellFactorBase[n] computes the fundamental unit of Q(√n) \
as a product of small elements. Returns <|\"n\"->n, \"R\"->regulator, \
\"factors\"->{{a1,v1},{a2,v2},...}, \"x\"->x, \"y\"->y|> where \
ε = ∏(ai+√n)^vi. Options: \"B\" (smoothness bound, default 50).";

IdealFactor::usage = "IdealFactor[n, a] factors the principal ideal (a+√n) \
in Z[√n] into prime ideals. Returns a list of {<|\"p\"->p, \"root\"->s|>, exponent} \
pairs, where each prime ideal is 𝔭 = (p, s+√n). \
IdealFactor[n, {a, b}] factors the ideal (a+b√n).";

Begin["`Private`"];

(* ================================================================ *)
(* IdealFactor                                                       *)
(* ================================================================ *)

IdealFactor[n_Integer, a_Integer] /; n > 1 && !IntegerQ[Sqrt[n]] :=
  pfbIdealFactorPARI[n, a, 1];

IdealFactor[n_Integer, {a_Integer, b_Integer}] /; n > 1 && !IntegerQ[Sqrt[n]] :=
  pfbIdealFactorPARI[n, a, b];

pfbIdealFactorPARI[n_, a_, b_] := Module[{script, raw, lines, result = {}},
  script = StringJoin[
    "K=nfinit(x^2-", ToString[n], ");\n",
    "alpha=nfalgtobasis(K,", ToString[a], "+", ToString[b], "*x);\n",
    "idl=idealhnf(K,alpha);\n",
    "fa=idealfactor(K,idl);\n",
    "for(i=1,matsize(fa)[1],",
      "pr=fa[i,1]; e=fa[i,2];",
      "g=pr.gen[2];",
      "printf(\"I %d %d %d %d %d\\n\", pr.p, pr.f, g[1], g[2], e)",
    ");\n"
  ];
  raw = RunProcess[{"gp", "-q"}, "StandardOutput", script];
  If[!StringQ[raw] || StringLength[raw] == 0, Return[{}]];
  lines = StringSplit[raw, "\n"];
  Do[
    If[StringMatchQ[line, "I " ~~ __],
      Module[{parts = ToExpression /@ StringSplit[StringDrop[line, 2]]},
        (* parts = {p, f, genA, genB, exponent} *)
        (* ideal 𝔭 = (p, genA + genB·√n) *)
        AppendTo[result, {
          <|"p" -> parts[[1]], "f" -> parts[[2]],
            "gen" -> {parts[[3]], parts[[4]]}|>,
          parts[[5]]}]]],
  {line, lines}];
  result
];

(* ================================================================ *)
(* PellFactorBase                                                    *)
(* ================================================================ *)

Options[PellFactorBase] = {"B" -> Automatic};

PellFactorBase[n_Integer, OptionsPattern[]] /; n > 1 && !IntegerQ[Sqrt[n]] :=
  Module[{Bopt, Blist, result},
  Bopt = OptionValue["B"];
  Blist = If[Bopt === Automatic,
    (* Auto-escalate: try increasing B until it works *)
    {7, 13, 23, 50, 97, 199},
    {Bopt}];
  Catch[
    Do[
      result = pfbTryB[n, B];
      If[result =!= $Failed, Throw[result]],
    {B, Blist}];
    $Failed
  ]
];

pfbTryB[n_, B_] := Module[{pariData, rels, FB, nfb, nr, M, ker, v, dsum, factors, eps},
  pariData = pfbPariRelations[n, B];
  If[pariData === $Failed, Return[$Failed]];

  {FB, rels} = pariData;
  nfb = Length[FB]; nr = Length[rels];
  If[nr <= nfb, Return[$Failed]];

  M = rels[[All, "evec"]];
  ker = NullSpace[Transpose[M]];
  If[Length[ker] == 0, Return[$Failed]];

  Catch[
    Do[
      v = ker[[k]];
      dsum = v . rels[[All, "dist"]];
      If[Abs[dsum] > 0.1,
        factors = {};
        Do[If[v[[i]] != 0, AppendTo[factors, {rels[[i, "a0"]], v[[i]]}]], {i, nr}];
        eps = pfbComputeUnit[n, factors];
        Which[
          IntegerQ[eps[[1]]] && IntegerQ[eps[[2]]] && eps[[1]]^2 - n eps[[2]]^2 == 1,
          Throw[<|"n" -> n, "R" -> Abs[dsum], "factors" -> factors,
                  "x" -> eps[[1]], "y" -> eps[[2]], "norm" -> 1,
                  "B" -> B, "factorBase" -> FB,
                  "nRelations" -> nr, "nFactorBase" -> nfb|>],
          IntegerQ[eps[[1]]] && IntegerQ[eps[[2]]] && eps[[1]]^2 - n eps[[2]]^2 == -1,
          Throw[<|"n" -> n, "R" -> 2 Abs[dsum], "factors" -> factors,
                  "x" -> 2 eps[[1]]^2 + 1, "y" -> 2 eps[[1]] eps[[2]],
                  "norm" -> -1, "fundamentalUnit" -> eps,
                  "B" -> B, "factorBase" -> FB,
                  "nRelations" -> nr, "nFactorBase" -> nfb|>]
        ]],
    {k, Length[ker]}];
    $Failed
  ]
];

(* === PARI backend === *)
pfbPariRelations[n_, B_] := Module[{script, raw, lines, FB = {}, rels = {}, sqn,
    line, rest, parts, a0, nm, evecStr, evec, r, dist},
  sqn = Sqrt[N[n, 100]];
  script = StringJoin[
    "K=nfinit(x^2-", ToString[n], ");\n",
    "B=", ToString[B], ";\n",
    "amax=", ToString[Max[4 Floor[Sqrt[n]], 10 B]], ";\n",
    "FB=List();\n",
    "forprime(p=2,B,dec=idealprimedec(K,p);for(j=1,#dec,listput(FB,dec[j])));\n",
    "FB=Vec(FB); nfb=#FB;\n",
    "print(\"FB \",nfb);\n",
    "for(j=1,nfb,print(\"P \",FB[j].p,\" \",FB[j].f));\n",
    "for(a0=1,amax,",
      "nm=a0^2-", ToString[n], ";",
      "r=abs(nm);",
      "if(r==0,next);",
      "fa=factor(r);",
      "if(matsize(fa)[1]>0 && fa[matsize(fa)[1],1]>B,next);",
      "idl=idealhnf(K,nfalgtobasis(K,a0+x));",
      "ev=vector(nfb,j,idealval(K,idl,FB[j]));",
      "print(\"R \",a0,\" \",nm,\" \",ev)",
    ");\n"
  ];
  raw = RunProcess[{"gp", "-q"}, "StandardOutput", script];
  If[!StringQ[raw] || StringLength[raw] == 0, Return[$Failed]];
  lines = StringSplit[raw, "\n"];
  Do[
    line = lines[[i]];
    Which[
      StringMatchQ[line, "P " ~~ __],
      parts = StringSplit[StringDrop[line, 2]];
      AppendTo[FB, <|"p" -> ToExpression[parts[[1]]], "f" -> ToExpression[parts[[2]]]|>],
      StringMatchQ[line, "R " ~~ __],
      rest = StringDrop[line, 2];
      a0 = ToExpression[StringSplit[rest][[1]]];
      nm = ToExpression[StringSplit[rest][[2]]];
      evecStr = StringCases[rest, "[" ~~ x__ ~~ "]" :> x];
      If[Length[evecStr] > 0,
        evec = ToExpression["{" <> evecStr[[1]] <> "}"];
        r = Abs[nm];
        dist = N[Log[Abs[a0 + sqn]] - Log[Sqrt[r]]/2, 50];
        AppendTo[rels, <|"a0" -> a0, "norm" -> nm, "evec" -> evec, "dist" -> dist|>]]
    ],
  {i, Length[lines]}];
  If[Length[FB] == 0 || Length[rels] == 0, Return[$Failed]];
  {FB, rels}
];

(* === Compute unit from factor list === *)
pfbComputeUnit[n_, factors_] := Module[{x = 1, y = 0, a, v, xn, yn},
  Do[
    {a, v} = fac;
    Do[
      If[v > 0,
        {xn, yn} = {x*a + y*n, x + y*a},
        {xn, yn} = {x*a - y*n, -x + y*a}/(a^2 - n)
      ];
      x = xn; y = yn,
    {Abs[v]}],
  {fac, factors}];
  {x, y}
];

End[];
EndPackage[];
