(* ================================================================ *)
(* COFACTOR MECHANISM: compare WITH and WITHOUT Euler correction    *)
(* At n=5,6 where strip-Euler creates singularity but Euler saves  *)
(*                                                                  *)
(* W^(ζ(3)) with Euler: non-singular at n=5,6                     *)
(* W^(ζ(3)·(1-p^{-3})) without Euler: singular at n=5,6          *)
(*                                                                  *)
(* Show entry-by-entry difference and cofactor at failure point    *)
(* ================================================================ *)

gList = Import["docs/sessions/2026-04-06-winding-roundtrip/scripts/zeros-500.wdx"];
lpList = Import["docs/sessions/2026-04-06-winding-roundtrip/scripts/logprimes-500.wdx"];

z3 = N[Zeta[3], 25];

(* With Euler product (standard) *)
fWM[nz_, k_] := Table[Floor[k gList[[n]] lpList[[j]]/(2 Pi)], {n, nz}, {j, nz}]

(* Without Euler: strip per-column factor *)
fWMStripped[nz_, s_] := Module[{zs = N[Zeta[s], 25]},
  Table[Floor[zs (1 - Prime[j]^(-s)) gList[[n]] lpList[[j]]/(2 Pi)],
    {n, nz}, {j, nz}]]

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  COFACTOR: Euler vs Stripped at failure points        ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Do[
  wE = fWM[n, z3];
  wS = fWMStripped[n, 3];
  dE = Det[wE];
  dS = Det[wS];

  Print["═══ n=", n, " ═══"];
  Print["  det WITH Euler:    ", dE];
  Print["  det WITHOUT Euler: ", dS];

  diff = wE - wS;
  changedEntries = Position[diff, _?(# != 0 &)];
  Print["  Entries that differ: ", Length[changedEntries]];

  If[Length[changedEntries] > 0 && Length[changedEntries] <= 20,
    Print["  Changed (row,col) → Δ:"];
    Do[
      {r, c} = pos;
      Print["    (", r, ",", c, "): ",
        wS[[r, c]], " → ", wE[[r, c]],
        "  (Euler adds ", wE[[r, c]] - wS[[r, c]], ")",
        "  p_", c, "=", Prime[c],
        "  correction=", NumberForm[N[Prime[c]^3/(Prime[c]^3 - 1) - 1], {4, 3}]],
    {pos, changedEntries}]];

  (* If stripped is singular but euler isn't: find the critical cofactor *)
  If[dS == 0 && dE != 0,
    Print["\n  ★ EULER SAVES: which entry change prevents singularity?"];
    (* For each changed entry, compute: what if ONLY that entry has Euler correction? *)
    Do[
      {r, c} = pos;
      wTest = wS;
      wTest[[r, c]] = wE[[r, c]];  (* restore just this entry *)
      dTest = Det[wTest];
      Print["    Restore (", r, ",", c, ") only: det=", dTest,
        If[dTest != 0, "  ← THIS ENTRY SAVES IT", ""]],
    {pos, changedEntries}];

    (* Also: null space of stripped matrix *)
    ns = NullSpace[wS];
    Print["  Null space of stripped W:"];
    Do[v = ns[[i]]; act = Select[Range[n], v[[#]] != 0 &];
      Print["    rows ", act, " coeffs ", v[[act]]], {i, Length[ns]}]];

  Print[""],
{n, {5, 6, 7, 8, 9, 10}}];

(* Deeper: what IS the Euler correction doing algebraically? *)
Print["═══ ALGEBRAIC VIEW ═══\n"];
Print["Entry (n,j): Floor[ζ(3)·γ_n·ln(p_j)/(2π)] vs Floor[ζ(3)·(1-p_j^{-3})·γ_n·ln(p_j)/(2π)]"];
Print["Difference comes from: ζ(3)·γ_n·ln(p_j)·p_j^{-3}/(1-p_j^{-3}) added to argument"];
Print["= γ_n·ln(p_j)·ζ(3)/(p_j^3 - 1)\n"];

n = 5;
Print["For n=5, the Euler correction to floor argument:"];
Do[
  corr = gList[[i]] * lpList[[j]] * z3 / (Prime[j]^3 - 1);
  If[corr > 0.3,
    Print["  (", i, ",", j, ") p=", Prime[j],
      "  correction=", NumberForm[corr, {6, 4}],
      "  floor arg WITH: ", NumberForm[z3 gList[[i]] lpList[[j]]/(2 Pi), {8, 4}],
      "  WITHOUT: ", NumberForm[z3 (1 - Prime[j]^(-3)) gList[[i]] lpList[[j]]/(2 Pi), {8, 4}]]],
{i, n}, {j, n}];
