#!/usr/bin/env python3
"""Quick debug of CF period detection"""

def isqrt(n):
    if n == 0: return 0
    x = n
    y = (x + 1) // 2
    while y < x:
        x = y
        y = (x + n // x) // 2
    return x

def cf_period_debug(D, max_steps=200):
    """Debug CF expansion"""
    a0 = isqrt(D)
    print(f"D = {D}, a0 = {a0}")

    m, d, a = 0, 1, a0

    print(f"Initial: m={m}, d={d}, a={a}")

    period = []
    seen = {}

    for step in range(max_steps):
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        print(f"Step {step}: m={m}, d={d}, a={a}, state={state}")

        if state in seen:
            print(f"  *** PERIOD DETECTED! State {state} seen before at step {seen[state]}")
            break

        seen[state] = step
        period.append(a)

        if step >= 20:
            print("  (stopping after 20 steps for display)")
            break

    print(f"\nPeriod length: {len(period)}")
    print(f"Period: {period[:20]}...")
    return period

# Test
print("="*60)
cf_period_debug(89)
