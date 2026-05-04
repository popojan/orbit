(* Extended verification for Theorem 3: F_{pm}(x) == F_m(x)^(p-1) mod p
   Fix: extract F_d directly via min poly of 2 cos(2 pi / d), substitute y -> 2(x+1) *)

(* F_d as primitive integer polynomial in x *)
Fd[d_Integer] := Module[{psi, raw},
  If[d === 1, Return[2 x]];
  psi = MinimalPolynomial[2 Cos[2 Pi/d], y];
  raw = psi /. y -> 2 (x + 1);
  raw / Last[CoefficientList[raw, x]] // FactorTermsList // Last  (* primitive *)
];

(* Sanity: print F_d(0) for d <= 20 to confirm Phi_d(1) match *)
Print["================ F_d(0) sanity ================"];
Print[StringJoin[StringPadRight[#, 10] & /@ {"d", "F_d(0)", "Phi_d(1)", "match"}]];
Do[
  fd = Fd[d];
  c0 = fd /. x -> 0;
  phi1 = Cyclotomic[d, 1];
  Print[StringJoin[StringPadRight[ToString[#], 10] & /@ {d, c0, phi1, c0 === phi1}]],
  {d, 2, 20}];

(* Theorem 3 verification: F_{pm}(x) = F_m(x)^(p-1) mod p *)
Print[];
Print["================ Theorem 3 extended ================"];
Print["F_{pm}(x) == F_m(x)^(p-1) (mod p) for gcd(p, m) = 1, p prime, m >= 2"];
Print[];
Print[StringJoin[StringPadRight[#, 12] & /@
   {"p", "m", "d=pm", "phi(pm)/2", "match", "note"}]];
Print[StringRepeat["-", 80]];

testCases = Flatten[Table[
  If[GCD[p, m] === 1 && m >= 2 && p*m <= 60,
    {p, m},
    Nothing],
  {p, {2, 3, 5, 7, 11, 13}}, {m, 2, 30}], 1];

allMatch = True;
results = Table[
  {p, m} = pair;
  d = p m;
  fd = Fd[d];
  fm = Fd[m];
  fdMod = PolynomialMod[fd, p];
  fmRaisedMod = PolynomialMod[fm^(p - 1), p];
  match = (fdMod === fmRaisedMod);
  allMatch = allMatch && match;
  Print[StringJoin[StringPadRight[ToString[#], 12] & /@
    {p, m, d, EulerPhi[d]/2, If[match, "OK", "FAIL"], ""}]];
  match,
  {pair, testCases}];

Print[];
Print["all match: ", allMatch];
Print["total cases tested: ", Length[testCases]];
Print["passes: ", Count[results, True]];
Print["fails: ", Count[results, False]];

(* Detailed look at any fails *)
fails = Pick[testCases, results, False];
If[Length[fails] > 0,
  Print[];
  Print["Failure details:"];
  Do[
    {p, m} = pair;
    d = p m;
    fd = Fd[d];
    fm = Fd[m];
    fdMod = PolynomialMod[fd, p];
    fmRaisedMod = PolynomialMod[fm^(p - 1), p];
    Print["  p=", p, " m=", m, " d=", d];
    Print["    F_d mod p     = ", fdMod];
    Print["    F_m^(p-1) mod p = ", fmRaisedMod];
    Print["    diff mod p    = ", PolynomialMod[fdMod - fmRaisedMod, p]],
    {pair, fails}]];

(* Theorem 1 extended verification: F_p(x) = (2/p) x^((p-1)/2) mod p, primes up to 100 *)
Print[];
Print["================ Theorem 1 extended (primes p <= 100) ================"];
allMatch1 = True;
Do[
  fp = Fd[p];
  fpMod = PolynomialMod[fp, p];
  expected = JacobiSymbol[2, p] x^((p - 1)/2);
  expectedMod = PolynomialMod[expected, p];
  match = (fpMod === expectedMod);
  allMatch1 = allMatch1 && match;
  If[!match,
    Print["FAIL  p=", p, "  F_p mod p = ", fpMod, "  expected ", expectedMod]],
  {p, Prime[Range[2, PrimePi[100]]]}];
Print["Theorem 1 all primes 3..97 match: ", allMatch1];

(* Theorem 2 extended verification: F_{p^k}(x) = (2/p) x^(phi(p^k)/2) mod p *)
Print[];
Print["================ Theorem 2 extended (prime powers p^k <= 200) ================"];
ppList = Select[Range[2, 200], (PrimePowerQ[#] && # > 2) &];
allMatch2 = True;
Do[
  fd = Fd[d];
  {p, k} = FactorInteger[d][[1]];
  fdMod = PolynomialMod[fd, p];
  expected = JacobiSymbol[2, p] x^(EulerPhi[d]/2);
  expectedMod = PolynomialMod[expected, p];
  match = (fdMod === expectedMod);
  allMatch2 = allMatch2 && match;
  If[!match,
    Print["FAIL  d=", d, "=", p, "^", k, "  F_d mod p = ", fdMod, "  expected ", expectedMod]],
  {d, ppList}];
Print["Theorem 2 all prime powers 3..200 match: ", allMatch2];
