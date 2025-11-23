#!/usr/bin/env wolframscript
(* Visualize Palindromic Möbius: (z+i)/(iz+1) maps real axis to unit circle *)

Print["=== PALINDROMIC MÖBIUS VISUALIZATION ===\n"];
Print["f(z) = (z + i)/(iz + 1) with a=1, b=i"];
Print["Property: f(z)·f(1/z) = 1\n"];

(* Palindromic Möbius transformation *)
a = 1;
b = I;
palindromicMobius[z_] := (a*z + b)/(b*z + a);

(* Real axis: z = x (purely real) *)
realAxis[x_] := x;

(* Sample points *)
xValues = Join[Range[-3, -0.2, 0.3], {-0.1}, Range[0.1, 3, 0.3]];
zPoints = realAxis /@ xValues;
wPoints = palindromicMobius /@ zPoints;

Print["Verification that f(z)·f(1/z) = 1:\n"];
Print["z\t\tf(z)\t\tf(1/z)\t\tf(z)·f(1/z)"];
Print[StringRepeat["-", 80]];

Do[
  z = xValues[[i]];
  If[Abs[z] > 0.05,  (* Avoid z=0 *)
    fz = palindromicMobius[z];
    f1z = palindromicMobius[1/z];
    product = Simplify[fz * f1z];
    Print[
      NumberForm[N[z], {5, 2}], "\t\t",
      NumberForm[N[fz], {6, 3}], "\t",
      NumberForm[N[f1z], {6, 3}], "\t",
      NumberForm[N[product], {6, 3}]
    ];
  ];
, {i, {1, 5, 10, 15, 20}}];

Print["\nAll products should equal 1.0\n"];

(* Plot 1: Side-by-side visualization *)
Print["Creating side-by-side visualization...\n"];

zPlot = Graphics[{
  (* Real axis *)
  Thickness[0.005], Blue,
  Line[{{-3.5, 0}, {3.5, 0}}],

  (* Sample points *)
  PointSize[0.015], Red,
  Point[Table[{Re[realAxis[x]], Im[realAxis[x]]}, {x, xValues}]],

  (* Axes *)
  Gray, Dashed,
  Line[{{0, -2}, {0, 2}}],  (* Imaginary axis *)

  (* Special points *)
  PointSize[0.02], Green,
  Point[{0, 0}],  (* Origin *)

  (* Labels *)
  Black,
  Text["Im(z) = 0 (real axis)", {0, -1.7}, {0, -1}],
  Text["z-plane", {3, 1.7}],
  Text["z = 0", {0.2, 0.2}]
},
  PlotRange -> {{-4, 4}, {-2, 2}},
  AspectRatio -> Automatic,
  Frame -> True,
  FrameLabel -> {"Re(z)", "Im(z)"},
  ImageSize -> 350
];

wPlot = Graphics[{
  (* Unit circle |w| = 1 *)
  Thickness[0.005], Blue,
  Circle[{0, 0}, 1],

  (* Transformed points *)
  PointSize[0.015], Red,
  Point[Table[{Re[wPoints[[i]]], Im[wPoints[[i]]]}, {i, Length[wPoints]}]],

  (* Axes *)
  Gray, Dashed,
  Line[{{0, -1.5}, {0, 1.5}}],
  Line[{{-1.5, 0}, {1.5, 0}}],

  (* Special points *)
  PointSize[0.02], Green,
  Point[{0, 1}],  (* f(0) = i *)

  (* Labels *)
  Black,
  Text["|w| = 1", {0, 1.3}, {0, -1}],
  Text["w-plane", {1.2, -1.3}],
  Text["w = (z+i)/(iz+1)", {0, -1.5}, {0, 1}],
  Text["f(0) = i", {0.2, 1.1}]
},
  PlotRange -> {{-1.5, 1.5}, {-1.5, 1.5}},
  AspectRatio -> 1,
  Frame -> True,
  FrameLabel -> {"Re(w)", "Im(w)"},
  ImageSize -> 350
];

