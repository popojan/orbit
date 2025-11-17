"""
Integer-only Pell equation solver using continued fractions.
Solves x² - Dy² = 1 for fundamental solution (x₀, y₀).

Algorithm: Pure integer arithmetic, no floating point.
"""

def isqrt(n):
    """Integer square root using Newton's method (integer only)"""
    if n < 0:
        raise ValueError("Square root of negative number")
    if n == 0:
        return 0

    # Initial guess
    x = n
    y = (x + 1) // 2

    while y < x:
        x = y
        y = (x + n // x) // 2

    return x

def continued_fraction_period(D):
    """
    Compute continued fraction of √D.
    Returns: (a₀, [a₁, a₂, ..., aₜ]) where t is the period length.
    Pure integer arithmetic.
    """
    a0 = isqrt(D)

    if a0 * a0 == D:
        # Perfect square - no period
        return a0, []

    # CF algorithm: a_i = floor((a₀ + m_i) / d_i)
    # m_{i+1} = d_i * a_i - m_i
    # d_{i+1} = (D - m_{i+1}²) / d_i

    period = []
    seen = {}

    m, d, a = 0, 1, a0

    while True:
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        if state in seen:
            # Found period
            break

        seen[state] = len(period)
        period.append(a)

    return a0, period

def pell_fundamental_solution(D):
    """
    Find fundamental solution to x² - Dy² = 1.
    Returns: (x₀, y₀) as integers.
    Pure integer arithmetic using convergents.
    """
    a0, period = continued_fraction_period(D)

    if not period:
        raise ValueError(f"{D} is a perfect square, no Pell solution")

    tau = len(period)

    # For x² - Dy² = 1:
    # - If period length τ is odd, solution is at convergent index τ-1 (0-indexed)
    # - If period length τ is even, solution is at convergent index 2τ-1 (0-indexed)
    # We compute convergents until we find one that satisfies x² - Dy² = 1

    # Generate enough CF terms (at least 2*tau to be safe)
    max_terms = 3 * tau if tau > 1 else 10

    # Build CF sequence [a₀; a₁, a₂, ..., aₙ]
    cf_seq = [a0]
    for _ in range((max_terms // tau) + 2):
        cf_seq.extend(period)

    # Compute convergents using recurrence:
    # p_{-1} = 1, p_0 = a_0
    # q_{-1} = 0, q_0 = 1
    # p_i = a_i * p_{i-1} + p_{i-2}
    # q_i = a_i * q_{i-1} + q_{i-2}

    p_prev, p_curr = 1, a0
    q_prev, q_curr = 0, 1

    # Check a_0 convergent
    if p_curr * p_curr - D * q_curr * q_curr == 1:
        return p_curr, q_curr

    for i in range(1, min(len(cf_seq), max_terms)):
        a_i = cf_seq[i]
        p_next = a_i * p_curr + p_prev
        q_next = a_i * q_curr + q_prev

        # Check if this is a solution
        norm = p_next * p_next - D * q_next * q_next
        if norm == 1:
            return p_next, q_next

        p_prev, p_curr = p_curr, p_next
        q_prev, q_curr = q_curr, q_next

    raise ValueError(f"Failed to find Pell solution for D={D} after {max_terms} convergents")

def verify_pell_solution(D, x, y):
    """Verify that (x, y) satisfies x² - Dy² = 1"""
    return x * x - D * y * y == 1

# Self-test
if __name__ == "__main__":
    print("Pell Equation Solver - Self Test")
    print("=" * 60)

    test_cases = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]

    for D in test_cases:
        x0, y0 = pell_fundamental_solution(D)
        verified = verify_pell_solution(D, x0, y0)

        status = "✓" if verified else "✗"
        print(f"D={D:3d}: x₀={x0:>10d}, y₀={y0:>10d}  {status}")

        if not verified:
            print(f"  ERROR: {x0}² - {D}·{y0}² = {x0*x0 - D*y0*y0}")

    print("\n" + "=" * 60)
    print("All tests passed!" if all(
        verify_pell_solution(D, *pell_fundamental_solution(D))
        for D in test_cases
    ) else "Some tests failed!")
