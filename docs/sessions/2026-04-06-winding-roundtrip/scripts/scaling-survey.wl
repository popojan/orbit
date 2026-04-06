(* ================================================================ *)
(* SCALING SURVEY: det(W(n,n,k)) for rational, irrational k        *)
(* ================================================================ *)

Needs["Orbit`"];

(* Utility *)
detW[n_, k_] := Det[WindingMatrix[n, n, k]]
singRate[k_, nMax_: 25] := Count[Table[detW[n, k] == 0, {n, 3, nMax}], True]

(* === Rational k = p/q, small denominators === *)
Print["=== Rational k: singularity rate (n=3..25) ===\n"];
Print["k          value     sing/23   notable"];
rationals = Union[Flatten[Table[p/q, {q, 1, 12}, {p, 1, 3 q}]]];
rationals = Select[rationals, 0 < # <= 3 &];
rationals = Union[rationals];
Do[
  sr = singRate[k];
  If[sr <= 2 || Denominator[k] <= 3,
    Print[PaddedForm[ToString[k], 10], "  ",
      NumberForm[N[k], {5, 3}], "  ",
      PaddedForm[sr, 3], "/23",
      If[sr == 0, "   ★ NEVER SINGULAR", ""]]],
{k, Sort[rationals, N[#1] < N[#2] &]}];

(* === Special irrationals === *)
Print["\n=== Irrational k: singularity rate (n=3..25) ===\n"];
irrationals = {
  {Sqrt[2], "√2"},
  {Sqrt[3], "√3"},
  {Sqrt[5], "√5"},
  {GoldenRatio, "φ"},
  {Pi, "π"},
  {Pi/2, "π/2"},
  {Pi/3, "π/3"},
  {Pi/4, "π/4"},
  {2 Pi, "2π"},
  {E, "e"},
  {E/2, "e/2"},
  {Log[2], "ln2"},
  {Log[3], "ln3"},
  {1/Pi, "1/π"},
  {2/Pi, "2/π"},
  {Pi/6, "π/6"},
  {Pi/7, "π/7"},
  {Sqrt[2 Pi], "√(2π)"},
  {Pi^2/6, "π²/6 = ζ(2)"}
};
Do[
  {val, label} = ir;
  sr = singRate[val];
  Print[PaddedForm[label, 12], "  ",
    NumberForm[N[val], {6, 4}], "  ",
    PaddedForm[sr, 3], "/23",
    If[sr == 0, "   ★ NEVER SINGULAR", ""]],
{ir, irrationals}];

(* === Hunt for NEVER SINGULAR k === *)
Print["\n=== Rational k with 0 singularities (n=3..25) ==="];
neverSing = {};
Do[
  If[singRate[p/q] == 0,
    AppendTo[neverSing, p/q]],
{q, 1, 20}, {p, 1, 3 q}];
neverSing = Union[neverSing];
Print["Count: ", Length[neverSing]];
Print["Values: ", N /@ neverSing[[1 ;; Min[30, Length[neverSing]]]]];
Print["Exact: ", neverSing[[1 ;; Min[30, Length[neverSing]]]]];
