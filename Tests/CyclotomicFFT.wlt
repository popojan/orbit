BeginTestSection["CyclotomicFFT"]

(* ============================================ *)
(* CONSTRUCTOR & REDUCTION                      *)
(* ============================================ *)

(* n=4: φ(4)=2, basis {1, ζ₄}, ζ₄=i *)
(* {1,0,0,0} → just the constant 1 → {1,0} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicElement[4, {1, 0, 0, 0}]],
  {1, 0},
  TestID -> "Constructor-reduction-n4-constant"
]

(* >n coefficients wrap via ζⁿ=1 and reduce mod Φₙ *)
(* {1,2,3,4,5}: poly = 1+2z+3z²+4z³+5z⁴ *)
(* z⁴=1 → 1+2z+3z²+4z³+5 = 6+2z+3z²+4z³ *)
(* Φ₄(z) = z²+1, so z²=-1: 6+2z+3(-1)+4(-z) = 3-2z *)
(* → coeffs {3, -2} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicElement[4, {1, 2, 3, 4, 5}]],
  {3, -2},
  TestID -> "Constructor-reduction-overflow"
]

(* n=6: φ(6)=2, Φ₆(z)=z²-z+1, so z²=z-1 *)
(* {0,0,1,0,0,0} = z² → z-1 → coeffs {-1, 1} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicElement[6, {0, 0, 1, 0, 0, 0}]],
  {-1, 1},
  TestID -> "Constructor-reduction-n6-zeta-squared"
]

(* n=1: φ(1)=1, trivial *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicElement[1, {7}]],
  {7},
  TestID -> "Constructor-n1-edge"
]

(* n=2: φ(2)=1, ζ₂=-1, so {3,5} = 3+5·(-1) = -2 → {-2} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicElement[2, {3, 5}]],
  {-2},
  TestID -> "Constructor-n2-edge"
]

(* n=3: φ(3)=2, Φ₃(z)=z²+z+1 *)
(* {1,1,1} = 1+z+z² = 0 mod Φ₃ → {0,0} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicElement[3, {1, 1, 1}]],
  {0, 0},
  TestID -> "Constructor-n3-sum-roots-zero"
]

(* Already-reduced input stays unchanged *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicElement[4, {3, -2}]],
  {3, -2},
  TestID -> "Constructor-already-reduced"
]

(* ============================================ *)
(* ARITHMETIC — SAME ORDER                     *)
(* ============================================ *)

(* (1+ζ₄) + (2-ζ₄) = 3 → coeffs {3, 0} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicAdd[
    CyclotomicElement[4, {1, 1}],
    CyclotomicElement[4, {2, -1}]
  ]],
  {3, 0},
  TestID -> "Add-same-order"
]

(* (1+ζ₄)·(1-ζ₄) = 1-ζ₄² = 1-(-1) = 2 → coeffs {2, 0} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicMultiply[
    CyclotomicElement[4, {1, 1}],
    CyclotomicElement[4, {1, -1}]
  ]],
  {2, 0},
  TestID -> "Multiply-same-order-1+i-times-1-i"
]

(* Negation *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicNegate[CyclotomicElement[4, {3, -2}]]],
  {-3, 2},
  TestID -> "Negate"
]

(* Scaling *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicScale[CyclotomicElement[4, {3, -2}], 1/2]],
  {3/2, -1},
  TestID -> "Scale-rational"
]

(* Subtraction *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicSubtract[
    CyclotomicElement[4, {5, 3}],
    CyclotomicElement[4, {2, 1}]
  ]],
  {3, 2},
  TestID -> "Subtract"
]

(* ============================================ *)
(* ARITHMETIC — CROSS-ORDER (PROMOTION)        *)
(* ============================================ *)

