(* ================================================================ *)
(* SMOOTH SNAP: continuous optimization with periodic potential      *)
(* L(a,ℓ) = ‖Θ - a⊗ℓ‖² + λ Σ(1-cos(2π e^ℓⱼ))                    *)
(*         + μ Σ(1-cos(2π(aₙℓⱼ - Wₙⱼ)))                           *)
(* ================================================================ *)

sz = 200;
g = Table[N[Im[ZetaZero[n]], 15], {n, sz}];
lp = Table[Log[N[Prime[j], 15]], {j, sz}];
w = Table[Floor[g[[n]] lp[[j]] / (2 Pi)], {n, sz}, {j, sz}];
pExact = Table[Prime[j], {j, sz}];
th = N[w] + 0.5;

(* === Initialize from ALS (no snap) === *)
a0 = First[SingularValueDecomposition[th]][[All, 1]];
If[a0[[1]] < 0, a0 = -a0];
a0 = a0 * Norm[th, "Frobenius"] / Norm[a0];
el0 = Transpose[th] . a0 / (a0 . a0);
el0 = el0 * (Log[2.] / el0[[1]]);

(* === Loss function === *)
loss[avec_, elvec_, lambda_, mu_] := Module[{rank1, lattice, floorP},
  rank1 = Total[(th - Outer[Times, avec, elvec])^2, 2];
  lattice = Total[1 - Cos[2 Pi Exp[elvec]]];
  floorP = Total[1 - Cos[2 Pi (Outer[Times, avec, elvec] - w)], 2];
  rank1 + lambda lattice + mu floorP
]

(* === Gradient by finite differences (Mathematica's FindMinimum is better) === *)
(* Pack a and ℓ into one vector for optimization *)
pack[avec_, elvec_] := Join[avec, elvec]
unpack[vec_] := {vec[[1 ;; sz]], vec[[sz + 1 ;; 2 sz]]}

lossFlat[vec_, lambda_, mu_] := Module[{a, el},
  {a, el} = unpack[vec];
  loss[a, el, lambda, mu]
]

(* === Strategy: start with λ=0, μ=0 (pure ALS), then increase === *)
Print["=== SMOOTH OPTIMIZATION ===\n"];

(* Phase 1: ALS only (λ=μ=0) *)
Print["Phase 1: pure rank-1 fit..."];
vec = pack[a0, el0];

(* Use gradient descent with periodic potential *)
(* Since FindMinimum with 400 variables is slow, use iterative approach: *)
(* Alternate: optimize a given ℓ, optimize ℓ given a, with penalty *)

smoothOpt[lambda_, mu_, nIter_, label_] := Module[
  {a = a0, el = el0, gradEl, gradA, lr = 0.00001, lossVal},

  Do[
    (* Gradient of lattice penalty w.r.t. ℓ *)
    gradEl = -Transpose[th] . a / (a . a)  (* rank-1 gradient: ℓ = Θᵀa/‖a‖² *)
      + el  (* current ℓ direction *)
      ;
    (* Actually, let's do this properly: *)
    (* ALS step for a given ℓ (exact) *)
    a = th . el / (el . el);

    (* ALS step for ℓ given a (exact for rank-1) *)
    el = Transpose[th] . a / (a . a);

    (* Scale fix *)
    el = el * (Log[2.] / el[[1]]);

    (* Add gradient of lattice penalty *)
    If[lambda > 0,
      gradEl = 2 Pi Exp[el] Sin[2 Pi Exp[el]] * lambda;
      el = el - lr * gradEl];

    (* Add gradient of floor penalty *)
    If[mu > 0,
      Module[{R = Outer[Times, a, el] - w, sinR},
        sinR = Sin[2 Pi R];
        (* ∂/∂ℓⱼ Σₙ (1-cos(2π(aₙℓⱼ-Wₙⱼ))) = 2π Σₙ aₙ sin(2π(aₙℓⱼ-Wₙⱼ)) *)
        gradEl = gradEl + 2 Pi mu * Table[Total[a sinR[[All, j]]], {j, sz}];
        el = el - lr * gradEl]],
  {nIter}];

  lossVal = loss[a, el, lambda, mu];
  pc = Count[Table[Round[Exp[el[[j]]]] == pExact[[j]], {j, sz}], True];
  Print[label, ": loss=", NumberForm[lossVal, {6, 1}],
    "  primes=", pc, "/", sz];
  {a, el, pc}
]

(* Phase 1: pure ALS *)
{a1, el1, pc1} = smoothOpt[0, 0, 100, "λ=0, μ=0 (ALS)"];

(* Phase 2: add lattice penalty *)
a0 = a1; el0 = el1;
{a2, el2, pc2} = smoothOpt[1, 0, 100, "λ=1, μ=0 (+lattice)"];

(* Phase 3: add floor penalty *)
a0 = a2; el0 = el2;
{a3, el3, pc3} = smoothOpt[1, 0.1, 100, "λ=1, μ=0.1 (+floor)"];

(* Phase 4: strong penalties *)
a0 = a3; el0 = el3;
{a4, el4, pc4} = smoothOpt[10, 1, 200, "λ=10, μ=1 (strong)"];

(* Phase 5: very strong *)
a0 = a4; el0 = el4;
{a5, el5, pc5} = smoothOpt[100, 10, 200, "λ=100, μ=10 (v.strong)"];

(* === Compare: what does simple ALS + OddQ snap give? === *)
Print["\n=== Baseline: ALS + independent OddQ snap ==="];
aB = First[SingularValueDecomposition[th]][[All, 1]];
If[aB[[1]] < 0, aB = -aB];
aB = aB * Norm[th, "Frobenius"] / Norm[aB];
Do[
  elB = Transpose[th] . aB / (aB . aB);
  elB = elB * (Log[2.] / elB[[1]]);
  elB = Log[N[Max[2, Round[#]] & /@ Exp[elB], 15]];
  aB = th . elB / (elB . elB), {10}];
pcB = Count[Table[Round[Exp[elB[[j]]]] == pExact[[j]], {j, sz}], True];
Print["Independent snap: ", pcB, "/", sz];
