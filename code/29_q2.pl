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

% tree_string(+Tree, -String)
% Declarative reading: String is the canonical, space-free text of Tree.
% A number is written in decimal. A tree op(Op, L, R) is the text of L,
% then Op, then the text of R, where L is parenthesised only if its top
% precedence is lower than Op's, and R is parenthesised if its top
% precedence is the same as or lower than Op's (left associativity).
tree_string(N, S) :-
    integer(N),
    number_string(N, S).
tree_string(op(Op, L, R), S) :-
    prec(Op, P),
    tree_prec(L, PL),
    tree_prec(R, PR),
    tree_string(L, SL0),
    tree_string(R, SR0),
    (   PL < P  -> paren(SL0, SL) ; SL = SL0 ),
    (   PR =< P -> paren(SR0, SR) ; SR = SR0 ),
    format(string(S), "~w~w~w", [SL, Op, SR]).

% paren(+S0, -S)
% Declarative reading: S is the string S0 enclosed in parentheses.
paren(S0, S) :-
    format(string(S), "(~w)", [S0]).

% equation(+List, -Eq)
% Declarative reading: Eq is the string "L=R" where L is the canonical text
% of an expression tree over a non-empty prefix of List, R is the canonical
% text of an expression tree over the remaining non-empty suffix, and both
% trees have the same integer value.
equation(List, Eq) :-
    split_nonempty(List, Left, Right),
    expr(Left, LT, V),
    expr(Right, RT, V),
    tree_string(LT, LS),
    tree_string(RT, RS),
    format(string(Eq), "~w=~w", [LS, RS]).

% generate_equation(+List, ?Equation)
% Declarative reading: Equation is a valid equation for List (the first
% one found by equation/2). Fails if List has no valid equation,
% including when List has fewer than two numbers.
generate_equation(List, Equation) :-
    once(equation(List, Equation)).

% all_equations(+List, -Equations)
% Declarative reading: Equations is the list of all valid equations for
% List, without duplicates, in standard order of terms; [] if there is none.
all_equations(List, Equations) :-
    findall(Eq, equation(List, Eq), Eqs),
    sort(Eqs, Equations).

% count_equations(+List, -N)
% Declarative reading: N is the number of distinct valid equations for List.
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).
