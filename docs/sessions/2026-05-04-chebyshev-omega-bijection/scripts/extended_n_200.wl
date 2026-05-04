(* Extended verification: n in [2, 200] *)

primePowerQ[d_Integer] := d > 1 && PrimePowerQ[d];

expectedPrimes[n_Integer] := Module[{ppDivs},
  ppDivs = Select[Divisors[n], primePowerQ];
  Sort[FactorInteger[#][[1, 1]] & /@ ppDivs]
];

primeConstQ[c_] := IntegerQ[c] && PrimeQ[Abs[c]];

verifyOne[n_Integer, poly_] := Module[{fl, items, expected, actual, ok},
  fl = FactorList[poly];
  items = ({#[[1]] /. x -> 0, #[[2]], Exponent[#[[1]], x]}) & /@ fl;
  expected = expectedPrimes[n];
  actual = Sort[Abs[#[[1]]] & /@ Select[items, primeConstQ[#[[1]]] && #[[3]] >= 1 &]];
  ok = (expected === actual);
  {n, IntegerExponent[n, 2], PrimeOmega[n], expected, actual, ok}
];

(* T_n(x+1) - 1 *)
results = Table[verifyOne[n, ChebyshevT[n, x + 1] - 1], {n, 2, 200}];

byV2 = GroupBy[results, #[[2]] &];
Print["=== T_n(x+1) - 1, n in [2, 200] ==="];
Do[
  matches = Select[byV2[v], #[[6]] &];
  Print["v2 = ", v, ": ", Length[matches], " / ", Length[byV2[v]], " match"],
  {v, Sort[Keys[byV2]]}];

(* Confirm sharp boundary: ALL n with 4 not | n match, NO n with 4 | n match *)
Print[];
nWith4 = Select[results, Mod[#[[1]], 4] === 0 &];
nWithout4 = Select[results, Mod[#[[1]], 4] != 0 &];
Print["n with 4 | n: ", Length[Select[nWith4, #[[6]] &]], " / ", Length[nWith4], " match"];
Print["n with 4 NOT | n: ", Length[Select[nWithout4, #[[6]] &]], " / ", Length[nWithout4], " match"];

(* ---- alternative polynomials for 4 | n cases -------------------------- *)

(* Try: T_n(x-1) + 1, T_n(x+1) + 1, T_n(2x+1) - 1, T_n(x/2 + 1) - 1, etc. *)

testAlt[n_Integer, polyFn_, label_String] := Module[{poly, r},
  poly = polyFn[n];
  r = verifyOne[n, poly];
  {label, r[[6]], r[[5]]}
];

Print[];
Print["=== alternative polynomials for n with 4 | n ==="];

candidates4 = Select[Range[4, 50], Mod[#, 4] === 0 &];
Do[
  Print[];
  Print["n = ", n, "  (Omega = ", PrimeOmega[n], ", expect ", expectedPrimes[n], ")"];
  Do[
    {label, lambda} = pair;
    poly = lambda[n];
    r = verifyOne[n, poly];
    Print["  ", StringPadRight[label, 30], "  match=",
      If[r[[6]], "OK  ", "FAIL"], "  got ", r[[5]]],
    {pair, {
      {"T_n(x+1) - 1", Function[m, ChebyshevT[m, x + 1] - 1]},
      {"T_n(x-1) + 1", Function[m, ChebyshevT[m, x - 1] + 1]},
      {"T_n(x+1) + 1", Function[m, ChebyshevT[m, x + 1] + 1]},
      {"T_n(x) - 1 (no shift)", Function[m, ChebyshevT[m, x] - 1]},
      {"T_n(2x+1) - 1", Function[m, ChebyshevT[m, 2 x + 1] - 1]},
      {"U_{n-1}(x+1)", Function[m, ChebyshevU[m - 1, x + 1]]},
      {"T_n(x+1)^2 - 1", Function[m, ChebyshevT[m, x + 1]^2 - 1]},
      {"(T_n(x+1)-1)(T_n(x-1)+1)", Function[m, (ChebyshevT[m, x + 1] - 1) (ChebyshevT[m, x - 1] + 1)]}
    }}],
  {n, candidates4}];
