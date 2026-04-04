#!/usr/bin/env wolframscript
(* Verification of all numerical calculations in giza-convergents.tex *)

Print["="*80]
Print["Giza Convergents Paper - Numerical Verification"]
Print["="*80]

(* Golden Ratio *)
Print["\n--- Golden Ratio ---"]
phi = GoldenRatio;
Print["φ = ", N[phi, 15]]
Print["φ² - φ - 1 = ", N[phi^2 - phi - 1]]  (* Should be 0 *)

(* √φ/2 calculation *)
Print["\n--- √φ/2 Calculation ---"]
sqrtPhiOver2 = Sqrt[phi]/2;
Print["√φ/2 = ", N[sqrtPhiOver2, 15]]

(* Verify Pythagorean relation for golden pyramid *)
Print["\n--- Golden Pyramid Geometry ---"]
halfBase = 1;
slantHeight = phi;
height = Sqrt[phi];
Print["Half-base = ", halfBase]
Print["Slant height = φ = ", N[phi, 10]]
Print["Height h: h² = φ² - 1 = φ = ", N[phi, 10]]
Print["Therefore h = √φ = ", N[height, 10]]
Print["Height/base ratio = √φ/2 = ", N[height/2, 10]]
Print["Verification: 1² + h² - φ² = ", N[1 + phi - phi^2]]  (* Should be 0 *)

(* Pyramid dimensions *)
Print["\n--- Pyramid Dimensions ---"]
khufuHeight = 280;  (* cubits *)
khufuBase = 440;    (* cubits *)
khafreHeight = 274;
khafreBase = 411;
menkaureHeight = 125;
menkaureBase = 200;

khufuRatio = khufuHeight/khufuBase;
khafreRatio = khafreHeight/khafreBase;
menkaureRatio = menkaureHeight/menkaureBase;

Print["Khufu: ", khufuHeight, "/", khufuBase, " = ", N[khufuRatio, 10], " = ", khufuHeight/GCD[khufuHeight,khufuBase], "/", khufuBase/GCD[khufuHeight,khufuBase]]
Print["Khafre: ", khafreHeight, "/", khafreBase, " = ", N[khafreRatio, 10], " = ", khafreHeight/GCD[khafreHeight,khafreBase], "/", khafreBase/GCD[khafreHeight,khafreBase]]
Print["Menkaure: ", menkaureHeight, "/", menkaureBase, " = ", N[menkaureRatio, 10], " = ", menkaureHeight/GCD[menkaureHeight,menkaureBase], "/", menkaureBase/GCD[menkaureHeight,menkaureBase]]

(* Convergents of √φ/2 *)
Print["\n--- Convergents of √φ/2 ---"]
cf = ContinuedFraction[Sqrt[phi]/2, 10];
Print["CF expansion: ", cf]

convergents = Convergents[Sqrt[phi]/2, 7];
Print["\nConvergent sequence:"]
Do[
  conv = convergents[[i]];
  error = Abs[N[conv - sqrtPhiOver2]];
  errorPct = 100 * error / sqrtPhiOver2;
  Print["  p", i-1, "/q", i-1, " = ", conv, " = ", N[conv, 10],
        "  (error: ", N[errorPct, 4], "%)"],
  {i, 1, Length[convergents]}
]

(* Verify pyramid ratios match convergents *)
Print["\n--- Pyramid Ratios vs Convergents ---"]
Print["2/3 = convergent? ", MemberQ[convergents, 2/3]]
Print["5/8 = convergent? ", MemberQ[convergents, 5/8]]
Print["7/11 = convergent? ", MemberQ[convergents, 7/11]]

Print["\nError from √φ/2:"]
Print["  Khafre (2/3):   ", N[100*Abs[2/3 - sqrtPhiOver2]/sqrtPhiOver2, 4], "%"]
Print["  Menkaure (5/8): ", N[100*Abs[5/8 - sqrtPhiOver2]/sqrtPhiOver2, 4], "%"]
Print["  Khufu (7/11):   ", N[100*Abs[7/11 - sqrtPhiOver2]/sqrtPhiOver2, 4], "%"]

(* Pell equation verification *)
Print["\n--- Pell Equation: x² - (7/11)y² = 1 ---"]
x = 351;
y = 440;
D = 7/11;
pellValue = x^2 - D*y^2;
Print["(x, y) = (", x, ", ", y, ")"]
Print["x² - (7/11)y² = ", x, "² - (7/11)×", y, "² = ", pellValue]
Print["GCD(351, 440) = ", GCD[x, y]]

