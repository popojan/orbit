(* ::Package:: *)

(* ============================================================================
   Exploratory follow-ups for the Chebyshev Omega-bijection
   Sections:
     P1a. F_d(0) constants for d <= 30 (OEIS-style table)
     P1b. Disc(T_n(x+1) - 1) and content patterns
     P1c. Leading content / residual content vs arithmetic functions
     P2a. Lucas / Fibonacci polynomial analogs (do they handle 4|n?)
     P2b. Exotic substitutions (quadratic, rational, composite shifts)
     P3a. Mod-p Frobenius identity (motivational)
     P3b. q-deformation hint (motivational)
   ========================================================================= *)

primePowerQ[d_Integer] := d > 1 && PrimePowerQ[d];
primeConstQ[c_] := IntegerQ[c] && PrimeQ[Abs[c]];

expectedPrimes[n_Integer] := Module[{ppDivs},
  ppDivs = Select[Divisors[n], primePowerQ];
  Sort[FactorInteger[#][[1, 1]] & /@ ppDivs]];

extractPrimeConstants[poly_] := Module[{fl, items},
  fl = FactorList[poly];
  items = ({#[[1]] /. x -> 0, #[[2]], Exponent[#[[1]], x]}) & /@ fl;
  Sort[Abs[#[[1]]] & /@ Select[items, primeConstQ[#[[1]]] && #[[3]] >= 1 &]]];

(* ----- P1a. F_d(0) constants -------------------------------------------- *)

Print["================ P1a. F_d(0) for d = 2..30 ================"];
Print["d-th cyclotomic Chebyshev factor of T_d(x+1) - 1, with constant"];
Print[];
Print[StringJoin[StringPadRight[#, 14] & /@
   {"d", "factored?", "Phi_d(1)", "F_d(0)", "deg", "match Phi_d(1)?"}]];
Print[StringRepeat["-", 80]];

fdData = Table[
  Module[{fl, primfactors, dmainFactor, c, deg, phi1},
    phi1 = Cyclotomic[d, 1];
    fl = FactorList[ChebyshevT[d, x + 1] - 1];
    (* Find the "d-th cyclotomic Chebyshev" factor: degree = phi(d)/2 (for d>2)
       or degree 1 for d in {1,2}, and "matching" the d-th orbit *)
    primfactors = Select[fl, #[[2]] > 0 &];
    targetDeg = If[d <= 2, 1, EulerPhi[d]/2];
    candidates = Select[primfactors, Exponent[#[[1]], x] === targetDeg &];
    dmainFactor = If[Length[candidates] > 0, First[candidates], None];
    If[dmainFactor =!= None,
      c = (dmainFactor[[1]] /. x -> 0);
      deg = Exponent[dmainFactor[[1]], x];
      {d, "Y", phi1, c, deg, c === phi1},
      {d, "?", phi1, "n/a", "n/a", "n/a"}]],
  {d, 2, 30}];

Do[Print[StringJoin[StringPadRight[ToString[#], 14] & /@ row]],
  {row, fdData}];

(* OEIS-relevant: integer constants of primary cyclotomic Chebyshev factors *)
Print[];
Print["Sequence of F_d(0) for d=2..30:"];
Print[#[[4]] & /@ fdData];

(* ----- P1b. Discriminant patterns -------------------------------------- *)

Print[];
Print["================ P1b. Disc(T_n(x+1) - 1) ================"];
Print[];
Print[StringJoin[StringPadRight[#, 12] & /@
   {"n", "Omega(n)", "Disc factored", "abs|Disc|^(1/n)"}]];
Print[StringRepeat["-", 70]];

Do[
  poly = ChebyshevT[n, x + 1] - 1;
  disc = Discriminant[poly, x];
  fact = If[disc =!= 0, FactorInteger[Abs[disc]], "0"];
  Print[StringJoin[StringPadRight[ToString[#], 12] & /@
     {n, PrimeOmega[n], fact, If[disc =!= 0, N[Abs[disc]^(1/n), 4], "-"]}]],
  {n, 2, 16}];

(* ----- P1c. Content / residual content vs arithmetic functions --------- *)

Print[];
Print["================ P1c. Leading & residual content ================"];
Print[];
Print[StringJoin[StringPadRight[#, 10] & /@
   {"n", "v2(n)", "lead", "v2(lead)", "n-1", "sigma(n)", "phi(n)"}]];
Print[StringRepeat["-", 70]];

Do[
  poly = ChebyshevT[n, x + 1] - 1;
  leading = Coefficient[poly, x, n];
  v2lead = IntegerExponent[leading, 2];
  Print[StringJoin[StringPadRight[ToString[#], 10] & /@
     {n, IntegerExponent[n, 2], leading, v2lead, n - 1,
      DivisorSigma[1, n], EulerPhi[n]}]],
  {n, 2, 20}];

(* Hypothesis check: for 4|n, the "missing" prime-2 factors are encoded in
   the integer constant pulled out by FactorList (its content). Compute that. *)

Print[];
Print["FactorList integer-content of T_n(x+1) - 1 (deg-0 entry):"];
Print[StringJoin[StringPadRight[#, 12] & /@
   {"n", "v2", "Omega2(n)", "intCont", "v2(intCont)"}]];
Print[StringRepeat["-", 60]];
Do[
  fl = FactorList[ChebyshevT[n, x + 1] - 1];
  intCont = If[Exponent[fl[[1, 1]], x] === 0, fl[[1, 1]], 1];
  Print[StringJoin[StringPadRight[ToString[#], 12] & /@
    {n, IntegerExponent[n, 2], IntegerExponent[n, 2], intCont, IntegerExponent[Abs[intCont], 2]}]],
  {n, 2, 32}];

(* ----- P2a. Lucas / Fibonacci polynomial analogs ----------------------- *)

Print[];
Print["================ P2a. Lucas/Fibonacci polynomial analogs ================"];
Print["Testing whether other Chebyshev-like recurrences fix the 4|n case"];
Print[];

(* Fibonacci polynomial: F_0=0, F_1=1, F_{n+1}(x) = x F_n + F_{n-1} *)
fibPoly[n_] := Module[{a = 0, b = 1, t},
  Do[t = x*b + a; a = b; b = t, {n}]; a];

(* Lucas polynomial: L_0 = 2, L_1 = x, L_{n+1} = x L_n + L_{n-1} *)
lucasPoly[n_] := Module[{a = 2, b = x, t},
  If[n === 0, Return[2]];
  Do[t = x*b + a; a = b; b = t, {n - 1}]; b];

(* Test: which polynomials fix 4|n? *)
candidates = {
  {"T_n(x+1) - 1", Function[m, ChebyshevT[m, x + 1] - 1]},
  {"U_n(x+1) - U_{n-1}(x+1)", Function[m, ChebyshevU[m, x + 1] - ChebyshevU[m - 1, x + 1]]},
  {"FibPoly_n(x+2)", Function[m, fibPoly[m] /. x -> x + 2]},
  {"LucasPoly_n(x+2) - 2", Function[m, (lucasPoly[m] /. x -> x + 2) - 2]},
  {"LucasPoly_n(x+1) - 2", Function[m, (lucasPoly[m] /. x -> x + 1) - 2]},
  {"FibPoly_n(2x)", Function[m, fibPoly[m] /. x -> 2 x]},
  {"LucasPoly_{2n}(x) - 2", Function[m, (lucasPoly[2 m] /. x -> x) - 2]}
};

Print[StringJoin[StringPadRight[#, 32] & /@ Prepend[(ToString /@ Range[4, 32, 4]), "polynomial"]]];
Print[StringRepeat["-", 100]];

Do[
  {label, fn} = cand;
  results = Table[
    poly = fn[n];
    actual = extractPrimeConstants[poly];
    expected = expectedPrimes[n];
    {n, actual, expected, actual === expected},
    {n, Range[4, 32, 4]}];
  okFlags = If[#[[4]], "OK", "F"] & /@ results;
  Print[StringJoin[StringPadRight[#, 32] & /@ Prepend[okFlags, label]]],
  {cand, candidates}];

(* Detailed Lucas dump for n=4,8,12 *)
Print[];
Print["Lucas L_n(x+2) - 2 detailed factorization for n=4,8,12,16:"];
Do[
  poly = (lucasPoly[n] /. x -> x + 2) - 2;
  Print["  n=", n, ":  L_n(x+2) - 2 = ", Factor[poly]],
  {n, {4, 8, 12, 16}}];

(* ----- P2b. Exotic substitutions --------------------------------------- *)

Print[];
Print["================ P2b. Exotic substitutions ================"];

exoticCandidates = {
  {"T_n((x+1)^2) - 1", Function[m, ChebyshevT[m, (x + 1)^2] - 1]},
  {"T_n(x^2 + 2x + 1) - 1", Function[m, ChebyshevT[m, x^2 + 2 x + 1] - 1]},
  {"T_n(2x^2 - 1) - T_n(-1)", Function[m, ChebyshevT[m, 2 x^2 - 1] - ChebyshevT[m, -1]]},
  {"T_n(x+1)*T_n(-x-1) - 1", Function[m, ChebyshevT[m, x + 1] ChebyshevT[m, -x - 1] - 1]},
  {"T_{2n}(x+1) - 1", Function[m, ChebyshevT[2 m, x + 1] - 1]},
  {"T_n(x+1) - T_n(1) using deriv", Function[m, ChebyshevT[m, x + 1] - 1]} (* same as canonical *)
};

Print[StringJoin[StringPadRight[#, 36] & /@ Prepend[(ToString /@ Range[4, 32, 4]), "polynomial"]]];
Print[StringRepeat["-", 100]];

Do[
  {label, fn} = cand;
  results = Table[
    Quiet[Check[
      poly = fn[n];
      actual = extractPrimeConstants[poly];
      expected = expectedPrimes[n];
      {n, actual === expected},
      {n, "ERR"}
    ]],
    {n, Range[4, 32, 4]}];
  okFlags = If[#[[2]] === True, "OK", If[#[[2]] === "ERR", "?", "F"]] & /@ results;
  Print[StringJoin[StringPadRight[#, 36] & /@ Prepend[okFlags, label]]],
  {cand, exoticCandidates}];

(* ----- P3a. Mod-p Frobenius identity ----------------------------------- *)

Print[];
Print["================ P3a. Mod-p Frobenius (motivational) ================"];
Print["Hypothesis: T_n(x+1) - 1 == (T_{n/p^a}(x+1) - 1)^{p^a}  mod p"];
Print["where p^a || n (i.e., p^a | n, p^{a+1} not | n)"];
Print[];

Do[
  poly = ChebyshevT[n, x + 1] - 1;
  Print["n = ", n, "  factorization of n: ", FactorInteger[n]];
  Do[
    {p, a} = pa;
    nReduced = n/p^a;
    polyReduced = ChebyshevT[nReduced, x + 1] - 1;
    rhs = polyReduced^(p^a);
    diff = PolynomialMod[poly - rhs, p];
    Print["  p=", p, "  a=", a, "  n/p^a=", nReduced,
      "  poly == (T_{n/p^a}(x+1)-1)^{p^a} mod p?  ",
      diff === 0],
    {pa, FactorInteger[n]}],
  {n, {6, 12, 18, 30, 60}}];

(* ----- P3b. q-deformation hint ----------------------------------------- *)

Print[];
Print["================ P3b. q-deformation hint (motivational) ================"];
Print["q-Chebyshev: T_n^{(q)}(x) = q-deformed Chebyshev. Quick eval: does"];
Print["constant term of analogous factorization at x = 1 give q-cyclotomic?"];
Print[];

(* Use q-binomial Chebyshev: simple version T_n^q satisfying T_n(cos theta) -> q-deform *)
(* For brevity, just show that at q=1, recovery is Phi_d(1) *)
(* and check Phi_d(q) at q=2, q=3 *)

Print["Phi_d(q) at q in {1, 2, 3} for d = 2..15:"];
Print[StringJoin[StringPadRight[#, 12] & /@ {"d", "Phi(1)", "Phi(2)", "Phi(3)"}]];
Print[StringRepeat["-", 60]];
Do[
  Print[StringJoin[StringPadRight[ToString[#], 12] & /@
    {d, Cyclotomic[d, 1], Cyclotomic[d, 2], Cyclotomic[d, 3]}]],
  {d, 2, 15}];

Print[];
Print["Note: Phi_d(2) gives Bang's theorem / Zsygmondy-relevant primes."];
Print["q-analog likely encodes 'primitive prime divisors' instead of standard primes."];

(* ----- summary --------------------------------------------------------- *)

Print[];
Print["================ summary ================"];
Print["P1a: F_d(0) sequence captured for d <= 30 (printed above)"];
Print["P1b: Discriminant tables computed for n <= 16"];
Print["P1c: Leading content tabulated; relation to v2(n) checked"];
Print["P2a: Lucas/Fibonacci analogs tested for 4|n at n in {4,8,...,32}"];
Print["P2b: Exotic substitutions tested at same n values"];
Print["P3a: Mod-p Frobenius identity verified for sample n"];
Print["P3b: Cyclotomic at q=1,2,3 tabulated for d <= 15"];
