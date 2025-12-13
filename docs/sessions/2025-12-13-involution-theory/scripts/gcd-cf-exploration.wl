#!/usr/bin/env wolframscript
(* GCD vs CF vs Involution Path - hledání analytického vzorce *)
(* Date: 2025-12-13 *)

(* --- Generátory --- *)
silver[x_] := (1 - x)/(1 + x) // Together;
copper[x_] := 1 - x;
inv[x_] := 1/x;

(* --- Invariant --- *)
oddPart[n_] := n / 2^IntegerExponent[n, 2];
invariantI[r_] := oddPart[Numerator[r] * (Denominator[r] - Numerator[r])];

(* --- BFS s rekonstrukcí cesty --- *)
bfsWithPath[start_, target_, maxIter_:500] := Module[
  {visited, queue, curr, d, parent, n, found, path},
  visited = <|start -> 0|>;
  parent = <|start -> None|>;
  queue = {start};
  found = False;

  Do[
    If[Length[queue] == 0, Break[]];
    curr = First[queue]; queue = Rest[queue];
    d = visited[curr];

    If[curr === target, found = True; Break[]];

    (* silver *)
    n = silver[curr];
    If[n > 0 && !KeyExistsQ[visited, n],
      visited[n] = d+1; parent[n] = {curr, "s"}; AppendTo[queue, n]];

    (* copper *)
    n = copper[curr];
    If[n > 0 && !KeyExistsQ[visited, n],
      visited[n] = d+1; parent[n] = {curr, "c"}; AppendTo[queue, n]];

    (* inv *)
    n = inv[curr];
    If[n > 0 && !KeyExistsQ[visited, n],
      visited[n] = d+1; parent[n] = {curr, "i"}; AppendTo[queue, n]],
    {maxIter}
  ];

  If[!found || !KeyExistsQ[visited, target], Return[{Infinity, {}}]];

  (* Rekonstrukce cesty *)
  path = {};
  curr = target;
  While[parent[curr] =!= None,
    {prev, op} = parent[curr];
    PrependTo[path, op];
    curr = prev
  ];
  {visited[target], path}
];

(* --- Analýza pro zlomky p/q --- *)
analyzeRational[p_, q_] := Module[{r, cf, cfLen, dist, path, gcd},
  r = p/q;
  cf = ContinuedFraction[r];
  cfLen = Total[cf];  (* suma CF koeficientů = počet kroků ve Stern-Brocot *)
  gcd = GCD[p, q];
  {dist, path} = bfsWithPath[1/2, r, 1000];
  <|
    "r" -> r,
    "cf" -> cf,
    "|cf|" -> cfLen,
    "dist" -> dist,
    "path" -> StringJoin[path],
    "I" -> invariantI[r],
    "gcd" -> gcd,
    "p" -> p,
    "q" -> q,
    "q-p" -> q - p
  |>
];

(* --- Main --- *)
If[$ScriptCommandLine =!= {},
  Print["=== GCD vs CF vs INVOLUTION PATH ===\n"];

  (* Testovací zlomky se stejným I=1 *)
  Print["Zlomky s I=1 (orbita 1/2 pod {s,c}):"];
  Print["r       | CF        | |CF| | dist | path          | q-p"];
  Print[StringJoin@Table["-", {65}]];

  testFracs = {1/3, 1/4, 2/5, 1/5, 2/7, 3/7, 3/8, 1/6, 2/9, 3/10};
  Do[
    a = analyzeRational[Numerator[r], Denominator[r]];
    If[a["I"] == 1,
      Print[a["r"], " | ", a["cf"], " | ", a["|cf|"], " | ", a["dist"],
            " | ", a["path"], " | ", a["q-p"]]
    ],
    {r, testFracs}
  ];

  Print["\n--- Hledání vzorce ---"];
  Print["Hypotéza: dist souvisí s CF strukturou"];

  (* Detailní analýza 1/n *)
  Print["\nŘada 1/n:"];
  Do[
    a = analyzeRational[1, n];
    Print["1/", n, ": I=", a["I"], ", |CF|=", a["|cf|"], ", dist=", a["dist"],
          ", path=", a["path"]],
    {n, 2, 10}
  ];

  (* Fibonacci zlomky F_{n-1}/F_n *)
  Print["\nFibonacci zlomky F_{n-1}/F_n:"];
  fibs = Table[Fibonacci[n], {n, 1, 12}];
  Do[
    r = fibs[[n]]/fibs[[n+1]];
    a = analyzeRational[Numerator[r], Denominator[r]];
    Print["F", n, "/F", n+1, " = ", r, ": I=", a["I"], ", |CF|=", a["|cf|"],
          ", dist=", a["dist"], ", path=", a["path"]],
    {n, 1, 8}
  ];
];
