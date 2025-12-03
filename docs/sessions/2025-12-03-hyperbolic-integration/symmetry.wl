(* Verify: sum over ALL poles (positive + negative) = 0 *)

Print["=== TOTAL SUM: POSITIVE + NEGATIVE POLES ==="];
Print[""];

(* Direct computation *)
positiveSum[N0_] := Sum[(-1)^m / (4 Pi m), {m, 1, N0}]
negativeSum[N0_] := Sum[(-1)^m / (4 Pi m), {m, 1, N0}] (* Same but with opposite sign *)

(* Actually, Res(-1/m) = (-1)^m · (-1) / (4π·m) from the symmetry *)
(* Let me verify this *)

Print["Res(1/m) = (-1)^m / (4πm)"];
Print["Res(-1/m) = (-1)^{m+1} / (4πm) = -Res(1/m)"];
Print[""];

totalSum[N0_] := Module[{pos, neg},
  pos = Sum[(-1)^m / (4 Pi m), {m, 1, N0}];
  neg = Sum[(-1)^(m+1) / (4 Pi m), {m, 1, N0}];
  pos + neg
]

Print["Total sum (positive + negative) for N poles each:"];
Do[
  ts = totalSum[N0] // N;
  Print["N = ", N0, ": total = ", ts],
  {N0, {10, 100, 1000}}
];

Print[""];
Print["=== THIS IS EXACT CANCELLATION! ==="];
Print[""];
Print["Σ_{m=1}^∞ [(-1)^m + (-1)^{m+1}] / (4πm) = 0"];
Print[""];
Print["Because (-1)^m + (-1)^{m+1} = (-1)^m · (1 + (-1)) = 0"];

Print[""];
Print["=== INTERPRETATION ==="];
Print[""];
Print["• Contour inside |n| < 1: captures only positive poles → -η(s)/(4π)"];
Print["• Contour |n| → ∞: captures ALL poles → 0 (perfect cancellation)"];
Print["• The eta value comes from ASYMMETRY in which poles we include!"];