(* Dedekind cut verification *)
Print["\n--- Dedekind Cut: Bounds for √(7/11) ---"]
sqrt7over11 = Sqrt[7/11];
lowerBound = 280/351;
middleBound = 351/440;
upperBound = 440/351;

Print["√(7/11) = ", N[sqrt7over11, 15]]
Print["280/351 = ", N[lowerBound, 15]]
Print["351/440 = ", N[middleBound, 15]]
Print["440/351 = ", N[upperBound, 15]]

Print["\nInequality check: 280/351 < 351/440 < √(7/11)"]
Print["  280/351 < 351/440? ", lowerBound < middleBound, " (", N[lowerBound, 10], " < ", N[middleBound, 10], ")"]
Print["  351/440 < √(7/11)? ", middleBound < sqrt7over11, " (", N[middleBound, 10], " < ", N[sqrt7over11, 10], ")"]

Print["\nErrors:"]
Print["  |280/351 - √(7/11)| = ", N[Abs[lowerBound - sqrt7over11], 10]]
Print["  Relative error: ", N[100*Abs[lowerBound - sqrt7over11]/sqrt7over11, 4], "%"]
Print["  |351/440 - √(7/11)| = ", N[Abs[middleBound - sqrt7over11], 10]]
Print["  Relative error: ", N[100*Abs[middleBound - sqrt7over11]/sqrt7over11, 4], "%"]

(* Metric conversions *)
Print["\n--- Metric Conversions ---"]
cubitMeters = 0.524;  (* meters *)
Print["Royal cubit = ", cubitMeters, " m"]
Print["\nKhufu:"]
Print["  Height: ", khufuHeight, " cubits = ", N[khufuHeight * cubitMeters, 4], " m"]
Print["  Base: ", khufuBase, " cubits = ", N[khufuBase * cubitMeters, 4], " m"]
Print["Khafre:"]
Print["  Height: ", khafreHeight, " cubits = ", N[khafreHeight * cubitMeters, 4], " m"]
Print["  Base: ", khafreBase, " cubits = ", N[khafreBase * cubitMeters, 4], " m"]
Print["Menkaure:"]
Print["  Height: ", menkaureHeight, " cubits = ", N[menkaureHeight * cubitMeters, 4], " m"]
Print["  Base: ", menkaureBase, " cubits = ", N[menkaureBase * cubitMeters, 4], " m"]

(* Seked calculations *)
Print["\n--- Seked Calculations ---"]
khufuSeked = 7 * (khufuBase/khufuHeight) / 2;
khafreSeked = 7 * (khafreBase/khafreHeight) / 2;
menkaureSeked = 7 * (menkaureBase/menkaureHeight) / 2;

Print["Khufu (7/11):   seked = ", N[khufuSeked, 10], " palms"]
Print["Khafre (2/3):   seked = ", N[khafreSeked, 10], " palms"]
Print["Menkaure (5/8): seked = ", N[menkaureSeked, 10], " palms"]

(* Slope angles *)
Print["\n--- Slope Angles ---"]
khufuAngle = ArcTan[2*khufuHeight/khufuBase] * 180/Pi;
khafreAngle = ArcTan[2*khafreHeight/khafreBase] * 180/Pi;
menkaureAngle = ArcTan[2*menkaureHeight/menkaureBase] * 180/Pi;
goldenAngle = ArcTan[Sqrt[phi]] * 180/Pi;

Print["Khufu:   ", N[khufuAngle, 10], "°"]
Print["Khafre:  ", N[khafreAngle, 10], "°"]
Print["Menkaure: ", N[menkaureAngle, 10], "°"]
Print["Golden pyramid (√φ slant): ", N[goldenAngle, 10], "°"]

Print["\n--- 2/π comparison ---"]
twoPi = 2/Pi;
Print["2/π = ", N[twoPi, 15]]
Print["√φ/2 = ", N[sqrtPhiOver2, 15]]
Print["Difference: ", N[Abs[twoPi - sqrtPhiOver2], 10]]
Print["Relative difference: ", N[100*Abs[twoPi - sqrtPhiOver2]/sqrtPhiOver2, 4], "%"]

Print["\nConvergents of 2/π:"]
cfPi = ContinuedFraction[2/Pi, 10];
Print["CF expansion: ", cfPi]
convergentsPi = Convergents[2/Pi, 7];
Do[
  Print["  ", convergentsPi[[i]]],
  {i, 1, Length[convergentsPi]}
]

Print["\nCommon convergents:"]
common = Intersection[convergents, convergentsPi];
Print["  ", common]

Print["\n" <> "="*80]
Print["Verification complete!"]
Print["="*80]