sideBySide = GraphicsRow[{zPlot, wPlot}, Spacings -> 50];

Export["viz_palindromic_side_by_side.png", sideBySide, ImageResolution -> 150];
Print["✓ Saved: viz_palindromic_side_by_side.png"];
Print[];

(* Plot 2: Color-coded transformation *)
Print["Creating color-coded transformation...\n"];

coloredPlot = Graphics[{
  (* Arrows showing transformation *)
  Table[
    With[{z = x, w = palindromicMobius[x]},
      If[Abs[z] > 0.05,  (* Avoid singularity *)
        {
          (* Color based on x position *)
          Hue[(x + 3.5)/7],
          Arrow[{
            {Re[z], Im[z]},
            {4 + Re[w], Im[w]}  (* Offset w-plane *)
          }],
          PointSize[0.012],
          Point[{Re[z], Im[z]}],
          Point[{4 + Re[w], Im[w]}]
        },
        {}
      ]
    ],
    {x, -3.5, 3.5, 0.2}
  ],

  (* Real axis *)
  Thickness[0.003], LightBlue,
  Line[{{-3.8, 0}, {3.8, 0}}],

  (* Unit circle (offset) *)
  Thickness[0.003], LightRed,
  Circle[{4, 0}, 1],

  (* Labels *)
  Black,
  Text["z-plane\nIm(z) = 0", {0, -1.5}],
  Text["w-plane\n|w| = 1", {4, -1.5}],
  Text[Style["x = -3.5 (blue) → x = 3.5 (red)", 10], {2, 1.8}],

  (* Show reciprocal property *)
  Text[Style["f(z)·f(1/z) = 1", 12, Bold], {2, 2.2}]
},
  PlotRange -> {{-4, 5.5}, {-2, 2.5}},
  AspectRatio -> Automatic,
  Frame -> True,
  ImageSize -> 700
];

Export["viz_palindromic_colored.png", coloredPlot, ImageResolution -> 150];
Print["✓ Saved: viz_palindromic_colored.png"];
Print[];

(* Plot 3: Verify |w| = 1 *)
Print["Numerical verification that |w| = 1:\n"];
Print["x\t\tz = x\t\tw = f(x)\t\t|w|\t\targ(w)"];
Print[StringRepeat["-", 90]];

verificationData = Table[
  With[{z = x, w = palindromicMobius[x]},
    {x, z, w, Abs[w], Arg[w]}
  ],
  {x, {-3, -2, -1, -0.5, 0.5, 1, 2, 3}}
];

Do[
  {x, z, w, absW, argW} = verificationData[[i]];
  Print[
    NumberForm[x, {5, 1}], "\t\t",
    NumberForm[N[z], {6, 3}], "\t\t",
    NumberForm[N[w], {6, 3}], "\t",
    NumberForm[N[absW], {6, 10}], "\t",
    NumberForm[N[argW], {6, 3}]
  ];
, {i, Length[verificationData]}];

Print[];
Print["All |w| values should be exactly 1.0"];
Print[];

(* Plot 4: Show poles and zeros *)
Print["Special points:\n"];

(* Find pole: iz + 1 = 0 → z = i *)
pole = I;
Print["Pole (denominator = 0): z = i (on imaginary axis)"];

(* Find zero: z + i = 0 → z = -i *)
zero = -I;
Print["Zero (numerator = 0): z = -i (on imaginary axis)"];

(* Check reciprocal *)
poleTimesZero = Simplify[pole * zero];
Print["Pole × Zero = ", poleTimesZero, " (reciprocal pair!)"];
Print[];

