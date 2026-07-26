---
name: imo-solve
description: Solve math olympiad problems with rigorous proofs, following the deedy/imo-2026 methodology — structured workspace, multi-angle attack, numerical verification, self-contained proofs
---

# IMO-Solve: Rigorous Math Olympiad Problem Solving

This skill encodes the methodology from [deedy/imo-2026](https://github.com/deedy/imo-2026) for solving math olympiad problems to a 7/7 IMO-grading standard.

## Workflow

### Step 1: Set up the problem workspace

Create a dedicated directory for the problem:

```
<run-name>/
  current.md          # Master tracking document
  approaches/         # One file per substantive approach
  lemmas/             # Standalone lemmas cited by the proof
  code/               # Python verification scripts
  scratch/            # Free scratch space for exploration
```

### Step 2: Solve the problem

You are a world-class mathematician solving the problem with complete rigor from first principles. **Do not recall or reproduce a published solution** — derive every claim yourself.

**Working discipline:**
- **Update `current.md` after EVERY significant advance.** The disk is the source of truth; if the session dies, only what is on disk survives. Never leave your best result only in conversation.
- Attack the problem from **multiple angles**; record dead ends honestly in `## Approaches tried`.
- **Rigor bar: IMO grader awarding 7/7.** No gaps, no "clearly", no "obviously", every case handled. For compute-and-prove problems, both the answer AND its optimality/completeness must be proved.
- When (and only when) you are satisfied the proof is complete, state the final answer clearly and stop.

**Verification strategy:**
- Write Python scripts in `code/` to sanity-check claims:
  - Brute-force enumeration for small cases
  - Monte Carlo / random testing for numeric identities
  - Symbolic algebra checks (with `sympy` where available)
  - Exact computation for combinatorial claims
- **Numeric verification of key identities is strongly encouraged before committing to them in the proof** — but computation never substitutes for proof.
- Run scripts with `python3` or `uv run --with sympy,numpy python3 <script>`.

### Step 3: File formats

#### `current.md` — Master tracking document

```markdown
# <problem-id> — tracking file

## Status
solved | partial | unsolved

## Problem
<verbatim problem statement>

## Approaches tried
- <approach-1>: <status and one-line summary>
- <approach-2>: <status and one-line summary>
- ...

## Current best
<one-paragraph summary of the best result so far. For compute-and-prove problems, state the explicit final answer here.>

## Full proof
<complete, self-contained, rigorous proof in markdown+LaTeX.
Every lemma proved or cited, every case handled, no logical gaps.
Use $$ for displayed equations and $ for inline math.>
```

#### `approaches/<slug>.md`

```markdown
# <approach-name>

## Idea
<core insight>

## Status
active | abandoned | succeeded | subsumed

## Details
<exploration notes, partial derivations, counterexamples to failed attempts>
```

#### `lemmas/<slug>.md`

```markdown
# <lemma-name>

## Statement
<precise statement>

## Proof
<self-contained proof>
```

#### `code/` scripts

Python scripts that verify claims numerically. Example:
```python
"""Brute-force verification of claim for n <= 100."""
def check_claim(n_max=100):
    for n in range(1, n_max + 1):
        # compute and assert
        pass
    print(f"Verified for n <= {n_max}")

if __name__ == "__main__":
    check_claim()
```

### Step 4: Typeset the final solution (optional)

Once the proof is complete in `current.md`, convert it to a clean LaTeX document using the project's `TLZLaTeXPack.sty` style file. Place the `.tex` file in the appropriate project directory (`Math Olympiad/Main/` or `MO-Private/`).

Template:
```latex
\documentclass{article}
\usepackage{TLZLaTeXPack}
\renewcommand{\authorname}{Zhiheng Luo}
\renewcommand{\pdftitle}{<Problem Title>}
\renewcommand{\createddate}{<date>}
\renewcommand{\updateddate}{<date>}

\title{\pdftitle}
\author{\TLZFullAuthor}

\begin{document}
\maketitle

\section{<Problem Name>}
% ... proof content in LaTeX ...

\end{document}
```

## Key principles

1. **Self-contained proofs**: Every claim is proved. Cite lemmas explicitly. No hand-waving.
2. **Multi-angle attack**: If one approach stalls, try another. Record what you learned from each failure.
3. **Verify before committing**: Use code to check identities, small cases, and edge cases before writing them into the proof.
4. **Disk as source of truth**: Write to `current.md` frequently. Partial results on disk are better than complete results lost.
5. **Finality**: When the proof is complete, state the answer and stop. Do not keep polishing.
