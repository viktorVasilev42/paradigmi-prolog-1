permutacii_inner([], []).
permutacii_inner([H|T], L) :-
    permutacii_inner(T, PT),
    my_insert(H, PT, L).

my_insert(X, L, [X|L]).
my_insert(X, [H|T], [H|T1]) :-
    my_insert(X, T, T1).

permutacii(L1, L2) :-
    findall(X, permutacii_inner(L1, X), L2).