(* Plot showing poles/zeros *)
specialPlot = Graphics[{
  (* Real axis *)
  Thickness[0.004], Blue,
  Line[{{-4, 0}, {4, 0}}],

  (* Imaginary axis *)
  Thickness[0.004], Gray, Dashed,
  Line[{{0, -2}, {0, 2}}],

  (* Zero at -i *)
  PointSize[0.03], Red,
  Point[{0, -1}],
  Text[Style["Zero: z = -i", 12, Bold], {0.5, -1}, {-1, 0}],

  (* Pole at +i *)
  PointSize[0.03], Purple,
  Point[{0, 1}],
  Text[Style["Pole: z = +i", 12, Bold], {0.5, 1}, {-1, 0}],

  (* Show reciprocal *)
  Thickness[0.002], Dashed, Orange,
  Circle[{0, 0}, 1],
  Text[Style["Pole × Zero = 1", 10, Italic], {1.2, 0}],

  (* Title *)
  Text[Style["Palindromic Möbius: (z+i)/(iz+1)", 14, Bold], {0, 2.2}]
},
  PlotRange -> {{-4, 4}, {-2.5, 2.5}},
  AspectRatio -> Automatic,
  Frame -> True,
  FrameLabel -> {"Re(z)", "Im(z)"},
  ImageSize -> 500
];

Export["viz_palindromic_poles.png", specialPlot, ImageResolution -> 150];
Print["✓ Saved: viz_palindromic_poles.png"];
Print[];

(* Plot 5: Compare with non-palindromic *)
Print["Creating comparison with non-palindromic Möbius...\n"];

(* Non-palindromic: w = z/(z-1) from before *)
nonPalindromic[z_] := z/(z - 1);

comparisonPlot = GraphicsGrid[{{
  (* Palindromic *)
  Graphics[{
    Text[Style["PALINDROMIC: (z+i)/(iz+1)", 12, Bold], {0, 2.2}],
    Blue, Thickness[0.004],
    Line[{{-3, 0}, {3, 0}}],
    Text["Real axis → |w|=1", {0, -2}],
    Text["f(z)·f(1/z) = 1 ✓", {0, -2.3}, Background -> Yellow]
  },
    PlotRange -> {{-3, 3}, {-2.5, 2.5}},
    Frame -> True,
    ImageSize -> 300
  ],

  (* Non-palindromic *)
  Graphics[{
    Text[Style["NON-PALINDROMIC: z/(z-1)", 12, Bold], {0, 2.2}],
    Blue, Thickness[0.004],
    Line[{{1/2, -3}, {1/2, 3}}],
    Text["Re(z)=1/2 → |w|=1", {1/2, -2}],
    Text["f(z)·f(1/z) ≠ const ✗", {1/2, -2.3}, Background -> LightRed]
  },
    PlotRange -> {{-1, 2}, {-3, 3}},
    Frame -> True,
    ImageSize -> 300
  ]
}}, Spacings -> 30];

Export["viz_palindromic_comparison.png", comparisonPlot, ImageResolution -> 150];
Print["✓ Saved: viz_palindromic_comparison.png"];
Print[];

(* Summary *)
Print[StringRepeat["=", 70]];
Print["SUMMARY"];
Print[StringRepeat["=", 70]];
Print[];
Print["Palindromic Möbius: f(z) = (z+i)/(iz+1)"];
Print[];
Print["✓ Coefficients: [a, b, b, a] = [1, i, i, 1] (palindromic!)"];
Print["✓ Reciprocal equation: f(z)·f(1/z) = 1 (always!)"];
Print["✓ Condition |a|=|b|: |1|=|i|=1 → maps LINE to circle"];
Print["✓ Input: Real axis Im(z) = 0"];
Print["✓ Output: Unit circle |w| = 1"];
Print["✓ Pole/Zero: i and -i (reciprocal pair: i·(-i) = 1)"];
Print[];
Print["Contrast with z/(z-1):"];
Print["✗ Not palindromic"];
Print["✗ No reciprocal equation"];
Print["✓ Still maps a line (Re(z)=1/2) to circle"];
Print[];
Print["Visualizations created:"];
Print["  1. viz_palindromic_side_by_side.png  - Real axis → circle"];
Print["  2. viz_palindromic_colored.png       - Color-coded arrows"];
Print["  3. viz_palindromic_poles.png         - Poles/zeros (reciprocal)"];
Print["  4. viz_palindromic_comparison.png    - Palindromic vs non-palindromic"];
