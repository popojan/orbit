(* Epsilon regularization to avoid divergence *)
(* Instead of stopping at singularity, introduce damping factor *)

Print["==============================================================="]
Print["  EPSILON REGULARIZATION"]
Print["==============================================================="]
Print[""]

f[n_, i_] := Product[n^2 - j^2, {j, 1, i}]

Print["1. EXPONENTIAL DAMPING"]
Print["==============================================================="]
Print[""]

(* S_eps = Sum[(2i+1)/f(n,i) * Exp[-eps*i]] *)
(* As eps -> 0, this should approach the full sum *)
(* But the damping keeps it finite even past singularities *)

sEps[n_, eps_, maxI_] := Sum[(2 i + 1)/f[n, i] * Exp[-eps * i], {i, 1, maxI}]

n = 143;
{p, q} = {11, 13};

Print["n = ", n, " = ", p, " * ", q]
Print[""]

Print["S(eps) for various eps:"]
Do[
  (* Sum far enough to see convergence *)
  s = sEps[n, eps, 50];
  Print["  eps=", eps, ": S = ", N[s, 10], ", S*n^2 = ", N[s * n^2, 10]],
  {eps, {0.5, 0.2, 0.1, 0.05, 0.02, 0.01, 0.005}}
]
Print[""]

Print["2. DERIVATIVE AT eps=0"]
Print["==============================================================="]
Print[""]

(* d/d(eps) S(eps) at eps=0 might encode structure *)
(* d/d(eps) Sum[T_i * e^(-eps*i)] = Sum[-i * T_i * e^(-eps*i)] *)

sEpsDeriv[n_, eps_, maxI_] := Sum[-i * (2 i + 1)/f[n, i] * Exp[-eps * i], {i, 1, maxI}]

Print["dS/d(eps) for various eps:"]
Do[
  sDeriv = sEpsDeriv[n, eps, 50];
  Print["  eps=", eps, ": dS/deps = ", N[sDeriv, 10]],
  {eps, {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}}
]
Print[""]

Print["3. ZETA-STYLE REGULARIZATION"]
Print["==============================================================="]
Print[""]

(* S_s = Sum[(2i+1)/f(n,i) * i^(-s)] *)
(* Analytic continuation in s *)

sZeta[n_, s_, maxI_] := Sum[(2 i + 1)/f[n, i] * i^(-s), {i, 1, maxI}]

Print["S(s) for various s:"]
Do[
  sz = sZeta[n, s, 30];
  Print["  s=", s, ": S = ", N[sz, 10]],
  {s, {2, 1.5, 1, 0.5, 0.1, 0}}
]
Print[""]

Print["4. REGULARIZED SUM FOR DIFFERENT n"]
Print["==============================================================="]
Print[""]

eps = 0.01;
semiprimes = {{3, 5}, {3, 7}, {5, 7}, {7, 11}, {11, 13}, {13, 17}, {17, 19}};

Print["eps = 0.01:"]
Do[
  {pp, qq} = pq;
  nn = pp * qq;
  s = sEps[nn, eps, 100];
  Print["  n=", nn, " (", pp, "*", qq, "): S(eps) = ", N[s, 10], ", S*n^2 = ", N[s * nn^2, 8]],
  {pq, semiprimes}
]
Print[""]

Print["5. LOOK FOR FACTOR-DEPENDENT STRUCTURE"]
Print["==============================================================="]
Print[""]

(* As eps -> 0, does the rate of divergence encode p? *)
(* For n = pq, there's a "soft singularity" at i = (p-1)/2 *)
(* But f(n,i) doesn't actually hit zero there! *)

Print["Checking: does f(n, (p-1)/2) = 0?"]
Print[""]

Do[
  {pp, qq} = pq;
  nn = pp * qq;
  iCrit = (pp - 1)/2;
  fAtCrit = f[nn, iCrit];
  Print["n=", nn, " (", pp, "*", qq, "): f(n, ", iCrit, ") = ", fAtCrit, If[fAtCrit == 0, " ZERO!", ""]],
  {pq, semiprimes}
]
Print[""]

Print["f(n,i) is NOT zero at i = (p-1)/2!"]
Print["The 'singularity' in original formula was from (2i+1) | f(n,i)."]
Print[""]

Print["6. DIFFERENT REGULARIZATION: NEAR THE WILSON POINT"]
Print["==============================================================="]
Print[""]

(* The original formula has signal at i = (p-1)/2 *)
(* There, f(n,i)/(2i+1) has fractional part (p-1)/p *)
(* Can we detect this with a regularized reciprocal? *)

(* Modified: Look at 1/{f(n,i)/(2i+1)} = (2i+1)/f(n,i) *)
(* Near Wilson point: (2i+1)/f ≈ p / (k*p + (p-1)) = p/(k*p + p - 1) for some large k *)

Print["Around the Wilson point i = (p-1)/2:"]
Print[""]

n = 143;
{p, q} = {11, 13};
i = (p - 1)/2;  (* = 5 *)

fVal = f[n, i];
ratio = fVal/p;
fracPart = FractionalPart[fVal/p];

Print["n = ", n, ", p = ", p, ", i = ", i]
Print["f(n,i) = ", fVal]
Print["f(n,i)/p = ", N[fVal/p, 10]]
Print["{f(n,i)/p} = ", fracPart]
Print[""]

Print["7. LAPLACE TRANSFORM APPROACH"]
Print["==============================================================="]
Print[""]

(* L[S](t) = integral_0^inf S(n) e^(-nt) dn *)
(* This might have nice properties... *)

Print["Consider the generating function:"]
Print["  G(z) = Sum[(2i+1)/f(n,i) * z^i]"]
Print[""]

gFunc[n_, z_, maxI_] := Sum[(2 i + 1)/f[n, i] * z^i, {i, 1, maxI}]

n = 143;
Print["G(z) for n = ", n, ":"]
Do[
  g = gFunc[n, z, 30];
  Print["  G(", z, ") = ", N[g, 10]],
  {z, {0.1, 0.5, 0.9, 0.99, 1.0}}
]
Print[""]

Print["8. SERIES AROUND z=0"]
Print["==============================================================="]
Print[""]

(* G(z) = Sum[a_i * z^i] where a_i = (2i+1)/f(n,i) *)
(* Coefficient a_i encodes structure at position i *)

n = 143;
Print["Coefficients a_i = (2i+1)/f(", n, ",i):"]
Do[
  ai = (2 i + 1)/f[n, i];
  Print["  a_", i, " = ", N[ai, 10]],
  {i, 1, 10}
]
Print[""]

Print["9. LOG OF GENERATING FUNCTION"]
Print["==============================================================="]
Print[""]

(* log G(z) might linearize the structure *)
Print["log G(z) for various z:"]
Do[
  g = gFunc[n, z, 30];
  Print["  z=", z, ": log G = ", N[Log[g], 10]],
  {z, {0.1, 0.5, 0.9, 0.99}}
]
Print[""]

Print["10. CONCLUSION"]
Print["==============================================================="]
Print[""]

Print["The epsilon regularization keeps the sum finite,"]
Print["but doesn't reveal factor structure because:"]
Print["  1. f(n,i) never actually hits zero for i < n"]
Print["  2. The Wilson signal was in the FRACTIONAL part, not the reciprocal"]
Print["  3. All terms decay rapidly, dominated by T_1 = 3/(n^2-1)"]
Print[""]
Print["The factor information is in WHERE (2i+1) | f(n,i),"]
Print["which is a divisibility condition, not a size condition."]
