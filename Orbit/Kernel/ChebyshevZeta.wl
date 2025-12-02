(* ::Package:: *)

(* ChebyshevZeta: Riemann Zeta via Chebyshev Polygon Lobe Areas *)
(* Based on the exact identity: n^{-s} = f(B(n, k_s)) *)
(* Discovered December 2, 2025 *)

BeginPackage["Orbit`"];

(* === Core Lobe Area Functions === *)

LobeAmplitude::usage = "LobeAmplitude[n] returns \[Beta](n) = n^2 Cos[\[Pi]/n]/(4-n^2), the amplitude coefficient in B(n,k). Handles n=2 singularity via L'Hopital: \[Beta](2) = -\[Pi]/4.";

LobeArea::usage = "LobeArea[n, k] returns B(n,k) = 1 + \[Beta](n) Cos[(2k-1)\[Pi]/n], the completed lobe area function for Chebyshev polygon with n vertices at lobe k.";

LobeAreaDerivative::usage = "LobeAreaDerivative[n, k] returns \[PartialD]B/\[PartialD]k = -\[Beta](n)(2\[Pi]/n)Sin[(2k-1)\[Pi]/n].";

(* === Critical Line Access via Complex k === *)

CriticalK::usage = "CriticalK[n, s] returns k_s(n) = 1/2 - I s n Log[n]/(2\[Pi]), the special complex k value that extracts n^{-s} from B(n,k).";

PowerMinusSViaB::usage = "PowerMinusSViaB[n, s] computes n^{-s} exactly using the identity:
n^{-s} = (B(n,k_s) - 1)/\[Beta](n) + I n/(2\[Pi]\[Beta](n)) \[CenterDot] \[PartialD]B/\[PartialD]k|_{k_s}
This is exact to machine precision for any n \[GreaterEqual] 1 and s \[Element] \[DoubleStruckCapitalC].";

(* === Zeta Function Computation === *)

DirichletEtaViaB::usage = "DirichletEtaViaB[s, nmax] computes the Dirichlet eta function \[Eta](s) = \[Sum](-1)^{n-1} n^{-s} using the B(n,k) identity. Converges for Re(s) > 0, including the critical line.";

RiemannZetaViaB::usage = "RiemannZetaViaB[s, nmax] computes the Riemann zeta function \[Zeta](s) = \[Eta](s)/(1-2^{1-s}) using the B(n,k) identity. Accesses the critical line Re(s) = 1/2 via Dirichlet eta.";

(* === Verification === *)

VerifyPowerIdentity::usage = "VerifyPowerIdentity[n, s] verifies that PowerMinusSViaB[n,s] matches n^{-s} to within tolerance.";

VerifyZetaViaB::usage = "VerifyZetaViaB[s, nmax] compares RiemannZetaViaB[s, nmax] with built-in Zeta[s] and returns {computed, true, error}.";

(* === Infinite Series via NSum === *)

DirichletEtaViaBNSum::usage = "DirichletEtaViaBNSum[s, opts] computes \[Eta](s) as infinite sum using NSum with Method->\"AlternatingSigns\". Pass WorkingPrecision and other NSum options.";

RiemannZetaViaBNSum::usage = "RiemannZetaViaBNSum[s, opts] computes \[Zeta](s) via NSum. Uses alternating series acceleration for better convergence.";

(* === Partial Sums and Remainders === *)

DirichletEtaViaBPartial::usage = "DirichletEtaViaBPartial[s, nmax] returns Around[partial_sum, remainder_bound] where remainder is O(1/nmax^Re[s]). The Around type integrates with N[], arithmetic, and uncertainty propagation.";

RiemannZetaViaBPartial::usage = "RiemannZetaViaBPartial[s, nmax] returns Around[partial_zeta, uncertainty] computed via DirichletEtaViaBPartial. Uncertainty propagates through the eta-to-zeta conversion.";

Begin["`Private`"];

(* === Implementation === *)

(* Lobe amplitude with n=2 singularity handled *)
LobeAmplitude[n_] := If[n == 2, -Pi/4, n^2 Cos[Pi/n]/(4 - n^2)];

(* Completed lobe area function *)
LobeArea[n_, k_] := 1 + LobeAmplitude[n] Cos[(2k - 1) Pi/n];

(* Derivative with respect to k *)
LobeAreaDerivative[n_, k_] := -LobeAmplitude[n] (2 Pi/n) Sin[(2k - 1) Pi/n];

(* Special k that extracts n^{-s} *)
CriticalK[n_, s_] := 1/2 - I s n Log[n]/(2 Pi);

(* n^{-s} via exact B identity *)
PowerMinusSViaB[n_, s_] := Module[{ks, \[Beta]n, Bval, dBdk},
  (* Special case: 1^{-s} = 1 for all s *)
  If[n == 1, Return[1]];

  ks = CriticalK[n, s];
  \[Beta]n = LobeAmplitude[n];
  Bval = LobeArea[n, ks];
  dBdk = LobeAreaDerivative[n, ks];

  (* Exact identity *)
  (Bval - 1)/\[Beta]n + I n dBdk/(2 Pi \[Beta]n)
];

(* Dirichlet eta via B *)
DirichletEtaViaB[s_, nmax_:100] :=
  Sum[(-1)^(n-1) PowerMinusSViaB[n, s], {n, 1, nmax}];

(* Riemann zeta via eta *)
RiemannZetaViaB[s_, nmax_:100] :=
  DirichletEtaViaB[s, nmax] / (1 - 2^(1-s));

(* Verification functions *)
VerifyPowerIdentity[n_, s_, tol_:10^-10] := Module[{viaB, direct, err},
  viaB = N[PowerMinusSViaB[n, s], 20];
  direct = N[n^(-s), 20];
  err = Abs[viaB - direct];
  <|"n" -> n, "s" -> s, "viaB" -> viaB, "direct" -> direct,
    "error" -> err, "pass" -> (err < tol)|>
];

VerifyZetaViaB[s_, nmax_:100] := Module[{computed, true, err},
  computed = N[RiemannZetaViaB[s, nmax]];
  true = N[Zeta[s]];
  err = Abs[computed - true];
  <|"s" -> s, "nmax" -> nmax, "computed" -> computed,
    "true" -> true, "error" -> err|>
];

(* === NSum versions for infinite series === *)

DirichletEtaViaBNSum[s_, opts___] :=
  NSum[(-1)^(n-1) PowerMinusSViaB[n, s], {n, 1, Infinity},
    Method -> "AlternatingSigns", opts];

RiemannZetaViaBNSum[s_, opts___] :=
  DirichletEtaViaBNSum[s, opts] / (1 - 2^(1-s));

(* === Partial sum with remainder estimate === *)

DirichletEtaViaBPartial[s_, nmax_] := Module[{partial, remainder},
  partial = DirichletEtaViaB[s, nmax];
  (* For alternating series, |remainder| <= |a_{nmax+1}| = 1/(nmax+1)^Re[s] *)
  remainder = 1/(nmax + 1)^Re[s];
  Around[partial, remainder]
];

RiemannZetaViaBPartial[s_, nmax_] :=
  DirichletEtaViaBPartial[s, nmax] / (1 - 2^(1-s));

End[];
EndPackage[];
