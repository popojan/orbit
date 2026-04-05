(* ::Package:: *)

(* SuccessorOrbit: Algebraic Sine from One Recurrence

   The universal recurrence:  next = (current² − seed) / previous
   Generates naturals (seed=1), algebraic sine waves (seed<1),
   exponential growth (seed>1), and everything in between.

   Matrix form: N = {{(λ²+1)a−b, −λa}, {λa, 0}} for seed o = a/b, scale λ
   Closed form: f[k] = o·U_k(c) + (1−o)/2·U_{k−1}(c), c = ((λ²+1)o−1)/(2λo)
   Cassini invariant: f[k]² − f[k−1]·f[k+1] = o (constant, independent of λ)

   Reference: docs/sessions/2026-04-04-algebraic-sine-successor/
*)

BeginPackage["Orbit`"];

(* === PUBLIC API === *)

SuccessorMatrix::usage = "SuccessorMatrix[o] or SuccessorMatrix[o, λ] returns the integer transfer matrix N.
Default scale λ = 2. For o = a/b: N = {{(λ²+1)a−b, −λa}, {λa, 0}}, det N = (λa)².";

SuccessorOrbit::usage = "SuccessorOrbit[o, k] or SuccessorOrbit[o, k, λ] returns f[k].
Threads over lists: SuccessorOrbit[o, {0, 1, 5, 28}] returns {f[0], f[1], f[5], f[28]}.
Default scale λ = 2. Accepts any real/complex λ (uses Chebyshev closed form).
The sequence satisfies f[k+1] = (f[k]² − o) / f[k−1].";

SuccessorTrace::usage = "SuccessorTrace[o, k] or SuccessorTrace[o, k, λ] returns tr(N^k), always an integer.
Threads over lists: SuccessorTrace[o, {0, 1, 2}] returns {2, tr(N), tr(N²)}.
The trace satisfies s[k+1] = tr(N)·s[k] − det(N)·s[k−1].";

SuccessorOrbitMod::usage = "SuccessorOrbitMod[o, k, m] or SuccessorOrbitMod[o, k, m, λ] returns (N^k·w₀) mod m as {x, y}.
Threads over lists: SuccessorOrbitMod[o, Range[0, 27], 41].
All values in {0, ..., m−1}. Always periodic.";

SuccessorPeriodMod::usage = "SuccessorPeriodMod[o, m] or SuccessorPeriodMod[o, m, λ] returns the period of N^k mod m.";

SuccessorChebyshev::usage = "SuccessorChebyshev[o] or SuccessorChebyshev[o, λ] returns {c, α}.
c = Chebyshev parameter, α = linear recurrence coefficient (α = 2c).";

SuccessorDiscriminant::usage = "SuccessorDiscriminant[o] or SuccessorDiscriminant[o, λ] returns (b−(λ−1)²a)((λ+1)²a−b).
Determines splitting behavior mod primes.";

SuccessorFromPeriod::usage = "SuccessorFromPeriod[2q] or SuccessorFromPeriod[2q, λ] returns the algebraic seed o
for exact period 2q. Formula: o = 1/|λ − e^(iπ/q)|². Returns exact algebraic (use ToRadicals to simplify).
The orbit SuccessorOrbit[o, k] then has exact period 2q.";

SuccessorSine::usage = "SuccessorSine[o, t] or SuccessorSine[o, t, λ] evaluates the continuous sine wave at real t.
This is the unique function f(t) = A·Sin[t·θ + φ] that interpolates the discrete orbit:
SuccessorSine[o, k] == SuccessorOrbit[o, k] for integer k (up to precision).
Threads over lists. This is \"the price of continuity\" — it introduces transcendentals (θ, A, φ).";

SuccessorSineParameters::usage = "SuccessorSineParameters[o] or SuccessorSineParameters[o, λ] returns
<|\"Amplitude\" → A, \"Frequency\" → θ, \"Phase\" → φ, \"Period\" → 2π/θ|>
such that the orbit satisfies f[k] = A·Sin[k·θ + φ].
Only valid in the oscillatory regime (|c| < 1).";

Begin["`Private`"];

