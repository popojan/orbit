(* CONCRETE bijection attempt for k=2 *)

Print["=== CONCRETE ENUMERATION: k=2 ===\n"];

(* Our coefficients: {3, 2} *)
Print["Target: {3, 2}"];
Print["  i=1: 3 paths"];
Print["  i=2: 2 paths\n"];

(* === LOBB(2,1) = 3 === *)
Print["=== LOBB(2,1) = 3 ===\n"];

Print["Formula: T(2,1) = (2*1+1) * C(4, 2-1) / (2+1+1) = 3 * 4 / 4 = 3"];
Print["Meaning: 3 lattice paths from (0,0) to (2,2) touching line x-y=1\n"];

Print["Explicit enumeration (steps: U=up, R=right):"];
Print["Path must reach points on line x-y=1 (i.e., x=y+1)\n"];

Print["Path 1: UURR"];
Print["  (0,0) -> U -> (0,1) -> U -> (0,2) -> R -> (1,2) [x-y=-1]"];
Print["  -> R -> (2,2) [x-y=0]"];
Print["  Never touches x-y=1? Let me recalculate...\n"];

Print["Wait - lattice (0,0) to (2,2) means:"];
Print["  2 steps in x-direction (East)"];
Print["  2 steps in y-direction (North)"];
Print["  Total: 4 steps, choose 2 for East = C(4,2) = 6 total paths\n"];

Print["Constraint: touch line x-y=1"];
Print["Line x-y=1 means: x = y+1 (one step right of diagonal)\n"];

Print["All 6 unrestricted paths:"];
paths = {{0,0}, {1,0}, {2,0}, {2,1}, {2,2}};  (* EENN *)
Print["1. EENN: (0,0)->(1,0)->(2,0)->(2,1)->(2,2)"];
Print["   x-y: 0, 1, 2, 1, 0 [MAX=2, touches x=y+2 not x=y+1]"];

Print["2. ENEN: (0,0)->(1,0)->(1,1)->(2,1)->(2,2)"];
Print["   x-y: 0, 1, 0, 1, 0 [MAX=1, touches x=y+1] ✓"];

Print["3. ENNE: (0,0)->(1,0)->(1,1)->(1,2)->(2,2)"];
Print["   x-y: 0, 1, 0, -1, 0 [goes below, then back]"];

Print["4. NEEN: (0,0)->(0,1)->(1,1)->(2,1)->(2,2)"];
Print["   x-y: 0, -1, 0, 1, 0 [MAX=1, touches x=y+1] ✓"];

Print["5. NENE: (0,0)->(0,1)->(1,1)->(1,2)->(2,2)"];
Print["   x-y: 0, -1, 0, -1, 0 [never positive]"];

Print["6. NNEE: (0,0)->(0,1)->(0,2)->(1,2)->(2,2)"];
Print["   x-y: 0, -1, -2, -1, 0 [never positive]\n"];

Print["Paths touching x-y=1 (staying at or above?): #2, #4"];
Print["That's only 2 paths, not 3! Lobb formula gives 3...\n"];

Print["ERROR in my interpretation - let me check Lobb definition again"];
Print["Lobb: 'touch but do not cross line x-y=k'"];
Print["For Grand Dyck: starts/ends at (0,0) to (2n,0), not (0,0) to (n,n)!\n"];

(* === CORRECT: GRAND DYCK PATHS === *)
Print["=== GRAND DYCK PATHS (CORRECT) ===\n"];

Print["Grand Dyck path of semilength n:"];
Print["  Start: (0,0)"];
Print["  End: (2n,0)"];  
Print["  Steps: u=(1,1) [up-right], d=(1,-1) [down-right]"];
Print["  Constraint: never go below x-axis (y≥0)\n"];

Print["For semilength 2:"];
Print["  (0,0) to (4,0) with 4 steps"];
Print["  2 up steps, 2 down steps\n"];

Print["Lobb(2,1): Grand Dyck paths with k=1 downward returns"];
Print["  'Return' = path touches y=0 after leaving it\n"];

