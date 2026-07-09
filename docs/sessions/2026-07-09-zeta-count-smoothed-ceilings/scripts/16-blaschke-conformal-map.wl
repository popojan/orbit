(* 16 -- Jan's question: is there a (non-)conformal map of the (t,y) plot
   plane -- not the s=sigma+it plane -- that would simplify the correct
   cross-prime summation, using the shared-height fixed points from script 15
   as anchors?
   HYPOTHESES (stated before running):
   H1: ceilSmooth's arctan term IS (a rescaling of) the boundary
       angle-distortion of the Blaschke/Mobius disk automorphism
       B[z,r] = (z-r)/(1-r z): Arg[B[e^(I theta),r]] - theta ==
       -2 Arg[1 - r e^(I theta)].
   H2: B[z,r] fixes z=1 and z=-1 for EVERY real r -- the two boundary
       endpoints of its hyperbolic translation axis. This is the deep reason
       script 15's H1 (shared height at half-integer x, independent of r) is
       true: theta=pi (x=1/2 mod 1) is exactly the antipodal fixed point z=-1.
   H3: conjugating by the Cayley map w=(1+z)/(1-z) (sending +-1 to infinity,0)
       turns B[z,r] into pure scaling w -> lambda(r) w; lambda(r) should equal
       the (1-r)/(1+r) riser/tread ratio already found in today's session
       (README section 4, ceilSmoothS). *)

blaschke[z_, r_] := (z - r)/(1 - r z);

Print["=== H2: B fixes z=1 and z=-1 for all real r ==="];
Print["B[1,r] - 1 = ", FullSimplify[blaschke[1, r] - 1]];
Print["B[-1,r] - (-1) = ", FullSimplify[blaschke[-1, r] + 1]];

Print["\n=== H1: boundary angle map vs ceilSmooth's arctan term ==="];
argOfWobble[x_, r_] := ArcTan[1 - r Cos[2 Pi x], -r Sin[2 Pi x]];
SeedRandom[7];
Print["numeric sweep, max|diff| of Arg[B(e^(I theta))]-theta vs -2 Arg(1-r e^(I theta)), theta=2 Pi x: ",
  Max@Table[
    With[{x0 = RandomReal[{-1, 1}], r0 = RandomReal[{0.01, 0.99}]},
     Module[{lhs, rhs},
      lhs = Mod[Arg[blaschke[Exp[2 Pi I x0], r0]] - 2 Pi x0 + Pi, 2 Pi] - Pi;
      rhs = Mod[-2 argOfWobble[x0, r0] + Pi, 2 Pi] - Pi;
      Abs[lhs - rhs]]], {300}]];

Print["\n=== H3: conjugation w=(1+z)/(1-z) turns B into scaling ==="];
wOf[z_] := (1 + z)/(1 - z);
zOf[ww_] := (ww - 1)/(ww + 1);
wNew = FullSimplify[wOf[blaschke[zOf[ww], r]]];
Print["w(B(z(ww))) = ", wNew];
Print["Simplified ratio wNew/ww (should be (1-r)/(1+r)): ", FullSimplify[wNew/ww]];
Print["Cross-check vs (1-r)/(1+r): ", FullSimplify[wNew/ww - (1 - r)/(1 + r)]];
