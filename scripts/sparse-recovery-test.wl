(* Sparse Recovery Test for Semiprime Factorization *)
(* Can we identify the 2 nonzero positions using O(log n) measurements? *)

(* The signal: s[i] = FractionalPart[Product[n^2-j^2, {j,1,i}] / (2i+1)] *)
signal[n_, i_] := FractionalPart[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1)]

(* For semiprime n = p*q, signal is nonzero only at i=(p-1)/2 and i=(q-1)/2 *)

Print["=== Sparse Recovery Test ==="]
Print[""]

(* Test case: n = 143 = 11 * 13 *)
n = 143;
{p, q} = {11, 13};
maxI = (q - 1)/2;  (* = 6 *)

Print["n = ", n, " = ", p, " × ", q]
Print["Nonzero positions: i = ", (p-1)/2, " and i = ", (q-1)/2]
Print["Signal values: ", (p-1)/p, " and ", (q-1)/q]
Print[""]

(* Full signal *)
fullSignal = Table[signal[n, i], {i, 1, maxI}];
Print["Full signal: ", fullSignal]
Print[""]

(* Binary search approach: Can we narrow down positions? *)
Print["=== Binary Search Approach ==="]
Print[""]

(* Idea: sum over subset tells us if ANY nonzero position is in subset *)
subsetSum[n_, indices_] := Sum[signal[n, i], {i, indices}]

(* Test: first half vs second half *)
firstHalf = Range[1, 3];
secondHalf = Range[4, 6];

Print["First half (1-3): sum = ", subsetSum[n, firstHalf]]
Print["Second half (4-6): sum = ", subsetSum[n, secondHalf]]
Print[""]

(* Both halves have nonzero sums because positions 5 and 6 are in second half... wait *)
(* Position 5 is in second half (4-6), but let me check position breakdown *)

Print["Position 5 ((11-1)/2) is in: ", If[MemberQ[firstHalf, 5], "first half", "second half"]]
Print["Position 6 ((13-1)/2) is in: ", If[MemberQ[secondHalf, 6], "second half", "first half"]]
Print[""]

(* The problem: both positions are close together! *)
(* Binary search works poorly when targets are adjacent *)

Print["=== Measurement Matrix Approach ==="]
Print[""]

(* Compressed sensing uses random measurement matrices *)
(* If we have k-sparse signal of length N, need O(k log N) measurements *)

(* For our problem: k=2 (two prime factors), N ~ sqrt(n) *)
(* So theoretically need O(log sqrt(n)) = O(log n) measurements *)

(* But here's the catch: computing each "measurement" requires... *)

(* Single index measurement *)
Print["Cost of measuring position i:"]
Print["  - Must compute Product[n^2 - j^2, {j, 1, i}]"]
Print["  - This is O(i) multiplications"]
Print["  - For i ~ sqrt(n), this is O(sqrt(n)) work"]
Print[""]

(* Random subset sum *)
Print["Cost of random subset measurement:"]
Print["  - Must compute signal[n, i] for each i in subset"]
Print["  - If subset has m elements, need m × O(sqrt(n)) work"]
Print["  - Total: O(m sqrt(n))"]
Print[""]

Print["=== The Fundamental Problem ==="]
Print[""]
Print["Even if we could identify positions with O(log n) measurements,"]
Print["each measurement requires O(sqrt(n)) computation."]
Print["Total: O(sqrt(n) log n) -- worse than naive O(sqrt(n))!"]
Print[""]

(* Unless... we can compute measurements WITHOUT evaluating individual positions *)

Print["=== Alternative: Algebraic Measurements ==="]
Print[""]

(* Can we compute sum of signal over subset algebraically? *)
(* Sum_{i in S} {f(n,i)/(2i+1)} = ??? *)

(* The fractional part makes this hard *)
(* FractionalPart is not linear! *)

Print["Problem: FractionalPart is not additive"]
Print["  {a} + {b} ≠ {a + b} in general"]
Print[""]

(* Let's check *)
a = signal[n, 5];
b = signal[n, 6];
Print["signal[143, 5] = ", a]
Print["signal[143, 6] = ", b]
Print["sum = ", a + b]
Print[""]

(* What if we work with the underlying expression before taking FractionalPart? *)
Print["=== Working with Full Expression ==="]
Print[""]

fullExpr[n_, i_] := Product[n^2 - j^2, {j, 1, i}]/(2 i + 1)

Print["Full expressions (before FractionalPart):"]
Do[
  expr = fullExpr[n, i];
  Print["  i=", i, ": ", expr, " = ", N[expr, 5]],
  {i, 1, 6}
]
Print[""]

(* The sum of full expressions *)
totalSum = Sum[fullExpr[n, i], {i, 1, 6}];
Print["Sum of full expressions: ", N[totalSum]]
Print[""]

(* What about generating functions? *)
Print["=== Generating Function Approach ==="]
Print[""]

(* Define G(x) = Sum_{i=1}^{inf} signal[n,i] * x^i *)
(* This encodes the sparse signal *)
(* For semiprime: G(x) = (p-1)/p * x^{(p-1)/2} + (q-1)/q * x^{(q-1)/2} *)

Print["For n = pq, the generating function is:"]
Print["  G(x) = (p-1)/p × x^{(p-1)/2} + (q-1)/q × x^{(q-1)/2}"]
Print[""]
Print["For n = 143 = 11×13:"]
Print["  G(x) = 10/11 × x^5 + 12/13 × x^6"]
Print[""]

(* Can we compute G(x) for specific x values without knowing p, q? *)
Print["Question: Can we evaluate G(x) for specific x without iteration?"]
Print[""]

(* G(1) = S_∞ = (p-1)/p + (q-1)/q -- requires full sum *)
(* G(-1) = (p-1)/p × (-1)^{(p-1)/2} + (q-1)/q × (-1)^{(q-1)/2} *)

gAt1 = (p-1)/p + (q-1)/q;
gAtMinus1 = (p-1)/p * (-1)^((p-1)/2) + (q-1)/q * (-1)^((q-1)/2);

Print["G(1) = ", gAt1, " = ", N[gAt1]]
Print["G(-1) = ", gAtMinus1, " = ", N[gAtMinus1]]
Print[""]

(* G(ω) for roots of unity could be interesting *)
Print["G at roots of unity (ω = e^{2πi/k}):"]
Do[
  omega = Exp[2 Pi I / k];
  gAtOmega = (p-1)/p * omega^((p-1)/2) + (q-1)/q * omega^((q-1)/2);
  Print["  G(ω_", k, ") = ", Simplify[gAtOmega]],
  {k, 2, 6}
]
Print[""]

(* If we could compute G(ω) for various ω, we could use DFT to recover positions! *)
Print["=== DFT Recovery Idea ==="]
Print[""]
Print["If we had G(ω_k) for k = 1, ..., N (roots of unity),"]
Print["inverse DFT would give us the signal directly."]
Print[""]
Print["BUT: computing G(ω_k) requires summing signal[n,i] × ω_k^i"]
Print["     which still needs to evaluate each signal[n,i]!"]
Print[""]

Print["=== Conclusion ==="]
Print[""]
Print["The sparse recovery framework shows WHY the problem is hard:"]
Print[""]
Print["1. Signal IS sparse (only 2 nonzero positions)"]
Print["2. BUT the signal is defined via modular arithmetic"]
Print["3. Evaluating any single position requires O(i) work"]
Print["4. No known way to compute 'aggregate measurements' cheaply"]
Print[""]
Print["This mirrors classical factoring hardness:"]
Print["  Structure EXISTS but accessing it requires iteration"]
Print[""]
