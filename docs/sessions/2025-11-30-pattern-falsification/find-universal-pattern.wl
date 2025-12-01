(* Find the universal pattern for SS(p*q) *)

signSumSemiprime[p_, q_] := Module[{k = p*q, valid},
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  Total[If[OddQ[#], 1, -1] & /@ valid]
];

Print["=== UNIVERSAL PATTERN SEARCH ===\n"];

(* For each p, find which residues give SS=1 vs SS=-3 *)
Do[
  p = Prime[i];
  Print["\n=== p = ", p, " ==="];

  (* Compute SS for all residue classes *)
  residueData = Table[
    {r, {}},
    {r, Select[Range[p - 1], GCD[#, p] == 1 &]}
  ] // Association;

  (* Gather data *)
  Do[
    q = Prime[j];
    r = Mod[q, p];
    ss = signSumSemiprime[p, q];
    AppendTo[residueData[r], ss],
    {j, i + 1, Min[i + 50, 100]}
  ];

  (* Report which residues give which SS *)
  ss1residues = Select[Keys[residueData], Union[residueData[#]] == {1} &];
  ssM3residues = Select[Keys[residueData], Union[residueData[#]] == {-3} &];
  mixedResidues = Select[Keys[residueData], Length[Union[residueData[#]]] > 1 &];

  Print["SS = 1 for q ≡ ", ss1residues, " (mod ", p, ")"];
  Print["SS = -3 for q ≡ ", ssM3residues, " (mod ", p, ")"];
  If[Length[mixedResidues] > 0,
    Print["MIXED: ", mixedResidues];
  ];

  (* What's the pattern? *)
  If[Length[mixedResidues] == 0,
    Print["Pattern holds perfectly!"];
    (* Check various hypotheses *)
    Print["  Comparing to QR: ", Sort[ss1residues], " vs QR=", Sort[Select[Range[p-1], JacobiSymbol[#, p] == 1 &]]];
    Print["  Sum of SS=1 residues: ", Total[ss1residues]];
    Print["  Sum of SS=-3 residues: ", Total[ssM3residues]];
  ],
  {i, 2, 12}
];

(* HYPOTHESIS: The pattern relates to primitive roots *)
Print["\n\n=== PRIMITIVE ROOT CONNECTION ===\n"];

Do[
  p = Prime[i];
  g = PrimitiveRoot[p];
  Print["p = ", p, ", primitive root g = ", g];

  (* Does the pattern relate to powers of g? *)
  ss1residues = {};
  ssM3residues = {};
  Do[
    q = Prime[j];
    r = Mod[q, p];
    ss = signSumSemiprime[p, q];
    If[ss == 1,
      AppendTo[ss1residues, r],
      AppendTo[ssM3residues, r]
    ],
    {j, i + 1, Min[i + 30, 60]}
  ];

  Print["  SS=1 residues: ", Union[ss1residues]];
  Print["  SS=-3 residues: ", Union[ssM3residues]];

  (* Convert to discrete logs *)
  If[Length[Union[ss1residues]] > 0 && Length[Union[ssM3residues]] > 0,
    dlogs1 = Table[MultiplicativeOrder[g, p, r], {r, Union[ss1residues]}];
    dlogsM3 = Table[MultiplicativeOrder[g, p, r], {r, Union[ssM3residues]}];
    Print["  Discrete logs (SS=1): ", dlogs1];
    Print["  Discrete logs (SS=-3): ", dlogsM3];
  ],
  {i, 2, 7}
];

(* DIRECT FORMULA ATTEMPT *)
Print["\n\n=== TRYING DIRECT FORMULAS ===\n"];

(* Maybe SS(p*q) = f(q mod p) where f depends on p *)
(* Let's compute what f would need to be for each p *)

Do[
  p = Prime[i];
  Print["\np = ", p, ":"];
  fTable = Table[
    {r, signSumSemiprime[p, NextPrime[p*10 + r - Mod[p*10, p]]]},
    {r, Select[Range[1, p - 1], GCD[#, p] == 1 &]}
  ];
  Print["  f(r) for r coprime to p: ", fTable],
  {i, 2, 8}
];

(* Try: SS(p*q) depends on whether q mod p is in first half or second half *)
Print["\n\n=== HALF-RANGE HYPOTHESIS ===\n"];

correctCount = 0;
totalCount = 0;
Do[
  p = Prime[i];
  Do[
    q = Prime[j];
    r = Mod[q, p];
    ss = signSumSemiprime[p, q];

    (* Predict based on whether r <= (p-1)/2 *)
    predicted = If[r <= (p - 1)/2, 1, -3];
    If[predicted == ss, correctCount++];
    totalCount++,
    {j, i + 1, Min[i + 30, 60]}
  ],
  {i, 2, 15}
];
Print["Half-range hypothesis: ", correctCount, "/", totalCount, " = ", N[correctCount/totalCount]];

(* Try: SS based on some character *)
Print["\n\n=== CHARACTER SUM CONNECTION ===\n"];

(* For semiprime p*q, the valid m satisfy m ≢ 0,1 (mod p) and m ≢ 0,1 (mod q) *)
(* The odd/even count might relate to character sums *)

(* Let's verify the structure algebraically for small cases *)
Print["Verifying structure for p*q semiprimes:"];
Do[
  p = Prime[i]; q = Prime[j];
  k = p*q;
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  oddCount = Count[valid, _?OddQ];
  evenCount = Length[valid] - oddCount;
  ss = oddCount - evenCount;

  (* Decompose by CRT: m = a*q*ModularInverse[q,p] + b*p*ModularInverse[p,q] mod k *)
  (* where a ∈ {2,...,p-1}, b ∈ {2,...,q-1} *)

  (* Count directly by residue pairs *)
  ssComputed = Total[
    If[OddQ[ChineseRemainder[{a, b}, {p, q}]], 1, -1],
    {a, 2, p - 1}, {b, 2, q - 1}
  ];
  Print["p=", p, ", q=", q, ": SS=", ss, ", computed=", ssComputed, ", match=", ss == ssComputed],
  {i, 2, 5}, {j, i + 1, i + 3}
];
