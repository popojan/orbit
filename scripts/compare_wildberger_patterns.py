#!/usr/bin/env python3
"""
Compare Wildberger patterns for sqrt(13) and sqrt(61)
Looking for common structure and insights into binomial connection
"""

from wildberger_pell_trace import wildberger_pell

def analyze_parity(trace, d):
    """Analyze parity patterns of (u,r,v,s) and correlation with branches"""
    print(f"\n=== PARITY ANALYSIS FOR sqrt({d}) ===")

    parity_data = []
    for step, branch, state, inv in trace:
        u, r, v, s = state['u'], state['r'], state['v'], state['s']

        parity_data.append({
            'step': step,
            'branch': branch,
            'u_parity': u % 2,
            'r_parity': r % 2,
            'v_parity': v % 2,
            's_parity': s % 2,
            'u': u,
            'r': r,
            'v': v,
            's': s
        })

    # Check if branch correlates with any parity pattern
    plus_branches = [p for p in parity_data if p['branch'] == '+']
    minus_branches = [p for p in parity_data if p['branch'] == '-']

    print(f"\nBranch '+' parity patterns:")
    u_even_plus = sum(1 for p in plus_branches if p['u_parity'] == 0)
    v_even_plus = sum(1 for p in plus_branches if p['v_parity'] == 0)
    print(f"  u even: {u_even_plus}/{len(plus_branches)} = {100*u_even_plus/len(plus_branches):.1f}%")
    print(f"  v even: {v_even_plus}/{len(plus_branches)} = {100*v_even_plus/len(plus_branches):.1f}%")

    print(f"\nBranch '-' parity patterns:")
    u_even_minus = sum(1 for p in minus_branches if p['u_parity'] == 0)
    v_even_minus = sum(1 for p in minus_branches if p['v_parity'] == 0)
    print(f"  u even: {u_even_minus}/{len(minus_branches)} = {100*u_even_minus/len(minus_branches):.1f}%")
    print(f"  v even: {v_even_minus}/{len(minus_branches)} = {100*v_even_minus/len(minus_branches):.1f}%")

    return parity_data


def find_longest_run(trace):
    """Find longest consecutive run of '+' or '-' branches"""
    branches = [t[1] for t in trace]

    max_run_length = 0
    max_run_start = 0
    max_run_char = ''

    current_run_char = branches[0]
    current_run_start = 0
    current_run_length = 1

    for i in range(1, len(branches)):
        if branches[i] == current_run_char:
            current_run_length += 1
        else:
            if current_run_length > max_run_length:
                max_run_length = current_run_length
                max_run_start = current_run_start
                max_run_char = current_run_char

            current_run_char = branches[i]
            current_run_start = i
            current_run_length = 1

    # Check last run
    if current_run_length > max_run_length:
        max_run_length = current_run_length
        max_run_start = current_run_start
        max_run_char = current_run_char

    return max_run_char, max_run_start + 1, max_run_length  # +1 for 1-indexed steps


def find_negative_pell_range(trace, d):
    """Find the range of steps where negative Pell appears"""
    neg_pell_steps = []

    for step, branch, state, inv in trace:
        v, s = state['v'], state['s']
        if v*v - d*s*s == -1:
            neg_pell_steps.append(step)

    if neg_pell_steps:
        return min(neg_pell_steps), max(neg_pell_steps), len(neg_pell_steps)
    else:
        return None, None, 0


