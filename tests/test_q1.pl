% Tests for P1 (code/29_q1.pl) - Group 29
% Run from the repo root:
%   swipl -q -g run_tests -t halt tests/test_q1.pl

:- use_module(library(plunit)).
:- consult('../code/29_q1').

% The unique solution kept by clues 1-9.
unique_solution([p('Alex',  design,      java,       embedded),
                 p('Ben',   development, javascript, web),
                 p('Carla', testing,     python,     'AI'),
                 p('Dana',  research,    'c++',      data)]).

% The two solutions removed by clue 9.
removed_solution([p('Alex',  design,      java,       'AI'),
                  p('Ben',   development, javascript, web),
                  p('Carla', research,    'c++',      data),
                  p('Dana',  testing,     python,     embedded)]).
removed_solution([p('Alex',  testing,     python,     embedded),
                  p('Ben',   development, javascript, web),
                  p('Carla', design,      java,       'AI'),
                  p('Dana',  research,    'c++',      data)]).

:- begin_tests(generator).

test(candidate_count) :-
    aggregate_all(count, solution(_), 13824).

test(names_in_order, [nondet]) :-
    solution([p('Alex',_,_,_), p('Ben',_,_,_), p('Carla',_,_,_), p('Dana',_,_,_)]).

:- end_tests(generator).

:- begin_tests(clues).

test(all_clues_hold_on_unique_solution, [forall(between(1, 9, K))]) :-
    unique_solution(S),
    once(clue(K, S)).

test(clues_1_to_8_hold_on_removed_solutions,
     [forall((removed_solution(S), between(1, 8, K)))]) :-
    once(clue(K, S)).

test(clue_9_rejects_removed_solutions, [forall(removed_solution(S))]) :-
    \+ clue(9, S).

% Clue 3 is violated when the tester does not like Python.
test(clue_3_negative, [fail]) :-
    clue(3, [p('Alex', testing, java, 'AI'), p('Ben', design, python, web),
             p('Carla', research, 'c++', data), p('Dana', development, javascript, embedded)]).

% Clue 7 is violated when Dana works in development.
test(clue_7_negative, [fail]) :-
    clue(7, [p('Alex', research, java, 'AI'), p('Ben', design, python, web),
             p('Carla', testing, 'c++', data), p('Dana', development, javascript, embedded)]).

:- end_tests(clues).

:- begin_tests(counts).

test(no_clues)       :- count_solutions([], 13824).
test(clues_1_to_8)   :- count_solutions([1,2,3,4,5,6,7,8], 3).
test(clues_1_to_9)   :- count_solutions([1,2,3,4,5,6,7,8,9], 1).
test(order_irrelevant) :- count_solutions([8,7,6,5,4,3,2,1], 3).
test(clue_3_only)    :- count_solutions([3], 3456).
test(clue_4_only)    :- count_solutions([4], 2592).
test(clue_5_only)    :- count_solutions([5], 3456).
test(clue_7_only)    :- count_solutions([7], 5184).
test(clues_4_and_8)  :- count_solutions([4,8], 432).

test(unique_solution_is_the_kept_one, [true(S == Expected)]) :-
    unique_solution(Expected),
    once(( solution(S), forall(between(1, 9, K), clue(K, S)) )).

:- end_tests(counts).

:- begin_tests(main_output).

test(exact_output, [true(Out == Expected)]) :-
    with_output_to(string(Out), main),
    Expected = "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n".

test(succeeds_once, [true(N == 1)]) :-
    aggregate_all(count, with_output_to(string(_), main), N).

:- end_tests(main_output).
