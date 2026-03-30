pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]
sqfree[n_] := Times @@ (Power @@@ ({#1, Mod[#2, 2]} & @@@ FactorInteger[n]))

(* For fcond > 1 cases where k != m:
   What determines m/k = 2 vs m/k = 3?
   
   Hypothesis A: m/k = 2 when norm(-1) unit exists for Q(sqrt(n_sf))
   Hypothesis B: m/k = 3 when n_sf ≡ 1 mod 4 (conductor 2 from maximal order)
   Hypothesis C: something about the CF period *)

cases = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  nsf = sqfree[n0];
  {xf, yf} = pslv[n0]; Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  (* Check norm -1 for the FIELD *)
  {xfsf, yfsf} = pslv[nsf];
  normM1field = (xfsf^2 - nsf*yfsf^2 == -1); (* fund unit of field has norm -1? *)
  (* Actually need to check if norm -1 solution EXISTS *)
  cfn = ContinuedFraction[Sqrt[nsf]];
  Lsf = If[Length[cfn]==2, Length[cfn[[2]]], 0];
  normM1 = OddQ[Lsf]; (* odd period = norm -1 exists *)
  
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          cextra = Round[Sqrt[n0/nsf]];
          ff = c*cextra;
          fcond = If[Mod[nsf,4]==1, 2ff, ff];
          AppendTo[cases, {n0, c, k, m, nsf, fcond, normM1, Lsf, Mod[nsf,4]}];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 10}],
{n0, 2, 1000}];

(* Focus on mismatches *)
mm = Select[cases, #[[3]] != #[[4]] &];

Print["=== MISMATCHES: m/k vs norm(-1) and n_sf mod 4 ===\n"];

(* Group by m/k ratio *)
Do[
  sub = Select[mm, #[[4]]/#[[3]] == ratio &];
  If[Length[sub] >= 3,
    nm1count = Count[sub, e_ /; e[[7]]]; (* norm -1 exists *)
    nsf1count = Count[sub, e_ /; e[[9]] == 1]; (* n_sf ≡ 1 mod 4 *)
    Print["m/k = ", ratio, " (", Length[sub], " cases):"];
    Print["  norm(-1) exists: ", nm1count, "/", Length[sub],
      " = ", Round[100. nm1count/Length[sub], 0.1], "%"];
    Print["  n_sf ≡ 1 mod 4:  ", nsf1count, "/", Length[sub],
      " = ", Round[100. nsf1count/Length[sub], 0.1], "%"];
    (* Both? Neither? *)
    both = Count[sub, e_ /; e[[7]] && e[[9]]==1];
    neither = Count[sub, e_ /; !e[[7]] && e[[9]]!=1];
    Print["  both:            ", both];
    Print["  neither:         ", neither];
    Print[]],
{ratio, {2, 3, 1/2, 1/3, 5, 6}}];

(* Cross-tabulation *)
Print["=== CROSS-TAB: norm(-1) x n_sf mod 4 for ALL mismatches ===\n"];

Print["                n_sf≡1(4)  n_sf≡2(4)  n_sf≡3(4)"];
Do[
  label = If[nm1, "norm-1 YES", "norm-1 NO "];
  sub = Select[mm, #[[7]] == nm1 &];
  c1 = Count[sub, e_ /; e[[9]]==1];
  c2 = Count[sub, e_ /; e[[9]]==2];
  c3 = Count[sub, e_ /; e[[9]]==3];
  Print[label, "    ", StringPadRight[ToString[c1],10],
    " ", StringPadRight[ToString[c2],10],
    " ", c3],
{nm1, {True, False}}];

Print["\nSame for k=m cases:"];
eq = Select[cases, #[[3]] == #[[4]] &];
Do[
  label = If[nm1, "norm-1 YES", "norm-1 NO "];
  sub = Select[eq, #[[7]] == nm1 &];
  c1 = Count[sub, e_ /; e[[9]]==1];
  c2 = Count[sub, e_ /; e[[9]]==2];
  c3 = Count[sub, e_ /; e[[9]]==3];
  Print[label, "    ", StringPadRight[ToString[c1],10],
    " ", StringPadRight[ToString[c2],10],
    " ", c3],
{nm1, {True, False}}];

Print["\n=== DETAILED: m/k=2 cases — what's special? ===\n"];
mk2 = Select[mm, #[[4]]/#[[3]] == 2 &];
Print["n values: ", #[[1]] & /@ mk2[[;;Min[20,Length[mk2]]]]];
Print["n_sf values: ", Union[#[[5]] & /@ mk2]];
Print["norm(-1): ", Tally[#[[7]] & /@ mk2]];
Print["L(n_sf) (CF period of sqfree part): ", Tally[#[[8]] & /@ mk2]];

Print["\n=== DETAILED: m/k=3 cases ===\n"];
mk3 = Select[mm, #[[4]]/#[[3]] == 3 &];
Print["n_sf values (first 20): ", Union[#[[5]] & /@ mk3][[;;Min[20,Length[Union[#[[5]]&/@mk3]]]]]];
Print["norm(-1): ", Tally[#[[7]] & /@ mk3]];
Print["n_sf mod 4: ", Tally[#[[9]] & /@ mk3]];
Print["L(n_sf): ", Tally[#[[8]] & /@ mk3] // SortBy[-#[[2]]&]];

Print["\n=== THE ANSWER? ===\n"];
Print["m/k=2: is it ALWAYS when norm(-1) exists AND fcond even?"];
mk2_test = Count[mk2, e_ /; e[[7]] && EvenQ[e[[6]]]];
Print["  ", mk2_test, "/", Length[mk2]];
Print[];
Print["m/k=3: is it ALWAYS when n_sf≡1(4) AND NOT norm(-1)?"];
mk3_test = Count[mk3, e_ /; e[[9]]==1 && !e[[7]]];
Print["  ", mk3_test, "/", Length[mk3]];
mk3_alt = Count[mk3, e_ /; e[[9]]==1];
Print["  (just n_sf≡1(4): ", mk3_alt, "/", Length[mk3], ")"];
