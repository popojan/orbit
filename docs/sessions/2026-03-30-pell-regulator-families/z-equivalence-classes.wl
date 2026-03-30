Get["/home/jan/github/orbit/Orbit/Kernel/PellChebyshevSolve.wl"];
sqfree[n_] := Times @@ (Power @@@ ({#1, Mod[#2, 2]} & @@@ FactorInteger[n]))

(* Collect all (n, z) pairs *)
pairs = {};
Do[
  If[IntegerQ[Sqrt[n0]], Continue[]];
  res = PellChebyshevSolve[n0];
  If[res =!= $Failed,
    AppendTo[pairs, {n0, res["z"], res["c"], res["m"], res["r"], sqfree[n0]}]],
{n0, 2, 10000}];

(* Group by z value *)
zGroups = GatherBy[pairs, #[[2]] &];
zGroups = Select[zGroups, Length[#] >= 2 &];
zGroups = Reverse@SortBy[zGroups, Length];

Print["=== z-EQUIVALENCE CLASSES (shared z) ===\n"];
Print["Classes with ≥ 2 members: ", Length[zGroups]];
Print["Largest class: ", Length[zGroups[[1]]], " members\n"];

Do[
  grp = zGroups[[i]];
  z0 = grp[[1, 2]];
  Print["z = ", If[IntegerQ[z0], z0, N[z0, 6]], " (", Length[grp], " members):"];
  (* Check: do they share a field? *)
  fields = Union[#[[6]] & /@ grp];
  Print["  Fields (sqfree): ", fields];
  Do[
    {n0, z, c, m, r, nsf} = entry;
    Print["    n=", StringPadRight[ToString[n0], 7],
      " = ", If[n0 != nsf, ToString[n0/nsf] <> "²·" <> ToString[nsf], ToString[nsf]],
      "  c=", c, " m=", m, " r=", r],
  {entry, grp}];
  Print[],
{i, 1, Min[15, Length[zGroups]]}];

Print["=== DO SHARED-z CLASSES = SHARED FIELD? ===\n"];
sameField = 0; diffField = 0;
Do[
  fields = Union[#[[6]] & /@ grp];
  If[Length[fields] == 1, sameField++, diffField++],
{grp, zGroups}];
Print["Same field: ", sameField, "/", Length[zGroups]];
Print["Different field: ", diffField, "/", Length[zGroups]];
