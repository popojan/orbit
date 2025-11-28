f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["ALTERNUJICI SUMY"]
Print["================="]
Print[""]

(* Varianta 1: (-1)^n * f10[n] *)
s1 = Sum[(-1)^n * f10[n], {n, 2, 80}];
Print["Sum[(-1)^n * f10[n], n=2..80]:"]
Print["  = ", N[s1, 25]]
Print["  racionalne: ", s1]
Print[""]

(* Varianta 2: (-1)^(n+1) * f10[n] od n=3 *)
s2 = Sum[(-1)^(n + 1) * f10[n], {n, 3, 80}];
Print["Sum[(-1)^(n+1) * f10[n], n=3..80]:"]
Print["  = ", N[s2, 25]]
Print[""]

(* Porovnani se znamymi konstantami *)
Print["Porovnani:"]
Print["  ln(2) = ", N[Log[2], 20]]
Print["  Pi/4  = ", N[Pi/4, 20]]
Print["  1/e   = ", N[1/E, 20]]
Print[""]

(* Varianta 3: alternujici od n=2 s jinym znakem *)
s3 = Sum[(-1)^n * f10[n], {n, 2, 80}];
Print["(-1)^2*f[2] + (-1)^3*f[3] + ... = ", N[s3, 20]]
Print["= 1 - 3/32 + 1/221 - 5/46624 + ..."]
Print[""]

(* Zkusme presne racionalni hodnoty parcialich sum *)
Print["Parcialni alternujici sumy (presne):"]
ps = 0;
Do[
  ps += (-1)^n * f10[n];
  If[n <= 8, 
    Print["  N=", n, ": ", ps, " = ", N[ps, 15]]
  ],
  {n, 2, 80}
]
Print["  ..."]
Print["  N=80: ", N[ps, 25]]