(* === INTERNALS === *)

ab[o_Rational] := {Numerator[o], Denominator[o]}
ab[o_Integer] := {o, 1}

rationalQ[o_Rational] := True
rationalQ[o_Integer] := True
rationalQ[_] := False

nMatrix[a_, b_, \[Lambda]_] := {
  {(\[Lambda]^2 + 1) a - b, -\[Lambda] a},
  {\[Lambda] a, 0}
}

w0[a_, \[Lambda]_] := {\[Lambda] a, a}

(* Single orbit value via matrix power *)
orbitSingle[a_, b_, \[Lambda]_, k_] := Module[{result},
  result = MatrixPower[nMatrix[a, b, \[Lambda]], k] . w0[a, \[Lambda]];
  result[[2]] / ((\[Lambda] a)^k b)
]

(* Single modular orbit value *)
orbitModSingle[NN_, w_, \[Lambda]a_, k_, m_] := Module[{v},
  v = Mod[MatrixPower[NN, k, m] . w, m];
  v
]

(* === IMPLEMENTATIONS === *)

SuccessorMatrix[o_, \[Lambda]_: 2] := Module[{a, b},
  {a, b} = ab[o];
  nMatrix[a, b, \[Lambda]]
]

(* Chebyshev closed form — works for any λ, o *)
orbitChebyshev[o_, k_, \[Lambda]_] := Module[{c},
  c = ((\[Lambda]^2 + 1) o - 1) / (2 \[Lambda] o);
  o ChebyshevU[k, c] + (1 - o)/2 ChebyshevU[k - 1, c]
]

(* Single k, integer λ: fast matrix path *)
SuccessorOrbit[o_?rationalQ, k_Integer, \[Lambda]_Integer: 2] := Module[{a, b},
  {a, b} = ab[o];
  orbitSingle[a, b, \[Lambda], k]
]

(* Single k, any λ: Chebyshev path (works for real k too) *)
SuccessorOrbit[o_, k_, \[Lambda]_] := orbitChebyshev[o, k, \[Lambda]] /; !IntegerQ[\[Lambda]]

(* Real k with default λ=2: Chebyshev path *)
SuccessorOrbit[o_, k_, \[Lambda]_Integer: 2] := orbitChebyshev[o, k, \[Lambda]] /; !IntegerQ[k]

