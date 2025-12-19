(* Test combined characterization with 7, 11, 13 *)

Print["=== COMBINED ORDERS: 7, 11, 13 ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

isDividing[p_] := MemberQ[Table[Mod[s[n], p], {n, 0, 2 p - 1}], 0];

(* Get orders for all three *)
data = {};
Do[
  divides = isDividing[p];
  ord7 = MultiplicativeOrder[7, p];
  ord11 = MultiplicativeOrder[11, p];
  ord13 = MultiplicativeOrder[13, p];
  lcm2 = LCM[ord7, ord11];
  lcm3 = LCM[ord7, ord11, ord13];
  AppendTo[data, {p, divides, ord7, ord11, ord13, lcm2, lcm3}];
, {p, Select[Prime[Range[2, 60]], !MemberQ[{7, 11, 13}, #] &]}];

Print["p | div | ord7 | ord11 | ord13 | lcm(7,11) | lcm(7,11,13) | lcm3=p-1?"];
Print["--+-----+------+-------+-------+-----------+--------------+----------"];
Do[
  {p, div, o7, o11, o13, l2, l3} = data[[i]];
  full = If[l3 == p - 1, "FULL", ""];
  Print[p, " | ", If[div, "Y", "n"], " | ", o7, " | ", o11, " | ", o13,
        " | ", l2, " | ", l3, " | ", full];
, {i, Min[30, Length[data]]}];

(* Check correlation with lcm being full *)
Print["\n=== LCM(7,11,13) = p-1 CORRELATION ==="];

dividing = Select[data, #[[2]] &];
nonDividing = Select[data, !#[[2]] &];

divFull = Count[dividing, d_ /; d[[7]] == d[[1]] - 1];
divNotFull = Count[dividing, d_ /; d[[7]] != d[[1]] - 1];
nonDivFull = Count[nonDividing, d_ /; d[[7]] == d[[1]] - 1];
nonDivNotFull = Count[nonDividing, d_ /; d[[7]] != d[[1]] - 1];

Print["LCM(ord7, ord11, ord13) = p-1:"];
Print["  Dividing: ", divFull, " full, ", divNotFull, " not full"];
Print["  Non-dividing: ", nonDivFull, " full, ", nonDivNotFull, " not full"];

(* Check the ones where lcm is NOT full *)
Print["\n=== CASES WHERE LCM < p-1 ==="];
Print["Dividing with lcm < p-1:"];
Do[
  {p, div, o7, o11, o13, l2, l3} = d;
  If[l3 != p - 1,
    Print["  p=", p, ": lcm=", l3, ", p-1=", p-1, ", ratio=", N[l3/(p-1), 3]]];
, {d, dividing}];

Print["\nNon-dividing with lcm < p-1:"];
Do[
  {p, div, o7, o11, o13, l2, l3} = d;
  If[l3 != p - 1,
    Print["  p=", p, ": lcm=", l3, ", p-1=", p-1, ", ratio=", N[l3/(p-1), 3]]];
, {d, nonDividing}];

(* Alternative: check if ANY of 7,11,13 has small order *)
Print["\n=== MIN ORDER AMONG 7, 11, 13 ==="];
Print["p | div | min(ord) | min/(p-1)"];
Do[
  {p, div, o7, o11, o13, l2, l3} = data[[i]];
  minOrd = Min[o7, o11, o13];
  ratio = N[minOrd / (p - 1), 3];
  If[i <= 25,
    Print[p, " | ", If[div, "Y", "n"], " | ", minOrd, " | ", ratio]];
, {i, Length[data]}];

(* Check if min order < 0.2 correlates with non-dividing *)
Print["\n=== MIN ORDER < 0.2 * (p-1) ==="];
divSmallMin = Count[dividing, d_ /; Min[d[[3]], d[[4]], d[[5]]] < 0.2 (d[[1]] - 1)];
divLargeMin = Count[dividing, d_ /; Min[d[[3]], d[[4]], d[[5]]] >= 0.2 (d[[1]] - 1)];
nonDivSmallMin = Count[nonDividing, d_ /; Min[d[[3]], d[[4]], d[[5]]] < 0.2 (d[[1]] - 1)];
nonDivLargeMin = Count[nonDividing, d_ /; Min[d[[3]], d[[4]], d[[5]]] >= 0.2 (d[[1]] - 1)];

Print["Min(ord7, ord11, ord13) < 0.2*(p-1):"];
Print["  Dividing: ", divSmallMin, " small, ", divLargeMin, " large"];
Print["  Non-dividing: ", nonDivSmallMin, " small, ", nonDivLargeMin, " large"];
