(* Sum of all variants *)

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f01[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 1, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])
f11[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, n - 1}])

Print["SUMA VSECH VARIANT Sum[f[n], n=2..50]"]
Print["======================================"]
Print[""]

s00 = Sum[f00[n], {n, 2, 50}];
s01 = Sum[f01[n], {n, 2, 50}];
s10 = Sum[f10[n], {n, 2, 50}];
s11 = Sum[f11[n], {n, 2, 50}];

Print["f00 (j=0, i=0): ", N[s00, 20]]
Print["f01 (j=0, i=1): ", N[s01, 20]]
Print["f10 (j=1, i=0): ", N[s10, 20], "  <-- 1.0984"]
Print["f11 (j=1, i=1): ", N[s11, 20]]
Print[""]

Print["Rozdily:"]
Print["s10 - s00 = ", N[s10 - s00, 15]]
Print["s10 - s01 = ", N[s10 - s01, 15]]
Print["s10 - s11 = ", N[s10 - s11, 15]]
