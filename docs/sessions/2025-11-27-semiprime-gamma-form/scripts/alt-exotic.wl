f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

s = Sum[(-1)^n * f10[n], {n, 2, 100}];
sN = N[s, 50];

Print["s = ", N[s, 25]]
Print[""]

(* Zeta hodnoty *)
Print["Zeta hodnoty:"]
Print["  Zeta[2] = Pi^2/6 = ", N[Zeta[2], 15]]
Print["  Zeta[3] = ", N[Zeta[3], 15]]
Print["  Zeta[4] = Pi^4/90 = ", N[Zeta[4], 15]]
Print["  s/Zeta[3] = ", N[sN/Zeta[3], 15]]
Print["  s - Zeta[3]/Zeta[2] = ", N[sN - Zeta[3]/Zeta[2], 15]]
Print[""]

(* Eta funkce (alternujici zeta) *)
Print["Dirichlet eta:"]
eta2 = (1 - 2^(1-2))*Zeta[2];
eta3 = (1 - 2^(1-3))*Zeta[3];
Print["  eta(2) = ", N[eta2, 15], " = Pi^2/12"]
Print["  eta(3) = ", N[eta3, 15]]
Print["  s/eta(2) = ", N[sN/eta2, 15]]
Print["  s/eta(3) = ", N[sN/eta3, 15]]
Print["  s - eta(3) = ", N[sN - eta3, 15]]
Print[""]

(* Beta funkce (Dirichlet) *)
Print["Dirichlet beta:"]
beta1 = Pi/4;  (* beta(1) *)
beta2 = Catalan;  (* beta(2) *)
beta3 = Pi^3/32;  (* beta(3) *)
Print["  beta(1) = Pi/4 = ", N[beta1, 15]]
Print["  beta(2) = Catalan = ", N[beta2, 15]]
Print["  beta(3) = Pi^3/32 = ", N[beta3, 15]]
Print["  s - beta(2) = ", N[sN - beta2, 15]]
Print["  |s - beta(2)| = ", N[Abs[sN - beta2], 15]]
Print[""]

(* Kombinace *)
Print["Kombinace:"]
Print["  s + ln(2)/Pi = ", N[sN + Log[2]/Pi, 15]]
Print["  s - 1 + 1/Pi = ", N[sN - 1 + 1/Pi, 15]]
Print["  s - Catalan + EulerGamma/10 = ", N[sN - Catalan + EulerGamma/10, 15]]
Print[""]

(* Pomerem blizko 1 *)
Print["Pomery blizke 1:"]
Print["  s/Catalan = ", N[sN/Catalan, 20]]
Print["  1 - s/Catalan = ", N[1 - sN/Catalan, 20]]
diff = sN - N[Catalan, 50];
Print["  s - Catalan = ", N[diff, 20]]
Print[""]

(* Je s - Catalan neco zajimaveho? *)
Print["Rozdil s - Catalan:"]
d = N[sN - Catalan, 40];
Print["  = ", d]
Print["  d*100 = ", N[d*100, 15]]
Print["  d*Pi = ", N[d*Pi, 15]]
Print["  d/EulerGamma = ", N[d/EulerGamma, 15]]
