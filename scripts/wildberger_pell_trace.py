#!/usr/bin/env python3
"""
Trace Wildberger's Pell algorithm for sqrt(13)
Looking for:
1. Negative Pell solution midpoint (a^2 - 13*b^2 = -1)
2. Branch +/- alternation pattern
3. Connection to binomial structure (j+i choose 2i)
"""

def wildberger_pell(d, verbose=True):
    """
    Wildberger's algorithm for fundamental Pell solution x^2 - d*y^2 = 1

    Returns: (x, y, trace_data)
    trace_data: list of (step, branch, state, invariant)
    """
    # Initial state
    a, b, c = 1, 0, -d
    u, v, r, s = 1, 0, 0, 1

    trace = []
    step = 0

    if verbose:
        print(f"Finding Pell solution for d={d}")
        print(f"Initial: a={a}, b={b}, c={c}, u={u}, v={v}, r={r}, s={s}")
        print()

    while True:
        # Compute t
        t = a + 2*b + c

        # Check invariant: a*c - b^2 = -d always
        invariant = a*c - b*b
        assert invariant == -d, f"Invariant broken at step {step}: {a}*{c} - {b}^2 = {invariant} != {-d}"

        # Branch decision
        if t > 0:
            branch = "+"
            # Branch +: a = t; b += c; u += v; r += s
            a = t
            b += c
            u += v
            r += s
        else:
            branch = "-"
            # Branch -: b += a; c = t; v += u; s += r
            b += a
            c = t
            v += u
            s += r

        step += 1

        # Compute current approximation AFTER update
        approx_u = u*u - d*r*r  # Main sequence
        approx_v = v*v - d*s*s  # Auxiliary sequence

        # Record trace
        state = {
            'a': a, 'b': b, 'c': c,
            'u': u, 'v': v, 'r': r, 's': s,
            'approx_u': approx_u,
            'approx_v': approx_v
        }
        trace.append((step, branch, state, invariant))

        if verbose:
            print(f"Step {step}: t={t:3d} → Branch {branch}")
            print(f"  State: a={a:3d}, b={b:3d}, c={c:3d}")
            print(f"  Main:  u={u:6d}, r={r:6d}, u²-{d}r² = {approx_u:+3d}")
            print(f"  Aux:   v={v:6d}, s={s:6d}, v²-{d}s² = {approx_v:+3d}")
            if approx_u == -1:
                print(f"  *** NEGATIVE PELL (u,r): ({u}, {r}) satisfies x²-{d}y²=-1 ***")
            if approx_v == -1:
                print(f"  *** NEGATIVE PELL (v,s): ({v}, {s}) satisfies x²-{d}y²=-1 ***")
            print()

        # Check termination: a == 1 && b == 0 && c == -d
        if a == 1 and b == 0 and c == -d:
            break

    if verbose:
        print(f"Found fundamental solution: x={u}, y={r}")
        print(f"Verification: {u}² - {d}*{r}² = {u*u - d*r*r}")
        print(f"Total steps: {step}")

    return u, r, trace


def analyze_alternation(trace):
    """Analyze branch +/- alternation pattern"""
    branches = [t[1] for t in trace]

    print("\n=== ALTERNATION ANALYSIS ===")
    print(f"Total steps: {len(branches)}")
    print(f"Branch sequence: {''.join(branches)}")

    # Count consecutive runs
    runs = []
    current_run = [branches[0]]
    for b in branches[1:]:
        if b == current_run[-1]:
            current_run.append(b)
        else:
            runs.append((current_run[0], len(current_run)))
            current_run = [b]
    runs.append((current_run[0], len(current_run)))

    print(f"\nRuns: {runs}")

    # Count total + and -
    plus_count = branches.count('+')
    minus_count = branches.count('-')
    print(f"\nTotal '+' branches: {plus_count}")
    print(f"Total '-' branches: {minus_count}")
    print(f"Total: {plus_count + minus_count}")

    # Check for even pairing
    print(f"\nEven pairing check:")
    print(f"  If 2i = {plus_count}, then i = {plus_count/2}")
    print(f"  j+i total = {len(branches)}, so j = {len(branches) - plus_count}")

    return branches, runs, plus_count, minus_count


def find_negative_pell(trace, d):
    """Find steps where u^2 - d*r^2 = -1 OR v^2 - d*s^2 = -1 (negative Pell)"""
    print("\n=== NEGATIVE PELL SOLUTIONS ===")

    negative_u = []
    negative_v = []

    for step, branch, state, inv in trace:
        u, r = state['u'], state['r']
        v, s = state['v'], state['s']
        approx_u = state['approx_u']
        approx_v = state['approx_v']

        if approx_u == -1:
            negative_u.append((step, 'u,r', u, r))
            print(f"Step {step}: Main (u,r) = ({u}, {r}) satisfies x²-{d}y²=-1")

        if approx_v == -1:
            negative_v.append((step, 'v,s', v, s))
            print(f"Step {step}: Aux  (v,s) = ({v}, {s}) satisfies x²-{d}y²=-1")

    if not negative_u and not negative_v:
        print("No negative Pell solutions found during algorithm")
    else:
        print(f"\nFound {len(negative_u)} main (u,r) and {len(negative_v)} auxiliary (v,s) negative Pell solutions")

    return negative_u, negative_v


def binomial_comparison(trace, d):
    """Compare trace structure with binomial coefficients"""
    total = len(trace)

    print("\n=== BINOMIAL STRUCTURE COMPARISON ===")

    # Try different interpretations
    for i in range(1, total//2 + 1):
        j = total - 2*i
        if j >= 0:
            # Compute binomial(j+i, 2i)
            from math import comb
            binom = comb(j+i, 2*i)
            coeff = 2**(i-1) if i > 0 else 1
            formula_value = coeff * binom

            print(f"j={j}, i={i}: total={j+2*i} = {total}")
            print(f"  Formula: 2^({i}-1) * C({j+i},{2*i}) = {coeff} * {binom} = {formula_value}")

    print("\nNote: Need to understand what these numbers represent in Wildberger trace")


if __name__ == "__main__":
    import sys

    # Allow d to be passed as command line argument
    d = int(sys.argv[1]) if len(sys.argv) > 1 else 61

    print("="*60)
    print(f"Wildberger Pell Algorithm Trace for sqrt({d})")
    print("="*60)
    print()

    # Run algorithm
    x, y, trace = wildberger_pell(d, verbose=True)

    # Analyze alternation
    branches, runs, plus, minus = analyze_alternation(trace)

    # Find negative Pell
    neg_pell = find_negative_pell(trace, d)

    # Binomial comparison
    binomial_comparison(trace, d)

    print("\n" + "="*60)
    print(f"SUMMARY: sqrt({d}) fundamental solution = ({x}, {y})")
    print(f"Algorithm steps: {len(trace)}")
    print(f"Branch pattern: {'+' * plus} and {'-' * minus}")
    print("="*60)
