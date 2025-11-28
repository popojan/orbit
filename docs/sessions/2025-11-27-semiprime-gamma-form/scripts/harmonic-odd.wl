Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]

Print["Vztah Hn k HarmonicNumber:"]
Print[""]

(* Hn = H_{2n-1} - (1/2) H_{n-1} ? *)
(* Licha = Vsechna - Suda *)
(* Suda do 2n-2: 1/2 + 1/4 + ... + 1/(2n-2) = (1/2)(H_{n-1}) *)

Print["Test identity:"]
Do[
  hn = Hn[n];
  h2n1 = HarmonicNumber[2 n - 1];
  hn1 = HarmonicNumber[n - 1];
  formula = h2n1 - hn1/2;
  
  Print["n=", n, ": Hn=", hn, ", H_{2n-1} - H_{n-1}/2 = ", formula, 
        ", match=", Simplify[hn == formula]],
  {n, 2, 8}
]
Print[""]

(* Jina forma: pres digamma *)
Print["Digamma forma:"]
Print["  Hn = (1/2)(Psi[n + 1/2] - Psi[1/2])"]
Print["  kde Psi = PolyGamma[0, x] = digamma"]
Print[""]

Do[
  hn = Hn[n];
  digamma = (PolyGamma[0, n + 1/2] - PolyGamma[0, 1/2])/2;
  Print["n=", n, ": Hn=", N[hn, 10], ", digamma=", N[digamma, 10],
        ", match=", Simplify[hn == digamma]],
  {n, 2, 6}
]
Print[""]

(* Nejjednodussi: *)
Print["Nejjednodussi forma:"]
Print["  Hn[n] = HarmonicNumber[2n-1] - HarmonicNumber[n-1]/2"]
Print[""]
Print["Nebo primo:"]
Print["  Hn[n] = (PolyGamma[0, n+1/2] + EulerGamma + 2*Log[2]) / 2"]
