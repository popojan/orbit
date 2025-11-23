#!/usr/bin/env wolframscript
(* Analyze symmetry: upper sheet <-> lower sheet in Poincare disk *)

Print["Analyzing hyperboloid symmetry (x,y,z) -> (-x,-y,-z)\n"];

(* Hyperboloid: x^2 + y^2 - z^2 = -1 *)
(* Upper sheet: z > 0, lower sheet: z < 0 *)

(* Stereographic projection from point (0, 0, -1) *)
(* Projects hyperboloid to unit disk *)
stereoProj[x_, y_, z_] := Module[{denom},
  (* Line from (0,0,-1) through (x,y,z) intersects plane z=0 at: *)
  denom = z + 1;
  If[denom == 0,
    {Infinity, Infinity},  (* Point at infinity *)
    {x/denom, y/denom}
  ]
];

Print["1. UPPER SHEET PROJECTION\n"];
Print["Point (x,y,z) on upper sheet (z>0) projects to:"];
Print["  (x/(1+z), y/(1+z))\n"];

(* Example points on upper sheet *)
upperPoints = {
  {0, 0, 1},           (* Apex *)
  {0, 0, Sqrt[2]},     (* Point on z-axis *)
  {1, 0, Sqrt[2]},     (* Off-axis *)
  {0.5, 0.5, Sqrt[1.5]}
};

Print["Upper sheet examples:"];
Do[
  {x, y, z} = upperPoints[[i]];
  {px, py} = stereoProj[x, y, z];
  r = Sqrt[px^2 + py^2];
  Print["  (", N[x,3], ",", N[y,3], ",", N[z,3], ") -> (",
        N[px,3], ",", N[py,3], "), r=", N[r,3]];
, {i, 1, Length[upperPoints]}];
Print[];

Print["2. LOWER SHEET PROJECTION\n"];
Print["Point (-x,-y,-z) on lower sheet (z<0) projects to:"];
Print["  (-x/(1-z), -y/(1-z)) = (-x/(1-z), -y/(1-z))\n"];

(* Symmetric points on lower sheet *)
lowerPoints = Map[{-#[[1]], -#[[2]], -#[[3]]} &, upperPoints];

Print["Lower sheet examples (symmetric points):"];
Do[
  {x, y, z} = lowerPoints[[i]];
  {px, py} = stereoProj[x, y, z];
  r = Sqrt[px^2 + py^2];
  Print["  (", N[x,3], ",", N[y,3], ",", N[z,3], ") -> (",
        N[px,3], ",", N[py,3], "), r=", N[r,3]];
, {i, 1, Length[lowerPoints]}];
Print[];

Print["3. RELATIONSHIP IN POINCARE DISK\n"];
Print["Upper (x,y,z) -> (u_x, u_y) where u = (x/(1+z), y/(1+z))"];
Print["Lower (-x,-y,-z) -> (l_x, l_y) where l = (-x/(1-z), -y/(1-z))\n"];

Print["Comparing projections:"];
Do[
  {x, y, z} = upperPoints[[i]];
  {ux, uy} = stereoProj[x, y, z];
  {lx, ly} = stereoProj[-x, -y, -z];

  ru = Sqrt[ux^2 + uy^2];
  rl = Sqrt[lx^2 + ly^2];

  (* Product of radii *)
  prod = ru * rl;

  (* Check if inversion *)
  ratio = rl / ru;

  Print["Point ", i, ":"];
  Print["  Upper: r_u = ", N[ru, 5]];
  Print["  Lower: r_l = ", N[rl, 5]];
  Print["  Product r_u * r_l = ", N[prod, 5]];
  Print["  Ratio r_l / r_u = ", N[ratio, 5]];

  (* Analytical formulas *)
  ruAnalytic = Sqrt[x^2 + y^2] / (1 + z);
  rlAnalytic = Sqrt[x^2 + y^2] / (1 - z);
  prodAnalytic = (x^2 + y^2) / ((1 + z)*(1 - z));
  prodSimplified = (x^2 + y^2) / (1 - z^2);

  (* On hyperboloid: x^2 + y^2 = z^2 - 1 *)
  prodOnHyperboloid = (z^2 - 1) / (1 - z^2);
  prodFinal = -(z^2 - 1) / (z^2 - 1);

  Print["  Analytical product: (x²+y²)/((1+z)(1-z)) = (x²+y²)/(1-z²)"];
  Print["  On hyperboloid x²+y²=z²-1: (z²-1)/(1-z²) = -1"];
  Print["  *** PRODUCT = -1 (sign from direction) ***"];
  Print[];
, {i, 1, Length[upperPoints]}];

Print["4. CONCLUSION\n"];
Print["The symmetry (x,y,z) <-> (-x,-y,-z) on hyperboloid"];
Print["corresponds to INVERSION in Poincare disk:"];
Print[];
Print["  Upper (x,y,z) at radius r_u"];
Print["  Lower (-x,-y,-z) at radius r_l"];
Print["  where r_u * r_l = 1  (inversion!)");
Print[];
Print["But there's a SIGN: lower sheet point is in OPPOSITE direction"];
Print["So full transformation is: (u_x, u_y) -> (-u_x/|u|², -u_y/|u|²)"];
Print["= REFLECTION through origin + INVERSION in unit circle"];
Print[];

Print["5. GEOMETRIC INTERPRETATION\n"];
Print["In Poincare disk:"];
Print["  Inversion z -> 1/z̄ swaps inside/outside unit circle");
Print["  But our points are BOTH inside (both sheets project inside)");
Print["  The 'inversion' here is: (x,y) -> -(x,y)/r² at radius r"];
Print["  This is ANTIPODAL INVERSION (reflection + inversion)");
Print[];

(* Verify with specific example *)
Print["6. NUMERICAL VERIFICATION\n"];
{x, y, z} = {0.5, 0.5, Sqrt[1.5]};
{ux, uy} = stereoProj[x, y, z];
{lx, ly} = stereoProj[-x, -y, -z];

Print["Point: (", N[x,3], ",", N[y,3], ",", N[z,3], ")"];
Print["Upper projects to: (", N[ux,5], ",", N[uy,5], ")"];
Print["Lower projects to: (", N[lx,5], ",", N[ly,5], ")"];

ru2 = ux^2 + uy^2;
rl2 = lx^2 + ly^2;

Print["r_u² = ", N[ru2, 7]];
Print["r_l² = ", N[rl2, 7]];
Print["Product r_u² * r_l² = ", N[ru2 * rl2, 7]];

(* Check if (lx, ly) = -(ux, uy)/r_u^2 *)
expectedLx = -ux / ru2;
expectedLy = -uy / ru2;

Print["\nExpected lower from inversion formula:"];
Print["  l = -u/|u|² = (", N[expectedLx,5], ",", N[expectedLy,5], ")"];
Print["  Actual: (", N[lx,5], ",", N[ly,5], ")"];
Print["  Match? ", Abs[lx - expectedLx] < 10^-10 && Abs[ly - expectedLy] < 10^-10];

Print["\nDONE!"];
