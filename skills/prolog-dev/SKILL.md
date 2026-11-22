---
name: prolog-dev
description: Instructions for writing, testing and reviewing SWI-Prolog 9.x code for CS F301 Assignment 2 (P1 department puzzle in id_q1.pl, P2 arithmetic equations in id_q2.pl). Use for every Prolog prompt in this assignment.
---

# prolog-dev

## 1. Language and environment
- SWI-Prolog 9.x only. Code must behave the same way under `swipl` 9.0 and later.
- Allowed libraries: `lists`, `apply`, `yall`, `aggregate`. Nothing else
  (no `clpfd`, `plunit`, `dcg/basics`, `strings`, `readutil`, etc.).
- Built-in predicates (`is/2`, `findall/3`, `sort/2`, `msort/2`, `length/2`,
  `format/2,3`, `number_string/2`, `string_concat/3`, `once/1`, `forall/2`, ...)
  are fine to use.
- Files: `code/<id>_q1.pl` (P1) and `code/<id>_q2.pl` (P2), where `<id>` is the group ID.

## 2. How the grader runs the code
```
swipl -q -f code/<id>_q1.pl -g main -t halt
swipl -q -f code/<id>_q2.pl -g "<goal>" -t halt
```
So the file must:
- contain **only definitions** (plus `:- use_module(library(...))` for the allowed libraries);
- contain **no** `:- initialization(...)` directive and **never** call `halt/0`;
- print **nothing** when loaded, and give no warnings (singleton variables, discontiguous clauses, redefinitions).

## 3. Hard constraints (both problems)
- No `assert`, `asserta`, `assertz`, `retract`, `retractall`.
- No global variables: no `b_setval`, `b_getval`, `nb_setval`, `nb_getval`.
- Do not print anything other than what the problem specifies.
- P1: `main/0` prints exactly four lines in the format
  `Alex = [Dept, Lang, Project]`, in the order Alex, Ben, Carla, Dana, derived from the clues (never hard-coded).
  Each clue is its own clause `clue(N, Solution)`. `count_solutions(Active, N)` uses `findall/3` or `aggregate_all/3`.
  Clue 9 has a `% CLUE 9:` comment with its English sentence on the line directly above it and names no friend.
- P2: results are SWI-Prolog **strings** (not atoms, not code lists) with no spaces.
  Never build a string and parse it back into a term to evaluate it.
  Division is allowed only when it is exact with a non-zero divisor, at every depth.
  `generate_equation/2` must fail (no loop, no error) when no equation exists, including for `[]` and one-element lists.

## 4. Coding conventions
- Predicate names: `snake_case`. Variables: `CamelCase`, descriptive (`Left`, `Right`, `Tree`, `Value`).
- One unit per prompt: one predicate (or a predicate plus a tiny helper) at a time.
- Every predicate has a header comment with:
  1. its mode, e.g. `% expr(+Nums, -Tree, -Value)`;
  2. a **declarative reading**: what relation holds between the arguments,
     written as "X is ... such that ...", not as a sequence of steps.
- Keep all clauses of a predicate together (no discontiguous definitions).
- Prefer pure relations. Use `->` and `once/1` only where determinism is wanted, and say why in the explanation.
- Use `_` for variables used once. Avoid singleton warnings.
- Generate-and-test: generate the most constraining choices first and test as early as possible
  (for example, bind the left-hand value before generating right-hand trees).

## 5. How to run and test
- Load check (must print nothing): `swipl -q -f code/<id>_q2.pl -g true -t halt`
- Single goal: `swipl -q -f code/<id>_q2.pl -g "all_equations([4,2,5,3],Es),print(Es),nl" -t halt`
- Test suites (plain goals, no plunit), from the repository root:
  ```
  swipl -q -f tests/test_q1.pl -g run -t halt
  swipl -q -f tests/test_q2.pl -g run -t halt
  ```
  Each test is a fact `test(Name, Goal)`. `run/0` runs every goal inside `catch/3`, prints PASS/FAIL and a summary,
  and fails (exit status 1) if any test fails.
- Every example in the assignment text is a test. Add edge cases: empty and one-element inputs, zeros, inputs with no solution,
  and checks that results are of the right type, sorted and duplicate-free.

## 6. Self-review checklist (apply before every answer)
1. Does the code load with no output and no warnings?
2. Are only the allowed libraries used? Any `assert`/`retract`/global variables? Any `initialization` or `halt`?
3. Does every predicate have its mode line and a declarative-reading comment?
4. Termination: does every recursive call work on a strictly smaller input? Is every generator finite?
5. Does the predicate fail cleanly (no exception) on inputs with no answer, including `[]` and one-element lists?
6. Arithmetic: no division by zero is ever evaluated; `/` is never used inside `is/2` where an integer is needed
   (`7/2` gives `3.5` in SWI-Prolog); exactness is checked with `A mod B =:= 0` before `A // B`.
7. Are outputs exactly the required type and format (string vs atom, spaces, order, line layout)?
8. Duplicates and order: is `sort/2` used where duplicates must be removed (`msort/2` keeps them)?
9. Does each generator yield each answer exactly once on backtracking? Is `once/1` used where exactly one answer is required?
10. Were the assignment examples actually run, and do they match character for character?

## 7. Known failure modes of AI tools in Prolog
- Writing imperative-style code with `assert`/`retract` or global counters instead of passing state through arguments.
- Using `/` inside `is/2` and getting floats; forgetting that `//` truncates toward zero and that `mod` and `rem` differ for negatives.
- Evaluating `A mod 0` or `A // 0` before checking the divisor, which raises an evaluation error instead of failing.
- Left recursion or unbounded generators (e.g. `append(L, R, X)` with `X` unbound) that loop on backtracking.
- Generating the same answer more than once, or leaving choice points where one answer is expected.
- Confusing strings, atoms and code lists (`"abc"` is a string in SWI-Prolog 7+, `'abc'` is an atom).
- Using `msort/2` instead of `sort/2`, or `setof/3` with free variables it doesn't account for.
- Adding `:- initialization(main).` or calling `halt.` inside the file.
- Using libraries that aren't allowed (`clpfd`, `plunit`) or SWI-only helpers from other libraries without checking.
- Hard-coding the puzzle answer or printing debug output.
- Building an expression as a string and calling `term_string/2` or `term_to_atom/2` to evaluate it (forbidden in P2).
- Claiming code is tested without running it. Always run the examples.
