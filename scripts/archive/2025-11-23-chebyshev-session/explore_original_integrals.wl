#!/usr/bin/env wolframscript

Print["EXPLORING ORIGINAL DEFINITIONS"];
Print[StringRepeat["=", 70]];
Print[];

Print["Ak[k] = Integrate[Sin[k*theta], {theta, 0, Pi}]"];
Print["Bk[k] = Integrate[Sin[k*theta]*Cos[theta], {theta, 0, Pi}]"];
Print["AB[k] = (Ak[k] - Bk[k])/2"];
Print[];

Print[StringRepeat["=", 70]];
Print["SYMBOLIC COMPUTATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Computing Ak[k] for k=1..10:"];
Print[];

akSymbolic = Table[
  Module[{integral},
    integral = Integrate[Sin[k*theta], {theta, 0, Pi}];
    {k, integral, Simplify[integral]}
  ],
  {k, 1, 10}
];

Print["k\tAk[k]\t\tSimplified"];
Print[StringRepeat["-", 70]];
Do[
  Print[akSymbolic[[i, 1]], "\t", akSymbolic[[i, 2]], "\t\t", akSymbolic[[i, 3]]];
, {i, 1, 10}];
Print[];

Print["Pattern observation:"];
Print["  Odd k:  Ak[k] = 2/k"];
Print["  Even k: Ak[k] = 0"];
Print[];

Print[StringRepeat["=", 70]];
Print["COMPUTING Bk[k]"];
Print[StringRepeat["=", 70]];
Print[];

Print["Computing Bk[k] for k=1..10:"];
Print[];

bkSymbolic = Table[
  Module[{integral},
    integral = Integrate[Sin[k*theta]*Cos[theta], {theta, 0, Pi}];
    {k, integral, Simplify[integral]}
  ],
  {k, 1, 10}
];

Print["k\tBk[k]\t\tSimplified"];
Print[StringRepeat["-", 70]];
Do[
  Print[bkSymbolic[[i, 1]], "\t", bkSymbolic[[i, 2]], "\t\t", bkSymbolic[[i, 3]]];
, {i, 1, 10}];
Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN IN Bk[k]"];
Print[StringRepeat["=", 70]];
Print[];

Print["Using product-to-sum formula:"];
Print["  Sin[k*theta]*Cos[theta] = (Sin[(k+1)*theta] + Sin[(k-1)*theta])/2"];
Print[];

Print["Therefore:"];
Print["  Bk[k] = (1/2)*[Integrate[Sin[(k+1)*theta], {theta,0,Pi}]"];
Print["                + Integrate[Sin[(k-1)*theta], {theta,0,Pi}]]"];
Print[];

Print["Using Ak pattern:"];
Print["  Bk[k] = (1/2)*[Ak[k+1] + Ak[k-1]]"];
Print[];

Print["Verification:"];
Do[
  akPlus1 = If[Mod[k + 1, 2] == 1, 2/(k + 1), 0];
  akMinus1 = If[k > 1, If[Mod[k - 1, 2] == 1, 2/(k - 1), 0], 0];
  predicted = (akPlus1 + akMinus1)/2;
  actual = bkSymbolic[[k, 3]];
  Print["  k=", k, ": Bk[k] = ", actual, ", predicted = ", predicted,
        ", match? ", Simplify[actual - predicted] == 0];
, {k, 1, 10}];
Print[];

Print[StringRepeat["=", 70]];
Print["COMPUTING AB[k] = (Ak[k] - Bk[k])/2"];
Print[StringRepeat["=", 70]];
Print[];

abValues = Table[
  Module[{ak, bk, ab},
    ak = akSymbolic[[k, 3]];
    bk = bkSymbolic[[k, 3]];
    ab = Simplify[(ak - bk)/2];
    {k, ak, bk, ab}
  ],
  {k, 1, 15}
];

