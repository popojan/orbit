(* TV identity verification (2026-06-11)
   Claim (Result 7 reduction):
     Sigma_inf  = (TV + frac(q))/2,   Sigma_tail = (TV - frac(q))/2
   where TV = total variation of the CF convergent sequence
            = Sum 1/(q_{n-1} q_n), in the even-length CF convention.
   Also: format non-uniqueness (six single-tuple reps of 1/6) and the
   reduction of the phi/sqrt2 constants to H_F (OEIS A290565) and H_P. *)
<< Orbit`

tupleValue[{u_, v_, i_, j_}] := (j - i + 1)/((u - v + v i) (u + v j));
tupleFull[{u_, v_, i_, j_}] := 1/(u v);
tupleTail[t_] := tupleFull[t] - tupleValue[t];

(* even-length CF convention: [..., an] -> [..., an-1, 1] if length past a0 is odd *)
evenCF[q_] := Module[{cf = ContinuedFraction[q]},
  If[EvenQ[Length[cf] - 1], cf, Join[Most[cf], {Last[cf] - 1, 1}]]];

convergents[cf_] := FromContinuedFraction /@ Table[Take[cf, k], {k, 1, Length[cf]}];

(* inputs restricted to (0,1); the integer-part tuple is not handled *)
checkTV[q_] := Module[{tuples, fulls, tails, tv},
  tuples = EgyptianFractions[q, Method -> "Raw"];
  fulls = Total[tupleFull /@ tuples];
  tails = Total[tupleTail /@ tuples];
  tv = Total[Abs[Differences[convergents[evenCF[q]]]]];
  {q, fulls - tails == q, fulls == (tv + q)/2, tails == (tv - q)/2}];

Print["q | Sinf-Stail==q | Sinf==(TV+q)/2 | Stail==(TV-q)/2"];
Print[checkTV[#]] & /@ {2/3, 5/8, 7/11, 13/21, 8/13, 1/6, 4/17, 16/113};

(* Format non-uniqueness: all single-tuple reps of 1/6 as full - tail *)
Print["Single-tuple reps of 1/6 as {u, v, m, full, tail}:"];
Print[Reap[Do[
  If[m/(u (u + v m)) == 1/6, Sow[{u, v, m, 1/(u v), 1/(v (u + v m))}]],
  {u, 1, 30}, {v, 1, 30}, {m, 1, 40}]][[2, 1]]];
Print["Canonical (anti-greedy) choice: ", EgyptianFractions[1/6, Method -> "Raw"]];
Print["Binary-vector collision {2} vs {3,4,5}: ", 1/6 == 1/12 + 1/20 + 1/30];

(* Constants: Sigma_inf(phi-1) = (H_F + (phi-1))/2, H_F = OEIS A290565 *)
HF = N[Sum[1/(Fibonacci[n] Fibonacci[n + 1]), {n, 1, 80}], 30];
SinfPhi = N[Sum[1/(Fibonacci[2 k - 1] Fibonacci[2 k]), {k, 1, 40}], 30];
Print["Sigma_inf(phi-1)      = ", SinfPhi];
Print["(H_F + (phi-1))/2     = ", N[(HF + GoldenRatio - 1)/2, 30]];
Print["H_F (= OEIS A290565)  = ", HF];

pell[0] = 1; pell[1] = 2; pell[n_] := pell[n] = 2 pell[n - 1] + pell[n - 2];
HP = N[Sum[1/(pell[n] pell[n + 1]), {n, 0, 50}], 30];
SinfSqrt2 = N[Sum[1/(pell[2 k - 2] pell[2 k - 1]), {k, 1, 25}], 30];
Print["Sigma_inf(sqrt2-1)    = ", SinfSqrt2];
Print["(H_P + (sqrt2-1))/2   = ", N[(HP + Sqrt[2] - 1)/2, 30]];
Print["H_P (not in OEIS)     = ", HP];
