(* ============================================================================
   Wieferich detection via F_p mod p^2.

   Setup:
   - F_p(x) = sum c_k(p) x^k, c_k(p) = 2^k p / (2k+1) * Binomial[(p-1)/2 + k, 2k]
   - Mod p: F_p ≡ (2/p) x^{(p-1)/2}
   - Mod p^2: residual = F_p - (2/p) x^{(p-1)/2}; expect divisible by p
   - For Wieferich p (q_p(2) ≡ 0 mod p): residual / p simpler than for non-Wieferich

   Known Wieferich primes: 1093, 3511 (the only two known < 1.5e17 ?)

   Test plan:
   1. Print F_p mod p^2 structure for small p (p=5,7,11,13,17,19) for baseline
   2. Compute leading coefficient 2^{(p-1)/2} mod p^2 for many p, compare
      Wieferich (1093, 3511) to neighbors.
   3. Compute full F_p mod p^2 for p=1093 and p=3511. Examine residual pattern.
============================================================================ *)

ck[k_, n_] := If[k === 0, n,
  2^k n / (2 k + 1) Binomial[(n - 1)/2 + k, 2 k]];

Fp[p_] := Sum[ck[k, p] x^k, {k, 0, (p - 1)/2}];

fermatQuotient[p_, b_] := Mod[(PowerMod[b, p - 1, p^2] - 1)/p, p];

(* ----- Phase 1: small primes structure ------------------------------- *)

Print["================ Phase 1: structure for small primes ================"];
Do[
  fp = Fp[p];
  fpModP2 = PolynomialMod[fp, p^2];
  jsymb = JacobiSymbol[2, p];
  leading = Mod[2^((p - 1)/2), p^2];
  expectedLeading = Mod[jsymb (1 + p fermatQuotient[p, 2]/2), p^2];
  qp = fermatQuotient[p, 2];
  Print["p = ", p, "  q_p(2) = ", qp, "  Wieferich? ", qp === 0,
        "  leading coeff = ", leading, "  expected = ", expectedLeading];
  Print["  F_p mod p^2 = ", fpModP2];
  residual = fpModP2 - jsymb x^((p - 1)/2);
  residual = PolynomialMod[residual, p^2];
  Print["  residual (F_p - (2/p) x^{(p-1)/2}) mod p^2 = ", residual];
  Print["  residual / p mod p = ", PolynomialMod[residual/p, p] // Expand];
  Print[],
  {p, {3, 5, 7, 11, 13, 17, 19, 23}}];

(* ----- Phase 2: leading coefficient survey for many primes ----------- *)

Print["================ Phase 2: leading coefficient survey ================"];
Print["Compare 2^((p-1)/2) mod p^2 to (2/p)*(1 + p*q_p(2)/2) mod p^2"];
Print[];
Print[StringJoin[StringPadRight[#, 10] & /@
  {"p", "q_p(2)", "Wief?", "(2/p)", "lead-(2/p)", "/p"}]];
Print[StringRepeat["-", 80]];

primes = Join[Prime[Range[2, 25]], {1093, 3511}];

Do[
  qp = fermatQuotient[p, 2];
  jsymb = JacobiSymbol[2, p];
  leading = Mod[2^((p - 1)/2), p^2];
  diff = Mod[leading - jsymb, p^2];
  diffOverP = If[Mod[diff, p] === 0, Mod[diff/p, p], "ERR"];
  Print[StringJoin[StringPadRight[ToString[#], 10] & /@
    {p, qp, qp === 0, jsymb, diff, diffOverP}]],
  {p, primes}];

(* ----- Phase 3: full F_p mod p^2 for known Wieferich primes ---------- *)

Print[];
Print["================ Phase 3: full F_p mod p^2 for Wieferich p ================"];

analyze[p_] := Module[{fp, fpModP2, jsymb, residual, residualOverP, nonzeros},
  Print["p = ", p, "  Wieferich = ", fermatQuotient[p, 2] === 0];
  fp = Fp[p];
  fpModP2 = PolynomialMod[fp, p^2];
  jsymb = JacobiSymbol[2, p];
  residual = PolynomialMod[fpModP2 - jsymb x^((p - 1)/2), p^2];
  Print["  residual nonzero terms (count): ",
    Count[CoefficientList[residual, x], c_ /; c =!= 0]];
  residualOverP = PolynomialMod[residual/p, p];
  Print["  residual/p mod p nonzero terms: ",
    Count[CoefficientList[residualOverP, x], c_ /; c =!= 0]];
  nonzeros = Select[Range[0, (p - 1)/2],
    Coefficient[residualOverP, x, #] =!= 0 &];
  Print["  residual/p mod p nonzero degrees: count=", Length[nonzeros],
    "  first few: ", Take[nonzeros, UpTo[10]],
    "  last few: ", Take[Reverse[nonzeros], UpTo[5]]];
  Print["  leading coef of (residual/p) mod p (deg ", (p - 1)/2, "): ",
    Coefficient[residualOverP, x, (p - 1)/2]];
  Print[];
];

analyze[5];
analyze[7];
analyze[11];
analyze[13];
analyze[1093];

(* small prime survey: which primes look "Wieferich-like" in residual? *)
Print["================ Phase 4: residual sparsity vs Wieferich ================"];
Print["Conjecture: Wieferich p have residual leading coef = 0 mod p (already)"];
Print["Question: does Wieferich also force residual to be 'simpler' beyond leading?"];
Print[];
Do[
  fp = Fp[p];
  fpModP2 = PolynomialMod[fp, p^2];
  jsymb = JacobiSymbol[2, p];
  residual = PolynomialMod[fpModP2 - jsymb x^((p - 1)/2), p^2];
  residualOverP = PolynomialMod[residual/p, p];
  nonzeroCount = Count[CoefficientList[residualOverP, x], c_ /; c =!= 0];
  totalDeg = (p - 1)/2 + 1;
  Print["p = ", StringPadRight[ToString[p], 5],
    "  q_p(2) = ", StringPadRight[ToString[fermatQuotient[p, 2]], 6],
    "  residual/p sparsity = ", nonzeroCount, " / ", totalDeg,
    "  Wief? ", fermatQuotient[p, 2] === 0],
  {p, Prime[Range[2, 25]]}];
