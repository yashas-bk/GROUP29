# P1 Report: Department Assignment Puzzle, Reloaded (Group 29)

## Value of N

```
?- count_solutions([1,2,3,4,5,6,7,8], N).
N = 3.
```

`solution/1` generates all 4! × 4! × 4! = 13824 candidate assignments, and only **3** of them satisfy all of clues 1–8:

| # | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

## What N = 3 tells us about the puzzle

The puzzle as given is **under-constrained**: clues 1–8 do not determine a unique answer. They fix Ben completely (development, javascript, web) and fix which attributes go together in every solution (Java goes with design, Python with testing, C++ with research and data). They do not fully decide who gets which of the remaining combinations, or which of them gets AI and which gets embedded. So `main/0` (P1.a) can only print *one* valid solution (the first one found, solution 1), not *the* solution.

Solutions 1 and 3 use exactly the same four (department, language, project) combinations:
(design, java, AI), (development, javascript, web), (research, c++, data) and (testing, python, embedded).
Only the names attached to them differ. A clue that cannot mention names can only talk about these combinations, so it is either true for both solutions 1 and 3 or false for both. Therefore no name-free clue can keep solution 1 or solution 3 alone. **Solution 2 is the only solution a ninth clue can single out.**

## Clue 9

```prolog
% CLUE 9: The friend who prefers the AI project likes Python.
clue(9, S) :-
    member(p(_, _, python, 'AI'), S).
```

- In solution 2, the AI project belongs to Carla, who likes Python, so the clue is **true**.
- In solutions 1 and 3, the AI project belongs to a Java user, so the clue is **false**.

It refers to the friend only through attribute values (as clue 5 does), never by name, and it is a fact about the kept solution, not something true of every solution. With it:

```
?- count_solutions([1,2,3,4,5,6,7,8,9], N).
N = 1.
```

The unique solution is:

```
Alex  = [design, java, embedded]
Ben   = [development, javascript, web]
Carla = [testing, python, AI]
Dana  = [research, c++, data]
```

All of the above is checked by `tests/test_q1.pl`.
