#!/usr/bin/env wolframscript
(* Visualize Möbius transformation: Re(z) = 1/2 → |w| = 1 *)

Print["=== MÖBIUS TRANSFORMATION VISUALIZATION ===\n"];

(* Transformation: w = z/(z-1) *)
mobius[z_] := z/(z - 1);

(* Critical line: z = 1/2 + I*t *)
criticalLine[t_] := 1/2 + I*t;

(* Plot 1: Input (z-plane) and Output (w-plane) side by side *)
Print["Creating side-by-side visualization...\n"];

(* Sample points on critical line *)
tValues = Range[-3, 3, 0.5];
zPoints = criticalLine /@ tValues;
wPoints = mobius /@ zPoints;

(* Z-plane plot *)
zPlot = Graphics[{
  (* Critical line Re(z) = 1/2 *)
  Thickness[0.005], Blue,
  Line[Table[{Re[criticalLine[t]], Im[criticalLine[t]]}, {t, -4, 4, 0.1}]],

  (* Sample points *)
  PointSize[0.02], Red,
  Point[Table[{Re[criticalLine[t]], Im[criticalLine[t]]}, {t, tValues}]],

  (* Axes *)
  Gray, Dashed,
  Line[{{0, -4}, {0, 4}}],  (* Imaginary axis *)
  Line[{{-1, 0}, {2, 0}}],  (* Real axis *)

  (* Labels *)
  Text["Re(z) = 1/2", {1/2, 3.5}, {0, -1}],
  Text["z-plane", {1.5, -3.5}]
},
  PlotRange -> {{-1, 2}, {-4, 4}},
  AspectRatio -> Automatic,
  Frame -> True,
  FrameLabel -> {"Re(z)", "Im(z)"},
  ImageSize -> 300
];

(* W-plane plot *)
wPlot = Graphics[{
  (* Unit circle |w| = 1 *)
  Thickness[0.005], Blue,
  Circle[{0, 0}, 1],

  (* Transformed points *)
  PointSize[0.02], Red,
  Point[Table[{Re[wPoints[[i]]], Im[wPoints[[i]]]}, {i, Length[wPoints]}]],

  (* Axes *)
  Gray, Dashed,
  Line[{{0, -1.5}, {0, 1.5}}],  (* Imaginary axis *)
  Line[{{-1.5, 0}, {1.5, 0}}],  (* Real axis *)

  (* Labels *)
  Text["|w| = 1", {0, 1.3}, {0, -1}],
  Text["w-plane", {1.2, -1.3}],
  Text["w = z/(z-1)", {0, -1.5}, {0, 1}]
},
  PlotRange -> {{-1.5, 1.5}, {-1.5, 1.5}},
  AspectRatio -> 1,
  Frame -> True,
  FrameLabel -> {"Re(w)", "Im(w)"},
  ImageSize -> 300
];

sideBySide = GraphicsRow[{zPlot, wPlot}, Spacings -> 50];

Export["viz_mobius_side_by_side.png", sideBySide, ImageResolution -> 150];
Print["✓ Saved: viz_mobius_side_by_side.png"];
Print[];

(* Plot 2: Animated transformation (color-coded by t parameter) *)
Print["Creating color-coded transformation...\n"];

coloredPlot = Graphics[{
  (* Show how different t-values map *)
  Table[
    With[{z = criticalLine[t], w = mobius[criticalLine[t]]},
      {
        (* Color based on t *)
        Hue[(t + 4)/8],
        (* Arrow from z to w (scaled and offset for visibility) *)
        Arrow[{
          {Re[z], Im[z]},
          {3 + Re[w], Im[w]}  (* Offset w-plane *)
        }],
        (* Points *)
        PointSize[0.015],
        Point[{Re[z], Im[z]}],
        Point[{3 + Re[w], Im[w]}]
      }
    ],
    {t, -4, 4, 0.3}
  ],

  (* Critical line *)
  Thickness[0.003], LightBlue,
  Line[Table[{Re[criticalLine[t]], Im[criticalLine[t]]}, {t, -5, 5, 0.1}]],

  (* Unit circle (offset) *)
  Thickness[0.003], LightRed,
  Circle[{3, 0}, 1],

  (* Labels *)
  Black,
  Text["z-plane\nRe(z) = 1/2", {1/2, -4.5}],
  Text["w-plane\n|w| = 1", {3, -1.5}],

  (* Legend *)
  Text[Style["t = -4 (blue) → t = 4 (red)", 10], {1.5, 4.5}]
},
  PlotRange -> {{-1, 4.5}, {-5, 5}},
  AspectRatio -> Automatic,
  Frame -> True,
  ImageSize -> 600
];

Export["viz_mobius_colored.png", coloredPlot, ImageResolution -> 150];
Print["✓ Saved: viz_mobius_colored.png"];
Print[];

(* Plot 3: Verify |w| = 1 numerically *)
Print["Numerical verification that |w| = 1:\n"];
Print["t\t\tz = 1/2 + I*t\t\tw = z/(z-1)\t\t|w|"];
Print[StringRepeat["-", 80]];

verificationData = Table[
  With[{z = criticalLine[t], w = mobius[criticalLine[t]]},
    {t, z, w, Abs[w]}
  ],
  {t, -3, 3, 1}
];

Do[
  {t, z, w, absW} = verificationData[[i]];
  Print[
    NumberForm[t, {4, 1}], "\t\t",
    NumberForm[N[z], {6, 3}], "\t\t",
    NumberForm[N[w], {6, 3}], "\t\t",
    NumberForm[N[absW], {6, 10}]
  ];
, {i, Length[verificationData]}];

Print[];
Print["All |w| values should be exactly 1.0"];
Print[];

(* Plot 4: 3D visualization showing transformation *)
Print["Creating 3D view...\n"];

(* Create a mesh showing how the line transforms *)
plot3D = ParametricPlot3D[
  {
    (* Input line in 3D (x, y, 0) *)
    {1/2, t, 0},
    (* Output circle in 3D (x, y, 1) *)
    {Re[mobius[criticalLine[t]]], Im[mobius[criticalLine[t]]], 1}
  },
  {t, -4, 4},
  PlotStyle -> {
    {Thick, Blue},    (* Input line *)
    {Thick, Red}      (* Output circle *)
  },
  PlotRange -> {{-1.5, 1.5}, {-4, 4}, {-0.2, 1.2}},
  BoxRatios -> {1, 2, 0.5},
  AxesLabel -> {"Re", "Im", "plane"},
  ViewPoint -> {2, -2, 1},
  ImageSize -> 500,
  PlotLegends -> {"Input: Re(z)=1/2", "Output: |w|=1"}
];

Export["viz_mobius_3d.png", plot3D, ImageResolution -> 150];
Print["✓ Saved: viz_mobius_3d.png"];
Print[];

(* Summary *)
Print[StringRepeat["=", 60]];
Print["SUMMARY"];
Print[StringRepeat["=", 60]];
Print[];
Print["Transformation: w = z/(z-1)"];
Print["Input:  Vertical line Re(z) = 1/2"];
Print["Output: Unit circle |w| = 1"];
Print[];
Print["Visualizations created:"];
Print["  1. viz_mobius_side_by_side.png  - Side-by-side comparison"];
Print["  2. viz_mobius_colored.png       - Color-coded transformation"];
Print["  3. viz_mobius_3d.png            - 3D view (line → circle)"];
Print[];
Print["Key insight: Infinite vertical line 'wraps' onto compact circle"];
Print["  • Points near t=0 spread out"];
Print["  • Points at t→±∞ collapse to w=1 (pole at z=1)"];
