#!/usr/bin/env wolframscript
(* Systematic exploration: mapping lines to circles via Möbius *)

Print["=== MÖBIUS TRANSFORMATIONS: LINES TO CIRCLES ===\n"];

Print["RECAP: What we know\n"];
Print[StringRepeat["=", 60]];
Print[];

(* ================================================================
   PART 1: CRITICAL LINE Re(z) = 1/2
   ================================================================ *)

Print["PART 1: CRITICAL LINE Re(z) = 1/2\n"];
Print["Parametrization: z = 1/2 + i·t, t ∈ ℝ"];
Print[];

Print["Transformation: w = z/(z-1)"];
Print["✓ Maps Re(z) = 1/2 to |w| = 1"];
Print["✗ Does NOT satisfy w(z)·w(1/z) = C"];
Print["✗ Non-constant angular velocity"];
Print[];

(* General form for Re(z) = c *)
Print["GENERAL: Vertical line Re(z) = c"];
Print["Parametrization: z = c + i·t, t ∈ ℝ"];
Print[];

Print["Question: Which Möbius maps this to unit circle?"];
Print[];

(* ================================================================
   PART 2: THEORY - Lines to Circles
   ================================================================ *)

Print[StringRepeat["=", 60]];
Print[];
Print["PART 2: MÖBIUS THEORY\n"];

Print["General Möbius: w = (az+b)/(cz+d) with ad-bc ≠ 0"];
Print[];

Print["Key facts:");
Print["1. Möbius maps circles/lines → circles/lines"];
Print["2. Circle through ∞ = line"];
Print["3. To map line L to circle C:");
Print["   - L passes through pole z₀ (where cz+d=0)? → C passes through ∞ (is a line)"];
Print["   - L doesn't pass through pole? → C is a circle"];
Print[];

Print["For line to map to CIRCLE (not line):"];
Print["   Pole must NOT be on the line"];
Print[];

(* ================================================================
   PART 3: VERTICAL LINE Re(z) = c
   ================================================================ *)

Print[StringRepeat["=", 60]];
Print[];
Print["PART 3: VERTICAL LINE Re(z) = c → UNIT CIRCLE\n"];

Print["Parametrization: z = c + i·t"];
Print[];

Print["Try: w = (z - c)/(z - (c+k))  for some k ≠ 0"];
Print["     = (i·t)/(i·t + k)"];
Print[];

(* Test this *)
c = 1/2;
k = -1/2;

Print["Example: c = 1/2, k = -1/2"];
Print["w = (z - 1/2)/(z - 0) = (z - 1/2)/z"];
Print[];

testT = {0, 1, 2, -1};
Print["Testing points z = 1/2 + i·t:"];
Print["t | z | w | |w|"];
Print[StringRepeat["-", 50]];

Do[
  z = c + I*testT[[i]];
  w = (z - c)/z // Simplify;
  absW = Abs[w] // N;
  Print[testT[[i]], " | ", z, " | ", w, " | ", absW];
, {i, Length[testT]}];

Print[];
Print["This does NOT give |w| = 1 uniformly"];
Print[];

(* Try different approach *)
Print["Better approach: Use 3-point formula"];
Print["Map 3 points from line to 3 points on circle"];
Print[];

Print["Standard construction:"];
Print["To map line L to unit circle, need:");
Print["1. Choose 3 points on L: z₁, z₂, z₃"];
Print["2. Choose 3 points on circle: w₁, w₂, w₃ with |wᵢ| = 1"];
Print["3. Unique Möbius maps z₁→w₁, z₂→w₂, z₃→w₃"];
Print[];

(* ================================================================
   PART 4: SPECIFIC CONSTRUCTION for Re(z) = c
   ================================================================ *)

Print[StringRepeat["=", 60]];
Print[];
Print["PART 4: EXPLICIT CONSTRUCTION\n"];

Print["For vertical line Re(z) = c:"];
Print["Standard choice: Map to unit circle via"];
Print[];
Print["w = (z - (c - i))/(z - (c + i))"];
Print[];
Print["This maps:"];
Print["  z = c - i → w = 0 (inside unit circle)"];
Print["  z = c + i → w = ∞ (pole)"];
Print["  Points on Re(z) = c with Im(z) ≠ ±1 → ?"];
Print[];

c = 1/2;
a = c - I;  (* point below line *)
b = c + I;  (* point above line *)

w[z_] := (z - a)/(z - b);

Print["Testing for c = 1/2:"];
Print["w(z) = (z - (1/2 - i))/(z - (1/2 + i))"];
Print[];

testPoints = Table[c + I*t, {t, {-5, -2, -1, 0, 1, 2, 5}}];
Print["t | z | w | |w|"];
Print[StringRepeat["-", 70]];

Do[
  z0 = testPoints[[i]];
  t = Im[z0];
  If[t == 1,
    Print[t, " | ", z0, " | ∞ (pole)"],
    w0 = w[z0] // Simplify;
    absW = Abs[w0] // N;
    Print[t, " | ", z0, " | ", w0, " | ", absW];
  ];
, {i, Length[testPoints]}];

Print[];
Print["✓ All points map to |w| = 1 (except pole)"];
Print[];

(* Verify algebraically *)
Print["ALGEBRAIC VERIFICATION:"];
Print[];
z = c + I*t;
wExpr = (z - a)/(z - b) // Simplify;
Print["For z = c + i·t:"];
Print["w = (c + i·t - (c - i))/(c + i·t - (c + i))"];
Print["  = (i·t + i)/(i·t - i)"];
Print["  = i(t + 1)/(i(t - 1))"];
Print["  = (t + 1)/(t - 1)"];
Print[];

