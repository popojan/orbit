#!/usr/bin/env python3
"""Quick test to find negative Pell solutions manually"""

def pellsol_debug(d: int):
    """Debug version that prints every step"""
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1
    path = []
    step = 0

    print(f"\n=== Solving for d={d} ===")
    print(f"{'Step':>4} {'Branch':>6} {'a':>4} {'b':>4} {'c':>4} {'u':>4} {'r':>4} {'u²-dr²':>8} {'Invariant':>10}")
    print("-" * 70)

    while True:
        # Check current state
        norm = u**2 - d*r**2
        invariant = a*c - b*b
        print(f"{step:4d} {'START' if step == 0 else path[-1]:>6} {a:4d} {b:4d} {c:4d} {u:4d} {r:4d} {norm:8d} {invariant:10d}")

        # Check for solutions
        if norm == -1 and step > 0:
            print(f"  ★ NEGATIVE PELL FOUND: ({u}, {r})")
        if norm == 1 and step > 0 and not (a == 1 and b == 0 and c == -d):
            print(f"  ⚠ INTERMEDIATE norm=1 (not final): ({u}, {r})")

        t = a + b + b + c
        if t > 0:
            path.append("R")
            a = t
            b += c
            u += v
            r += s
        else:
            path.append("L")
            b += a
            c = t
            v += u
            s += r

        step += 1

        # Check termination
        if a == 1 and b == 0 and c == -d:
            norm = u**2 - d*r**2
            invariant = a*c - b*b
            print(f"{step:4d} {'FINAL':>6} {a:4d} {b:4d} {c:4d} {u:4d} {r:4d} {norm:8d} {invariant:10d}")
            print(f"  ★ FUNDAMENTAL: ({u}, {r})")
            break

        if step > 100:  # Safety
            print("TOO MANY STEPS!")
            break

    return u, r, "".join(path)


# Test known examples
print("Testing d values known to have negative Pell solutions:")
for d in [2, 5, 10, 13]:
    x, y, path = pellsol_debug(d)
    print(f"\nFinal: x={x}, y={y}, path={path}")
    print(f"Check fundamental: {x}² - {d}*{y}² = {x**2 - d*y**2}")
