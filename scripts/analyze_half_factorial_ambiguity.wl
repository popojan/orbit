#!/usr/bin/env wolframscript
(* Analyze the ± ambiguity in half-factorial *)

Print["Half-Factorial Sign Ambiguity\n"];
Print[StringRepeat["=", 70]];

Print["\nFor prime p, ((p-1)/2)! has two possible values mod p: ±r"];
Print["where r^2 = ±1 (mod p) depending on p mod 4\n"];

primes = Select[Range[3, 41, 2], PrimeQ];

Print["p | p mod 4 | ((p-1)/2)! mod p | Should square to | Actual square | Both roots"];
Print[StringRepeat["-", 85]];

data = Table[
  Module[{h, hFact, pMod4, shouldSq, actualSq, otherRoot, bothRoots},
    h = (p-1)/2;
    hFact = Mod[h!, p];
    pMod4 = Mod[p, 4];

    (* What should it square to? *)
    shouldSq = If[pMod4 == 3, 1, p-1];  (* 1 or -1 mod p *)
    actualSq = Mod[hFact^2, p];

    (* Find the other root *)
    otherRoot = Mod[-hFact, p];
    bothRoots = Sort[{hFact, otherRoot}];

    Print[StringPadRight[ToString[p], 2], " | ",
          StringPadRight[ToString[pMod4], 7], " | ",
          StringPadRight[ToString[hFact], 18], " | ",
          StringPadRight[ToString[shouldSq], 16], " | ",
          StringPadRight[ToString[actualSq], 13], " | ",
          bothRoots];

    {p, pMod4, hFact, bothRoots, shouldSq, actualSq}
  ],
  {p, primes}
];

Print["\n" <> StringRepeat["=", 70]];
Print["THE AMBIGUITY PROBLEM\n"];
Print[StringRepeat["=", 70], "\n"];

Print["For each prime p, there are TWO values r such that r^2 = ±1 (mod p)"];
Print["These are {r, -r} = {r, p-r} when viewed as residues.\n"];

Print["Computing ((p-1)/2)! directly gives ONE of these roots,"];
Print["but there's no easy way to know WHICH one without computing the factorial.\n"];

Print["This is why Wilson's theorem is computationally expensive:\n"];
Print["  1. Must compute (p-1)! or ((p-1)/2)!");
Print["  2. Both require O(p) multiplications");
Print["  3. The ± ambiguity means you can't shortcut it\n"];

Print["Now let's check if alt[p] mod p relates to this ambiguity:\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

Print["p | ((p-1)/2)! mod p | alt[p] mod p | Relationship"];
Print[StringRepeat["-", 60]];

Do[
  Module[{h, hFact, altModP, ratio},
    h = (p-1)/2;
    hFact = Mod[h!, p];
    altModP = Mod[alt[p], p];

    If[altModP == 0,
      ratio = "alt=0";
      ,
      ratio = If[hFact == altModP, "EQUAL",
              If[Mod[-hFact, p] == altModP, "NEGATIVE",
              If[Mod[hFact * altModP, p] == Mod[-1, p], "product=-1",
              "other"]]];
    ];

    Print[StringPadRight[ToString[p], 2], " | ",
          StringPadRight[ToString[hFact], 18], " | ",
          StringPadRight[ToString[altModP], 12], " | ",
          ratio];
  ],
  {p, Take[primes, 12]}
];

Print["\nDone! The ± ambiguity is fundamental to Wilson structure.");
Print["alt[p] might be encoding a way to resolve this ambiguity...");
