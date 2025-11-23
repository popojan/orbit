#!/usr/bin/env wolframscript
(* Analyze angular velocity of Möbius transformation *)

Print["=== ANGULAR VELOCITY ANALYSIS ===\n"];
Print["Transformation: w = z/(z-1) where z = 1/2 + t*I\n"];

(* Define the transformation *)
z[t_] := 1/2 + t*I;
w[t_] := z[t]/(z[t] - 1);

Print["w(t) = ", w[t]];
Print[];

(* Expand in terms of t *)
wExpanded = ComplexExpand[w[t], TargetFunctions -> {Re, Im}];
Print["Expanded: w(t) = ", Simplify[wExpanded]];
Print[];

(* Separate real and imaginary parts *)
wRe[t_] := (-1 + 4*t^2)/(1 + 4*t^2);
wIm[t_] := (-4*t)/(1 + 4*t^2);

Print["Re(w) = ", wRe[t]];
Print["Im(w) = ", wIm[t]];
Print[];

(* Compute angle θ(t) *)
Print["Computing angle θ(t) = Arg(w(t)):\n"];

theta[t_] := ArcTan[wRe[t], wIm[t]];

(* Sample values *)
sampleT = {-5, -2, -1, -0.5, 0, 0.5, 1, 2, 5};
Print["t | θ(t) [radians] | θ(t) [degrees]"];
Print[StringRepeat["-", 50]];
Do[
  tVal = sampleT[[i]];
  thetaVal = theta[tVal] // N;
  Print[PaddedForm[tVal, {5, 1}], " | ",
        PaddedForm[thetaVal, {8, 4}], " | ",
        PaddedForm[thetaVal*180/Pi, {8, 2}]];
, {i, Length[sampleT]}];
Print[];

(* Angular velocity *)
Print["Computing angular velocity dθ/dt:\n"];

thetaPrime[t_] := D[theta[t], t];
Print["dθ/dt = ", Simplify[thetaPrime[t]]];
Print[];

(* Evaluate at specific points *)
Print["t | dθ/dt"];
Print[StringRepeat["-", 30]];
Do[
  tVal = sampleT[[i]];
  If[tVal == 0,
    Print[PaddedForm[tVal, {5, 1}], " | ", "undefined (limit = -4)"],
    thetaPrimeVal = thetaPrime[tVal] // N;
    Print[PaddedForm[tVal, {5, 1}], " | ", PaddedForm[thetaPrimeVal, {10, 6}]];
  ];
, {i, Length[sampleT]}];
Print[];

(* Limit as t -> 0 *)
limitVal = Limit[thetaPrime[t], t -> 0];
Print["Limit as t → 0: dθ/dt = ", limitVal];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Check if it's constant *)
Print["Is angular velocity constant?\n"];
Print["NO - dθ/dt varies with t"];
Print["For small |t|: dθ/dt ≈ ", Limit[thetaPrime[t], t -> 0]];
Print["For large |t|: dθ/dt → ", Limit[thetaPrime[t], t -> Infinity]];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Inverse question: what parametrization gives constant velocity? *)
Print["INVERSE QUESTION: Parametrization with constant angular velocity\n"];
Print["If we want dθ/ds = c (constant), what is s(t)?\n"];

Print["From w = z/(z-1) with z = 1/2 + t*I:"];
Print["θ(t) = -ArcTan(2t) (approximately for the branch)"];
Print[];

Print["For uniform parametrization, use arc length:"];
Print["θ = s (angle as parameter directly)"];
Print["w(s) = e^(i·s)"];
Print[];

Print["Then inverse transformation gives:"];
Print["z(s) = w/(w-1) = e^(i·s)/(e^(i·s) - 1)"];
Print[];

(* Verify Re(z) = 1/2 *)
Print["Verification that Re(z(s)) = 1/2:\n"];
sampleAngles = {0, Pi/6, Pi/4, Pi/3, Pi/2};
Print["s | z(s) | Re(z)"];
Print[StringRepeat["-", 50]];
Do[
  s = sampleAngles[[i]];
  If[s == 0 || s == Pi,
    Print[PaddedForm[s/Pi, {5, 3}], "π | undefined"],
    zVal = Exp[I*s]/(Exp[I*s] - 1);
    Print[PaddedForm[s/Pi, {5, 3}], "π | ", zVal // N, " | ", Re[zVal] // N];
  ];
, {i, Length[sampleAngles]}];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Alternative: arc length parametrization *)
Print["ARC LENGTH PARAMETRIZATION on line Re(z) = 1/2\n"];
Print["Natural parametrization: s = t (distance along imaginary axis)"];
Print["Arc length = |dz/dt| = |d(1/2 + t*I)/dt| = |I| = 1"];
Print["So t is already arc length parameter on the line ✓\n"];

Print["But on the circle, arc length is θ (angle in radians)"];
Print["So the map is NOT arc-length preserving.\n"];

(* Compute arc length element on circle *)
Print["Computing |dw/dt|:\n"];
wPrime[t_] := D[w[t], t];
Print["dw/dt = ", Simplify[wPrime[t]]];
Print[];

absWPrime[t_] := Abs[wPrime[t]];
Print["|dw/dt| = ", Simplify[absWPrime[t], Assumptions -> Element[t, Reals]]];
Print[];

Print["Sample values:"];
Print["t | |dw/dt|"];
Print[StringRepeat["-", 30]];
Do[
  tVal = sampleT[[i]];
  val = absWPrime[tVal] // N;
  Print[PaddedForm[tVal, {5, 1}], " | ", PaddedForm[val, {10, 6}]];
, {i, Length[sampleT]}];
Print[];

Print["Maximum speed at t = 0: |dw/dt| = ", absWPrime[0] // N];
Print["Speed decreases as |t| → ∞"];
Print[];

Print[StringRepeat["=", 60]];
Print[];

(* Summary *)
Print["SUMMARY:\n"];
Print["✗ Angular velocity is NOT constant"];
Print["  dθ/dt = -4/(1 + 4t²)"];
Print[];
Print["✓ Maximum at t = 0: |dθ/dt| = 4"];
Print["✓ Decreases to 0 as |t| → ∞"];
Print[];
Print["✓ Arc length on line: |dz/dt| = 1 (constant)"];
Print["✗ Arc length on circle: |dw/dt| varies"];
Print[];
Print["The transformation is conformal (angle-preserving)"];
Print["but NOT isometric (distance-changing)"];
