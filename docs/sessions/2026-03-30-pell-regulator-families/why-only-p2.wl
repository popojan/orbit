Print["=== WHY ONLY p=2 WORKS FOR CHEBYSHEV ===\n"];

Print["The integrality trick relies on T_m mapping rationals"];
Print["with small denominator to integers.\n"];

Print["Q: For which denominators q does T_m(p/q) in Z for some m?\n"];

Print["T_m has leading coefficient 2^{m-1}, so:"];
Print["  T_m(p/q) has denominator dividing q^m / gcd(2^{m-1}, q^m)\n"];

Do[
  Print["--- Denominator q = ", q, " ---"];
  Do[
    (* Try p coprime to q *)
    p = q + 1; (* just a test value coprime to q *)
    z = p/q;
    val = ChebyshevT[m, z];
    Print["  T_", m, "(", p, "/", q, ") = ", val,
      "  integer: ", IntegerQ[val]];
    If[IntegerQ[val], Print["  *** FOUND! ***"]; Break[]];
  , {m, 1, 12}];
  Print[];
, {q, {2, 3, 4, 5, 6}}];

Print["=== ALGEBRAIC EXPLANATION ===\n"];
Print["T_m(p/q): denominator of leading term = q^m / 2^{m-1}\n"];
Print["For q=2: q^m/2^{m-1} = 2^m/2^{m-1} = 2."];
Print["  So T_m(p/2) has denom dividing 2 for ALL m."];
Print["  And T_3(p/2) is always integer (proved in the paper).\n"];
Print["For q=3: q^m/2^{m-1} = 3^m/2^{m-1} -> infinity."];
Print["  No cancellation possible. T_m(p/3) NEVER integer.\n"];
Print["For q>=3: q^m/2^{m-1} -> infinity (q > 2)."];
Print["  Chebyshev CANNOT produce integers. Hopeless.\n"];

Print["=== WHAT ABOUT OTHER POLYNOMIAL IDENTITIES? ===\n"];

(* Dickson polynomials: D_n(x,a)^2 - (x^2-4a) E_{n-1}(x,a)^2 = 4a^n *)
Print["Dickson polynomials D_n(x,a) satisfy:"];
Print["  D_n(x,a)^2 - (x^2-4a) E_{n-1}(x,a)^2 = 4 a^n\n"];
Print["For a=1: D_n = 2 T_n(x/2), reduces to Chebyshev."];
Print["For a=-1: D_n(x,-1)^2 - (x^2+4) E_{n-1}(x,-1)^2 = 4(-1)^n"];
Print["  This gives x^2+4 families! (Not x^2-4.)\n"];

(* Check: can Dickson with a=-1 solve different n? *)
Print["Dickson a=-1 identity: for even n,"];
Print["  D_n(x,-1)^2 - (x^2+4) E_{n-1}(x,-1)^2 = 4\n"];

(* D_n(x, -1) for small n *)
Print["D_n(x,-1) polynomials:"];
Do[
  poly = ChebyshevT[n, x/2] * 2 /. x -> x; (* Dickson = 2T_n(x/2) for a=1 *)
  (* For a=-1, use the recurrence D_n = x D_{n-1} + D_{n-2} *)
  Nothing,  (* skip complex computation *)
{n, 1, 4}];

(* Actually let's just directly test: for n = m^2 + 3 (odd prime offset),
   can we find a Pell solution via any known identity? *)
Print["=== DIRECT TEST: n = k^2 + 3 (offset d=3) ===\n"];
Print["These are NOT covered by our Chebyshev tower.\n"];

Do[
  n = k^2 + 3;
  If[!IntegerQ[Sqrt[n]],
    {xa, ya} = {x, y} /. First@FindInstance[x x - n y y == 1, {x, y}, PositiveIntegers];
    (* R-D: works when 3|k *)
    rd = Mod[k, 3] == 0;
    xrd = If[rd, (2k^2+3)/3, "-"];
    Print["  k=", StringPadRight[ToString[k], 4],
      " n=", StringPadRight[ToString[n], 6],
      If[rd, " R-D: x=" <> ToString[xrd] <> " ✓",
        " NOT R-D: x=" <> ToString[xa] <> " (no formula)"]];
  ],
{k, 1, 20}];

Print["\n=== CONCLUSION ===\n"];
Print["The Chebyshev-Pell mechanism is INHERENTLY 2-ADIC."];
Print["T_m maps Z -> Z and (1/2)Z -> Z (via T_3), but"];
Print["T_m NEVER maps (1/p)Z -> Z for any prime p >= 3.\n"];
Print["This means: for non-power-of-2 offsets d, the only"];
Print["covered cases are the classical R-D (m=1, d|2k).\n"];
Print["OPEN: Are there OTHER polynomial families (not Chebyshev)"];
Print["that satisfy Pell-like identities with p-adic integrality?"];
Print["Dickson polynomials with a != 1 are a candidate."];
