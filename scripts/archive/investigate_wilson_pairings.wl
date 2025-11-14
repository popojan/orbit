#!/usr/bin/env wolframscript
(* Investigate Wilson's theorem via pairing structure *)

Print["Wilson's Theorem: Pairing Structure Analysis\n"];
Print[StringRepeat["=", 70]];

Print["\nWilson's theorem: (p-1)! ≡ -1 (mod p) for prime p"];
Print["Standard proof: Elements of Z_p* pair with their inverses\n"];

(* Show the pairing for small primes *)
primes = {3, 5, 7, 11, 13};

Do[
  Module[{elements, pairings, selfInverse},
    elements = Range[1, p-1];

    Print["p = ", p, ":"];
    Print["  Elements of Z_", p, "*: ", elements];

    (* Find inverse pairings *)
    pairings = Table[
      {a, Mod[PowerMod[a, -1, p], p]},
      {a, elements}
    ];

    Print["  Inverse pairs (a, a^-1 mod p):"];
    Do[
      {a, inv} = pair;
      If[a <= inv,  (* Only print each pair once *)
        If[a == inv,
          Print["    ", a, " is self-inverse"],
          Print["    {", a, ", ", inv, "} → product ≡ 1 (mod ", p, ")"]
        ]
      ];
      ,
      {pair, pairings}
    ];

    selfInverse = Select[pairings, #[[1]] == #[[2]] &][[All, 1]];
    Print["  Self-inverse elements: ", selfInverse, " (these are ±1 mod p)"];
    Print["  Product of self-inverse: ", Times @@ selfInverse, " ≡ ",
          Mod[Times @@ selfInverse, p], " (mod ", p, ")"];
    Print["  Wilson check: (p-1)! = ", (p-1)!, " ≡ ", Mod[(p-1)!, p], " (mod ", p, ")\n"];
  ],
  {p, primes}
];

Print[StringRepeat["=", 70]];
Print["Connection to Half-Factorial\n"];
Print[StringRepeat["=", 70], "\n"];

Print["The pairing structure splits (p-1)! into two halves:\n"];

Do[
  Module[{h, firstHalf, secondHalf, firstProd, secondProd},
    h = (p-1)/2;

    Print["p = ", p, " (h = ", h, "):"];

    firstHalf = Range[1, h];
    secondHalf = Range[h+1, p-1];

    firstProd = Mod[h!, p];
    secondProd = Mod[Product[k, {k, h+1, p-1}], p];

    Print["  First half: 1·2·...·h = h! = ", firstHalf, " → ", firstProd, " (mod p)"];
    Print["  Second half: (h+1)·...·(p-1) = ", secondHalf, " → ", secondProd, " (mod p)"];

    (* The second half relates to the first via inversion *)
    Print["  Notice: (p-k) ≡ -k (mod p)"];
    Print["  So second half = (-1)^h · (p-h)·(p-(h-1))·...·(p-1)"];
    Print["                 = (-1)^h · h·(h-1)·...·1 = (-1)^h · h!"];

    expectedSecond = Mod[(-1)^h * firstProd, p];
    Print["  Expected second half: (-1)^", h, " · ", firstProd, " ≡ ", expectedSecond, " (mod p)"];
    Print["  Actual second half: ", secondProd, " (mod p)"];
    Print["  Match? ", secondProd == expectedSecond];

    (* Full product *)
    fullProd = Mod[firstProd * secondProd, p];
    Print["  Full product: ", firstProd, " · ", secondProd, " ≡ ", fullProd, " (mod p)"];
    Print["  This should equal (h!)^2 · (-1)^h ≡ -1 (mod p)");

    halfSq = Mod[firstProd^2, p];
    Print["  (h!)^2 ≡ ", halfSq, " (mod p)");

    Print["  So (p-1)! = (h!)^2 · (-1)^h ≡ ", Mod[halfSq * (-1)^h, p], " (mod p)\n"];
  ],
  {p, Take[primes, 5]}
];

Print[StringRepeat["=", 70]];
Print["KEY INSIGHT: Connection to alt[m]\n"];
Print[StringRepeat["=", 70], "\n"];

Print["alt[m] = Sum[(-1)^k · k!/(2k+1), {k, 1, (m-1)/2}]\n"];
Print["This sum runs to h = (m-1)/2, which is the halfway point in Wilson pairing!\n"];

Print["The alternating sign (-1)^k might be encoding the pairing structure:"];
Print["  - Pairs that cancel to +1"];
Print["  - The alternation captures the (-1)^h factor in the half-factorial relation\n");

Print["For prime p, the sum goes up to h = (p-1)/2 factorials,"];
Print["which contains exactly the 'first half' of the Wilson pairing structure.\n");

Print["This explains why ((p-1)/2)! has special properties mod p:");
Print["  - For p ≡ 3 (mod 4): h even, so (-1)^h = +1, giving (h!)^2 ≡ 1 (mod p)");
Print["  - For p ≡ 1 (mod 4): h odd, so (-1)^h = -1, giving (h!)^2 ≡ -1 (mod p)");
Print["  This is the sqrt(-1) mod p structure!\n"];

Print["Done! The pairing structure in Wilson connects directly to"];
Print["the half-factorial limit in alt[m] and the alternating signs!");
