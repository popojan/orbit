pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

Print["================================================================"];
Print["  THE GOVERNING PRINCIPLE: Chebyshev elevation of order units"];
Print["================================================================\n"];

Print["For d = 2^a,  n = 4k² + 2^a = 4(k² + 2^{a-2}):"];
Print[];
Print["  'Order unit':  z = (k² + 2^{a-2}) / 2^{a-2}"];
Print["                 w = k / 2^{a-2}"];
Print["  so that z² - (k²+2^{a-2})·w² = 1  (always)"];
Print[];
Print["  Pell solution: x = T_m(z),  m = max(1, a-2-v₂(k))"];
Print["  ... BUT only works when T_m(z) is integer!\n"];

Print["Denominators:"];
Print["  d=8  (a=3): z = k²+1         denom = 1 → T_m always integer ✓"];
Print["  d=16 (a=4): z = (k²+2)/2     denom = 2 → T_m integer for m≤3 ✓"];
Print["  d=32 (a=5): z = (k²+4)/4     denom = 4 → T_m NOT integer ✗\n"];

(* WHY d=16 works: integrality analysis *)
Print["================================================================"];
Print["  WHY d=16 WORKS: algebraic integrality"];
Print["================================================================\n"];

Print["z = (k²+2)/2.  y_Pell = k·U_{m-1}(z)/4"];
Print[];
Print["m=1: x = z = (k²+2)/2.   Integer iff 2|(k²+2), i.e., k even."];
Print["     y = k/4.             Integer iff 4|k."];
Print["     → R-D branch: 4|k."];
Print[];
Print["m=2: x = 2z²-1 = (k⁴+4k²+2)/2.  Integer iff 2|(k⁴+4k²+2), always ✓"];
Print["     y = k·2z/4 = k(k²+2)/4.    Integer iff 4|k(k²+2)."];
Print["     k even but 4∤k: k≡2(4), k²+2≡2(4), product≡4(16) → 4|... ✓"];
Print["     k odd: k(k²+2) = odd·odd = odd → 4∤... ✗"];
Print["     → degree-4 branch: k even, 4∤k"];
Print[];
Print["m=3: x = 4z³-3z = (k²+2)((k²+2)²-3)/2 = (k²+2)(k⁴+4k²+1)/2"];
Print["     Integer? (k²+2)²-3 = k⁴+4k²+1."];
Print["     k odd: k²+2 odd, k⁴+4k²+1 odd → product odd. BUT wait..."];
(* Actually let me compute properly *)
Do[k0 = 2j+1;
  val = (k0^2+2)*(k0^4+4k0^2+1);
  Print["     k=",k0,": (k²+2)(k⁴+4k²+1) = ", val, " / 2 = ", val/2,
    "  integer: ", IntegerQ[val/2]];
, {j, 1, 5}];
Print[];
Print["     The product is always EVEN for odd k because:"];
Print["     k²+2 ≡ 1+2 = 3 (mod 4),  k⁴+4k²+1 ≡ 1+0+1 = 2 (mod 4)"];
Print["     So k⁴+4k²+1 is always even! → x = integer. ✓"];
Print[];
Print["     y = k(k²+1)(k²+3)/4."];
Print["     k odd: (k²+1)(k²+3) = even·even = 4·(...)  → 4|... ✓"];
Print["     → degree-6 branch: k odd. ✓"];

Print[];
Print["================================================================"];
Print["  WHY d=32 FAILS: denominator analysis"];
Print["================================================================\n"];

Print["z = (k²+4)/4.  For k=3: z = 13/4.\n"];
Print["T₁(13/4) = 13/4                                  NOT integer ✗"];
Print["T₂(13/4) = 2·(13/4)²-1 = 2·169/16-1 = 153/8     NOT integer ✗"];
Print["T₃(13/4) = 4·(13/4)³-3·13/4 = 8788/64-39/4"];
x3 = 4*(13/4)^3 - 3*(13/4);
Print["         = ", x3, "                              ",
  If[IntegerQ[x3], "integer ✓", "NOT integer ✗"]];
x4 = ChebyshevT[4, 13/4];
Print["T₄(13/4) = ", x4, "        ",
  If[IntegerQ[x4], "integer ✓", "NOT integer ✗"]];
