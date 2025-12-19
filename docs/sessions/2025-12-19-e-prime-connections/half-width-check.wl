(* Check connection between s_n divisibility and half-width denominators *)

<< Orbit`;

Print["=== HALF-WIDTH INTERVAL ANALYSIS ===\n"];

(* Compute half-widths for various k *)
Print["EulerEInterval[k] gives Interval[{T_{2k-1}, T_{2k}}]"];
Print["Half-width = (T_{2k} - T_{2k-1}) / 2\n"];

Print["k | lower | upper | width | width denominator factors"];
Print["--+-------+-------+-------+--------------------------"];

Do[
  intv = EulerEInterval[k];
  {lo, hi} = List @@ Normal[intv][[1]];
  width = hi - lo;
  halfW = width / 2;
  numW = Numerator[width];
  denW = Denominator[width];

  Print[k, " | T_", 2k-1, "/T_", 2k, " | width = ", width,
        " | denom factors: ", FactorInteger[denW][[All, 1]]];
, {k, 1, 6}];

(* Check relationship between width denominator and s_n *)
Print["\n=== COMPARISON WITH s_n ===\n"];

(* s_n sequence *)
s[0] = 1; s[1] = 7;
s[n_] := s[n] = (4 n + 2) s[n - 1] + s[n - 2];

Print["s_n for n = 0..10:"];
Print[Table[{n, s[n]}, {n, 0, 10}] // TableForm];

Print["\n=== WIDTH DENOMINATORS vs s_n PRODUCTS ==="];

Do[
  intv = EulerEInterval[k];
  {lo, hi} = List @@ Normal[intv][[1]];
  width = hi - lo;
  denW = Denominator[width];

  (* Check if denW = s_{2k-1} * s_{2k} *)
  product = s[2 k - 1] * s[2 k];

  Print["k=", k, ": width denom = ", denW,
        ", s_{", 2k-1, "}*s_{", 2k, "} = ", product,
        ", equal? ", denW == product];
, {k, 1, 6}];

(* Half-width specifically *)
Print["\n=== HALF-WIDTH DENOMINATORS ==="];

Do[
  intv = EulerEInterval[k];
  {lo, hi} = List @@ Normal[intv][[1]];
  halfW = (hi - lo) / 2;
  denHW = Denominator[halfW];

  Print["k=", k, ": half-width denom = ", denHW,
        " = ", FactorInteger[denHW]];
, {k, 1, 6}];

(* Answer user's question directly *)
Print["\n=== DIVISIBILITY EQUIVALENCE ==="];
Print["Is p | s_k equivalent to p | (half-width denominator)?"];

(* Take p = 7, 11, 13, 71 and check *)
testPrimes = {7, 11, 13, 71, 17, 23};

Print["\nFor each prime p, check if it divides:"];
Print["  1. Some s_k"];
Print["  2. Some half-width denominator\n"];

Do[
  (* Check s_k *)
  firstSk = SelectFirst[Range[0, 50], Mod[s[#], p] == 0 &];
  dividesSk = !MissingQ[firstSk];

  (* Check half-width denominators *)
  hwDenoms = Table[
    Module[{intv, lo, hi, hw},
      intv = EulerEInterval[k];
      {lo, hi} = List @@ Normal[intv][[1]];
      Denominator[(hi - lo)/2]
    ]
  , {k, 1, 10}];

  firstHW = SelectFirst[Range[10], Mod[hwDenoms[[#]], p] == 0 &];
  dividesHW = !MissingQ[firstHW];

  Print["p = ", p, ": divides s_k? ", dividesSk,
        If[dividesSk, " (first k=" <> ToString[firstSk] <> ")", ""],
        " | divides HW denom? ", dividesHW,
        If[dividesHW, " (first at k=" <> ToString[firstHW] <> ")", ""]];
, {p, testPrimes}];
