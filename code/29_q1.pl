% CS F301 Assignment 2 - P1: Department Assignment Puzzle, Reloaded
% Group 29
% Run: swipl -q -f 29_q1.pl

:- use_module(library(lists)).

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
