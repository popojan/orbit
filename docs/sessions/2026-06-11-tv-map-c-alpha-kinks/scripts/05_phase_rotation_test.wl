(* 05_phase_rotation_test.wl -- is the left limit C-(p/q) equal to the
   boundary-system constant with a ROTATED Sturmian phase? (2026-06-11)
   Pre-registered hypothesis H-D1 (BEFORE running): for each target, the
   measured left limit equals exactCVal computed with steps word rotated
   by some r in 1..q-1 (same master equation, different starting phase).
   Confirmation would give the jump J(p/q) an exact algebraic closed form.
   Falsification: no rotation matches within extrapolation accuracy (~2e-4). *)

exactCValRot[pp_Integer, qq_Integer, r_Integer] := Module[
  {alpha = pp/qq, steps, poly, allRoots, subUnit, nR, rts,
   fMat, cumMat, sol, coeffs},
  steps = RotateLeft[
    Table[Floor[alpha*(j + 1)] - Floor[alpha*j], {j, 1, qq}], r];
  poly = (2 tVar - 1)^qq - tVar^(pp + qq);
  allRoots = tVar /. NSolve[poly == 0, tVar, WorkingPrecision -> 40];
  subUnit = Select[allRoots, Abs[#] < 1 - 10^-10 &];
  subUnit = SortBy[subUnit, -Abs[#] &];
  nR = Min[Length[subUnit], qq];
  If[nR < qq, Return[$Failed]];
  rts = subUnit[[1 ;; nR]];
  fMat = Table[(2 ri - 1)/ri^(steps[[j]] + 1),
    {ri, rts}, {j, 1, qq}] // N[#, 30] &;
  cumMat = Table[
    If[ph == 0, 1, Product[fMat[[i, j]], {j, 1, ph}]],
    {ph, 0, qq - 1}, {i, nR}] // N[#, 25] &;
  sol = LinearSolve[cumMat, Table[1, qq]];
  coeffs = sol*cumMat[[qq]];
  Re[1 - Sum[coeffs[[i]]*rts[[i]], {i, nR}]]
];

Off[General::stop]; Off[N::precsm];

(* measured left limits from scripts 02/04 (Aitken / lambda-fit) *)
leftLimits = {
  {3, 2, 0.224566}, {4, 3, 0.177053}, {5, 3, 0.272354},
  {6, 5, 0.1250537}, {7, 5, 0.203800}, {8, 5, 0.2627869},
  {10, 7, 0.2129092}};

Do[
  Module[{p = t[[1]], q = t[[2]], cm = t[[3]], vals, best},
    vals = Table[{r, exactCValRot[p, q, r]}, {r, 0, q - 1}];
    best = MinimalBy[vals, Abs[#[[2]] - cm] &][[1]];
    Print[p, "/", q, "  C-(measured) = ", cm];
    Print["  rotations: ",
      Table[NumberForm[N[v[[2]], 8], 8], {v, vals}]];
    Print["  best match: r = ", best[[1]], "  C_rot = ",
      NumberForm[N[best[[2]], 9], 9], "  residual = ",
      NumberForm[N[best[[2]] - cm, 3], 3]]],
  {t, leftLimits}];
