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

% expr(+Nums, -Tree, -Value)
% Declarative reading: Tree is an expression tree over the numbers of Nums,
% each used exactly once and in order, and Value is its integer value.
% A single number N is the tree N with value N. Otherwise Nums is split
% into two non-empty parts, each part forms a sub-tree, and the two
% sub-trees are joined by an operator whose application is defined
% (so every division at every depth is exact with a non-zero divisor).
expr([N], N, N).
expr(Nums, op(Op, LT, RT), V) :-
    split_nonempty(Nums, LNums, RNums),
    expr(LNums, LT, LV),
    expr(RNums, RT, RV),
    op_symbol(Op),
    apply_op(Op, LV, RV, V).

% prec(?Op, ?P)
% Declarative reading: P is the precedence of operator Op;
% + and - have precedence 1, * and / bind tighter with precedence 2.
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

% tree_prec(+Tree, -P)
% Declarative reading: P is the precedence of the top of Tree. A tree
% op(Op,_,_) has the precedence of Op; a single number has precedence 3,
% higher than any operator, so it never needs parentheses.
tree_prec(op(Op, _, _), P) :- prec(Op, P).
tree_prec(N, 3) :- integer(N).
