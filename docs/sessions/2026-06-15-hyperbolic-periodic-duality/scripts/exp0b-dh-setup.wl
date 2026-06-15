(* Davenport-Heilbronn function: self-validating setup.
   chi = primitive char mod 5, chi(2)=i (order 4, odd).  chi(1,2,3,4)=(1,i,-i,-1).
   f(s) = a L(s,chi) + conj(a) L(s,chibar),  a=(1-I kappa)/2,  kappa real,
   chosen so the completed  Phi(s)=(5/Pi)^((s+1)/2) Gamma((s+1)/2) f(s)
   satisfies Phi(s)=Phi(1-s).  Condition: epsilon(chi) = conj(a)/a = (1+I k)/(1-I k),
   i.e. kappa = tan( arg(epsilon)/2 ),  epsilon = tau(chi)/(I Sqrt[5]).
   Dirichlet coeffs c(n) periodic mod 5: [1, k, -k, -1, 0]  =>  via Hurwitz zeta:
   f(s) = 5^-s [ zetaH(s,1/5) + k zetaH(s,2/5) - k zetaH(s,3/5) - zetaH(s,4/5) ]. *)

prec = 40;

(* ---- Gauss sum and kappa ---- *)
chiv = {1, I, -I, -1};                                  (* chi(1..4) *)
tau  = Sum[chiv[[n]] Exp[2 Pi I n/5], {n, 1, 4}];
tau  = N[tau, prec];
eps  = tau/(I Sqrt[5]);
Print["|tau| (should be Sqrt5=", N[Sqrt[5], 8], ") = ", N[Abs[tau], 12]];
Print["|epsilon| (should be 1) = ", N[Abs[eps], 12]];
kappa = Tan[Arg[eps]/2];
kappa = N[kappa, prec];
Print["kappa = ", N[kappa, 20]];
Print["closed-form (Sqrt[10-2Sqrt5]-2)/(Sqrt5-1) = ",
   N[(Sqrt[10 - 2 Sqrt[5]] - 2)/(Sqrt[5] - 1), 20]];

(* ---- the function ---- *)
fDH[s_] := 5^(-s) (HurwitzZeta[s, 1/5] + kappa HurwitzZeta[s, 2/5]
                    - kappa HurwitzZeta[s, 3/5] - HurwitzZeta[s, 4/5]);
Phi[s_] := (5/Pi)^((s + 1)/2) Gamma[(s + 1)/2] fDH[s];

(* ---- VALIDATE the functional equation at random points ---- *)
Print["\n=== functional-equation check  Phi(s) - Phi(1-s) ==="];
Do[
  With[{s = pt},
   Print["  s=", s, "   |Phi(s)-Phi(1-s)| = ",
     ScientificForm[N[Abs[Phi[s] - Phi[1 - s]], 6]]]],
  {pt, {0.3 + 7 I, 0.5 + 14.1347 I, 0.9 + 30 I, 1.2 + 3 I, 0.5 + 0.5 I}}];

(* ---- sanity: a few coefficients via series vs c(n) pattern ---- *)
Print["\n=== Dirichlet coeff check (series head) ==="];
ser = Normal[Series[fDH[s] /. s -> sv, {sv, Infinity, 0}]];  (* not robust; skip *)
Print["  c(n) target (n=1..10): ",
   Table[{1, kappa, -kappa, -1, 0}[[Mod[n - 1, 5] + 1]], {n, 1, 10}] // N];

(* ---- SEARCH for an off-line zero (sigma != 1/2) ---- *)
Print["\n=== scanning |f| for off-line zeros (sigma != 1/2) ==="];
absf[sig_, t_] := Abs[fDH[N[sig + I t, 25]]];
(* coarse scan: collect cells with small |f|, off the line *)
cells = Reap[
   Do[
     Module[{v = absf[sig, t]},
      If[v < 0.08 && Abs[sig - 0.5] > 0.03, Sow[{sig, t, v}]]],
     {sig, 0.30, 1.25, 0.05}, {t, 1, 110, 0.5}]][[2]];
cells = If[cells === {}, {}, cells[[1]]];
Print["  candidate off-line cells (sig,t,|f|), smallest 12:"];
cells = SortBy[cells, Last];
Do[Print["    ", N[cells[[i]], 6]], {i, 1, Min[12, Length[cells]]}];

(* refine the best few with FindRoot on {Re f=0, Im f=0} *)
Print["\n=== FindRoot refinement of off-line candidates ==="];
refine[sig0_, t0_] := Quiet@Check[
   Module[{sol},
    sol = FindRoot[{Re[fDH[sig + I t]] == 0, Im[fDH[sig + I t]] == 0},
       {sig, sig0}, {t, t0}, WorkingPrecision -> 30,
       AccuracyGoal -> 25, MaxIterations -> 80];
    {sig, t} /. sol], $Failed];
seen = {};
Do[
  Module[{c = cells[[i]], r},
   r = refine[c[[1]], c[[2]]];
   If[r =!= $Failed,
    With[{sig = r[[1]], t = r[[2]]},
     If[Abs[sig - 1/2] > 0.02 && t > 0.5 &&
        Not[Or @@ (Abs[#[[1]] - sig] < 0.01 && Abs[#[[2]] - t] < 0.01 & /@ seen)],
      AppendTo[seen, {sig, t}];
      Print["  ZERO at  s = ", N[sig, 12], " + ", N[t, 12], " I",
        "   |f| = ", ScientificForm[N[Abs[fDH[sig + I t]], 4]],
        "   |sigma-1/2| = ", N[Abs[sig - 1/2], 6]]]]]],
  {i, 1, Min[20, Length[cells]]}];

If[seen === {},
  Print["  (no off-line zero refined in scanned box; widen scan)"],
  Print["\n  --> ", Length[seen], " distinct off-line zero(s) found. RH-violation in a real FE object."]];

Print["\nDONE."];
