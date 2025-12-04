(* identity_both_betas.wl *)
(* Verify that n^{-s} identity works for BOTH beta functions *)
(* Key finding: beta cancels out, so any beta works! *)

Print["=== n^{-s} Identity Test for Both Beta Functions ==="];
Print[""];

(* Two beta definitions *)
betaGeom[n_] := n^2 Cos[Pi/n]/(4 - n^2);
betaRes[n_] := (n - Cot[Pi/n])/(4 n);

(* k_s = 1/2 - i*s*n*log(n)/(2*pi) *)
kS[n_, s_] := 1/2 - I s n Log[n]/(2 Pi);

(* B(n,k) = 1 + beta(n) * cos((2k-1)*pi/n) *)
BFunc[beta_, n_, k_] := 1 + beta[n] Cos[(2 k - 1) Pi/n];

(* dB/dk = -beta(n) * (2*pi/n) * sin((2k-1)*pi/n) *)
dBdk[beta_, n_, k_] := -beta[n] (2 Pi/n) Sin[(2 k - 1) Pi/n];

(* Identity: n^{-s} = (B-1)/beta + i*n/(2*pi*beta)*dB/dk *)
extractNminusS[beta_, n_, s_] := Module[{k, B, dB},
  k = kS[n, s];
  B = BFunc[beta, n, k];
  dB = dBdk[beta, n, k];
  (B - 1)/beta[n] + I n/(2 Pi beta[n]) dB
];

(* Test for various n and s *)
Print["Testing identity: n^{-s} = (B-1)/beta + i*n/(2*pi*beta)*dB/dk"];
Print[""];

testCases = {{5, 2}, {7, 1 + I}, {10, 3 - 2 I}, {13, 1/2 + 14.1 I}};

Do[
  {n, s} = tc;
  expected = n^(-s);
  resultGeom = extractNminusS[betaGeom, n, s];
  resultRes = extractNminusS[betaRes, n, s];

  Print["n = ", n, ", s = ", s];
  Print["  Expected n^{-s} = ", expected // N];
  Print["  With beta_geom:  ", resultGeom // N];
  Print["  With beta_res:   ", resultRes // N];
  Print["  Error (geom): ", Abs[resultGeom - expected] // N];
  Print["  Error (res):  ", Abs[resultRes - expected] // N];
  Print[""],
  {tc, testCases}
];

Print["=== WHY BETA CANCELS ==="];
Print[""];
Print["Let B = 1 + beta * cos(theta), dB/dk = -beta * (2pi/n) * sin(theta)"];
Print[""];
Print["Term 1: (B-1)/beta = beta*cos(theta)/beta = cos(theta)"];
Print["Term 2: i*n/(2*pi*beta) * dB/dk"];
Print["       = i*n/(2*pi*beta) * (-beta * 2*pi/n * sin(theta))"];
Print["       = -i * sin(theta)"];
Print[""];
Print["Both terms are INDEPENDENT of beta!"];
Print["beta is merely a 'transfer function' that cancels out."];
