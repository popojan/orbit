#!/usr/bin/env wolframscript
(* Use cosh product formulas to derive (1+2k) *)

Print["Using cosh product formulas for exact derivation\n"];
Print[StringRepeat["=", 70]];
Print[];

Print["From previous analysis:"];
Print["  U_m(cosh t) - U_{m-1}(cosh t) = cosh((2m+1)t/2) / cosh(t/2)"];
Print["  T_n(cosh t) = cosh(n*t)"];
Print[];

Print["Full product:"];
Print["  T_n * (U_m - U_{m-1}) = cosh(n*t) * cosh((2m+1)t/2) / cosh(t/2)"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

Print["COSH PRODUCT FORMULA:\n"];
Print["  cosh(A) * cosh(B) = [cosh(A+B) + cosh(A-B)] / 2"];
Print[];

Print["Let A = n*t, B = (2m+1)t/2"];
Print["  A+B = n*t + (2m+1)t/2 = [2n + 2m+1]t/2 = (2n+2m+1)t/2"];
Print["  A-B = n*t - (2m+1)t/2 = [2n - 2m-1]t/2 = (2n-2m-1)t/2"];
Print[];

Print["Therefore:"];
Print["  cosh(n*t) * cosh((2m+1)t/2)"];
Print["  = [cosh((2n+2m+1)t/2) + cosh((2n-2m-1)t/2)] / 2"];
Print[];

Print["Dividing by cosh(t/2):"];
Print["  = [cosh((2n+2m+1)t/2) + cosh((2n-2m-1)t/2)] / [2*cosh(t/2)]"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

Print["CASE ANALYSIS:\n"];

Print["k EVEN (k = 2j): n=j, m=j"];
Print["  2n+2m+1 = 2j+2j+1 = 4j+1 = 2(2j)+1 = 2k+1"];
Print["  2n-2m-1 = 2j-2j-1 = -1"];
Print[];
Print["  Product = [cosh((2k+1)t/2) + cosh(-t/2)] / [2*cosh(t/2)]"];
Print["          = [cosh((2k+1)t/2) + cosh(t/2)] / [2*cosh(t/2)]  (cosh even)"];
Print[];

Print["k ODD (k = 2j+1): n=j+1, m=j"];
Print["  2n+2m+1 = 2(j+1)+2j+1 = 2j+2+2j+1 = 4j+3 = 2(2j+1)+1 = 2k+1"];
Print["  2n-2m-1 = 2(j+1)-2j-1 = 2j+2-2j-1 = 1"];
Print[];
Print["  Product = [cosh((2k+1)t/2) + cosh(t/2)] / [2*cosh(t/2)]"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

Print["UNIFIED FORMULA (both cases):\n"];
Print["  D_Chebyshev(t,k) = [cosh((2k+1)t/2) + cosh(t/2)] / [2*cosh(t/2)]"];
Print[];
Print["  Factor of (2k+1), NOT (1+2k)!"];
Print[];

Print["But wait... (2k+1) and (1+2k) are THE SAME!"];
Print["  2k+1 = 1+2k ✓"];
Print[];

Print["So the factor IS (1+2k), appearing as coefficient of t/2:\n"];
Print["  cosh((1+2k)t/2)"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

Print["CONNECTION TO OUR FORMULA:\n"];

Print["Our hyperbolic form uses:"];
Print["  Cosh[(1+2k) * s] / denominator"];
Print["  where s = ArcSinh[sqrt(x/2)]"];
Print[];

Print["Chebyshev derivation gives:"];
Print["  [cosh((1+2k)t/2) + cosh(t/2)] / [2*cosh(t/2)]"];
Print["  where t = ArcCosh[x+1]"];
Print[];

Print["These should be related by:"];
Print["  (1+2k)*s = (1+2k)*t/2"];
Print["  ⟹ s = t/2"];
Print[];

Print["VERIFICATION:\n"];
Print["Does s = t/2 hold?"];
Print["  s = ArcSinh[sqrt(x/2)]"];
Print["  t = ArcCosh[x+1]"];
Print[];

Print["Testing numerically:\n"];
Print["x\t\ts\t\tt\t\tt/2\t\ts/(t/2)"];
Print[StringRepeat["-", 70]];
Do[
  s = ArcSinh[Sqrt[x/2]];
  t = ArcCosh[x + 1];
  Print[N[x,4], "\t\t", N[s,5], "\t\t", N[t,5], "\t\t", N[t/2,5], "\t\t", N[s/(t/2),5]];
, {x, {1, 2, 5, 10, 20}}];
Print[];

Print["NOT EXACTLY t/2, but ratio approaches 1 for large x!"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

Print["EXACT RELATIONSHIP:\n"];

Print["From hyperbolic identities:"];
Print["  cosh(t) = x+1"];
Print["  sinh(t) = sqrt((x+1)² - 1) = sqrt(x² + 2x) = sqrt(x)*sqrt(x+2)"];
Print[];

Print["  cosh(s) = sqrt(1 + sinh²(s)) = sqrt(1 + x/2) = sqrt((2+x)/2)"];
Print["  sinh(s) = sqrt(x/2)"];
Print[];

Print["For s = t/2 to hold:"];
Print["  sinh(t/2) should equal sqrt(x/2)"];
Print[];

Print["Using sinh(t/2) = sqrt[(cosh(t)-1)/2]:"];
Print["  sinh(t/2) = sqrt[(x+1-1)/2] = sqrt(x/2) ✓✓✓"];
Print[];

Print["EXACT! So s = t/2 holds precisely!\n"];

Print["Verification:"];
Do[
  t = ArcCosh[x + 1];
  sFromT = t/2;
  sDirect = ArcSinh[Sqrt[x/2]];
  Print["x=", N[x,4], ": t/2=", N[sFromT,8], ", s=", N[sDirect,8],
        ", diff=", N[Abs[sFromT-sDirect],3]];
, {x, {1, 2, 5, 10, 100}}];
Print[];

Print[StringRepeat["=", 70]];
Print[];

Print["FINAL ANSWER:\n"];
Print["The factor (1+2k) comes from:"];
Print[];
Print["1. Chebyshev product: T_n * (U_m - U_{m-1})"];
Print["2. Hyperbolic extension: u = cosh(t)"];
Print["3. U_m - U_{m-1} simplifies to cosh((2m+1)t/2) / cosh(t/2)"];
Print["4. Product with T_n gives cosh((2n+2m+1)t/2) terms"];
Print["5. For both k even/odd: 2n+2m+1 = 2k+1 = 1+2k"];
Print["6. Relationship s = t/2 transforms (1+2k)t/2 → (1+2k)s"];
Print[];
Print["Therefore: (1+2k) is the natural degree emerging from"];
Print["           the Chebyshev indices n=⌈k/2⌉, m=⌊k/2⌋"];
Print[];

Print["DONE!\n"];
