:- use_module(library(lists)).

% split_nonempty(+List, -Left, -Right)
% Declarative reading: Left and Right are two non-empty lists whose
% concatenation (in this order) is List. Each solution is one split
% point j with 1 =< j < length(List).
% Fails for [] and one-element lists, since no split leaves both parts non-empty.
split_nonempty(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).
