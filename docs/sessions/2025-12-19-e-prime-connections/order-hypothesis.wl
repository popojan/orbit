(* Test hypothesis: p divides s_n iff ord(7) is large mod p *)

Print["=== ORDER OF 7 HYPOTHESIS ===\n"];

s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

isDividing[p_] := MemberQ[Table[Mod[s[n], p], {n, 0, 2 p - 1}], 0];

data = {};
Do[
  divides = isDividing[p];
  ord7 = MultiplicativeOrder[7, p];
  ratio = N[ord7 / (p - 1), 4];
  AppendTo[data, {p, divides, ord7, ratio}];
, {p, Select[Prime[Range[2, 60]], # != 7 &]}];

Print["p | divides? | ord(7) | ord(7)/(p-1)"];
Print["--+----------+--------+-------------"];
Do[
  {p, div, ord, r} = data[[i]];
  Print[p, " | ", If[div, "YES", "no "], " | ", ord,
        " | ", r, If[r >= 0.5, " *", ""]];
, {i, Length[data]}];

(* Threshold analysis *)
Print["\n=== THRESHOLD ANALYSIS ==="];

dividingRatios = Select[data, #[[2]] &][[All, 4]];
nonDividingRatios = Select[data, !#[[2]] &][[All, 4]];

Print["Dividing primes ord(7)/(p-1):"];
Print["  Min: ", Min[dividingRatios], ", Max: ", Max[dividingRatios],
      ", Mean: ", Mean[dividingRatios]];

Print["\nNon-dividing primes ord(7)/(p-1):"];
Print["  Min: ", Min[nonDividingRatios], ", Max: ", Max[nonDividingRatios],
      ", Mean: ", Mean[nonDividingRatios]];

(* Check if there's a clean threshold *)
Print["\n=== CHECKING THRESHOLDS ==="];
thresholds = {0.25, 0.3, 0.4, 0.5};
Do[
  divAbove = Count[dividingRatios, r_ /; r >= t];
  divBelow = Count[dividingRatios, r_ /; r < t];
  nonDivAbove = Count[nonDividingRatios, r_ /; r >= t];
  nonDivBelow = Count[nonDividingRatios, r_ /; r < t];
  Print["Threshold ", t, ":"];
  Print["  Dividing: ", divAbove, " above, ", divBelow, " below"];
  Print["  Non-dividing: ", nonDivAbove, " above, ", nonDivBelow, " below"];
, {t, thresholds}];

(* Alternative: check (7|p) Legendre symbol *)
Print["\n=== LEGENDRE SYMBOL (7|p) ==="];
divQR = Count[Select[data, #[[2]] &], d_ /; JacobiSymbol[7, d[[1]]] == 1];
divNQR = Count[Select[data, #[[2]] &], d_ /; JacobiSymbol[7, d[[1]]] == -1];
nonDivQR = Count[Select[data, !#[[2]] &], d_ /; JacobiSymbol[7, d[[1]]] == 1];
nonDivNQR = Count[Select[data, !#[[2]] &], d_ /; JacobiSymbol[7, d[[1]]] == -1];

Print["Dividing: ", divQR, " QR, ", divNQR, " NQR"];
Print["Non-dividing: ", nonDivQR, " QR, ", nonDivNQR, " NQR"];

(* Check if it's related to p mod 28 = 4*7 *)
Print["\n=== p MOD 28 ==="];
Print["Dividing primes mod 28: ", Counts[Mod[Select[data, #[[2]] &][[All, 1]], 28]]];
Print["Non-dividing primes mod 28: ", Counts[Mod[Select[data, !#[[2]] &][[All, 1]], 28]]];
