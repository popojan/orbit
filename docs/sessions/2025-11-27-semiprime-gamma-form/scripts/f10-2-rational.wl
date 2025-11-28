f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["f10[2] presne:"]
Print[""]

val = f10[2];
Print["f10[2] = ", val]
Print[""]

Print["Rozklad:"]
Print["  Sum pro n=2, i=0..1:"]
Print["    i=0: Product[4-j^2, j=1..0]/(2*0+1) = 1/1 = 1"]
Print["    i=1: Product[4-j^2, j=1..1]/(2*1+1) = (4-1)/3 = 3/3 = 1"]
Print[""]
Print["  S = 1 + 1 = 2"]
Print["  f = -1/(1 - 2) = -1/(-1) = 1"]
Print[""]

Print["Overeni:"]
s = Sum[Product[4 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, 1}];
Print["  S = ", s]
Print["  f = -1/(1-S) = ", -1/(1 - s)]
