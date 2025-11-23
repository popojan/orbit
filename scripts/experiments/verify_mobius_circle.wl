#!/usr/bin/env wolframscript
(* Verify Möbius transformations mapping Re(z)=1/2 to unit circle *)

Print["=== VERIFICATION: Möbius transformations for Re(z)=1/2 → |w|=1 ===\n"];

(* Test points on the line Re(z) = 1/2 *)
testPoints = Table[1/2 + t*I, {t, {-5, -2, -1, 0, 1, 2, 5, 10}}];

Print["Test points z = 1/2 + t*I:"];
Print[testPoints // TableForm];
Print[];

(* ===================================================================
   TRANSFORMATION 1: w = z/(z-1)
   =================================================================== *)

Print["TRANSFORMATION 1: w = z/(z-1)\n"];
w1[z_] := z/(z - 1);

results1 = Table[{
  t,
  z = 1/2 + t*I,
  w = w1[z],
  absW = Abs[w] // N,
  Chop[absW - 1, 10^-10]
}, {t, {-5, -2, -1, 0, 1, 2, 5}}];

Print["t | z | w | |w| | |w|-1"];
Print[StringRepeat["-", 80]];
Do[
  {t, z, w, absW, diff} = results1[[i]];
  Print[StringForm["`` | `` | `` | `` | ``",
    PaddedForm[t, {3, 1}],
    z,
    w,
    PaddedForm[absW, {5, 10}],
    PaddedForm[diff, {10, 3}, NumberFormat -> (If[#3 == "", "0", #1 <> "×10^" <> #3] &)]
  ]],
  {i, Length[results1]}
];
Print[];

(* Check if all |w| = 1 *)
maxError1 = Max[Abs[results1[[All, 5]]]];
Print["Maximum error for w1: ", maxError1 // ScientificForm];
Print["All points on unit circle? ", maxError1 < 10^-10];
Print[];

(* ===================================================================
   TRANSFORMATION 2: w = (z - a)/(z - b) with a = 0, b = 1
   =================================================================== *)

Print["TRANSFORMATION 2: w = (z - 0)/(z - 1) [same as T1]\n"];
w2[z_] := (z - 0)/(z - 1);

(* Verify it's the same *)
Print["Verification: w2[1/2 + I] = ", w2[1/2 + I]];
Print["Same as w1? ", w2[1/2 + I] === w1[1/2 + I]];
Print[];

(* ===================================================================
   TRANSFORMATION 3: w = (z + 1/2)/(z - 3/2) with r=1
   =================================================================== *)

Print["TRANSFORMATION 3: w = (z + 1/2)/(z - 3/2) [r=1]\n"];
w3[z_] := (z + 1/2)/(z - 3/2);

results3 = Table[{
  t,
  z = 1/2 + t*I,
  w = w3[z],
  absW = Abs[w] // N,
  Chop[absW - 1, 10^-10]
}, {t, {-5, -2, -1, 0, 1, 2, 5}}];

Print["t | |w| | |w|-1"];
Print[StringRepeat["-", 40]];
Do[
  {t, z, w, absW, diff} = results3[[i]];
  Print[StringForm["`` | `` | ``",
    PaddedForm[t, {3, 1}],
    PaddedForm[absW, {5, 10}],
    PaddedForm[diff, {10, 3}, NumberFormat -> (If[#3 == "", "0", #1 <> "×10^" <> #3] &)]
  ]],
  {i, Length[results3]}
];
Print[];

maxError3 = Max[Abs[results3[[All, 5]]]];
Print["Maximum error for w3: ", maxError3 // ScientificForm];
Print["All points on unit circle? ", maxError3 < 10^-10];
Print[];

(* ===================================================================
   TRANSFORMATION 4: w = (z - 1)/z with r=-1/2 (reciprocal)
   =================================================================== *)

Print["TRANSFORMATION 4: w = (z - 1)/z [r=-1/2, reciprocal of T1]\n"];
w4[z_] := (z - 1)/z;

results4 = Table[{
  t,
  z = 1/2 + t*I,
  w = w4[z],
  absW = Abs[w] // N,
  Chop[absW - 1, 10^-10]
}, {t, {-5, -2, -1, 0, 1, 2, 5}}];

Print["t | w | |w| | |w|-1"];
Print[StringRepeat["-", 60]];
Do[
  {t, z, w, absW, diff} = results4[[i]];
  Print[StringForm["`` | `` | `` | ``",
    PaddedForm[t, {3, 1}],
    w,
    PaddedForm[absW, {5, 10}],
    PaddedForm[diff, {10, 3}, NumberFormat -> (If[#3 == "", "0", #1 <> "×10^" <> #3] &)]
  ]],
  {i, Length[results4]}
];
Print[];

maxError4 = Max[Abs[results4[[All, 5]]]];
Print["Maximum error for w4: ", maxError4 // ScientificForm];
Print["All points on unit circle? ", maxError4 < 10^-10];
Print[];

(* ===================================================================
   GENERAL FORMULA: w = (z - 1/2 + r)/(z - 1/2 - r)
   =================================================================== *)

Print["GENERAL FORMULA: w = (z - 1/2 + r)/(z - 1/2 - r)\n"];

wGeneral[z_, r_] := (z - 1/2 + r)/(z - 1/2 - r);

(* Test several values of r *)
testR = {1/4, 1/2, 1, 2, -1/2, -1};
testT = {0, 1, 2};

Print["Testing different r values:"];
Print["r | t | z | |w| | |w|-1"];
Print[StringRepeat["-", 80]];

Do[
  z = 1/2 + t*I;
  w = wGeneral[z, r];
  absW = Abs[w] // N;
  diff = Chop[absW - 1, 10^-10];
  Print[StringForm["`` | `` | `` | `` | ``",
    PaddedForm[r, {4, 2}],
    PaddedForm[t, {3, 1}],
    z,
    PaddedForm[absW, {5, 10}],
    PaddedForm[diff, {10, 3}, NumberFormat -> (If[#3 == "", "0", #1 <> "×10^" <> #3] &)]
  ]],
  {r, testR}, {t, testT}
];

Print[];

(* ===================================================================
   GEOMETRIC VERIFICATION
   =================================================================== *)

Print["=== GEOMETRIC PROPERTIES ===\n"];

(* For w = z/(z-1), find where unit circle maps to *)
Print["Inverse transformation: z = w/(w-1)"];
Print["Where does unit circle |w|=1 map to?"];
Print[];

(* Parametrize unit circle as w = e^(i*theta) *)
zInverse[theta_] := Module[{w = Exp[I*theta]},
  w/(w - 1)
];

sampleThetas = Table[theta, {theta, 0, 2*Pi, Pi/6}];
inversePoints = Table[{theta, zInverse[theta]}, {theta, sampleThetas}];

Print["θ | z = w/(w-1) | Re(z)"];
Print[StringRepeat["-", 60]];
Do[
  {theta, z} = inversePoints[[i]];
  Print[StringForm["`` | `` | ``",
    PaddedForm[theta/Pi, {4, 2}] <> "π",
    z,
    PaddedForm[Re[z] // N, {10, 8}]
  ]],
  {i, Length[inversePoints]}
];

Print[];
Print["Verification: Re(z) ≈ 0.5 for all points? ",
  Max[Abs[Re[#] - 0.5 & /@ inversePoints[[All, 2]]]] < 10^-10
];

Print[];
Print["=== ALL VERIFICATIONS COMPLETE ==="];
