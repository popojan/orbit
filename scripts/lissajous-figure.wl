(* Lissajous Curve Visualization for Class Number Paper *)
(* Generates figures showing x-axis crossings and closest-to-origin points *)

(* Enhanced version with all improvements *)
ppstEnhanced[Rational[x1_, y1_], opts___] := Module[
  {xinv, kprime, kstar, allCrossings, kprimeX, kstarX,
   kprimeLabelX, kstarLabelX, labelY = 0.12},

  (* Compute modular inverse and closest crossing positions *)
  xinv = PowerMod[x1, -1, y1];
  kprime = xinv;                (* k' = x^{-1} mod p *)
  kstar = y1 - xinv;            (* k* = p - x^{-1} mod p *)

  (* X-coordinates of closest crossings *)
  kprimeX = Sin[Pi x1 kprime/y1];
  kstarX = Sin[Pi x1 kstar/y1];

  (* Label positions: offset from origin based on ratio *)
  (* For 7/11: half distance from origin *)
  (* For 2/3: one third distance from origin *)
  Which[
    {x1, y1} === {7, 11},
      kstarLabelX = kstarX-1/10;
      kprimeLabelX = -Abs[kprimeX]/2,
    {x1, y1} === {2, 3},
      kprimeLabelX = -2*Abs[kprimeX]/3;
      kstarLabelX = 2*Abs[kstarX]/3,
    True,
      kprimeLabelX = kprimeX;
      kstarLabelX = kstarX
  ];

  (* Primary crossings: k in [1, p-1] *)
  primaryCrossings = Table[{Sin[Pi x1 k/y1], 0}, {k, 1, y1 - 1}];

  (* Secondary crossings: k in [p+1, 2p-1] (same x-coords, different k) *)
  secondaryCrossings = Table[{Sin[Pi x1 k/y1], 0}, {k, y1 + 1, 2 y1 - 1}];

  ParametricPlot[{Sin[Pi x1/y1 b], Sin[Pi b]}, {b, 0, 2 y1},
    Frame -> True,
    FrameLabel -> {
      Style[Row[{"sin(\[Pi]t \[CenterDot] ", DisplayForm[FractionBox[x1, y1]], ")"}], 12],
      Style["sin(\[Pi]t)", 12]
    },
    PlotLabel -> Style[Row[{"\[Omega] = ", DisplayForm[FractionBox[x1, y1]]}], Bold, 14],
    ImagePadding -> {{50, 15}, {55, 20}},
    AspectRatio -> 1,
    PlotStyle -> {Blue, Thickness[0.004]},
    Epilog -> {
      (* Secondary crossings: hollow circles *)
      Gray, Thickness[0.002],
      Circle[#, 0.03] & /@ secondaryCrossings,

      (* Primary crossings: filled *)
      Gray, PointSize[Medium],
      Point[primaryCrossings],

      (* k-prime crossing in green *)
      Darker[Green], PointSize[Large],
      Point[{kprimeX, 0}],
      Text[Style[Row[{Superscript["k", "\[Prime]"], " = ", kprime}], 11, Darker[Green], Bold],
        {kprimeLabelX, labelY}],

      (* k-star crossing in red *)
      Red, PointSize[Large],
      Point[{kstarX, 0}],
      Text[Style[Row[{Superscript["k", "*"], " = ", kstar}], 11, Red, Bold],
        {kstarLabelX, -labelY}],

      (* Origin marker *)
      Black, PointSize[Small], Point[{0, 0}]
    },
    FrameTicks -> Automatic,
    Background -> White,
    ImageSize -> 350,
    opts
  ]
]

(* Export function *)
exportLissajous[x_, p_, filename_] := Module[{fig},
  fig = ppstEnhanced[x/p];
  Export[filename, fig];
  Print["Exported: ", filename, " (k' = ", PowerMod[x, -1, p],
        ", k* = ", p - PowerMod[x, -1, p], ")"];
  fig
]

(* Side-by-side comparison *)
exportDualityFigure[{x1_, p1_}, {x2_, p2_}, filename_] := Module[{fig1, fig2, combined},
  fig1 = ppstEnhanced[x1/p1, ImageSize -> 300];
  fig2 = ppstEnhanced[x2/p2, ImageSize -> 300];
  combined = Row[{fig1, Spacer[20], fig2}];
  Export[filename, combined, ImageSize -> 700];
  Print["Exported combined figure: ", filename];
  combined
]

(* Generate figures when run as script *)
If[$ScriptCommandLine =!= {},
  Print["Generating Lissajous figures for paper..."];

  (* Individual figures *)
  exportLissajous[7, 11, "docs/papers/figures/lissajous_7_11.pdf"];
  exportLissajous[2, 3, "docs/papers/figures/lissajous_2_3.pdf"];

  (* Combined figure *)
  exportDualityFigure[{7, 11}, {2, 3}, "docs/papers/figures/lissajous_7_11_2_3.pdf"];

  Print["Done."];
]
