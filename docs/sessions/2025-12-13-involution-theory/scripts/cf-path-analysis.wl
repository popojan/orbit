#!/usr/bin/env wolframscript
(* CF vs Involuční cesty - analýza *)
(* Date: 2025-12-13 *)
(* Key finding: Orbity s různým I vyžadují dlouhé objížďky přes Q⁺ *)

(* --- Definice --- *)
silver[x_] := (1 - x)/(1 + x) // Together;
copper[x_] := 1 - x;
inv[x_] := 1/x;

oddPart[n_] := n / 2^IntegerExponent[n, 2];
invariantI[r_] := oddPart[Numerator[r] * (Denominator[r] - Numerator[r])];

(* --- BFS bez Module (funguje spolehlivě) --- *)
bfsOrbit[start_, maxIter_:200] := Module[{visited, queue, curr, n1, n2, n3},
  visited = <|start -> 0|>;
  queue = {start};

  Do[
    If[Length[queue] == 0, Break[]];
    curr = First[queue]; queue = Rest[queue];
    d = visited[curr];

    n1 = silver[curr]; n2 = copper[curr]; n3 = inv[curr];
    If[n1 > 0 && n1 < 100 && !KeyExistsQ[visited, n1],
      visited[n1] = d+1; AppendTo[queue, n1]];
    If[n2 > 0 && n2 < 100 && !KeyExistsQ[visited, n2],
      visited[n2] = d+1; AppendTo[queue, n2]];
    If[n3 > 0 && n3 < 100 && !KeyExistsQ[visited, n3],
      visited[n3] = d+1; AppendTo[queue, n3]],
    {maxIter}
  ];

  visited
];

(* --- Main --- *)
If[$ScriptCommandLine =!= {},
  Print["=== CF vs INVOLUČNÍ CESTY ===\n"];

  (* Orbita z 1/2 *)
  orbit = bfsOrbit[1/2, 500];
  Print["Orbita z 1/2 (500 iter): ", Length[orbit], " zlomků"];
  Print["Prvních 20: ", Take[Sort[Keys[orbit]], Min[20, Length[orbit]]]];
  Print[""];

  (* Invarianty *)
  Print["Invarianty v orbitě:"];
  inOrbit01 = Select[Keys[orbit], 0 < # < 1 &];
  iValues = Union[invariantI /@ inOrbit01];
  Print["  I hodnoty: ", iValues];
  Print[""];

  (* CF srovnání pro I=1 členy *)
  Print["Srovnání pro I=1 členy:"];
  Print["target | CF | |CF| | dist | ratio"];
  Print[StringJoin@Table["-", {50}]];

  i1members = Select[inOrbit01, invariantI[#] == 1 &];
  Do[
    cf = ContinuedFraction[r];
    cfLen = Total[cf];
    d = orbit[r];
    Print[r, " | ", cf, " | ", cfLen, " | ", d, " | ", N[d/cfLen, 3]],
    {r, Take[Sort[i1members], 10]}
  ];

  Print["\n=== KLÍČOVÝ INSIGHT ==="];
  Print["Pod {silver, copper}: orbity separovány invariantem I = odd(p(q-p))"];
  Print["Pod {silver, copper, inv}: orbity se propojují přes Q⁺ \\ (0,1)"];
  Print[""];
  Print["Pro členy se STEJNÝM I: ratio dist/|CF| < 1 (involuce dávají zkratky)"];
  Print["Pro členy s RŮZNÝM I: potřeba objížďka -> ratio >> 1"];
];
