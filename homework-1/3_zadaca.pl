br_elementi([], 0).
br_elementi([_ | L1], N) :-
    br_elementi(L1, M),
    N is M + 1.

is_even(0) :- !.
is_even(N) :-
    N > 0,
    M is N - 1,
    is_odd(M).

is_odd(1) :- !.
is_odd(N) :-
    N > 0,
    M is N - 1,
    is_even(M).

dva_ili_poveke_el(L1) :-
    br_elementi(L1, BrL1),
    BrL1 >= 2.

naizmenicnost([_], _) :- !.
naizmenicnost([X, Y | L1], Indeks) :-
    is_even(Indeks),
    !,
    X > Y,
    NovIndeks is Indeks + 1,
    naizmenicnost([Y | L1], NovIndeks).
% ovde sigg indeks e odd
naizmenicnost([X, Y | L1], Indeks) :-
    is_odd(Indeks),
    !,
    X < Y,
    NovIndeks is Indeks + 1,
    naizmenicnost([Y | L1], NovIndeks).


proveri(L1) :-
    br_elementi(L1, BrL1),
    BrL1 >= 2,
    naizmenicnost(L1, 1).
