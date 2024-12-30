permutacii_inner([], []).
permutacii_inner([X | L1], L2) :-
    permutacii_inner(L1, PermL1),
    my_insert(X, PermL1, L2).

my_insert(X, L1, [X | L1]).
my_insert(X, [Y | L1], [Y | L2]) :-
    my_insert(X, L1, L2).

permutacii(L1, L2) :-
    findall(X, permutacii_inner(L1, X), L2).


