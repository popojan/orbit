<< Orbit`

(* Generate BeattyBallotCount[2/3, {n,n}] for slope 3/2 *)
(* alpha = 2/3 means staircase Floor[x * 3/2] = Floor[3x/2] *)

nMax = 500;
Print["Computing BeattyBallotCount[2/3, {n,n}] for n=1..", nMax, " ..."];

a = Table[BeattyBallotCount[2/3, {n, n}], {n, 1, nMax}];
Print["Done. First 15 terms: ", a[[1 ;; 15]]];

(* Export as plain text, one number per line *)
outFile = FileNameJoin[{DirectoryName[$InputFileName], "seq_slope_3_2.txt"}];
Export[outFile, StringRiffle[ToString /@ a, "\n"], "Text"];
Print["Saved ", nMax, " terms to ", outFile];

(* Also do slope 2 (k=2) as control *)
b = Table[BeattyBallotCount[1/2, {n, n}], {n, 1, nMax}];
Print["Slope 2 first 15: ", b[[1 ;; 15]]];
outFile2 = FileNameJoin[{DirectoryName[$InputFileName], "seq_slope_2.txt"}];
Export[outFile2, StringRiffle[ToString /@ b, "\n"], "Text"];
Print["Saved slope 2 to ", outFile2];

(* Also slope 3 (k=3) *)
c = Table[BeattyBallotCount[1/3, {n, n}], {n, 1, nMax}];
Print["Slope 3 first 15: ", c[[1 ;; 15]]];
outFile3 = FileNameJoin[{DirectoryName[$InputFileName], "seq_slope_3.txt"}];
Export[outFile3, StringRiffle[ToString /@ c, "\n"], "Text"];
Print["Saved slope 3 to ", outFile3];