Print[];
Print["Actual pslv[68] = ", pslv[68], " (x=33 comes from Q(√17) being R-D!)"];

Print[];
Print["================================================================"];
Print["  COMPLETE PICTURE: when does Chebyshev work?"];
Print["================================================================\n"];

Print["For n = 4k²+d with d = 2^a:"];
Print[];
Print["  z = (k² + 2^{a-2}) / 2^{a-2}  has denominator D = 2^{a-2} / gcd(k²+2^{a-2}, 2^{a-2})"];
Print[];
Print["  T_m(z) integer requires: D^m divides the leading coeff of T_m."];
Print["  T_m has leading coeff 2^{m-1}, so need 2^{m-1} ≥ D^m,"];
Print["  i.e., m-1 ≥ m·log₂(D), i.e., only possible when D ≤ 1 (always)"];
Print["  or D = 2 (limited m). For D ≥ 4: impossible for any m.\n"];

Print["This is why:"];
Print["  d=8  (D=1 for all k):          ALL branches work via Chebyshev"];
Print["  d=16 (D=1 for k even, D=2 odd): ALL branches work (m≤3 suffices)"];
Print["  d=32 (D=4 for k odd):           Chebyshev BREAKS for k odd"];
Print["  d=64 (D=8 for k odd):           Chebyshev BREAKS even more\n"];

Print["The boundary is d = 16: the LAST power of 2 where Chebyshev"];
Print["gives a complete polynomial hierarchy for ALL congruence classes of k."];

Print[];
Print["================================================================"];
Print["  UNIFIED FORMULA (d=8 and d=16 only)"];
Print["================================================================\n"];

Print["┌───────┬───────────┬─────┬────────────────────────────────────────┐"];
Print["│ d     │ v₂(k)     │ m   │ x = T_m(z)                             │"];
Print["├───────┼───────────┼─────┼────────────────────────────────────────┤"];
Print["│ d=8   │ ≥1 (even) │  1  │ T₁(k²+1) = k²+1                       │"];
Print["│ d=8   │  0 (odd)  │  2  │ T₂(k²+1) = 2k⁴+4k²+1                 │"];
Print["├───────┼───────────┼─────┼────────────────────────────────────────┤"];
Print["│ d=16  │ ≥2 (4|k)  │  1  │ T₁((k²+2)/2) = (k²+2)/2               │"];
Print["│ d=16  │  1 (k≡2₄) │  2  │ T₂((k²+2)/2) = (k⁴+4k²+2)/2          │"];
Print["│ d=16  │  0 (odd)  │  3  │ T₃((k²+2)/2) = (k²+2)(k⁴+4k²+1)/2    │"];
Print["└───────┴───────────┴─────┴────────────────────────────────────────┘"];
Print[];
Print["  where m = max(1, a-2-v₂(k))  and  a = log₂(d)"];
Print["  z = (k² + d/4) / (d/4)"];
Print[];
Print["  Degree of x in k: deg = 2m (since z ~ k²)"];
Print["  CF period: L = 2 + 6(m-1) = 6m - 4  (for m≥2)"];
Print[];

(* Verify the L formula *)
Print["CF period verification:"];
Do[
  k0 = 2j+1; n = 4k0^2+8;
  cf = ContinuedFraction[Sqrt[n]];
  L = If[Length[cf]==2, Length[cf[[2]]], "?"];
  Print["  d=8  k=",k0," (m=2): L=",L," expected=", 6*2-4, "=8"];
, {j, 1, 3}];
Do[
  k0 = 2j+1; n = 4k0^2+16;
  cf = ContinuedFraction[Sqrt[n]];
  L = If[Length[cf]==2, Length[cf[[2]]], "?"];
  Print["  d=16 k=",k0," (m=3): L=",L," expected=", 6*3-4, "=14"];
, {j, 3, 5}];
Do[
  k0 = 4j+2; n = 4k0^2+16;
  cf = ContinuedFraction[Sqrt[n]];
  L = If[Length[cf]==2, Length[cf[[2]]], "?"];
  Print["  d=16 k=",k0," (m=2): L=",L," expected=", 6*2-4, "=8"];
, {j, 1, 3}];
