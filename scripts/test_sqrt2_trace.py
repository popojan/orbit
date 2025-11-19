#!/usr/bin/env python3
"""Quick test for sqrt(2) - known to have negative Pell"""

import sys
sys.path.insert(0, '/home/user/orbit/scripts')
from wildberger_pell_trace import wildberger_pell, analyze_alternation, find_negative_pell

print("Testing sqrt(2) - known negative Pell: (1,1)")
x, y, trace = wildberger_pell(2, verbose=True)

branches, runs, plus, minus = analyze_alternation(trace)
neg_pell = find_negative_pell(trace, 2)
