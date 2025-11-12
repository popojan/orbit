comp1[m_, n_] := Join @@ Table[{k x  + x^2, k x + 1}, {k, 0, n}, {x,
    Max[1, Ceiling[1/2 (-k + Sqrt[k^2 + 4 m])]], 
    Floor[1/2 (-k + Sqrt[k^2 + 4 n])]}]
lpl[hi_] := 
 ListPlot[GatherBy[#, PrimeQ@*First], 
    PlotRange -> {Automatic, {-1/2, Automatic}}, 
    AxesOrigin -> {0, 0},(*Epilog->{Thin,Line/@MaximalLines[#]},*)
    AspectRatio -> 1, PlotMarkers -> {Automatic, Large}, 
    GridLines -> {Range@hi - 1/2, Range[0, hi] - 1/2}, 
    Epilog -> {Thick, ColorData[97, "ColorList"][[2]], 
      Line[{#, {First@#, 0}}] & /@ Select[#, PrimeQ@*First]}] &@
  comp1[1, hi]
lpl@31
