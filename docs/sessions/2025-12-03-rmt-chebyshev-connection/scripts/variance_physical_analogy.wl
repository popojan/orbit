(* Physical Analogies for Variance Mechanisms *)
(* Session: 2025-12-03 RMT-Chebyshev Connection *)

(* === Two mechanisms for variance reduction === *)

Print["╔═══════════════════════════════════════════════════════════════╗"];
Print["║          PHYSICAL ANALOGIES FOR SPACING VARIANCE             ║"];
Print["╚═══════════════════════════════════════════════════════════════╝\n"];

(* === Mechanism 1: Level Repulsion (RMT) === *)
Print["═══════════════════════════════════════════════════════════════"];
Print["MECHANISM 1: LEVEL REPULSION (GUE/GOE)"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["Analogy: ELECTRONS ON A WIRE"];
Print[""];
Print["  ←────●────────●──────●────────────●──────●────→"];
Print["       e⁻       e⁻     e⁻           e⁻     e⁻"];
Print[""];
Print["  • Electrons REPEL each other (Coulomb force)"];
Print["  • Cannot approach → small spacings suppressed"];
Print["  • Wire is infinite → large spacings allowed"];
Print["  • P(s) ~ s² for small s (quadratic repulsion)"];
Print[""];

(* === Mechanism 2: Bounded Support (Arcsine) === *)
Print["═══════════════════════════════════════════════════════════════"];
Print["MECHANISM 2: BOUNDED SUPPORT (Arcsine)"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["Analogy: CAROUSEL VIEWED FROM THE SIDE"];
Print[""];
Print["  Top view:       Side view (projection):"];
Print["    ○ ○ ○"];
Print["  ○       ○       ──●●●──────●──────────●──────●●●──"];
Print["  ○   ●   ○           ↑                          ↑"];
Print["  ○       ○        bunched                   bunched"];
Print["    ○ ○ ○          (edges)                   (edges)"];
Print[""];
Print["  • People DON'T REPEL (stand where they stand)"];
Print["  • But projection is BOUNDED by carousel diameter"];
Print["  • Small spacings allowed near edges (cos changes slowly)"];
Print["  • Maximum spacing = carousel diameter"];
Print[""];

(* === Summary === *)
Print["═══════════════════════════════════════════════════════════════"];
Print["WHY BOTH REDUCE VARIANCE"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["VARIANCE = how much spacings differ from mean\n"];

Print["ELECTRONS (GUE):"];
Print["  ✗ Small gaps forbidden (repulsion)"];
Print["  ✓ Large gaps possible (infinite wire)"];
Print["  → Variance reduced FROM BELOW (no clusters)"];
Print[""];

Print["CAROUSEL (Arcsine):"];
Print["  ✓ Small gaps allowed (near edge projections)"];
Print["  ✗ Large gaps bounded (by diameter)"];
Print["  → Variance reduced FROM ABOVE (no large holes)"];
Print[""];

(* === Numerical comparison === *)
Print["═══════════════════════════════════════════════════════════════"];
Print["VARIANCE HIERARCHY"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["                Small spacings    Large spacings    Variance"];
Print["                ──────────────    ──────────────    ────────"];
Print["Poisson         allowed           unbounded         1.000"];
Print["GOE             suppressed (s¹)   exp. tail         0.273"];
Print["Arcsine         allowed           BOUNDED           0.234"];
Print["GUE             suppressed (s²)   exp. tail         0.178"];
Print[""];

Print["KEY INSIGHT:"];
Print["  Arcsine achieves LOWER variance than GOE"];
Print["  WITHOUT repulsion - purely through bounded support!"];
Print["  This is the power of geometric constraints."];