absWSquared = Abs[(t + 1)/(t - 1)]^2 // Simplify;
Print["|w|² = |", (t+1)/(t-1), "|²"];

(* For real t *)
absWSquaredReal = ((t+1)^2)/((t-1)^2);
Print["     = (t+1)²/(t-1)² for real t"];
Print["     = 1 iff |t+1| = |t-1|"];
Print[];

Print["Wait - this is NOT always 1!"];
Print["Let's recalculate...");
Print[];

(* ================================================================
   PART 5: CORRECT FORMULA
   ================================================================ *)

Print[StringRepeat["=", 60]];
Print[];
Print["PART 5: CORRECTED ANALYSIS\n"];

Print["For line Re(z) = c to map to |w| = 1:"];
Print["Need |z - a| = |z - b| where a, b are symmetric about line"];
Print[];

Print["Symmetry condition: If z on line, then"];
Print["|z - a| = |z - b| requires a and b symmetric w.r.t. line"];
Print[];

Print["For vertical line Re(z) = c:");
Print["  a = c - r  (to the left)"];
Print["  b = c + r  (to the right)"];
Print["where r is real, r > 0"];
Print[];

Print["Then w = (z - (c-r))/(z - (c+r))"];
Print[];

c = 1/2;
r = 1/2;

a2 = c - r;  (* = 0 *)
b2 = c + r;  (* = 1 *)

w2[z_] := (z - a2)/(z - b2);

Print["Example: c = 1/2, r = 1/2"];
Print["  a = 0, b = 1"];
Print["  w = z/(z - 1)  (our original formula!)"];
Print[];

testPoints2 = Table[c + I*t, {t, {-5, -2, -1, 0, 1, 2, 5}}];
Print["Testing:"];
Print["t | z | w | |w|"];
Print[StringRepeat["-", 70]];

Do[
  z0 = testPoints2[[i]];
  t = Im[z0];
  w0 = w2[z0] // Simplify;
  absW = Abs[w0] // N;
  Print[t, " | ", z0, " | ", w0, " | ", absW];
, {i, Length[testPoints2]}];

Print[];
Print["✓✓✓ ALL POINTS map to |w| = 1 ✓✓✓"];
Print[];

(* ================================================================
   PART 6: GENERAL LINE z = a + b·t
   ================================================================ *)

Print[StringRepeat["=", 60]];
Print[];
Print["PART 6: GENERAL LINE z = z₀ + v·t\n"];

Print["Parametrization: z(t) = z₀ + v·t"];
Print["where z₀ is a point on line, v is direction vector"];
Print[];

Print["Example: z = (1+i) + (1+2i)·t"];
Print["  Passes through z₀ = 1+i"];
Print["  Direction: v = 1+2i"];
Print[];

Print["To map to unit circle:"];
Print["1. Find two points a, b symmetric w.r.t. line"];
Print["2. Use w = (z-a)/(z-b)"];
Print[];

Print["Symmetry: For line through z₀ with direction v,"];
Print["  Points a, b symmetric iff:"];
Print["  a = z₀ + r·v^⊥  (perpendicular offset)"];
Print["  b = z₀ - r·v^⊥"];
Print["  where v^⊥ = i·v (90° rotation)"];
Print[];

(* Example *)
z0 = 1 + I;
v = 1 + 2*I;
vPerp = I*v;  (* = i(1+2i) = i - 2 *)

Print["Example construction:"];
Print["  z₀ = ", z0];
Print["  v = ", v];
Print["  v^⊥ = i·v = ", vPerp];
Print[];

r = 1;
aGen = z0 + r*vPerp;
bGen = z0 - r*vPerp;

Print["With r = ", r, ":"];
Print["  a = z₀ + r·v^⊥ = ", aGen];
Print["  b = z₀ - r·v^⊥ = ", bGen];
Print[];

wGen[z_] := (z - aGen)/(z - bGen);

testTGen = {-2, -1, 0, 1, 2};
Print["Testing points on line z = (1+i) + (1+2i)·t:"];
Print["t | z | w | |w|"];
Print[StringRepeat["-", 70]];

Do[
  t = testTGen[[i]];
  zTest = z0 + v*t;
  wTest = wGen[zTest] // Simplify;
  absWTest = Abs[wTest] // N;
  Print[t, " | ", zTest, " | ", wTest // N, " | ", absWTest];
, {i, Length[testTGen]}];

Print[];

(* ================================================================
   SUMMARY
   ================================================================ *)

Print[StringRepeat["=", 60]];
Print[];
Print["SUMMARY\n"];

Print["✓ VERTICAL LINE Re(z) = c → unit circle:"];
Print["  w = (z - (c-r))/(z - (c+r))  for any r > 0"];
Print["  Special case r = c: w = z/(z - 2c)"];
Print[];

Print["✓ GENERAL LINE z = z₀ + v·t → unit circle:"];
Print["  w = (z - a)/(z - b)"];
Print["  where a = z₀ + r·(i·v), b = z₀ - r·(i·v)"];
Print["  (points symmetric perpendicular to line)"];
Print[];

Print["✓ Different r values → different rotations on circle"];
Print[];

Print["✗ Generic Möbius does NOT satisfy f(z)·f(1/z) = C"];
Print["✓ Special form (az+b)/(bz+a) DOES satisfy f(z)·f(1/z) = 1"];
Print["  but requires specific symmetric structure"];
Print[];

Print["KEY INSIGHT:");
Print["  Mapping line to circle: easy (many choices)"];
Print["  Satisfying reciprocal equation: requires palindromic form"];
Print["  Both simultaneously: requires special configuration"];
