(* Test characterization with 11 instead of 7 *)

Print["=== TESTING WITH 11 ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

isDividing[p_] := MemberQ[Table[Mod[s[n], p], {n, 0, 2 p - 1}], 0];

(* Collect data for primes not equal to 7 or 11 *)
data = {};
Do[
  divides = isDividing[p];
  ord11 = MultiplicativeOrder[11, p];
  ratio = N[ord11 / (p - 1), 4];
  leg11 = JacobiSymbol[11, p];
  AppendTo[data, {p, divides, ord11, ratio, leg11}];
, {p, Select[Prime[Range[2, 60]], # != 7 && # != 11 &]}];

Print["=== MULTIPLICATIVE ORDER OF 11 ===\n"];
Print["p | divides? | ord(11) | ord(11)/(p-1) | (11|p)"];
Print["--+----------+---------+---------------+-------"];
Do[
  {p, div, ord, r, leg} = data[[i]];
  Print[p, " | ", If[div, "YES", "no "], " | ", ord,
        " | ", r, If[r >= 0.5, " *", ""],
        " | ", If[leg == 1, "+1", "-1"]];
, {i, Length[data]}];

(* Separate analysis *)
dividing = Select[data, #[[2]] &];
nonDividing = Select[data, !#[[2]] &];

Print["\n=== STATISTICS FOR ord(11) ==="];
dividingRatios = dividing[[All, 4]];
nonDividingRatios = nonDividing[[All, 4]];

Print["Dividing primes ord(11)/(p-1):"];
Print["  Min: ", Min[dividingRatios], ", Max: ", Max[dividingRatios],
      ", Mean: ", Mean[dividingRatios]];

Print["\nNon-dividing primes ord(11)/(p-1):"];
Print["  Min: ", Min[nonDividingRatios], ", Max: ", Max[nonDividingRatios],
      ", Mean: ", Mean[nonDividingRatios]];

(* Legendre symbol analysis *)
Print["\n=== LEGENDRE SYMBOL (11|p) ==="];
divQR = Count[dividing, d_ /; d[[5]] == 1];
divNQR = Count[dividing, d_ /; d[[5]] == -1];
nonDivQR = Count[nonDividing, d_ /; d[[5]] == 1];
nonDivNQR = Count[nonDividing, d_ /; d[[5]] == -1];

Print["Dividing: ", divQR, " QR, ", divNQR, " NQR"];
Print["Non-dividing: ", nonDivQR, " QR, ", nonDivNQR, " NQR"];

(* Check mod 44 = 4*11 *)
Print["\n=== p MOD 44 ==="];
Print["Dividing primes mod 44: "];
Print[Sort[Normal[Counts[Mod[dividing[[All, 1]], 44]]]]];
Print["Non-dividing primes mod 44: "];
Print[Sort[Normal[Counts[Mod[nonDividing[[All, 1]], 44]]]]];

(* Try product ord(7) * ord(11) or lcm *)
Print["\n=== COMBINED ord(7) AND ord(11) ==="];
Print["p | div? | ord(7) | ord(11) | lcm | lcm/(p-1)"];
Do[
  p = data[[i, 1]];
  div = data[[i, 2]];
  ord11 = data[[i, 3]];
  ord7 = If[p != 7, MultiplicativeOrder[7, p], 0];
  lcmOrd = LCM[ord7, ord11];
  ratio = N[lcmOrd / (p - 1), 3];
  If[i <= 25,
    Print[p, " | ", If[div, "Y", "n"], " | ", ord7, " | ", ord11,
          " | ", lcmOrd, " | ", ratio]];
, {i, Length[data]}];

(* Check if lcm being full order correlates *)
Print["\n=== LCM = p-1 (full order) ==="];
divFull = Count[data, d_ /; d[[2]] && LCM[MultiplicativeOrder[7, d[[1]]], d[[3]]] == d[[1]] - 1];
divNotFull = Count[data, d_ /; d[[2]] && LCM[MultiplicativeOrder[7, d[[1]]], d[[3]]] != d[[1]] - 1];
nonDivFull = Count[data, d_ /; !d[[2]] && LCM[MultiplicativeOrder[7, d[[1]]], d[[3]]] == d[[1]] - 1];
nonDivNotFull = Count[data, d_ /; !d[[2]] && LCM[MultiplicativeOrder[7, d[[1]]], d[[3]]] != d[[1]] - 1];

Print["Dividing: ", divFull, " full, ", divNotFull, " not full"];
Print["Non-dividing: ", nonDivFull, " full, ", nonDivNotFull, " not full"];
