(* More variants with i starting at 2 *)

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f01[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 1, n}])
f02[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 2, n}])

f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])
f11[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, n - 1}])
f12[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 2, n - 1}])

Print["SUMA VARIANT Sum[f[n], n=3..50]"]
Print["================================"]
Print["(zaciname od n=3 aby i=2 davalo smysl)"]
Print[""]

s00 = Sum[f00[n], {n, 3, 50}];
s01 = Sum[f01[n], {n, 3, 50}];
s02 = Sum[f02[n], {n, 3, 50}];
s10 = Sum[f10[n], {n, 3, 50}];
s11 = Sum[f11[n], {n, 3, 50}];
s12 = Sum[f12[n], {n, 3, 50}];

Print["j=0 varianta:"]
Print["  f00 (i=0): ", N[s00, 15]]
Print["  f01 (i=1): ", N[s01, 15]]
Print["  f02 (i=2): ", N[s02, 15]]
Print[""]

Print["j=1 varianta:"]
Print["  f10 (i=0): ", N[s10, 15]]
Print["  f11 (i=1): ", N[s11, 15]]
Print["  f12 (i=2): ", N[s12, 15]]
Print[""]

Print["Pro uplnost, f10 od n=2:"]
s10full = Sum[f10[n], {n, 2, 50}];
Print["  Sum[f10[n], n=2..50] = ", N[s10full, 20]]