(* Thread over list *)
SuccessorOrbit[o_, ks_List, \[Lambda]_: 2] :=
  SuccessorOrbit[o, #, \[Lambda]] & /@ ks

(* Single k — integer λ: matrix path *)
SuccessorTrace[o_?rationalQ, k_Integer, \[Lambda]_Integer: 2] :=
  Tr[MatrixPower[SuccessorMatrix[o, \[Lambda]], k]]

(* Single k — any λ: Chebyshev path *)
SuccessorTrace[o_, k_Integer, \[Lambda]_] := Module[{c},
  c = ((\[Lambda]^2 + 1) o - 1) / (2 \[Lambda] o);
  2 (\[Lambda] o)^k ChebyshevT[k, c]
] /; !IntegerQ[\[Lambda]]

(* Thread over list *)
SuccessorTrace[o_, ks_List, \[Lambda]_: 2] :=
  SuccessorTrace[o, #, \[Lambda]] & /@ ks

(* Single k *)
(* === MODULAR ARITHMETIC via F_m[r]/(r² − tr·r + det) === *)
(* The orbit mod m lives in the quotient ring F_m[r]/(charPoly).    *)
(* r^k mod (charPoly, m) gives coefficients {a,b} with              *)
(* N^k·w₀ ≡ a·(N·w₀) + b·w₀  (mod m)                             *)
(* No matrix operations needed — just polynomial multiply + mod.    *)

(* Polynomial multiply in F_m[r]/(r²-αr+δ): (a₁r+b₁)(a₂r+b₂) mod charPoly *)
(* r² = αr - δ, so: result = (a₁b₂+a₂b₁+a₁a₂α)r + (b₁b₂-a₁a₂δ) *)
polyMulMod[{a1_, b1_}, {a2_, b2_}, \[Alpha]_, \[Delta]_, m_] :=
  Mod[{a1 b2 + a2 b1 + a1 a2 \[Alpha], b1 b2 - a1 a2 \[Delta]}, m]

(* r^k mod (charPoly, m) via repeated squaring, returns {coeff of r, constant} *)
polyPowMod[_, 0, __] := {0, 1}
polyPowMod[base_, 1, __] := base
polyPowMod[base_, k_Integer, \[Alpha]_, \[Delta]_, m_] := Module[{half},
  If[EvenQ[k],
    half = polyPowMod[base, k/2, \[Alpha], \[Delta], m];
    polyMulMod[half, half, \[Alpha], \[Delta], m]
  ,
    polyMulMod[base, polyPowMod[base, k - 1, \[Alpha], \[Delta], m], \[Alpha], \[Delta], m]
  ]
]

(* === DISPATCH: rational o → integer arithmetic, symbolic/algebraic o → Factor ===*)

(* Rational o: orbit mod m at step k via polynomial ring F_m[r]/(charPoly) *)
SuccessorOrbitMod[o_?rationalQ, k_Integer, m_Integer, \[Lambda]_Integer: 2] := Module[
  {a, b, NN, w, Nw, \[Alpha], \[Delta], ab2},
  {a, b} = ab[o];
  NN = nMatrix[a, b, \[Lambda]];
  \[Alpha] = Mod[Tr[NN], m];
  \[Delta] = Mod[Det[NN], m];
  w = Mod[w0[a, \[Lambda]], m];
  Nw = Mod[NN . w0[a, \[Lambda]], m];
  ab2 = polyPowMod[{1, 0}, k, \[Alpha], \[Delta], m];
  Mod[ab2[[1]] Nw + ab2[[2]] w, m]
]

(* Rational o: thread over list *)
SuccessorOrbitMod[o_?rationalQ, ks_List, m_Integer, \[Lambda]_Integer: 2] := Module[
  {a, b, NN, w, Nw, NNm, v, results, \[Alpha], \[Delta]},
  {a, b} = ab[o];
  NN = nMatrix[a, b, \[Lambda]];
  w = Mod[w0[a, \[Lambda]], m];
  If[ks === Range[0, Max[ks]] && Min[ks] == 0,
    NNm = Mod[NN, m];
    v = w;
    results = {v};
    Do[v = Mod[NNm . v, m]; AppendTo[results, v], {Max[ks]}];
    results
  ,
    \[Alpha] = Mod[Tr[NN], m];
    \[Delta] = Mod[Det[NN], m];
    Nw = Mod[NN . w0[a, \[Lambda]], m];
    Function[k, Module[{ab2 = polyPowMod[{1, 0}, k, \[Alpha], \[Delta], m]},
      Mod[ab2[[1]] Nw + ab2[[2]] w, m]
    ]] /@ ks
  ]
]

(* Symbolic/algebraic o: compute orbit as rational function of o, *)
(* then simplify via Factor[..., Modulus -> p].                   *)
(* Returns polynomial/rational expression in o over F_p.          *)
SuccessorOrbitMod[o_, k_Integer, p_Integer, \[Lambda]_Integer: 2] := Module[{expr},
  expr = SuccessorOrbit[o, k, \[Lambda]];
  Factor[expr, Modulus -> p]
]

SuccessorOrbitMod[o_, ks_List, p_Integer, \[Lambda]_Integer: 2] :=
  Factor[SuccessorOrbit[o, #, \[Lambda]], Modulus -> p] & /@ ks

SuccessorPeriodMod[o_, m_Integer, \[Lambda]_Integer: 2] := Module[
  {a, b, NN, \[Alpha], \[Delta], rk, k},
  {a, b} = ab[o];
  NN = nMatrix[a, b, \[Lambda]];
  \[Alpha] = Mod[Tr[NN], m];
  \[Delta] = Mod[Det[NN], m];
  rk = {1, 0}; (* start: r^1 = {1, 0} = "r" *)
  k = 1;
  While[rk =!= {0, 1} && k < m^2 + m,
    rk = polyMulMod[rk, {1, 0}, \[Alpha], \[Delta], m]; (* multiply by r *)
    k++
  ];
  If[rk === {0, 1}, k, None]
]

SuccessorChebyshev[o_, \[Lambda]_Integer: 2] := Module[{c, \[Alpha]},
  \[Alpha] = ((\[Lambda]^2 + 1) o - 1) / (\[Lambda] o) // Simplify;
  c = \[Alpha] / 2 // Simplify;
  {c, \[Alpha]}
]

SuccessorDiscriminant[o_, \[Lambda]_Integer: 2] := Module[{a, b},
  {a, b} = ab[o];
  (b - (\[Lambda] - 1)^2 a) ((\[Lambda] + 1)^2 a - b)
]

(* Period constructor: o = 1/|λ - e^{iπ/q}|² for period 2q *)
SuccessorFromPeriod[period_Integer, \[Lambda]_Integer: 2] := Module[{q},
  q = period / 2;
  1 / (\[Lambda]^2 - 2 \[Lambda] Cos[Pi/q] + 1) // RootReduce
] /; EvenQ[period] && period >= 4

(* Odd period: not achievable (period is always 2q) *)
SuccessorFromPeriod[period_Integer, ___] := (
  Message[SuccessorFromPeriod::oddper, period]; $Failed
) /; OddQ[period]

SuccessorFromPeriod::oddper = "Period `` must be even (period = 2q).";

(* SuccessorOrbit also accepts algebraic seeds *)
ab[o_] := Module[{r = Rationalize[o, 0]},
  If[r === o || Head[o] === Rational || Head[o] === Integer,
    {Numerator[r], Denominator[r]},
    (* Algebraic: return as-is, let matrix be symbolic *)
    {o, 1}
  ]
] /; !IntegerQ[o] && !Head[o] === Rational

(* For algebraic o: orbit via closed form (Chebyshev) *)
SuccessorOrbit[o_, k_Integer, \[Lambda]_Integer: 2] := Module[{c},
  c = ((\[Lambda]^2 + 1) o - 1) / (2 \[Lambda] o);
  o ChebyshevU[k, c] + (1 - o)/2 ChebyshevU[k - 1, c] // Simplify
] /; !IntegerQ[o] && !Head[o] === Rational

SuccessorOrbit[o_, ks_List, \[Lambda]_Integer: 2] :=
  SuccessorOrbit[o, #, \[Lambda]] & /@ ks /; !IntegerQ[o] && !Head[o] === Rational

(* === CONTINUOUS INTERPOLATION ("the price of continuity") === *)
(* All symbolic — evaluates to exact expressions. Use N[] for numerics. *)

SuccessorSineParameters[o_, \[Lambda]_Integer: 2] := Module[
  {c, \[Theta], sinTh, \[Phi], amp},
  c = ((\[Lambda]^2 + 1) o - 1) / (2 \[Lambda] o) // Simplify;
  \[Theta] = ArcCos[c];
  sinTh = Sqrt[1 - c^2] // Simplify;
  \[Phi] = ArcTan[\[Lambda] - c, sinTh];
  amp = o / Sin[\[Phi]] // Simplify;
  <|"Amplitude" -> amp, "Frequency" -> \[Theta], "Phase" -> \[Phi],
    "Period" -> 2 Pi / \[Theta], "ChebyshevC" -> c|>
]

(* Continuous sine: symbolic, threads over lists *)
(* Uses direct Chebyshev formula — avoids recomputing parameters *)
(* f(t) = [o·Sin[(t+1)θ] + (1-o)/2·Sin[tθ]] / Sin[θ] *)
SuccessorSine[o_, t_, \[Lambda]_Integer: 2] := Module[{c, \[Theta]},
  c = ((\[Lambda]^2 + 1) o - 1) / (2 \[Lambda] o) // Simplify;
  \[Theta] = ArcCos[c];
  (o Sin[(t + 1) \[Theta]] + (1 - o)/2 Sin[t \[Theta]]) / Sin[\[Theta]]
]

SuccessorSine[o_, ts_List, \[Lambda]_Integer: 2] :=
  SuccessorSine[o, #, \[Lambda]] & /@ ts

End[];

EndPackage[];
