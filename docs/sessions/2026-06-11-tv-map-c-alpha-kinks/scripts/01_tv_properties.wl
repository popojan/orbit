(* 01_tv_properties.wl -- TV map regularity (2026-06-11)
   TV(alpha) = Sum 1/(q_{n-1} q_n) over CF convergent denominators.
   Pre-registered hypotheses (documented BEFORE running):
   H-A1: at rational p/q the two CF representations give TV values
         differing by exactly 2/((q - qs) q), qs = q_{n-1} of canonical rep;
         one-sided limits are the two rep values (right limit = even-length rep).
   H-A2: TV(alpha) < HF = Sum 1/(F_n F_{n+1}) for all alpha in (0,1), alpha != phi-1;
         the all-ones CF is the unique maximizer. *)

tvOfRep[cf_List] := Module[{ds},
  ds = Table[Denominator[FromContinuedFraction[Take[cf, k]]], {k, 1, Length[cf]}];
  Total[Table[1/(ds[[k]] ds[[k + 1]]), {k, 1, Length[cf] - 1}]]];

(* --- H-A1: jump law, exhaustive over q <= 40 (exact arithmetic) --- *)
okJump = True; cnt = 0;
Do[
  If[GCD[p, q] == 1,
    Module[{cf, rep2, tv1, tv2, qs},
      cf = ContinuedFraction[p/q];
      rep2 = Join[Most[cf], {Last[cf] - 1, 1}];
      tv1 = tvOfRep[cf]; tv2 = tvOfRep[rep2];
      qs = Denominator[FromContinuedFraction[Most[cf]]];
      cnt++;
      If[tv2 - tv1 =!= 2/((q - qs) q),
        okJump = False; Print["FAIL jump law at ", p, "/", q]]]],
  {q, 2, 40}, {p, 1, q - 1}];
Print["H-A1 jump law tv_long - tv_short == 2/((q-qs)q): ", okJump,
  " (", cnt, " fractions, q<=40)"];

(* --- H-A1: one-sided limits via K-extensions (numeric) --- *)
Print["one-sided limits (K = 10^6 extension), value | leftLim | rightLim:"];
Do[
  Module[{cf, rep2, evenRep, oddRep, tvE, tvO, xE, xO, sE},
    cf = ContinuedFraction[pq];
    rep2 = Join[Most[cf], {Last[cf] - 1, 1}];
    evenRep = If[EvenQ[Length[cf] - 1], cf, rep2];
    oddRep = If[EvenQ[Length[cf] - 1], rep2, cf];
    tvE = tvOfRep[evenRep]; tvO = tvOfRep[oddRep];
    xE = FromContinuedFraction[Join[evenRep, {10^6}]];
    xO = FromContinuedFraction[Join[oddRep, {10^6}]];
    sE = Sign[xE - pq];
    Print[pq, ": TV(evenRep)=", tvE, " reached from side ", sE,
      ";  TV(oddRep)=", tvO, " from side ", Sign[xO - pq],
      ";  numeric: ", N[tvOfRep[ContinuedFraction[xE]] - tvE, 3], " / ",
      N[tvOfRep[ContinuedFraction[xO]] - tvO, 3]]],
  {pq, {1/2, 2/3, 3/7, 5/8}}];

(* --- H-A2: maximizer --- *)
hf = N[Sum[1/(Fibonacci[n] Fibonacci[n + 1]), {n, 1, 90}], 25];
Print["HF = ", hf];
tvAllOnes = N[tvOfRep[Join[{0}, ConstantArray[1, 60]]], 25];
Print["TV([0;1,1,...,1] 60 ones) = ", tvAllOnes, "  (should -> HF)"];
maxRand = 0;
Do[
  Module[{x = RandomReal[{0, 1}, WorkingPrecision -> 80], tv},
    tv = tvOfRep[ContinuedFraction[x, 50]];
    If[tv > maxRand, maxRand = tv]],
  {2000}];
Print["max TV over 2000 random alpha (50 CF terms): ", N[maxRand, 10],
  "  < HF: ", maxRand < hf];
