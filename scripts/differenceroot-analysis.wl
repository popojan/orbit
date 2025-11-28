(* Analysis of Mathematica's DifferenceRoot "closed form" *)

Print["==============================================================="]
Print["  DIFFERENCEROOT ANALYSIS"]
Print["==============================================================="]
Print[""]

Print["1. THE FORMULA"]
Print["==============================================================="]
Print[""]

Print["forfacti[n] = -1/(1 - Sum[Product[n^2-j^2]/(2i+1), i=1..(1+sqrt(n))/2])"]
Print[""]

(* Define the sum *)
innerSum[n_, maxI_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, maxI}]

(* Test numerically first *)
n = 143;
maxI = Floor[(1 + Sqrt[n])/2];
numResult = innerSum[n, maxI];
Print["For n = ", n, ", maxI = ", maxI]
Print["Sum = ", numResult]
Print["forfacti = ", -1/(1 - numResult)]
Print[""]

Print["2. WHAT IS DifferenceRoot?"]
Print["==============================================================="]
Print[""]

Print["DifferenceRoot[Function[{y, n}, {recurrence, y[0]==..., y[1]==...}]][k]"]
Print[""]
Print["This represents a sequence y[n] defined by a linear recurrence."]
Print["It's NOT a closed form - it's a SYMBOLIC representation of iteration!"]
Print[""]

Print["The recurrence from Mathematica:"]
Print["(1+2n)(-1-n+N)(1+n+N) y[n] +"]
Print["(-2+2n+5n^2+2n^3-N^2-2nN^2) y[n+1] +"]
Print["(3+2n) y[n+2] = 0"]
Print[""]
Print["where N is the semiprime, n is the recurrence index."]
Print[""]

Print["3. VERIFY THE RECURRENCE"]
Print["==============================================================="]
Print[""]

(* Define partial sums *)
partialSum[nn_, i_] := Sum[Product[nn^2 - j^2, {j, 1, k}]/(2 k + 1), {k, 1, i}]

(* The recurrence should connect y[i], y[i+1], y[i+2] *)
(* where y[i] = partialSum[n, i] *)

nn = 143;
Print["Testing recurrence for N = ", nn, ":"]
Print[""]

Do[
  y0 = partialSum[nn, i];
  y1 = partialSum[nn, i + 1];
  y2 = partialSum[nn, i + 2];

  (* Coefficients from the recurrence *)
  c0 = (1 + 2 i) * (-1 - i + nn) * (1 + i + nn);
  c1 = (-2 + 2 i + 5 i^2 + 2 i^3 - nn^2 - 2 i nn^2);
  c2 = (3 + 2 i);

  residual = c0 * y0 + c1 * y1 + c2 * y2;
  Print["  i=", i, ": residual = ", N[residual, 6],
    If[Abs[residual] < 10^-10, " (~ 0)", ""]],
  {i, 1, 6}
]
Print[""]

Print["4. WHAT DOES THIS MEAN FOR COMPLEXITY?"]
Print["==============================================================="]
Print[""]

Print["Even though Mathematica gives a 'closed form' with DifferenceRoot,"]
Print["EVALUATING DifferenceRoot[...][k] requires:"]
Print["  - Starting from initial conditions y[0], y[1]"]
Print["  - Iterating the recurrence k times"]
Print["  - This is O(k) = O(sqrt(n)) operations!"]
Print[""]

Print["The DifferenceRoot is just a FANCY WAY of writing the iteration."]
Print["It doesn't provide a computational shortcut."]
Print[""]

Print["5. THE GAMMA TERMS"]
Print["==============================================================="]
Print[""]

Print["Gamma[1-n] * Gamma[1+n] = -n * pi / sin(n*pi)"]
Print["By reflection formula: Gamma[z] * Gamma[1-z] = pi / sin(pi*z)"]
Print[""]

n = 143;
gammaProduct = Gamma[1 - n] * Gamma[1 + n];
Print["For n = ", n, ":"]
Print["  Gamma[1-143] * Gamma[1+143] = ", gammaProduct]
Print["  = ", N[gammaProduct]]
Print[""]

Print["This is a HUGE number (143! scale) - not useful numerically."]
Print[""]

Print["6. THE EXPONENTIAL PREFACTOR"]
Print["==============================================================="]
Print[""]

Print["I * E^(-I n pi) * (-1 + E^(2 I n pi)) / (2 n pi)"]
Print[""]

(* For integer n: E^(I n pi) = (-1)^n, E^(2 I n pi) = 1 *)
(* So -1 + E^(2 I n pi) = 0 for integer n! *)

Print["For integer n:"]
Print["  E^(2 I n pi) = 1"]
Print["  -1 + E^(2 I n pi) = 0"]
Print[""]

Print["The whole expression has a 0/0 indeterminate form for integers!"]
Print["Mathematica's result is for SYMBOLIC n, not integer n."]
Print[""]

Print["7. TRYING TO EVALUATE SYMBOLICALLY"]
Print["==============================================================="]
Print[""]

(* Let's see what Mathematica gives for the full expression *)
Print["Computing Sum symbolically..."]

symbolicSum = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, m}];
Print["Sum[..., {i,1,m}] = (symbolic result too complex to display)"]
Print[""]

(* Try specific *)
Print["For m = 3:"]
sum3 = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, 3}];
Print["  = ", Simplify[sum3]]
Print[""]

Print["8. PARTIAL FRACTION / HYPERGEOMETRIC?"]
Print["==============================================================="]
Print[""]

(* The product n^2 - j^2 = (n-j)(n+j) *)
(* Can be written as Pochhammer symbols *)
(* Product[n^2-j^2, j=1..i] = Pochhammer[n-i,i] * Pochhammer[n+1,i] * some sign *)

Print["Product[n^2-j^2, j=1..i] = (-1)^i * Pochhammer[1-n,i] * Pochhammer[1+n,i]"]
Print[""]

(* Verify *)
Do[
  prod = Product[n^2 - j^2, {j, 1, i}];
  poch = (-1)^i * Pochhammer[1 - n, i] * Pochhammer[1 + n, i];
  Print["  i=", i, ": Product = ", prod, ", Pochhammer = ", poch, ", Match: ", prod == poch],
  {i, 1, 5}
]
Print[""]

Print["9. HYPERGEOMETRIC CONNECTION"]
Print["==============================================================="]
Print[""]

Print["Sum[(-1)^i Poch[1-n,i] Poch[1+n,i] / (2i+1), i=1..m]"]
Print[""]

Print["This looks like a truncated hypergeometric series!"]
Print["But 2F1 or 3F2 with these parameters doesn't simplify nicely."]
Print[""]

Print["10. CONCLUSION"]
Print["==============================================================="]
Print[""]

Print["Mathematica's 'closed form' with DifferenceRoot is NOT a shortcut:"]
Print["  1. DifferenceRoot just encodes the recurrence relation"]
Print["  2. Evaluating it still requires O(sqrt(n)) iterations"]
Print["  3. The Gamma/exponential terms have indeterminate forms for integer n"]
Print[""]

Print["The recurrence IS interesting though:"]
Print["  (1+2i)(n-1-i)(n+1+i) y[i] + ... y[i+1] + (3+2i) y[i+2] = 0"]
Print[""]
Print["Maybe this 3-term recurrence could be solved in closed form?"]
Print["That would require finding a pattern in the characteristic roots."]
