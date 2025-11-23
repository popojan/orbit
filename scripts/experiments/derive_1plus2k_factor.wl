#!/usr/bin/env wolframscript
(* Derive the (1+2k) factor from Chebyshev structure *)

Print["Deriving (1+2k) from Chebyshev product formula\n"];
Print[StringRepeat["=", 70]];
Print[];

Print["Our Chebyshev form:"];
Print["  D(x,k) = T_ceiling(k/2)(x+1) * [U_floor(k/2)(x+1) - U_floor(k/2)-1(x+1)]"];
Print[];

Print["Let's denote:"];
Print["  n = Ceiling[k/2]"];
Print["  m = Floor[k/2]"];
Print[];

Print["CASE ANALYSIS:\n"];

(* Case 1: k even *)
Print["Case 1: k EVEN (k = 2j)"];
Print["  n = Ceiling[2j/2] = j"];
Print["  m = Floor[2j/2] = j"];
Print["  Product: T_j(u) * [U_j(u) - U_{j-1}(u)]"];
Print[];

(* Case 2: k odd *)
Print["Case 2: k ODD (k = 2j+1)"];
Print["  n = Ceiling[(2j+1)/2] = j+1"];
Print["  m = Floor[(2j+1)/2] = j"];
Print["  Product: T_{j+1}(u) * [U_j(u) - U_{j-1}(u)]"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

(* Analyze the difference U_m - U_{m-1} *)
Print["ANALYZING U_m(u) - U_{m-1}(u):\n"];

Print["Chebyshev U polynomials satisfy:"];
Print["  U_n(u) = [sin((n+1)*arccos(u))] / sin(arccos(u))"];
Print[];

Print["For u = cosh(t) (hyperbolic extension):"];
Print["  U_n(cosh t) = sinh((n+1)t) / sinh(t)"];
Print[];

Print["Therefore:"];
Print["  U_m(cosh t) - U_{m-1}(cosh t)"];
Print["  = sinh((m+1)t)/sinh(t) - sinh(m*t)/sinh(t)"];
Print["  = [sinh((m+1)t) - sinh(m*t)] / sinh(t)"];
Print[];

(* Use sinh addition formula *)
Print["Using sinh(A) - sinh(B) = 2*cosh((A+B)/2)*sinh((A-B)/2):"];
Print[];
Print["  A = (m+1)t, B = m*t"];
Print["  (A+B)/2 = [(m+1)t + m*t]/2 = (2m+1)t/2"];
Print["  (A-B)/2 = [(m+1)t - m*t]/2 = t/2"];
Print[];
Print["  sinh((m+1)t) - sinh(m*t) = 2*cosh((2m+1)t/2)*sinh(t/2)"];
Print[];

Print["Therefore:"];
Print["  U_m(cosh t) - U_{m-1}(cosh t) = 2*cosh((2m+1)t/2)*sinh(t/2) / sinh(t)"];
Print[];

Print["Using sinh(t) = 2*sinh(t/2)*cosh(t/2):"];
Print["  = 2*cosh((2m+1)t/2)*sinh(t/2) / [2*sinh(t/2)*cosh(t/2)]"];
Print["  = cosh((2m+1)t/2) / cosh(t/2)"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

(* Now analyze T_n *)
Print["ANALYZING T_n(cosh t):\n"];

Print["For u = cosh(t):"];
Print["  T_n(cosh t) = cosh(n*t)"];
Print[];

Print["Case 1 (k even, k=2j): n=j, m=j"];
Print["  T_j(cosh t) * [U_j - U_{j-1}]"];
Print["  = cosh(j*t) * cosh((2j+1)t/2) / cosh(t/2)"];
Print[];

Print["Case 2 (k odd, k=2j+1): n=j+1, m=j"];
Print["  T_{j+1}(cosh t) * [U_j - U_{j-1}]"];
Print["  = cosh((j+1)*t) * cosh((2j+1)t/2) / cosh(t/2)"];
Print[];

Print[StringRepeat["=", 70]];
Print[];

(* Look for pattern *)
Print["LOOKING FOR (1+2k) PATTERN:\n"];

Print["For k even (k=2j):"];
Print["  Factor in cosh: (2j+1) = 2(k/2)+1 = k+1"];
Print["  But we need (1+2k) = 1+2(2j) = 1+4j = 2(2j)+1"];
Print["  That's (2k+1), not matching...\n"];

Print["Wait! Let me reconsider the full product...\n"];

Print[StringRepeat["=", 70]];
Print[];

(* Product formula approach *)
Print["PRODUCT FORMULA APPROACH:\n"];

Print["Chebyshev product identities:"];
Print["  T_m * T_n = (T_{m+n} + T_{|m-n|})/2"];
Print["  T_m * U_n = (U_{m+n} + U_{m-n})/2  (for m >= n)"];
Print[];

Print["But we have T_n * (U_m - U_{m-1}), not just products...\n"];

Print["Let me try numerical verification first:\n"];

(* Numerical test *)
Print["NUMERICAL VERIFICATION:\n"];
Print[StringRepeat["-", 70]];

Do[
  n = Ceiling[k/2];
  m = Floor[k/2];

  (* Test value *)
  u = 2.5;  (* arbitrary > 1 *)
  t = ArcCosh[u];

  (* Chebyshev product *)
  chebProd = ChebyshevT[n, u] * (ChebyshevU[m, u] - ChebyshevU[m-1, u]);

  (* Our hyperbolic form (without the 1/2 + ... part) *)
  (* We need to find what argument gives same result *)

  (* The denominator part *)
  s = ArcSinh[Sqrt[(u-1)/2]];  (* x = u-1 *)
  hypDenom = Sqrt[2] * Sqrt[u+1];

  (* Try different factors *)
  factors = {k, k+1, 2*k, 2*k+1, k/2, (2*k+1)/2};

  Print["k=", k, " (n=", n, ", m=", m, "):"];
  Print["  Chebyshev product = ", N[chebProd, 6]];

  Do[
    hypNum = Cosh[factor * s];
    hypVal = hypNum / hypDenom;
    ratio = chebProd / hypVal;

    If[Abs[ratio - 1] < 0.01,
      Print["  >>> Factor ", factor, ": cosh(", factor, "*s)/denom = ",
            N[hypVal, 6], " CLOSE! ratio=", N[ratio, 4]];
    ];
  , {factor, factors}];

  (* Also test (1+2k) specifically *)
  hypNum = Cosh[(1+2*k) * s];
  hypVal = hypNum / hypDenom;
  ratio = chebProd / hypVal;
  Print["  *** (1+2k)=", 1+2*k, ": ratio = ", N[ratio, 6]];
  Print[];

, {k, 1, 5}];

Print[StringRepeat["=", 70]];
Print[];

(* Try symbolic *)
Print["SYMBOLIC ATTEMPT:\n"];

Print["For k=1: n=1, m=0"];
Print["  T_1(u) * [U_0(u) - U_{-1}(u)]"];
Print["  = u * [1 - 0] = u"];
Print["  Expected from (1+2k)=3: cosh(3s)/denom where u = cosh(t)"];
Print[];

k = 1;
u = Symbol["u"];
cheb = Expand[ChebyshevT[1, u] * (ChebyshevU[0, u] - 0)];
Print["  Symbolic: ", cheb];
Print[];

Print["For k=2: n=1, m=1"];
k = 2;
n = Ceiling[k/2];
m = Floor[k/2];
cheb = Expand[ChebyshevT[n, u] * (ChebyshevU[m, u] - ChebyshevU[m-1, u])];
Print["  Symbolic: ", cheb];
Print[];

Print["For k=3: n=2, m=1"];
k = 3;
n = Ceiling[k/2];
m = Floor[k/2];
cheb = Expand[ChebyshevT[n, u] * (ChebyshevU[m, u] - ChebyshevU[m-1, u])];
Print["  Symbolic: ", cheb];
Print[];

Print["DONE! Need to analyze these polynomials further...\n"];
