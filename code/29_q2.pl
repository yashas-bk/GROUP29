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

% op_symbol(?Op)
% Declarative reading: Op is one of the four binary arithmetic operators,
% enumerated in the order + - * /.
op_symbol(+).
op_symbol(-).
op_symbol(*).
op_symbol(/).

% apply_op(+Op, +A, +B, -V)
% Declarative reading: V is the integer obtained by applying operator Op
% to integers A and B. For / this holds only when B is non-zero and B
% divides A exactly; otherwise there is no such V and the goal fails
% (it never raises an error).
apply_op(+, A, B, V) :- V is A + B.
apply_op(-, A, B, V) :- V is A - B.
apply_op(*, A, B, V) :- V is A * B.
apply_op(/, A, B, V) :-
    B =\= 0,
    A mod B =:= 0,
    V is A // B.