Print["All Grand Dyck paths n=2:"];
Print["1. uudd: (0,0)->(1,1)->(2,2)->(3,1)->(4,0)"];
Print["   Returns: at (4,0) [END] - 0 interior returns"];

Print["2. udud: (0,0)->(1,1)->(2,0)->(3,1)->(4,0)"];
Print["   Returns: at (2,0) [INTERIOR], at (4,0) [END] - 1 interior return ✓"];

Print["3. uddu: (0,0)->(1,1)->(2,0)->(3,-1) [INVALID - below axis]"];

Print["4. duud: (0,0)->(1,-1) [INVALID]"];

Print["5. dduu: (0,0)->(1,-1) [INVALID]\n"];

Print["Wait, only 2 valid Dyck paths total for n=2:"];
Print["  Catalan_2 = 2 ✓ (confirmed)\n"];

Print["With k=1 (one interior return): only path #2 = udud"];
Print["That's 1 path, not 3!\n"];

Print["Let me recalculate Lobb(2,1) manually:"];
lobbManual = (2*1 + 1) * Binomial[2*2, 2 - 1] / (2 + 1 + 1);
Print["T(2,1) = 3 * C(4,1) / 4 = 3 * 4 / 4 = 3"];
Print["Formula gives 3, but enumeration gives 1?\n"];

Print["ISSUE: My enumeration is wrong or Lobb definition is different"];
Print["Need to check: what EXACTLY does T(n,k) count?\n"];

(* === ALTERNATIVE: BINOMIAL C(3i,2i) === *)
Print["=== ALTERNATIVE: C(3i,2i) for k=2 ===\n"];

Print["From archived work: coefficient 2^(i-1) * C(3i, 2i)"];
Print["For k=2:"];
Do[
  coeff = 2^(i-1) * Binomial[3*i, 2*i];
  Print["  i=", i, ": 2^", i-1, " * C(", 3*i, ",", 2*i, ") = ", coeff],
  {i, 1, 2}
];

Print["\ni=1: 1 * C(3,2) = 1 * 3 = 3 ✓ MATCH!"];
Print["i=2: 2 * C(6,4) = 2 * 15 = 30 ✗ Doesn't match {3,2}\n"];

Print["So C(3i,2i) pattern doesn't hold for general k"];
Print["Only for specific 'simple symmetric' cases from Wildberger?\n"];

(* === OUR ACTUAL FORMULA === *)
Print["=== BACK TO OUR FORMULA ===\n"];

Print["Our: 2^(i-1) * Poch[k-i+1, 2i] / (2i)!"];
Print["For k=2:"];
Do[
  poch = Pochhammer[2-i+1, 2*i];
  fact = Factorial[2*i];
  coeff = 2^(i-1) * poch / fact;
  Print["  i=", i, ": 2^", i-1, " * Poch[", 2-i+1, ",", 2*i, "] / ", fact];
  Print["       = ", 2^(i-1), " * ", poch, " / ", fact, " = ", coeff],
  {i, 1, 2}
];

Print["\nPoch[2, 2] = 2*3 = 6"];
Print["Poch[1, 4] = 1*2*3*4 = 24\n"];

Print["IDEA: Pochhammer Poch[a, n] counts:"];
Print["  Rising factorial = a*(a+1)*...*(a+n-1)"];
Print["  = permutations? selections? arrangements?\n"];

Print["Poch[2,2] / 2! = 6 / 2 = 3"];
Print["  Could be: 3 ways to arrange 2 items from sequence starting at 2?"];
Print["  Or: 3 pairs (2,3) with some constraint?\n"];

Print["Poch[1,4] / 4! = 24 / 24 = 1"];
Print["  With factor 2^1: 2*1 = 2"];
Print["  Could be: 2 arrangements of 4 items from sequence [1,2,3,4]?"];
Print["  Or: 2 ways to partition into pairs?\n"];

Print["=== NEXT STEP ==="];
Print["Need to find combinatorial interpretation of:"];
Print["  Poch[a, 2i] / (2i)! with factor 2^(i-1)"];
Print["This is a GENERALIZED BINOMIAL coefficient"];
Print["  Poch[a,n] / n! = generalized binomial"];

