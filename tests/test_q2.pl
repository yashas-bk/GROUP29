% Tests for P2 (code/29_q2.pl).
% Run from the repository root:
%   swipl -q -f tests/test_q2.pl -g run -t halt
% Plain goals only (no plunit). Each test is a fact test(Name, Goal);
% run/0 executes every Goal inside catch/3, prints PASS/FAIL per test
% and a summary, and fails (exit status 1) if any test fails.

:- use_module(library(lists)).
:- use_module(library(apply)).
:- ensure_loaded('../code/29_q2.pl').

% ---------- helpers ----------

% fails_cleanly(:G): G has no solution and raises no error.
fails_cleanly(G) :-
    catch(\+ G, _, fail).

% all_strings(+L): every element of L is an SWI-Prolog string.
all_strings(L) :-
    maplist(string, L).

% sorted_no_dups(+L): L is strictly increasing in standard order,
% i.e. already sorted and without duplicates.
sorted_no_dups(L) :-
    sort(L, S),
    S == L.

% gen_is_valid(+List): generate_equation/2 gives exactly one answer,
% it is a string, and it is one of all_equations/2.
gen_is_valid(List) :-
    findall(E, generate_equation(List, E), [E]),
    string(E),
    all_equations(List, Es),
    memberchk(E, Es).

% ---------- assignment examples ----------

test(ex_4253_all,
     ( all_equations([4,2,5,3], Es),
       Es == ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3",
              "4=2*(5-3)","4=2+(5-3)","4=2+5-3"] )).
test(ex_4253_count,   count_equations([4,2,5,3], 7)).
test(ex_4253_gen,     gen_is_valid([4,2,5,3])).
test(ex_234_gen_fail, fails_cleanly(generate_equation([2,3,4], _))).
test(ex_234_all,      ( all_equations([2,3,4], Es), Es == [] )).
test(ex_234_count,    count_equations([2,3,4], 0)).
test(ex_248_all,      ( all_equations([2,4,8], Es), Es == ["2*4=8"] )).
test(ex_248_gen,      ( generate_equation([2,4,8], E), E == "2*4=8" )).

% ---------- lists of length 0 and 1 ----------

test(empty_gen_fail,  fails_cleanly(generate_equation([], _))).
test(empty_all,       ( all_equations([], Es), Es == [] )).
test(empty_count,     count_equations([], 0)).
test(single_gen_fail, fails_cleanly(generate_equation([5], _))).
test(single_all,      ( all_equations([5], Es), Es == [] )).
test(single_count,    count_equations([5], 0)).

% ---------- zeros: division by zero must fail silently ----------

test(zero_00_all,     ( all_equations([0,0], Es), Es == ["0=0"] )).
test(zero_400_all,    ( all_equations([4,0,0], Es), Es == ["4*0=0"] )).
test(zero_400_no_div, ( all_equations([4,0,0], Es),
                        \+ ( member(E, Es), sub_string(E, _, _, _, "/0") ) )).
test(zero_050_gen,    gen_is_valid([0,5,0])).
test(zero_no_error,   catch((all_equations([0,0,0,0], _), true), _, fail)).

% ---------- exact division ----------

test(exact_842_member, ( all_equations([8,4,2], Es), memberchk("8/4=2", Es) )).
test(exact_842_nested, ( all_equations([8,4,2], Es), memberchk("8=4*2", Es) )).
% 7//2 would be 3 by truncation, so "7/2=3" must NOT appear.
test(inexact_723_rejected, ( all_equations([7,2,3], Es),
                             \+ memberchk("7/2=3", Es) )).
test(inexact_723_none,     ( all_equations([7,2,3], Es), Es == [] )).
test(inexact_723_gen_fail, fails_cleanly(generate_equation([7,2,3], _))).

% ---------- result type, order, duplicates ----------

test(strings_4253,   ( all_equations([4,2,5,3], Es), all_strings(Es) )).
test(strings_12345,  ( all_equations([1,2,3,4,5], Es), all_strings(Es) )).
test(sorted_4253,    ( all_equations([4,2,5,3], Es), sorted_no_dups(Es) )).
test(sorted_12345,   ( all_equations([1,2,3,4,5], Es), sorted_no_dups(Es) )).
test(count_matches_length,
     ( all_equations([1,2,3,4,5], Es), length(Es, N),
       count_equations([1,2,3,4,5], N) )).
test(no_spaces,      ( all_equations([1,2,3,4,5], Es),
                       \+ ( member(E, Es), sub_string(E, _, _, _, " ") ) )).

% ---------- canonical parentheses (tree_string/2) ----------

test(paren_1, ( tree_string(op(*,op(+,4,2),3), S), S == "(4+2)*3" )).
test(paren_2, ( tree_string(op(+,4,op(*,2,3)), S), S == "4+2*3" )).
test(paren_3, ( tree_string(op(*,op(/,8,4),2), S), S == "8/4*2" )).
test(paren_4, ( tree_string(op(/,8,op(*,4,2)), S), S == "8/(4*2)" )).
test(paren_5, ( tree_string(op(-,op(-,1,2),3), S), S == "1-2-3" )).
test(paren_6, ( tree_string(op(-,1,op(-,2,3)), S), S == "1-(2-3)" )).
test(paren_7, ( tree_string(op(+,1,op(+,2,3)), S), S == "1+(2+3)" )).
test(paren_8, ( tree_string(op(+,op(+,1,2),3), S), S == "1+2+3" )).
test(paren_number, ( tree_string(7, S), S == "7" )).
test(paren_is_string, ( tree_string(op(*,op(+,4,2),3), S), string(S) )).
% Different trees must give different strings.
test(paren_injective,
     ( findall(S, (expr([1,2,3,4], T, _), tree_string(T, S)), Ss),
       length(Ss, N), sort(Ss, U), length(U, N) )).

% ---------- runner ----------

run :-
    findall(Name-Goal, test(Name, Goal), Tests),
    foldl(run_one, Tests, 0-0, Pass-Fail),
    Total is Pass + Fail,
    format("~nP2 tests: ~d/~d passed, ~d failed~n", [Pass, Total, Fail]),
    Fail =:= 0.

run_one(Name-Goal, P0-F0, P-F) :-
    (   catch(once(Goal), Err, (print_message(error, Err), fail))
    ->  format("PASS  ~w~n", [Name]), P is P0 + 1, F = F0
    ;   format("FAIL  ~w~n", [Name]), P = P0, F is F0 + 1
    ).
