pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

(* MASTER TABLE using standard R-D: n = a₀² + r, a₀ = Floor[√n], r | 4a₀ *)
(* General formula: x = (2a₀² + r)/r,  y = 2a₀/r *)
(* Proof: x²-ny² = (2a₀²+r)²/r² - (a₀²+r)·4a₀²/r² *)
(*       = [4a₀⁴+4a₀²r+r² - 4a₀⁴-4a₀²r]/r² = 1 *)

Print["══════════════════════════════════════════════════════════════════════"];
Print["  MASTER R-D TABLE: n = a₀² + r,  a₀ = Floor[√n],  r | 4a₀"];
Print["══════════════════════════════════════════════════════════════════════"];
Print[];
Print["  General formula:  x = (2a₀² + r)/r     y = 2a₀/r"];
Print["  Proof: x²-ny² = (2a₀²+r)²/r² - (a₀²+r)·4a₀²/r² = r²/r² = 1  ■"];
Print[];

(* For each r, determine when r|4a₀ always vs conditionally *)
(* r | 4a₀ iff r/gcd(r,4) | a₀ iff a₀ ≡ 0 mod (r/gcd(r,4)) *)

Print["  r   | cond on a₀     | CF period | x formula      | y formula  | R/log(n)"];
Print["  ────┼────────────────┼───────────┼────────────────┼────────────┼─────────"];

Do[
  r0 = r;
  g = GCD[r0, 4];
  modCond = r0/g;  (* a₀ must be ≡ 0 mod modCond *)
  
  condStr = If[modCond == 1, "all a₀",
    ToString[modCond] <> " | a₀"];
  
  (* Collect verified data *)
  ratios = {};
  nfails = 0;
  Do[
    If[Mod[a0, modCond] == 0,
      n = a0^2 + r0;
      If[n > 1 && !IntegerQ[Sqrt[n]],
        xf = (2 a0^2 + r0)/r0;
        yf = 2 a0/r0;
        If[IntegerQ[xf] && IntegerQ[yf] && xf > 0 && yf > 0,
          {xa, ya} = pslv[n];
          If[xa == xf && ya == yf,
            AppendTo[ratios, Log[N[xf + yf Sqrt[n], 30]]/Log[N[n, 30]]];
          , nfails++];
        ];
      ];
    ];
  , {a0, 1, 400}];
  
  meanR = If[Length[ratios] > 0, Round[Mean[ratios], 0.0001], "N/A"];
  stdR = If[Length[ratios] > 1, Round[StandardDeviation[ratios], 0.0001], "N/A"];
  
  xStr = "(2a₀²+" <> ToString[r0] <> ")/" <> ToString[r0];
  yStr = "2a₀/" <> ToString[r0];
  
  fundStr = If[nfails == 0, "  ✓",
    "  ⚠" <> ToString[nfails] <> " non-fund"];
  
  (* CF period - compute for a few values *)
  periods = {};
  Do[
    If[Mod[a0, modCond] == 0,
      n = a0^2 + r0;
      If[n > 1 && !IntegerQ[Sqrt[n]],
        cf = ContinuedFraction[Sqrt[n]];
        If[Length[cf] == 2, AppendTo[periods, Length[cf[[2]]]]];
      ];
    ];
  , {a0, 1, 50}];
  periodStr = If[Length[periods] > 0,
    If[Min[periods] == Max[periods],
      ToString[periods[[1]]],
      ToString[Min[periods]] <> "-" <> ToString[Max[periods]]
    ], "?"];
  
  Print["  ", StringPadRight[ToString[r0], 4],
    "| ", StringPadRight[condStr, 15],
    "| ", StringPadRight[periodStr, 10],
    "| ", StringPadRight[xStr, 15],
    "| ", StringPadRight[yStr, 11],
    "| ", meanR, " ± ", stdR, fundStr,
    "  (n=", Length[ratios], ")"];
, {r, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}}];

Print[];
Print["══════════════════════════════════════════════════════════════════════"];
Print["  SIMPLIFIED: only families where formula = fundamental solution"];
Print["══════════════════════════════════════════════════════════════════════"];
Print[];

(* Now present just the clean families *)
cleanFamilies = {};
Do[
  r0 = r; g = GCD[r0, 4]; modCond = r0/g;
  nGood = 0; nBad = 0;
  Do[
    If[Mod[a0, modCond] == 0,
      n = a0^2 + r0;
      If[n > 1 && !IntegerQ[Sqrt[n]],
        xf = (2 a0^2 + r0)/r0; yf = 2 a0/r0;
        If[IntegerQ[xf] && IntegerQ[yf] && xf > 0 && yf > 0,
          {xa, ya} = pslv[n];
          If[xa == xf && ya == yf, nGood++, nBad++];
        ];
      ];
    ];
  , {a0, 1, 200}];
  If[nBad == 0 && nGood > 5,
    AppendTo[cleanFamilies, {r0, modCond, nGood}];
  ];
, {r, 1, 20}];

Print["Clean R-D families (formula = fundamental for ALL members):"];
Print[];
Do[
  {r0, mc, ng} = cf;
  condStr = If[mc == 1, "all a₀", ToString[mc] <> " | a₀"];
  Print["  r = ", r0, " (", condStr, ", ", ng, " verified):"];
  (* Show first 3 examples *)
  cnt = 0;
  Do[
    If[Mod[a0, mc] == 0 && cnt < 3,
      n = a0^2 + r0;
      If[n > 1 && !IntegerQ[Sqrt[n]],
        xf = (2 a0^2 + r0)/r0; yf = 2 a0/r0;
        If[IntegerQ[xf] && IntegerQ[yf],
          Print["    a₀=", a0, "  n=", n, "  x=", xf, "  y=", yf];
          cnt++;
        ];
      ];
    ];
  , {a0, 1, 100}];
, {cf, cleanFamilies}];

Print[];
Print["══════════════════════════════════════════════════════════════════════"];
Print["  FAMILIES WHERE FORMULA ≠ FUNDAMENTAL (need correction)"];
Print["══════════════════════════════════════════════════════════════════════"];
Print[];

(* For d=1 (even a₀): formula = ε², fund has norm -1 *)
Print["r = 1, a₀ even: formula gives ε² (norm-1 unit exists)"];
Print["  Fundamental norm(-1) unit: x₋ = a₀, y₋ = 1"];
Print["  Fundamental Pell+ (= ε₋²): x = 2a₀²+1, y = 2a₀"];
Do[
  a0 = 2k; n = a0^2 + 1;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = pslv[n];
    Print["    a₀=", a0, "  n=", n, "  fund=", {xa,ya},
      "  formula=", {2a0^2+1, 2a0},
      If[xa == 2a0^2+1, "  ✓", "  ✗"]];
  ],
{k, 1, 6}];
Print[];

Print["r = 1, a₀ odd: formula should give fundamental"];
Do[
  a0 = 2k+1; n = a0^2 + 1;
  If[!IntegerQ[Sqrt[n]],
    xf = 2a0^2+1; yf = 2a0;
    {xa, ya} = pslv[n];
    Print["    a₀=", a0, "  n=", n, "  fund=", {xa,ya},
      "  formula=", {xf, yf},
      If[xa == xf, "  ✓", "  ✗"]];
  ],
{k, 1, 6}];