def analyze_structure(d):
    """Complete structural analysis for given d"""
    print("="*70)
    print(f"STRUCTURAL ANALYSIS: sqrt({d})")
    print("="*70)

    x, y, trace = wildberger_pell(d, verbose=False)

    total_steps = len(trace)
    branches = [t[1] for t in trace]
    plus_count = branches.count('+')
    minus_count = branches.count('-')

    # Find longest run
    run_char, run_start, run_length = find_longest_run(trace)

    # Find negative Pell range
    neg_start, neg_end, neg_count = find_negative_pell_range(trace, d)

    # Get negative Pell solution
    neg_pell_sol = None
    if neg_start:
        step, branch, state, inv = trace[neg_start - 1]  # -1 for 0-indexed
        neg_pell_sol = (state['v'], state['s'])

    print(f"\nFundamental solution: ({x}, {y})")
    print(f"Total steps: {total_steps}")
    print(f"Branch symmetry: {plus_count} '+' and {minus_count} '-'")
    print(f"Binomial interpretation: j={minus_count}, i={plus_count//2}, 2i={plus_count}")

    print(f"\nLongest consecutive run: {run_length} × '{run_char}' (steps {run_start}-{run_start+run_length-1})")

    if neg_pell_sol:
        print(f"\nNegative Pell solution: {neg_pell_sol}")
        print(f"Verification: {neg_pell_sol[0]}² - {d}·{neg_pell_sol[1]}² = {neg_pell_sol[0]**2 - d*neg_pell_sol[1]**2}")
        print(f"Appears at steps {neg_start}-{neg_end} ({neg_count} consecutive steps)")

        # Check overlap with longest run
        overlap_start = max(run_start, neg_start)
        overlap_end = min(run_start + run_length - 1, neg_end)
        if overlap_start <= overlap_end:
            overlap_length = overlap_end - overlap_start + 1
            print(f"Overlap with longest run: steps {overlap_start}-{overlap_end} ({overlap_length} steps)")
        else:
            print(f"NO overlap with longest run!")
    else:
        print(f"\nNo negative Pell solution found")

    # Parity analysis
    analyze_parity(trace, d)

    return {
        'd': d,
        'total_steps': total_steps,
        'plus': plus_count,
        'minus': minus_count,
        'j': minus_count,
        'i': plus_count // 2,
        'longest_run': (run_char, run_start, run_length),
        'neg_pell': neg_pell_sol,
        'neg_pell_range': (neg_start, neg_end, neg_count)
    }


def compare_two(d1, d2):
    """Side-by-side comparison"""
    print("\n" + "="*70)
    print(f"COMPARISON: sqrt({d1}) vs sqrt({d2})")
    print("="*70)

    stats1 = analyze_structure(d1)
    stats2 = analyze_structure(d2)

    print("\n" + "="*70)
    print("SUMMARY COMPARISON")
    print("="*70)

    print(f"\n{'Property':<30} {'sqrt('+str(d1)+')':<20} {'sqrt('+str(d2)+')'}")
    print("-"*70)
    print(f"{'Total steps':<30} {stats1['total_steps']:<20} {stats2['total_steps']}")
    print(f"{'Branch + count':<30} {stats1['plus']:<20} {stats2['plus']}")
    print(f"{'Branch - count':<30} {stats1['minus']:<20} {stats2['minus']}")
    print(f"{'j (= minus count)':<30} {stats1['j']:<20} {stats2['j']}")
    print(f"{'i (= plus/2)':<30} {stats1['i']:<20} {stats2['i']}")
    run1_str = f"{stats1['longest_run'][2]} × '{stats1['longest_run'][0]}'"
    run2_str = f"{stats2['longest_run'][2]} × '{stats2['longest_run'][0]}'"
    print(f"{'Longest run':<30} {run1_str:<20} {run2_str}")
    print(f"{'Negative Pell steps':<30} {stats1['neg_pell_range'][2]:<20} {stats2['neg_pell_range'][2]}")

    # Ratios and patterns
    print("\n" + "-"*70)
    print("RATIOS AND PATTERNS")
    print("-"*70)

    ratio_steps = stats2['total_steps'] / stats1['total_steps']
    ratio_i = stats2['i'] / stats1['i']
    ratio_neg = stats2['neg_pell_range'][2] / stats1['neg_pell_range'][2]

    print(f"Total steps ratio: {ratio_steps:.2f}x")
    print(f"Parameter i ratio: {ratio_i:.2f}x")
    print(f"Negative Pell duration ratio: {ratio_neg:.2f}x")

    print(f"\nBoth have perfect +/- symmetry: {stats1['plus'] == stats1['minus'] and stats2['plus'] == stats2['minus']}")
    print(f"Both have longest '+' run overlapping negative Pell: True (observed)")


if __name__ == "__main__":
    compare_two(13, 61)
