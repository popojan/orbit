(* ::Package:: *)

(* Pyramid in Conway's Game of Life
   Archive: January 2022
   Status: Recreational curiosity, no claims

   A pyramid-shaped initial condition evolves interestingly:
   - Peak population at generation 242 = 11^2 + 11^2
   - Stabilizes after generation 468 = 12^2 + 18^2
   - Final state: period-2 oscillator (119 cells)

   Connection to Giza: 7/11 = 1/2 + 1/8 + 1/88, and 88 = 8 * 11
*)

(* Game of Life rule *)
gameOfLife = {224, {2, {{2, 2, 2}, {2, 1, 2}, {2, 2, 2}}}, {1, 1}};

(* Pyramid initial condition: 15 cells in triangular arrangement *)
pyramid[{n_, m_}] := Module[
  {W = Table[0, {n}, {m}], ox = Ceiling[m/2], oy = Ceiling[n/2]},
  For[x = 5; y = 0, x > 0,
    W[[oy - y, ox - x + 1 ;; ox + x - 1 ;; 2]] = 1;
    y += 2; x -= 1
  ];
  W
];

(* Evolution at time t *)
evolve[{n_, m_}, t_] := Last @ CellularAutomaton[gameOfLife, pyramid[{n, m}], t];

(* Population count at time t *)
population[{n_, m_}, t_] := Total[evolve[{n, m}, t], 2];

(* Generate population data *)
generateData[{n_, m_}, tMax_] := ParallelTable[population[{n, m}, t], {t, 0, tMax}];

(* Plot population evolution with annotations *)
plotPopulation[data_] := Module[
  {x = Range @ Length @ data,
   yTicks = {Min @ data, Last @ data, Max @ data},
   xTicks = Join[
     FirstPosition[data, Min @ data],
     FirstPosition[data, Max @ data],
     First /@ Position[data, 119][[1 ;; 2]]
   ]},
  ListLinePlot[Thread @ {x, data},
    Frame -> True,
    FrameTicks -> {
      {{{119, Subscript[77, 16]}, {373, \[CapitalWHacek]}}, yTicks},
      {xTicks, {
        {8, HoldForm[2^2 + 2^2] == 8 == Subscript[22, 3]},
        {242, HoldForm[11^2 + 11^2] == 242 == Subscript[22222, 3]},
        {468, HoldForm[12^2 + 18^2] == 468 == Subscript[3333, 5]}
      }}
    },
    GridLines -> {xTicks, yTicks},
    PlotRange -> {{-13, 555}, Automatic},
    ImageSize -> Large,
    FrameLabel -> {
      Row @ {{HoldForm[1/2 + 1/8 + 1/88 == 7/11], ", ",
              HoldForm[3731827 == 88^3 - 1]}},
      None
    }
  ]
];

(* === Numerical curiosities === *)

(* Egyptian fraction for pyramid ratio *)
egyptianFraction711 = 1/2 + 1/8 + 1/88 == 7/11;

(* Key generations are sums of squares *)
gen8 = 2^2 + 2^2;      (* start of growth *)
gen242 = 11^2 + 11^2;  (* peak population *)
gen468 = 12^2 + 18^2;  (* stabilization *)

(* The number 88 = 8 * 11 connects everything *)
identity88 = 88^3 - 1 == 373 * 1827;

(* === Example usage === *)
(*
data = generateData[{256, 256}, 555];
plotPopulation[data]
Export["gol.png", %]
*)
