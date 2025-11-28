(* Explore additive structure of RESIDUES, not k itself *)
(* Key insight: CRT says x mod k is determined by (x mod p1, x mod p2, x mod p3) *)
(* The "lobes" are residue classes - maybe their additive structure matters *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

Print["=== Exploring the structure of primitive lobes ===\n"];

(* For a small example, let's see which n are primitive lobes *)
p1 = 5; p2 = 11; p3 = 17;
k = p1 p2 p3;
Print["k = ", p1, "*", p2, "*", p3, " = ", k];
Print["Σsigns = ", signSum[k], "\n"];

(* List primitive lobes with their CRT signatures *)
lobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
Print["Number of primitive lobes: ", Length[lobes]];

Print["\nFirst 20 primitive lobes with CRT signatures:"];
Do[
  n = lobes[[i]];
  sig = {Mod[n, p1], Mod[n, p2], Mod[n, p3]};
  parity = If[OddQ[n], "+", "-"];
  Print["n=", n, " -> (", sig[[1]], ", ", sig[[2]], ", ", sig[[3]], ") ", parity],
  {i, Min[20, Length[lobes]]}
];

(* The sign of each lobe is (-1)^(n-1) = sign(n odd) *)
(* Count by parity and see if CRT signature determines anything *)

oddLobes = Select[lobes, OddQ];
evenLobes = Select[lobes, EvenQ];
Print["\nOdd lobes (contribute +1): ", Length[oddLobes]];
Print["Even lobes (contribute -1): ", Length[evenLobes]];
Print["Σsigns = ", Length[oddLobes] - Length[evenLobes]];

(* Key question: what determines whether a lobe is odd or even? *)
(* n odd <=> n mod 2 = 1 *)
(* But in CRT: n = a1*c1 + a2*c2 + a3*c3 where ai = n mod pi *)
(* So n mod 2 = (a1*c1 + a2*c2 + a3*c3) mod 2 *)

Print["\n=== CRT parity analysis ==="];
c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
Print["c1 = ", c1, " mod 2 = ", Mod[c1, 2]];
Print["c2 = ", c2, " mod 2 = ", Mod[c2, 2]];
Print["c3 = ", c3, " mod 2 = ", Mod[c3, 2]];

Print["\nFor n = a1*c1 + a2*c2 + a3*c3 (mod k):"];
Print["n mod 2 = (a1*", Mod[c1, 2], " + a2*", Mod[c2, 2], " + a3*", Mod[c3, 2], ") mod 2"];
Print["       = (a1*c1mod2 + a2*c2mod2 + a3*c3mod2) mod 2"];

(* Count primitive lobes by their CRT signature parity *)
Print["\n=== CRT signature analysis ==="];
bySig = GroupBy[lobes, {Mod[#, p1], Mod[#, p2], Mod[#, p3]} &];
Print["Number of distinct CRT signatures among lobes: ", Length[bySig]];

(* The ADDITIVE structure: Σsigns = Σ over signatures of (count * sign_contribution) *)
Print["\nPer-signature contributions:"];
totalContrib = 0;
Do[
  ns = bySig[sig];
  contrib = Total[(-1)^(# - 1) & /@ ns];
  If[Abs[contrib] > 0,
    Print["  ", sig, " -> ", Length[ns], " lobes, contrib = ", contrib]
  ];
  totalContrib += contrib,
  {sig, Sort[Keys[bySig]]}
];
Print["Total Σsigns = ", totalContrib];

(* Key insight: each CRT signature (a1, a2, a3) appears at most once mod k *)
(* So the contribution is just (-1)^(n-1) for each primitive (a1, a2, a3) *)
Print["\n=== The formula ==="];
Print["Σsigns = Σ_{primitive signatures} (-1)^(n(sig)-1)"];
Print["where n(sig) = a1*c1 + a2*c2 + a3*c3 mod k"];
Print["and primitive means: GCD(n-1, k)=1 AND GCD(n, k)=1"];
