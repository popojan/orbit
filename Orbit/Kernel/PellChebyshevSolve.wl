(* ::Package:: *)

(* PellChebyshevSolve: Pell solver via Chebyshev elevation *)
(* Uses rank-of-apparition / LCM method for exact minimal m *)
(* See: docs/papers/chebyshev-pell-tower.tex *)

BeginPackage["Orbit`"];

PellChebyshevSolve::usage = "PellChebyshevSolve[n] solves x^2 - n y^2 = 1 \
via Chebyshev polynomial evaluation. Returns <|\"x\"->x, \"y\"->y, \"c\"->c, \
\"r\"->r, \"m\"->m, \"z\"->z|> on success, or $Failed. \
Option: \"CMax\" (default 7) controls decomposition search breadth.";

Begin["`Private`"];

Options[PellChebyshevSolve] = {"CMax" -> 7};

PellChebyshevSolve[n_, OptionsPattern[]] /;
  (IntegerQ /@ NumeratorDenominator@Sqrt[n] != {True, True}) :=
  Module[{cmax},
    cmax = OptionValue["CMax"];
    Catch[
      Do[
        pellChebyshevTryC[n, Denominator@n * cc],
      {cc, 1, cmax}];
      $Failed
    , "pellHit"]
  ];

PellChebyshevSolve[___] := $Failed;

(* Try a specific c value: enumerate divisors of 4c^2 n *)
(* Two passes: below-sqrt first (smaller solutions), then above-sqrt *)
pellChebyshevTryC[n_, c_] :=
  Module[{cn = c^2 * n, divs},
    divs = Divisors[4 Numerator@cn];
    (* Pass 1: below sqrt — a0^2 = cn - rr *)
    Do[
      If[rr <= 0 || rr >= cn, Continue[]];
      pellTrySeed[n, c, cn - rr, rr, 1],
    {rr, divs}];
    (* Pass 2: above sqrt — a0^2 = cn + rr *)
    Do[
      If[rr <= 0, Continue[]];
      pellTrySeed[n, c, cn + rr, rr, -1],
    {rr, divs}]
  ];

(* Try a single seed. sign: +1 for below-sqrt, -1 for above-sqrt *)
(* Below: z = (2a0^2 + rr)/rr.  Above: z = (2a0^2 - rr)/rr. *)
pellTrySeed[n_, c_, a0sq_, rr_, sign_] :=
  Module[{a0, z, delta, w, m, x, y},
    If[a0sq <= 0, Return[]];
    a0 = Sqrt[a0sq];
    If[!IntegerQ[a0], Return[]];
    z = (2 a0sq + sign * rr) / rr;
    delta = Denominator[z];
    If[delta > 2, Return[]];
    w = 2 a0 / rr;
    m = pellFindM[z, w, delta];
    If[!IntegerQ[m] || m < 1, Return[]];
    x = ChebyshevT[m, z];
    If[!IntegerQ[x] || x <= 0, Return[]];
    y = c * w * ChebyshevU[m - 1, z];
    If[!IntegerQ[y], Return[]];
    If[x^2 - n * y^2 == 1,
      Throw[<|"n" -> n, "x" -> x, "y" -> y,
        "c" -> c, "r" -> sign * rr, "z" -> z, "m" -> m|>, "pellHit"]
    ]
  ];

(* Find minimal m for given seed (z, w) with denominator defect delta *)
pellFindM[z_, w_, 1] := (* delta = 1: z integer *)
  Module[{nn = Denominator[w]},
    If[nn == 1, 1, chebyshevURank[z, nn]]
  ];

pellFindM[z_, w_, 2] := (* delta = 2: z half-integer, m = 3q *)
  Module[{zp, u2, nn, rank},
    zp = ChebyshevT[3, z];
    u2 = ChebyshevU[2, z];
    nn = Denominator[w * u2];
    If[nn == 1, Return[3]];
    rank = chebyshevURank[zp, nn];
    If[rank === $Failed, $Failed, 3 rank]
  ];

(* Rank of apparition: smallest m >= 1 with U_{m-1}(z) = 0 (mod N) *)
(* Factor N, find rank per prime power, take LCM *)
chebyshevURank[z_, nn_] :=
  Module[{ranks},
    ranks = chebyshevURankPP[z, #[[1]], #[[2]]] & /@ FactorInteger[nn];
    If[MemberQ[ranks, $Failed], $Failed, LCM @@ ranks]
  ];

(* Rank for a single prime power p^e *)
(* Iterates U_k(z) mod p^e until first zero *)
(* Bound: alpha(p^e) | p^(e-1) * (p - (z^2-1 | p)), so <= p^(e-1)*(p+1) *)
chebyshevURankPP[z_, p_, e_] :=
  Module[{pe = p^e, uprev, ucurr, unext, zmod, bound, result = $Failed},
    zmod = Mod[z, pe];
    uprev = 1;                        (* U_0 *)
    ucurr = Mod[2 zmod, pe];          (* U_1 *)
    bound = 2 p^(e - 1) (p + 1);
    If[ucurr == 0, Return[2]];
    Do[
      unext = Mod[2 zmod ucurr - uprev, pe];
      uprev = ucurr;
      ucurr = unext;
      If[ucurr == 0, result = k + 2; Break[]],
    {k, 1, bound}];
    result
  ];

End[];
EndPackage[];
