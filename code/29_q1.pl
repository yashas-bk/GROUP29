:- use_module(library(lists)).
:- use_module(library(aggregate)).

%% solution(-S)
%  S is a candidate assignment: a list of four p(Name, Dept, Lang, Project)
%  terms in the order Alex, Ben, Carla, Dana, where the departments, the
%  languages and the projects are each a permutation of their four values.
%  No clues are applied here, so on backtracking this enumerates all
%  4! * 4! * 4! = 13824 candidates. Clues are checked separately by clue/2.
solution([p('Alex',  D1, L1, P1),
          p('Ben',   D2, L2, P2),
          p('Carla', D3, L3, P3),
          p('Dana',  D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],       [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],              [P1, P2, P3, P4]).

%% clue(+N, +S)
%  Clue number N holds in the fully instantiated candidate S.
%  S is always ground when clue/2 is called (it comes from solution/1),
%  so the negations (\=, \+) below compare concrete atoms and are safe.

% CLUE 1: The friend who prefers the AI project does not work in research
%         and is not Dana.
clue(1, S) :-
    member(p(Name, Dept, _, 'AI'), S),
    Dept \= research,
    Name \= 'Dana'.

% CLUE 2: Alex does not work in development and does not prefer C++.
clue(2, S) :-
    member(p('Alex', Dept, Lang, _), S),
    Dept \= development,
    Lang \= 'c++'.

% CLUE 3: The friend working in the testing department likes Python.
clue(3, S) :-
    member(p(_, testing, python, _), S).

% CLUE 4: Ben prefers web projects and does not work in testing.
clue(4, S) :-
    member(p('Ben', Dept, _, web), S),
    Dept \= testing.

% CLUE 5: The friend whose favorite language is Java works in the design
%         department.
clue(5, S) :-
    member(p(_, design, java, _), S).

% CLUE 6: Carla's project preference is not embedded, and her department is
%         not development.
clue(6, S) :-
    member(p('Carla', Dept, _, Proj), S),
    Proj \= embedded,
    Dept \= development.

% CLUE 7: Dana's favorite language is not Java, and she works in research
%         or testing.
clue(7, S) :-
    member(p('Dana', Dept, Lang, _), S),
    Lang \= java,
    memberchk(Dept, [research, testing]).

% CLUE 8: The friend who prefers data projects works in research and does
%         not use JavaScript.
clue(8, S) :-
    member(p(_, research, Lang, data), S),
    Lang \= javascript.

% CLUE 9: The friend who prefers the AI project likes Python.
clue(9, S) :-
    member(p(_, _, python, 'AI'), S).

%% main
%  Finds the first candidate from solution/1 that satisfies every clue
%  1..8 and prints one line per friend, in the order Alex, Ben, Carla,
%  Dana, as "Name = [Dept, Lang, Project]". The answer is derived from
%  the clues, never hard-coded. ~w writes atoms without quotes, so 'c++'
%  prints as c++ and 'AI' as AI.
main :-
    once(( solution(S),
           forall(between(1, 8, K), clue(K, S)) )),
    forall(member(p(Name, Dept, Lang, Proj), S),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Proj])).

%% count_solutions(+Active, -N)
%  N is the number of candidates from solution/1 that satisfy every clue
%  whose number is in Active. Clues not in Active are ignored, so
%  count_solutions([], N) gives N = 13824 (all candidates).
count_solutions(Active, N) :-
    aggregate_all(count,
                  ( solution(S),
                    forall(member(K, Active), clue(K, S)) ),
                  N).
