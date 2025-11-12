<< Ratio`

EgyptianHorcrux[q_Rational, extra_List, k_, m_] := 
 Select[ReverseSort@Join[extra, #] & /@ DeleteDuplicatesBy[Table[
     Module[{e = EgyptianFractions[q], idx},
      idx = RandomInteger[{1, m}, Length@e];
      (*{idx,*)
      ReverseSort[
       Join @@ (EgyptianFractions[Total@#[[All, 1]], 
            Method -> "ReverseMerge"] & /@ 
          GatherBy[Transpose[{e, idx}], Last])](*}*)], k
     ], Last], Length@DeleteDuplicates@# == Length@# &]

Total /@ EgyptianHorcrux[7/11, {}, 100, 2]
