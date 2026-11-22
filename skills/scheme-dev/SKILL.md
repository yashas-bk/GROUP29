---
name: scheme-dev
description: Conventions, allowed built-ins, testing steps and a self-review checklist for writing CS F301 Assignment 2 Scheme solutions (S1, S2) in Racket 8.x using only the restricted built-in set.
---

# scheme-dev

## 1. Language and version
- Racket 8.x. Every solution file starts with exactly: `#lang racket/base`
- Not `#lang racket`, not `#lang scheme`.
- Files contain **only definitions**. No top-level calls, nothing printed on load.
  The grader appends its own calls to the end of the file.

## 2. Allowed built-ins (nothing else)
**Forms:** `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`,
`cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` / `'`

**Lists:** `cons`, `car`, `cdr`, `list`, any `c[ad]{1,4}r` (`cadr`, `cddr`, `caddr`, `cadddr` ...),
`null?`, `pair?`, `eq?`, `assq`, `assoc`

**Numbers:** `+ - * < > <= >= =`, `max`

**Output:** `display`, `newline`

**Input:** `read`, for S2 only

**BANNED (write your own helper instead):**
- `set!` and friends; vectors, hash tables, strings
- `do`, `for` loops
- `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`
- Also not on the list, so banned: `first`, `rest`, `empty?`, `null` (write `'()`), `list?`,
  `equal?`, `number?`, `symbol?`, `zero?`, `add1`, `sub1`, `when`, `unless`, `displayln`,
  `printf`, `format`, `print`, `write`, `foldl`, `foldr`, `apply`, `provide`, `require`
- `min` (only `max` is allowed)
- quasiquote `` ` `` and unquote `,` (only `quote` / `'` is allowed)
- `case`, `abs`, `quotient`, `remainder`, `error`, `void`, `values`, `eqv?`, `last`

## 3. Coding conventions
- Names are lowercase-with-hyphens: `inorder-acc`, `my-length`, `leaf-count`.
- Helpers we write to replace banned functions get a `my-` prefix: `my-reverse`, `my-map`.
- Accumulator helpers end in `-acc` and take the accumulator as the **last** argument.
- Above every `define`, write a comment block:
  ```racket
  ;; (inorder-acc tree acc) -> list
  ;; Purpose: values of tree in inorder, placed in front of acc.
  ;; Recursive reading: for the empty tree, the answer is acc.
  ;;   For (v l r), first put the inorder of r in front of acc,
  ;;   then cons v onto that, then put the inorder of l in front of the result.
  ```
- Pass all state through arguments. No global mutable state.
- Prefer tail recursion when it's natural (an accumulator plus a named `let`).
- Build lists with `cons` plus an accumulator. Never glue two lists together with `append`.
- Tree shape: `'()`, or `(value left right)`, so use `(car t)`, `(cadr t)`, `(caddr t)`.

## 4. How to run and test
All commands, Windows and bash, run from the repo root (GROUP29/).

### Windows (PowerShell)
Check the version:
```powershell
racket --version          # Welcome to Racket v8.xx [cs].
```
Loading the solution alone must print **nothing**:
```powershell
racket code\GROUP29_q3.rkt
```
Testing works the same way the grader does: add the test calls to the end of the code file, then run it.
The test file `tests\test_q3.rkt` holds only calls (no `#lang` line):
```powershell
Get-Content code\GROUP29_q3.rkt, tests\test_q3.rkt | Set-Content -Encoding ascii run_tmp.rkt
racket run_tmp.rkt
Remove-Item run_tmp.rkt
```
Use `-Encoding ascii` because a UTF-8 BOM before `#lang` can break the reader.
For S2 (reads from stdin):
```powershell
"42 ((1 2) (3 4 5) (6) ()) 3" | racket run_tmp.rkt
```

### macOS / Linux (bash)
```bash
racket --version
racket code/GROUP29_q3.rkt     # must print nothing
cat code/GROUP29_q3.rkt tests/test_q3.rkt > /tmp/run.rkt && racket /tmp/run.rkt
```
For S2 (reads stdin):
```bash
cat code/GROUP29_q4.rkt tests/test_q4.rkt > /tmp/run.rkt && echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket /tmp/run.rkt
```
Compare each output line with the expected line in the assignment PDF.

## 5. Self-review checklist (the AI must apply this before answering)
1. Does the first line say exactly `#lang racket/base`?
2. Is every identifier used either in Section 2's allowed list or defined in this file?
3. Is there no `append`/`reverse`/`length`/`map`/`filter`/`member` and no `set!`?
4. Is there no top-level call and nothing printed on load?
5. Does every print function use `display` and end with `(newline)`?
6. Does the empty tree / empty list case come first and return the right base value (`'()` or `0`)?
7. Is the left subtree visited before the right?
8. Run the tests and show the actual output. Don't rely on hand-tracing.
9. Does every `define` have a purpose comment and a recursive reading?
10. Is recursion depth OK for big inputs (nesting depth 100, lists of 10,000)?
11. The file ends with a newline, and the last line is code or blank, not a comment.
    The grader appends its calls to the end of the file.
12. Only the unit asked for (one function or one test file) was written.
    Never write a whole problem in one response.

If any item fails, fix it before answering.

## 6. Known AI failure modes in Scheme
- Using `append` to join traversal lists, even though it's banned. Fix: an accumulator.
- Using `length`/`reverse`/`map` from habit, or `first`/`rest`/`empty?` from `#lang racket`.
- Writing `#lang racket` instead of `#lang racket/base`.
- Writing `null` or `empty` instead of `'()`.
- Using `displayln` or `printf` instead of `display` + `newline`.
- Using `print`/`write`, which add a quote or extra formatting to the output.
- Leaving test calls like `(print-inorder t1)` at the top level of the solution file.
- Using `equal?`, `number?`, `symbol?`, `list?`. Tell atoms from lists with `pair?` / `null?` instead.
- Mixing up `cadr` (left subtree) and `caddr` (right subtree).
- Building a list backwards with an accumulator, then "fixing" it with `reverse`.
- Off-by-one in height: `'()` is 0, so a single node is 1.
- Counting `'()` as a leaf. A leaf is a node whose two children are both `'()`.
- Mismatched or extra parentheses. Count them before answering.
- (S2) Treating `'()` as an atom by testing only `pair?`. A list element is anything
  where `(or (null? e) (pair? e))` is true.
- (S2) Measuring a list's length after inserting into it. It must be the original length.
- (S2) Leaving two definitions of `insert-if-short`. The final file has exactly one,
  built with `make-inserter`.
- (S2) Printing a prompt or any extra text in `print-insert-result`.

## 7. Line endings
- Files may be edited on Windows (CRLF) and macOS (LF). Racket accepts both.
- Never save `.rkt` files with a UTF-8 BOM.
