(* ::Package:: *)

(* Square Root Rationalizations via Chebyshev Polynomials and Pell Equations *)

BeginPackage["Orbit`"];

SqrtRationalization::usage = "SqrtRationalization[n] computes a rational approximation to Sqrt[n] using Pell equation solutions and Chebyshev polynomial refinement.

Options:
  Method -> \"Rational\" | \"List\" | \"Expression\"
  Accuracy -> integer (number of Chebyshev terms, default 8)

The method uses the fundamental solution to x² - n·y² = 1, then refines using Chebyshev-based terms.

IMPORTANT: The Chebyshev series yields exact rational results ONLY when evaluated at x-1 where (x,y) is the Pell solution. This is a characterization property - the Pell solution is the unique point where the rationalization is perfectly rational.";

PellSolution::usage = "PellSolution[d] finds the fundamental solution {x, y} to the Pell equation x² - d·y² = 1.

Returns: {x -> value, y -> value}

Uses Wildberger's efficient algorithm from:
https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf";

ChebyshevTerm::usage = "ChebyshevTerm[x, k] computes the k-th term in the Chebyshev-based rational approximation series.

Formula:
  1 / (ChebyshevT[⌈k/2⌉, x+1] · (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1]))

where T is Chebyshev polynomial of the first kind, U is second kind.";

Begin["`Private`"];

(* Chebyshev-based term for rational approximation *)
ChebyshevTerm[x_, k_] :=
    1 / (     ChebyshevT[Ceiling[k/2],     x + 1]
          (   ChebyshevU[  Floor[k/2],     x + 1]
            - ChebyshevU[  Floor[k/2] - 1, x + 1]))

(* Sum of Chebyshev terms *)
sqrtTerms[x_, n_] :=
    1 + Sum[ChebyshevTerm[x, j], {j, 1, n}]

(* Held form for symbolic display *)
sqrtTermsHeld[x_, n_] :=
    1 + Sum[HoldForm[#]& @ ChebyshevTerm[x, j], {j, 1, n}]

(* List form *)
sqrtTermsList[x_, n_] :=
    Join[{1}, Table[ChebyshevTerm[x, j], {j, 1, n}]]

(* Pell equation solver - Wildberger's algorithm
   https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf *)
PellSolution[d_] := Module[
  { a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {x -> u, y -> r} ]

(* Main rationalization function *)
SqrtRationalization[n_, OptionsPattern[]] :=
    Module[{sol, acc = OptionValue[Accuracy]},
        sol = PellSolution[n];
        Switch[OptionValue[Method],
            "List",
                {(x - 1) / y, sqrtTermsList[x - 1, acc]} /. sol
            ,
            "Rational",
                (x - 1) / y sqrtTerms[x - 1, acc] /. sol
            ,
            "Expression",
                (x - 1) / y sqrtTermsHeld[x - 1, acc] /. sol
        ]
    ]

Options[SqrtRationalization] = {Method -> "List", Accuracy -> 8}

End[];

EndPackage[];
