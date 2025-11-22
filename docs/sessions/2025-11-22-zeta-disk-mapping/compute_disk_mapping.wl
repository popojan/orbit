#!/usr/bin/env wolframscript
(* Compute correct disk mapping values for documentation *)

Print["Computing disk mapping examples...\n"];

(* Correct transformation *)
diskMap[s_] := Module[{z},
  z = Exp[Pi*I*(s - 1/2)];
  (z - 1)/(z + 1)
];

(* Critical line examples *)
Print["Critical line points (s = 1/2 + it):\n"];
critPoints = {0, 1, 5, 10, 14.1347, 50};
Do[
  s = 1/2 + I*t;
  w = diskMap[s];
  Print["t = ", NumberForm[t, {8, 4}],
        " → w = ", NumberForm[N[w], {10, 6}],
        ", |w| = ", NumberForm[N[Abs[w]], {8, 6}]];
, {t, critPoints}];

Print["\nFirst 10 zeta zeros:\n"];
Do[
  s = ZetaZero[n];
  t = Im[s];
  w = diskMap[s];
  Print["n=", n, ": t=", NumberForm[N[t], {8, 4}],
        " → w=", NumberForm[N[w], {12, 8}],
        ", |w|=", NumberForm[N[Abs[w]], {10, 8}]];
, {n, 1, 10}];

Print["\nGeneral strip points:\n"];
testPoints = {{0, 0}, {1, 0}, {1/2, 0}, {0, 10}, {1, 10}, {1/4, 5}};
Do[
  {sigma, t} = testPoints[[i]];
  s = sigma + I*t;
  w = diskMap[s];
  Print["s = ", NumberForm[N[s], {8, 3}],
        " → w = ", NumberForm[N[w], {10, 6}],
        ", |w| = ", NumberForm[N[Abs[w]], {8, 6}]];
, {i, 1, Length[testPoints]}];
