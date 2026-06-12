(* 20_finite_size_constant.wl -- the Theorem 0 finite-size constant
   (2026-06-12). Derivation: the prefix Radon-Nikodym weight expands as
     2^T C(m-T, k-r)/C(m,k) = 1 + (T/2 - D - D^2/2)/m + O(T^4/m^2),
   D = 2r - T, m = 2n-1 (checked: E[w] = 0 since E D = 0, E D^2 = T).
   Hence n (P_n(surv) - sigma) -> c1 = L/2 with
     L = lim_T E[ 1_{surv<=T} (T/2 - D_T - D_T^2/2) ]   (free coin walk).
   Pre-registered H-T2: L/2 matches the measured n*err -> 0.622 (alpha=3/2).
   DP over (tau, u) with survival mask u <= floor(1.5 (tau+1)). *)

alpha = 3/2;
tMax = 600;
uCap = Floor[alpha (tMax + 2)] + 2;

(* mass[tau+1, u+1]; start: 0 steps, tau=0, u=0 *)
mass = ConstantArray[0.0, {tMax + 2, uCap + 2}];
mass[[1, 1]] = 1.0;

(* survival mask per tau: u <= floor(alpha (tau+1)) *)
uMax = Table[Floor[alpha (tau + 1)], {tau, 0, tMax + 1}];

checkpoints = {100, 200, 300, 400, 500, 600};
results = {};

Do[
  Module[{shiftR, shiftU},
    (* R-step: tau+1 (prob 1/2); U-step: u+1 (prob 1/2) *)
    shiftR = 0.5 RotateRight[mass, {1, 0}]; shiftR[[1, All]] = 0.0;
    shiftU = 0.5 RotateRight[mass, {0, 1}]; shiftU[[All, 1]] = 0.0;
    mass = shiftR + shiftU;
    (* ruin mask *)
    Do[
      Module[{um = uMax[[tau + 1]]},
        If[um + 2 <= uCap + 2,
          mass[[tau + 1, um + 2 ;; uCap + 2]] = 0.0]],
      {tau, 0, Min[t, tMax + 1]}];
    If[MemberQ[checkpoints, t],
      Module[{survP = Total[mass, 2], lVal},
        lVal = Sum[
          Module[{row = mass[[tau + 1]], dd, w},
            Sum[
              If[row[[u + 1]] > 0,
                dd = 2 tau - t;
                row[[u + 1]] (t/2 - dd - dd^2/2),
                0.0],
              {u, 0, Min[uMax[[tau + 1]], uCap]}]],
          {tau, 0, Min[t, tMax]}];
        AppendTo[results, {t, survP, lVal}];
        Print["T=", t, "  P(surv<=T) = ", NumberForm[survP, 10],
          "  L_T = ", NumberForm[lVal, 8],
          "  L_T/2 = ", NumberForm[lVal/2, 8]]]]],
  {t, 1, tMax}];

Print["sigma = 2 C(3/2) = 0.503696331672573  (DP survival should approach)"];
Print["measured n*err (script 15): 0.6164, 0.6193, 0.6208, 0.6215, 0.6219 (n=50..800)"];
