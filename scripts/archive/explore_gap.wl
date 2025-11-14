#!/usr/bin/env wolframscript
(* ::Package:: *)

(*
  Single Gap Exploration
  Deep dive into a specific prime's gap structure with visualizations
*)

(* Load the local Orbit paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

(* Configuration - explore this prime's gap *)
targetPrime = 113;
reportFile = "reports/gap_" <> ToString[targetPrime] <> ".md";
plotFile = "reports/gap_" <> ToString[targetPrime] <> "_plot.png";

(* Analyze the gap *)
Print["Analyzing gap after prime ", targetPrime, "..."];
gap = NextPrime[targetPrime] - targetPrime;
gapAnalysis = AnalyzeGapOrbits[targetPrime];
posetStats = PosetStatistics[targetPrime];
jumpAnalysis = AnalyzeJumps[targetPrime];

(* Generate visualization *)
Print["Creating visualization..."];
plot = PlotOrbitLengths[targetPrime];
Export[plotFile, plot, "PNG", ImageSize -> 800];

(* Generate detailed report *)
report = StringJoin[
  "# Gap Analysis: Prime ", ToString[targetPrime], "\n\n",
  "**Date:** ", DateString[], "\n",
  "**Gap size:** ", ToString[gap], "\n\n",
  "## Orbit Length Distribution\n\n",
  "![Orbit Lengths](", FileNameTake[plotFile], ")\n\n",
  "### Statistics\n\n",
  "- Gap: ", ToString[gapAnalysis["Gap"]], "\n",
  "- Orbit length range: ", ToString[gapAnalysis["Min length"]], " to ", ToString[gapAnalysis["Max length"]], "\n",
  "- Mean length: ", ToString[NumberForm[gapAnalysis["Mean length"], {10, 2}]], "\n",
  "- Standard deviation: ", ToString[NumberForm[gapAnalysis["Std dev"], {10, 2}]], "\n",
  "- Unique lengths: ", ToString[gapAnalysis["Unique lengths"]], "\n",
  "- Number of steps: ", ToString[gapAnalysis["Step count"]], "\n\n",
  "### Length Distribution\n\n",
  StringRiffle[
    Table[
      "- Length " <> ToString[pair[[1]]] <> ": " <> ToString[pair[[2]]] <> " occurrences",
      {pair, gapAnalysis["Distribution"]}
    ],
    "\n"
  ],
  "\n\n## Partial Order Statistics\n\n",
  "- Total pairs: ", ToString[posetStats["Total pairs"]], "\n",
  "- Incomparable pairs: ", ToString[posetStats["Incomparable"]], "\n",
  "- Incomparable percentage: ", ToString[NumberForm[posetStats["Incomparable %"], {10, 2}]], "%\n\n",
  "## Jump Analysis\n\n",
  If[Length[jumpAnalysis] > 0,
    "Found " <> ToString[Length[jumpAnalysis]] <> " jump points:\n\n" <>
    ExportString[Normal[jumpAnalysis], "Table"],
    "No jumps detected (constant orbit length).\n"
  ]
];

(* Export report *)
Export[reportFile, report, "Text"];
Print["Report exported to: ", reportFile];
Print["Visualization exported to: ", plotFile];