Print["k\tAk[k]\t\tBk[k]\t\tAB[k] = (Ak-Bk)/2"];
Print[StringRepeat["-", 80]];
Do[
  Print[abValues[[i, 1]], "\t", abValues[[i, 2]], "\t\t", abValues[[i, 3]], "\t\t", abValues[[i, 4]]];
, {i, 1, 15}];
Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN ANALYSIS"];
Print[StringRepeat["=", 70]];
Print[];

Print["AB[k] values:"];
Do[
  Print["  AB[", abValues[[i, 1]], "] = ", abValues[[i, 4]]];
, {i, 1, 10}];
Print[];

Print["Looking for pattern..."];
Print[];

Print["Odd k:"];
oddVals = Table[abValues[[2*i - 1, 4]], {i, 1, 7}];
Print["  AB[1,3,5,7,9,11,13] = ", oddVals];
Print[];

Print["Even k:"];
evenVals = Table[abValues[[2*i, 4]], {i, 1, 7}];
Print["  AB[2,4,6,8,10,12,14] = ", evenVals];
Print[];

Print[StringRepeat["=", 70]];
Print["CLOSED FORM"];
Print[StringRepeat["=", 70]];
Print[];

Print["For odd k = 2m+1:"];
Print["  Ak[2m+1] = 2/(2m+1)"];
Print["  Bk[2m+1] = (1/2)[Ak[2m+2] + Ak[2m]] = (1/2)[0 + 2/(2m)] = 1/(2m)"];
Print["  AB[2m+1] = [2/(2m+1) - 1/(2m)]/2"];
Print[];

Do[
  m = (k - 1)/2;
  predicted = (2/(2*m + 1) - 1/(2*m))/2;
  actual = abValues[[k, 4]];
  Print["  k=", k, " (m=", m, "): AB = ", actual, ", predicted = ",
        Simplify[predicted], ", match? ", Simplify[actual - predicted] == 0];
, {k, 1, 13, 2}];
Print[];

Print["For even k = 2m:"];
Print["  Ak[2m] = 0"];
Print["  Bk[2m] = (1/2)[Ak[2m+1] + Ak[2m-1]] = (1/2)[2/(2m+1) + 2/(2m-1)]"];
Print["  AB[2m] = [0 - (1/(2m+1) + 1/(2m-1))]/2 = -(1/(2m+1) + 1/(2m-1))/2"];
Print[];

Do[
  m = k/2;
  predicted = -(1/(2*m + 1) + 1/(2*m - 1))/2;
  actual = abValues[[k, 4]];
  Print["  k=", k, " (m=", m, "): AB = ", actual, ", predicted = ",
        Simplify[predicted], ", match? ", Simplify[actual - predicted] == 0];
, {k, 2, 14, 2}];
Print[];

Print[StringRepeat["=", 70]];
Print["ASYMPTOTIC BEHAVIOR"];
Print[StringRepeat["=", 70]];
Print[];

Print["For large k:"];
Print[];
Print["Odd k = 2m+1:"];
Print["  AB[2m+1] ~ [2/(2m+1) - 1/(2m)]/2"];
Print["           ~ [2/(2m) - 1/(2m)]/2  (for large m)"];
Print["           ~ 1/(4m)"];
Print["           ~ 1/(2k)"];
Print[];

Print["Even k = 2m:"];
Print["  AB[2m] ~ -(1/(2m) + 1/(2m))/2"];
Print["         ~ -1/(2m)"];
Print["         ~ -1/k"];
Print[];

Print["Numerical check for large k:"];
Do[
  abVal = abValues[[k, 4]];
  approx = If[Mod[k, 2] == 1, 1/(2*k), -1/k];
  Print["  k=", k, ": AB[k] = ", N[abVal, 10], ", ~1/k approx = ", N[approx, 10],
        ", ratio = ", N[abVal/approx, 5]];
, {k, 11, 15}];
Print[];

Print["DONE!"];
