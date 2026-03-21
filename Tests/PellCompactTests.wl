(* PellCompact module tests *)
(* Run with: wolframscript -file Tests/PellCompactTests.wl *)

AppendTo[$Path, FileNameJoin[{DirectoryName[$InputFileName], "..", "Orbit", "Kernel"}]];
Get["PellCompact.wl"];

Print["=== PellReconstruct tests ===\n"];

(* Known Pell solutions with their rounded regulators *)
tests = {
  {2, 2, 3, 2},
  {3, 1, 2, 1},
  {5, 3, 9, 4},
  {7, 3, 8, 3},
  {11, 3, 10, 3},
  {13, 7, 649, 180},
  {17, 4, 33, 8},
  {23, 4, 24, 5},
  {29, 10, 9801, 1820},
  {37, 5, 73, 12},
  {41, 8, 2049, 320},
  {43, 9, 3482, 531},
  {47, 5, 48, 7},
  {61, 22, 1766319049, 226153980},
  {83, 5, 82, 9},
  {109, 33, 158070671986249, 15140424455100},
  {193, 30, 6224323426849, 448036604040}
};

nOK = 0; nFail = 0;
Do[
  {d, rr, xRef, yRef} = t;
  {x, y} = PellReconstruct[d, rr];
  ok = (x == xRef && y == yRef);
  If[ok, nOK++,
    nFail++;
    Print["FAIL d=", d, " R=", rr, " got {", x, ",", y, "} expected {", xRef, ",", yRef, "}"]
  ];
  Print["d=", d, " R=", rr, " x=",
    If[IntegerLength[x] > 15, ToString[IntegerLength[x]] <> "dig", ToString[x]],
    " ", If[ok, "OK", "FAIL"]],
  {t, tests}
];

Print["\nResult: ", nOK, "/", nOK + nFail];

(* Larger validation against FindInstance *)
Print["\n=== Cross-validation with FindInstance (primes 2..200) ===\n"];
nOK2 = 0; nFail2 = 0;
Do[
  If[!PrimeQ[d], Continue[]];
  sol = FindInstance[x^2 - d y^2 == 1, {x, y}, PositiveIntegers];
  If[sol === {}, Continue[]];
  {xRef, yRef} = {x, y} /. First[sol];
  rr = PellCompactEncode[d];
  {xRec, yRec} = PellReconstruct[d, rr];
  If[xRec == xRef,
    nOK2++,
    nFail2++;
    If[nFail2 <= 5,
      Print["FAIL d=", d, " R=", rr, " got=", xRec, " ref=", xRef]]
  ],
  {d, 2, 200}
];
Print["Cross-validated: ", nOK2, "/", nOK2 + nFail2];
