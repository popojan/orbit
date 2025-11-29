(* Test flattened recursion: ω=4 needs ALL lower levels *)

signSumNaive[k_] := Count[#, _?OddQ] - Count[#, _?EvenQ] & @
  Select[Range[2, k-1], GCD[#-1, k] == 1 && GCD[#, k] == 1 &];

(* Precompute ss for pairs and triples *)
signSumPair[p_, q_] := 1 - 4*Mod[PowerMod[p, -1, q], 2];

signSumTripleFormula[{p1_, p2_, p3_}] := Module[
  {b12, b13, b23, b1, b2, b3, sumB2, sumBtriple},
  b12 = Mod[PowerMod[p1, -1, p2], 2];
  b13 = Mod[PowerMod[p1, -1, p3], 2];
  b23 = Mod[PowerMod[p2, -1, p3], 2];
  sumB2 = b12 + b13 + b23;
  b1 = Mod[PowerMod[p2 p3, -1, p1], 2];
  b2 = Mod[PowerMod[p1 p3, -1, p2], 2];
  b3 = Mod[PowerMod[p1 p2, -1, p3], 2];
  sumBtriple = b1 + b2 + b3;
  -1 + 4*(sumB2 - sumBtriple)
];

primes = Prime[Range[2, 13]];
Print["Testing FLATTENED recursion for ω=4"];
Print["Using primes: ", primes];

data = {};
Do[
  If[p1 < p2 < p3 < p4,
    k = p1 p2 p3 p4;
    ss = signSumNaive[k];
    f = (ss - 1)/4;
    
    (* All 6 pairwise ss values *)
    ssPairs = {
      signSumPair[p1, p2], signSumPair[p1, p3], signSumPair[p1, p4],
      signSumPair[p2, p3], signSumPair[p2, p4], signSumPair[p3, p4]
    };
    sumPairs = Total[ssPairs];
    
    (* All 4 triple ss values *)
    ssTriples = {
      signSumTripleFormula[{p1, p2, p3}],
      signSumTripleFormula[{p1, p2, p4}],
      signSumTripleFormula[{p1, p3, p4}],
      signSumTripleFormula[{p2, p3, p4}]
    };
    sumTriples = Total[ssTriples];
    
    (* Quadruple b-vector *)
    bQuad = {
      Mod[PowerMod[p2 p3 p4, -1, p1], 2],
      Mod[PowerMod[p1 p3 p4, -1, p2], 2],
      Mod[PowerMod[p1 p2 p4, -1, p3], 2],
      Mod[PowerMod[p1 p2 p3, -1, p4], 2]
    };
    sumBquad = Total[bQuad];
    
    AppendTo[data, <|
      "primes" -> {p1, p2, p3, p4},
      "ss" -> ss,
      "f" -> f,
      "sumPairs" -> sumPairs,
      "sumTriples" -> sumTriples,
      "sumBquad" -> sumBquad,
      "ssPairs" -> ssPairs,
      "ssTriples" -> ssTriples
    |>];
  ],
  {p1, primes}, {p2, primes}, {p3, primes}, {p4, primes}
];

Print["Generated ", Length[data], " cases\n"];

(* Search for: ss = c + a*sumPairs + b*sumTriples + d*sumBquad *)
Print["Searching for: ss = c + a*Σss(pairs) + b*Σss(triples) + d*sumBquad"];
found = False;
Do[
  res = Table[d["ss"] - (c + a*d["sumPairs"] + b*d["sumTriples"] + d*d["sumBquad"]), {d, data}];
  uniq = Union[res];
  If[uniq == {0},
    Print["✓ EXACT: ss = ", c, " + ", a, "*Σss(pairs) + ", b, "*Σss(triples) + ", dd, "*sumBquad"];
    found = True;
  ];
, {c, -10, 10}, {a, -3, 3}, {b, -3, 3}, {dd, -8, 8}];

If[!found,
  Print["No exact formula found. Looking for best approximations..."];
  
  (* Find formulas with smallest residual set *)
  bestResiduals = 100;
  bestFormula = {};
  Do[
    res = Table[d["ss"] - (c + a*d["sumPairs"] + b*d["sumTriples"] + dd*d["sumBquad"]), {d, data}];
    uniq = Union[res];
    If[Length[uniq] < bestResiduals,
      bestResiduals = Length[uniq];
      bestFormula = {c, a, b, dd, uniq};
    ];
  , {c, -10, 10}, {a, -3, 3}, {b, -3, 3}, {dd, -8, 8}];
  
  Print["\nBest formula: ss = ", bestFormula[[1]], " + ", bestFormula[[2]], "*Σpairs + ", 
        bestFormula[[3]], "*Σtriples + ", bestFormula[[4]], "*Bquad"];
  Print["Residuals: ", bestFormula[[5]]];
];

(* Also try with f = (ss-1)/4 *)
Print["\n\n=== Alternative: work with f = (ss-1)/4 ==="];
Print["Pairs contribute: (ss-1)/4 = -ε for pair = {0, -1}"];
Print["Triples contribute: more complex"];

(* Convert pair ss to f *)
Do[
  d["fPairs"] = (d["ssPairs"] - 1)/4;  (* Each is 0 or -1 *)
  d["sumFpairs"] = Total[d["fPairs"]];
  d["fTriples"] = (d["ssTriples"] - 1)/4;
  d["sumFtriples"] = Total[d["fTriples"]];
, {d, data}];

Print["Range of sumFpairs: ", Union[data[[All, "sumFpairs"]]]];
Print["Range of sumFtriples: ", Union[data[[All, "sumFtriples"]]]];

(* Search for: f = c + a*sumFpairs + b*sumFtriples + d*sumBquad *)
Print["\nSearching for: f = c + a*Σf(pairs) + b*Σf(triples) + d*sumBquad"];
found = False;
Do[
  res = Table[d["f"] - (c + a*d["sumFpairs"] + b*d["sumFtriples"] + dd*d["sumBquad"]), {d, data}];
  uniq = Union[res];
  If[uniq == {0},
    Print["✓ EXACT: f = ", c, " + ", a, "*Σf(pairs) + ", b, "*Σf(triples) + ", dd, "*sumBquad"];
    found = True;
  ];
, {c, -10, 10}, {a, -3, 3}, {b, -3, 3}, {dd, -8, 8}];

If[!found,
  (* Best approximation *)
  bestRes = 100;
  bestF = {};
  Do[
    res = Table[d["f"] - (c + a*d["sumFpairs"] + b*d["sumFtriples"] + dd*d["sumBquad"]), {d, data}];
    uniq = Union[res];
    If[Length[uniq] < bestRes,
      bestRes = Length[uniq];
      bestF = {c, a, b, dd, uniq};
    ];
  , {c, -10, 10}, {a, -3, 3}, {b, -3, 3}, {dd, -8, 8}];
  
  Print["\nBest f formula: f = ", bestF[[1]], " + ", bestF[[2]], "*Σf(pairs) + ",
        bestF[[3]], "*Σf(triples) + ", bestF[[4]], "*Bquad"];
  Print["Residuals: ", bestF[[5]]];
];
