(* ::Package:: *)

(* PellChebyshevSolve: fast Pell solver via Chebyshev elevation *)
(* See: docs/sessions/2026-03-30-pell-regulator-families/ *)

BeginPackage["Orbit`"];

PellChebyshevSolve::usage = "PellChebyshevSolve[n] attempts to solve x^2 - n y^2 = 1 \
via Chebyshev polynomial evaluation. Returns <|\"x\"->x, \"y\"->y, \"c\"->c, \
\"r\"->r, \"m\"->m, \"z\"->z|> on success, or $Failed if n is too hard. \
Options: \"CMax\" (default 7), \"MMax\" (default 15).";

Begin["`Private`"];

Options[PellChebyshevSolve] = {"CMax" -> 7, "MMax" -> 15};

PellChebyshevSolve[n_, OptionsPattern[]] /; (IntegerQ/@ NumeratorDenominator@Sqrt[n] != {True, True}) :=
  Module[{cmax, mmax},
    cmax = OptionValue["CMax"];
    mmax = OptionValue["MMax"];
    Catch[
      Monitor[Do[
        pellChebyshevTryC[n, Denominator@n * cc, mmax],
      {cc, 1, cmax}],cc];
      $Failed
    , "pellHit"]
  ];

PellChebyshevSolve[___] := $Failed;

(* Try a specific c value: enumerate divisors of 4c²n *)
pellChebyshevTryC[n_, c_, mmax_] :=
  Module[{cn = c^2 * n, divs, a0sq, a0, z, delta, w, xc, wU, yn},
    divs = Divisors[4 Numerator@cn];
    Do[
      If[rr <= 0 || rr >= cn, Continue[]];
      a0sq = cn - rr;
      If[a0sq <= 0, Continue[]];
      a0 = Sqrt[a0sq];
      If[!IntegerQ[a0], Continue[]];
      z = (2 a0^2 + rr) / rr;
      If[Denominator[z] > 2, Continue[]];
      w = 2 a0 / rr;
      Do[
        xc = ChebyshevT[mm, z];
        If[!IntegerQ[xc] || xc <= 0, Continue[]];
        wU = w * ChebyshevU[mm - 1, z];
        If[!IntegerQ[wU], Continue[]];
        yn = c * wU;
        If[xc^2 - n * yn^2 == 1,
          (* Valid solution. Try to reduce via smaller m. *)
          Throw[
            pellTryReduce[n, c, rr, z, w, mm, xc, yn, mmax],
          "pellHit"]],
      {mm, 1, mmax}],
    {rr, divs}]
  ];

(* Try to reduce: check if T_{m/k}(z) gives a smaller valid solution *)
pellTryReduce[n_, c_, r_, z_, w_, m_, x_, y_, mmax_] :=
  Module[{kCands, mred, xred, yred},
    kCands = Reverse@Sort@Union@Select[
      Join[{m}, If[Mod[m, #] == 0, {m/#}, {}] & /@ {2, 3, 5, 6}],
      IntegerQ[#] && # >= 1 &];
    Do[
      If[kk == m, Continue[]];
      mred = m / kk;
      If[!IntegerQ[mred] || mred < 1, Continue[]];
      xred = ChebyshevT[mred, z];
      If[!IntegerQ[xred] || xred <= 0, Continue[]];
      yred = c * w * ChebyshevU[mred - 1, z];
      If[IntegerQ[yred] && xred^2 - n * yred^2 == 1,
        Return[<|"n" -> n, "x" -> xred, "y" -> yred,
          "c" -> c, "r" -> r, "z" -> z,
          "m" -> mred, "mOrig" -> m, "k" -> kk|>]],
    {kk, kCands}];
    (* No reduction found, return original *)
    <|"n" -> n, "x" -> x, "y" -> y,
      "c" -> c, "r" -> r, "z" -> z, "m" -> m|>
  ];

End[];
EndPackage[];