(* Order 3 + Order 4 → promoted to LCM=12 *)
(* Verify result is correct by comparing complex values *)
(* FullSimplify confirms equality but yields different normal forms, so use SameTest *)
VerificationTest[
  CyclotomicToComplex[CyclotomicAdd[
    CyclotomicElement[3, {1, 1}],   (* 1 + ζ₃ *)
    CyclotomicElement[4, {1, 1}]    (* 1 + ζ₄ = 1 + i *)
  ]],
  (1 + Exp[2 Pi I / 3]) + (1 + I),
  SameTest -> (FullSimplify[#1 - #2] === 0 &),
  TestID -> "Add-cross-order-complex-value"
]

(* Verify promoted order is LCM *)
VerificationTest[
  CyclotomicOrder[CyclotomicAdd[
    CyclotomicElement[3, {1, 0}],
    CyclotomicElement[4, {0, 1}]
  ]],
  12,
  TestID -> "Add-cross-order-promoted-to-LCM"
]

(* Cross-order multiply *)
VerificationTest[
  CyclotomicToComplex[CyclotomicMultiply[
    CyclotomicElement[3, {0, 1}],   (* ζ₃ *)
    CyclotomicElement[4, {0, 1}]    (* ζ₄ = i *)
  ]] // FullSimplify,
  Exp[2 Pi I / 3] * I // FullSimplify,
  TestID -> "Multiply-cross-order-complex-value"
]

(* ============================================ *)
(* CONVERSION: CyclotomicToComplex             *)
(* ============================================ *)

(* {3,-2} in order 4: 3 - 2i *)
VerificationTest[
  CyclotomicToComplex[CyclotomicElement[4, {3, -2}]],
  3 - 2 I,
  TestID -> "ToComplex-order4"
]

(* Order 3: {1,1} = 1 + ζ₃ = 1 + e^(2πi/3) *)
VerificationTest[
  CyclotomicToComplex[CyclotomicElement[3, {1, 1}]] // FullSimplify,
  1 + Exp[2 Pi I / 3] // FullSimplify,
  TestID -> "ToComplex-order3"
]

(* Order 1: just a rational *)
VerificationTest[
  CyclotomicToComplex[CyclotomicElement[1, {42}]],
  42,
  TestID -> "ToComplex-rational"
]

(* ============================================ *)
(* CONVERSION: CyclotomicFromComplex roundtrip *)
(* ============================================ *)

VerificationTest[
  CyclotomicToComplex[CyclotomicFromComplex[3 + 4 I, 4]],
  3 + 4 I,
  TestID -> "FromComplex-roundtrip-order4"
]

VerificationTest[
  CyclotomicToComplex[CyclotomicFromComplex[-1 - 7 I, 8]],
  -1 - 7 I,
  TestID -> "FromComplex-roundtrip-order8"
]

(* ============================================ *)
(* CONVERSION: CyclotomicFromReal              *)
(* ============================================ *)

VerificationTest[
  CyclotomicCoeffs[CyclotomicFromReal[5, 8]],
  {5, 0, 0, 0},
  TestID -> "FromReal-order8"
]

VerificationTest[
  CyclotomicToComplex[CyclotomicFromReal[7/3, 4]],
  7/3,
  TestID -> "FromReal-rational-roundtrip"
]

(* ============================================ *)
(* REAL/IMAG EXTRACTION                        *)
(* ============================================ *)

(* Order 4: 3+4i → Re=3, Im=4 *)
VerificationTest[
  CyclotomicRealPart[CyclotomicElement[4, {3, 4}]],
  3,
  TestID -> "RealPart-order4"
]

VerificationTest[
  CyclotomicImagPart[CyclotomicElement[4, {3, 4}]],
  4,
  TestID -> "ImagPart-order4"
]

(* Order 8: test general n case (was buggy) *)
VerificationTest[
  CyclotomicRealPart[CyclotomicFromComplex[3 + 4 I, 8]],
  3,
  TestID -> "RealPart-order8"
]

VerificationTest[
  CyclotomicImagPart[CyclotomicFromComplex[3 + 4 I, 8]],
  4,
  TestID -> "ImagPart-order8"
]

(* Pure real element *)
VerificationTest[
  CyclotomicImagPart[CyclotomicFromReal[5, 4]],
  0,
  TestID -> "ImagPart-pure-real"
]

(* ============================================ *)
(* TWIDDLE FACTORS vs Wolfram built-in         *)
(* ============================================ *)

(* ω^k = e^(-2πik/n): compare against Exp *)
VerificationTest[
  CyclotomicToComplex[CyclotomicTwiddle[4, 1]] // FullSimplify,
  Exp[-2 Pi I / 4] // FullSimplify,
  TestID -> "Twiddle-n4-k1-vs-Exp"
]

VerificationTest[
  CyclotomicToComplex[CyclotomicTwiddle[8, 3]] // FullSimplify,
  Exp[-2 Pi I * 3 / 8] // FullSimplify,
  TestID -> "Twiddle-n8-k3-vs-Exp"
]

(* Twiddle k=0 is always 1 *)
VerificationTest[
  CyclotomicToComplex[CyclotomicTwiddle[6, 0]],
  1,
  TestID -> "Twiddle-k0-is-unity"
]

(* Twiddle k=n is also 1 (periodicity) *)
VerificationTest[
  CyclotomicToComplex[CyclotomicTwiddle[5, 5]] // FullSimplify,
  1,
  TestID -> "Twiddle-kn-periodicity"
]

(* ============================================ *)
(* DFT: KNOWN TRANSFORMS                       *)
(* ============================================ *)

(* Delta → constant: all coeffs are {1, 0} in Q(ζ₄) *)
VerificationTest[
  CyclotomicCoeffs /@ CyclotomicDFT[{1, 0, 0, 0}],
  {{1, 0}, {1, 0}, {1, 0}, {1, 0}},
  TestID -> "DFT-delta-to-constant"
]

(* Constant → scaled delta *)
VerificationTest[
  CyclotomicCoeffs /@ CyclotomicDFT[{1, 1, 1, 1}],
  {{4, 0}, {0, 0}, {0, 0}, {0, 0}},
  TestID -> "DFT-constant-to-DC"
]

(* Alternating → shifted delta *)
VerificationTest[
  CyclotomicCoeffs /@ CyclotomicDFT[{1, -1, 1, -1}],
  {{0, 0}, {0, 0}, {4, 0}, {0, 0}},
  TestID -> "DFT-alternating"
]

(* DFT output is uniform CyclotomicElement: CyclotomicCoeffs /@ always produces matrix *)
VerificationTest[
  Module[{result = CyclotomicDFT[{11, 3, 7, 5, 12}]},
    MatrixQ[CyclotomicCoeffs /@ result]
  ],
  True,
  TestID -> "DFT-uniform-CyclotomicElement-output"
]

(* Same invariant for IDFT *)
VerificationTest[
  Module[{freq = CyclotomicDFT[{1, 2, 3, 4}]},
    MatrixQ[CyclotomicCoeffs /@ CyclotomicInverseDFT[freq]]
  ],
  True,
  TestID -> "IDFT-uniform-CyclotomicElement-output"
]

(* ============================================ *)
(* DFT vs Wolfram Fourier built-in             *)
(* ============================================ *)

(* Compare CyclotomicDFT against Fourier with FourierParameters->{1,-1} *)
(* CyclotomicDFT always returns CyclotomicElement list; convert to complex for comparison *)

VerificationTest[
  Module[{signal = {1, 2, 3, 4}, ours, theirs},
    ours = N[CyclotomicToComplex /@ CyclotomicDFT[signal]];
    theirs = Fourier[N[signal], FourierParameters -> {1, -1}];
    Max[Abs[ours - theirs]] < 10^-10
  ],
  True,
  TestID -> "DFT-vs-Fourier-n4"
]

VerificationTest[
  Module[{signal = {1, 0, -1, 0, 2}, ours, theirs},
    ours = N[CyclotomicToComplex /@ CyclotomicDFT[signal]];
    theirs = Fourier[N[signal], FourierParameters -> {1, -1}];
    Max[Abs[ours - theirs]] < 10^-10
  ],
  True,
  TestID -> "DFT-vs-Fourier-n5"
]

VerificationTest[
  Module[{signal = {3, 1, 4, 1, 5, 9}, ours, theirs},
    ours = N[CyclotomicToComplex /@ CyclotomicDFT[signal]];
    theirs = Fourier[N[signal], FourierParameters -> {1, -1}];
    Max[Abs[ours - theirs]] < 10^-10
  ],
  True,
  TestID -> "DFT-vs-Fourier-n6"
]

VerificationTest[
  Module[{signal = {2, 7, 1, 8, 2, 8, 1}, ours, theirs},
    ours = N[CyclotomicToComplex /@ CyclotomicDFT[signal]];
    theirs = Fourier[N[signal], FourierParameters -> {1, -1}];
    Max[Abs[ours - theirs]] < 10^-10
  ],
  True,
  TestID -> "DFT-vs-Fourier-n7"
]

VerificationTest[
  Module[{signal = {1, 0, 0, 1, 0, 0, 1, 0}, ours, theirs},
    ours = N[CyclotomicToComplex /@ CyclotomicDFT[signal]];
    theirs = Fourier[N[signal], FourierParameters -> {1, -1}];
    Max[Abs[ours - theirs]] < 10^-10
  ],
  True,
  TestID -> "DFT-vs-Fourier-n8"
]

(* ============================================ *)
(* INVERSE DFT ROUNDTRIP                       *)
(* ============================================ *)

(* IDFT returns CyclotomicElement list; extract rationals for comparison *)
VerificationTest[
  CyclotomicToRational /@ CyclotomicInverseDFT[CyclotomicDFT[{1, 2, 3, 4}]],
  {1, 2, 3, 4},
  TestID -> "IDFT-roundtrip-n4"
]

VerificationTest[
  CyclotomicToRational /@ CyclotomicInverseDFT[CyclotomicDFT[{1, 0, -1, 0, 2}]],
  {1, 0, -1, 0, 2},
  TestID -> "IDFT-roundtrip-n5"
]

VerificationTest[
  CyclotomicToRational /@ CyclotomicInverseDFT[CyclotomicDFT[{3, 1, 4, 1, 5, 9}]],
  {3, 1, 4, 1, 5, 9},
  TestID -> "IDFT-roundtrip-n6"
]

VerificationTest[
  CyclotomicToRational /@ CyclotomicInverseDFT[CyclotomicDFT[{2, 7, 1, 8, 2, 8, 1}]],
  {2, 7, 1, 8, 2, 8, 1},
  TestID -> "IDFT-roundtrip-n7"
]

VerificationTest[
  CyclotomicToRational /@ CyclotomicInverseDFT[CyclotomicDFT[{1, 0, 0, 1, 0, 0, 1, 0}]],
  {1, 0, 0, 1, 0, 0, 1, 0},
  TestID -> "IDFT-roundtrip-n8"
]

(* ============================================ *)
(* CONVOLUTION via DFT vs ListConvolve         *)
(* ============================================ *)

(* Circular convolution: Ψ[Φ[a] ⊗ Φ[b]] should equal circular ListConvolve *)
VerificationTest[
  Module[{a = {1, 2, 3, 4}, b = {1, 0, -1, 0}},
    CyclotomicToRational /@ CyclotomicInverseDFT[CircleTimes[CyclotomicDFT[a], CyclotomicDFT[b]]]
  ],
  ListConvolve[{1, 2, 3, 4}, {1, 0, -1, 0}, 1],
  TestID -> "Convolution-vs-ListConvolve-n4"
]

(* DFT of delta signals: CircleTimes on uniform CyclotomicElement outputs *)
VerificationTest[
  Module[{a = {1, 0, 0, 0}, b = {0, 1, 0, 0}},
    CyclotomicToRational /@ CyclotomicInverseDFT[CircleTimes[CyclotomicDFT[a], CyclotomicDFT[b]]]
  ],
  ListConvolve[{1, 0, 0, 0}, {0, 1, 0, 0}, 1],
  TestID -> "Convolution-delta-signals"
]

(* ============================================ *)
(* BUTTERFLY OPERATION                         *)
(* ============================================ *)

(* Butterfly: {e + tw·o, e - tw·o} *)
VerificationTest[
  Module[{e, o, tw, result},
    e = CyclotomicFromReal[1, 4];
    o = CyclotomicFromReal[1, 4];
    tw = CyclotomicTwiddle[4, 0];  (* tw = 1 *)
    result = CyclotomicButterfly[e, o, tw];
    {CyclotomicToComplex[First[result]], CyclotomicToComplex[Last[result]]}
  ],
  {2, 0},
  TestID -> "Butterfly-trivial-twiddle1"
]

VerificationTest[
  Module[{e, o, tw, result},
    e = CyclotomicFromReal[1, 4];
    o = CyclotomicFromReal[1, 4];
    tw = CyclotomicTwiddle[4, 1];  (* tw = -i *)
    result = CyclotomicButterfly[e, o, tw];
    {CyclotomicToComplex[First[result]], CyclotomicToComplex[Last[result]]}
  ],
  {1 - I, 1 + I},
  TestID -> "Butterfly-twiddle-minus-i"
]

(* ============================================ *)
(* CyclotomicToRational                        *)
(* ============================================ *)

VerificationTest[
  CyclotomicToRational[CyclotomicFromReal[7/3, 4]],
  7/3,
  TestID -> "ToRational-pure-rational"
]

VerificationTest[
  CyclotomicToRational[CyclotomicElement[4, {0, 1}]],
  I,
  TestID -> "ToRational-complex-returns-complex"
]

(* ============================================ *)
(* INVERSE & DIVISION                          *)
(* ============================================ *)

(* e * e^{-1} = 1 in Q(ζ₄) *)
VerificationTest[
  Module[{e = CyclotomicElement[4, {3, -2}]},
    CyclotomicCoeffs[CyclotomicMultiply[e, CyclotomicInverse[e]]]
  ],
  {1, 0},
  TestID -> "Inverse-n4-mul-identity"
]

(* Inverse of ζ₄ = i is -i = -ζ₄ → coeffs {0, -1} *)
VerificationTest[
  CyclotomicCoeffs[CyclotomicInverse[CyclotomicElement[4, {0, 1}]]],
  {0, -1},
  TestID -> "Inverse-n4-i-known"
]

(* (1+ζ₃) * (1+ζ₃)^{-1} = 1 in Q(ζ₃) *)
VerificationTest[
  Module[{e = CyclotomicElement[3, {1, 1}]},
    CyclotomicCoeffs[CyclotomicMultiply[e, CyclotomicInverse[e]]]
  ],
  {1, 0},
  TestID -> "Inverse-n3-identity"
]

(* a / a = 1 *)
VerificationTest[
  Module[{a = CyclotomicElement[4, {3, -2}]},
    CyclotomicCoeffs[CyclotomicDivide[a, a]]
  ],
  {1, 0},
  TestID -> "Divide-self-is-one"
]

(* Deconvolution roundtrip: IDFT(DFT(a·b) / DFT(b)) = a *)
(* b = {1,2,3,4} has no zeros in DFT: {10, -2+2i, -2, -2-2i} *)
VerificationTest[
  Module[{a = {5, 6, 7, 8}, b = {1, 2, 3, 4}, fa, fb, product, divided},
    fa = CyclotomicDFT[a];
    fb = CyclotomicDFT[b];
    product = MapThread[CyclotomicMultiply, {fa, fb}];
    divided = MapThread[CyclotomicDivide, {product, fb}];
    CyclotomicToRational /@ CyclotomicInverseDFT[divided]
  ],
  {5, 6, 7, 8},
  TestID -> "Divide-deconvolution-roundtrip"
]

(* Inverse of zero element fails *)
VerificationTest[
  CyclotomicInverse[CyclotomicElement[4, {0, 0}]],
  $Failed,
  {CyclotomicInverse::zero},
  TestID -> "Inverse-zero-fails"
]

EndTestSection[]
