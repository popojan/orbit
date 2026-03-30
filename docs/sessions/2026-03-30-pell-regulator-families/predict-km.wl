pslv[nn_] := {x, y} /. First@FindInstance[x x - nn y y == 1, {x, y}, PositiveIntegers]

cases = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  {xf, yf} = pslv[n0];
  Rf = Log[N[xf + yf*Sqrt[n0], 50]];
  Do[
    cn = c^2*n0; a0 = Floor[Sqrt[cn]]; r = cn - a0^2;
    If[r > 0 && Denominator[(2a0^2+r)/r] <= 2,
      z = (2a0^2+r)/r; w = 2a0/r;
      Catch[Do[
        xc = ChebyshevT[m, z]; Yc = w*ChebyshevU[m-1, z];
        If[IntegerQ[xc] && IntegerQ[Yc] && xc > 0,
          yn = c*Yc; Rc = Log[N[xc + yn*Sqrt[n0], 50]];
          k = Round[Rc/Rf];
          cf = ContinuedFraction[Sqrt[n0]];
          Ln = If[Length[cf]==2, Length[cf[[2]]], -1];
          cfcn = ContinuedFraction[Sqrt[cn]];
          Lcn = If[Length[cfcn]==2, Length[cfcn[[2]]], -1];
          delta = Denominator[z];
          AppendTo[cases, {n0, c, k, m, k/m, r, delta, Ln, Lcn, OddQ[Ln], OddQ[Lcn]}];
          Throw[True]],
      {m, 1, 20}]]],
  {c, 1, 15}],
{n0, 2, 500}];

(* Filter k/m = 1/3 *)
c13 = Select[cases, Abs[#[[5]] - 1/3] < 0.01 &];
c12 = Select[cases, Abs[#[[5]] - 1/2] < 0.01 &];
c1 = Select[cases, #[[5]] == 1 &];

Print["=== k/m = 1/3: ", Length[c13], " cases ===\n"];
Print[StringPadRight["n",5], StringPadRight["c",4],
  StringPadRight["m",3], StringPadRight["δ",3],
  StringPadRight["r",6], StringPadRight["L(n)",5],
  StringPadRight["L(c²n)",7], "oddL(n) oddL(c²n)"];
Print[StringJoin[Table["-",{55}]]];
Do[{n0,c0,k0,m0,rat,r0,d0,ln,lcn,oln,olcn} = e;
  Print[StringPadRight[ToString[n0],5],
    StringPadRight[ToString[c0],4],
    StringPadRight[ToString[m0],3],
    StringPadRight[ToString[d0],3],
    StringPadRight[ToString[r0],6],
    StringPadRight[ToString[ln],5],
    StringPadRight[ToString[lcn],7],
    If[oln,"ODD   ","even  "],
    If[olcn,"ODD","even"]],
{e, c13[[;;Min[40, Length[c13]]]]}];

Print["\n=== STATISTICS ===\n"];
Print["k/m=1/3:"];
Print["  odd L(n): ", Count[c13, e_ /; e[[10]]], "/", Length[c13]];
Print["  odd L(c²n): ", Count[c13, e_ /; e[[11]]], "/", Length[c13]];
Print["  m=3: ", Count[c13, e_ /; e[[4]]==3], "/", Length[c13]];
Print["  delta=2: ", Count[c13, e_ /; e[[7]]==2], "/", Length[c13]];

Print["\nk/m=1/2:"];
Print["  odd L(n): ", Count[c12, e_ /; e[[10]]], "/", Length[c12]];
Print["  odd L(c²n): ", Count[c12, e_ /; e[[11]]], "/", Length[c12]];

Print["\nk/m=1 (reference):"];
Print["  odd L(n): ", Count[c1, e_ /; e[[10]]], "/", Length[c1]];
Print["  odd L(c²n): ", Count[c1, e_ /; e[[11]]], "/", Length[c1]];

Print["\n=== IS odd L(n) THE PREDICTOR? ===\n"];

(* For m=3 cases: split by odd/even L(n) *)
m3cases = Select[cases, #[[4]] == 3 &];
m3_odd = Select[m3cases, #[[10]] &]; (* odd L(n) *)
m3_even = Select[m3cases, !#[[10]] &];

Print["Among all m=3 cases (", Length[m3cases], "):"];
Print["  L(n) odd:  k/m values: ", Tally[Round[#[[5]], 0.01] & /@ m3_odd] // SortBy[-#[[2]]&]];
Print["  L(n) even: k/m values: ", Tally[Round[#[[5]], 0.01] & /@ m3_even] // SortBy[-#[[2]]&]];

Print["\n=== CONJECTURE TEST ===\n"];
Print["H: k/m = 1/3 iff L(n) is odd AND m = 3"];
Print["H: k/m = 1/2 iff L(n) is odd AND m = 2"];
Print["H: k/m = 1/m iff L(n) is odd (norm-1 exists for n)"];
Print[];

(* Test: for ALL cases where L(n) is odd: is k/m always 1/m? *)
oddLn = Select[cases, #[[10]] &]; (* odd L(n) *)
Print["All cases with odd L(n): ", Length[oddLn]];
Print["  k/m = 1/m: ", Count[oddLn, e_ /; Abs[e[[5]]*e[[4]] - 1] < 0.01]];
Print["  k/m = 1:   ", Count[oddLn, e_ /; Abs[e[[5]] - 1] < 0.01]];
Print["  other:     ", Count[oddLn, e_ /; Abs[e[[5]]*e[[4]]-1] >= 0.01 && Abs[e[[5]]-1] >= 0.01]];

evenLn = Select[cases, !#[[10]] &];
Print["\nAll cases with even L(n): ", Length[evenLn]];
Print["  k = m:     ", Count[evenLn, e_ /; e[[3]] == e[[4]]]];
Print["  k != m:    ", Count[evenLn, e_ /; e[[3]] != e[[4]]]];
