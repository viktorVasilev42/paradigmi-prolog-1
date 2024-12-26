br_elementi([], 0).
br_elementi([X | L1], N) :-
    br_elementi(L1, M),
    N is M + 1.


prefiks(_, []) :- !.
prefiks([X | L1], [X | L2]) :-
    prefiks(L1, L2).


kolku_pati_podniza([], _, 0) :- !.
kolku_pati_podniza([X | L1], L2, N) :-
    prefiks([X | L1], L2),
    !,
    kolku_pati_podniza(L1, L2, M),
    N is M + 1.
kolku_pati_podniza([_ | L1], L2, N) :-
    kolku_pati_podniza(L1, L2, N).


zemi_prvi_n_el(_, 0, []) :- !.
zemi_prvi_n_el([X | L1], N, [X | L2]) :-
    M is N - 1,
    zemi_prvi_n_el(L1, M, L2).


koja_podniza_poveke_ja_ima(Niza, Podniza1, Podniza2, Resenie) :-
    kolku_pati_podniza(Niza, Podniza1, N1),
    kolku_pati_podniza(Niza, Podniza2, N2),
    N1 >= N2,
    !,
    Resenie = Podniza1.
koja_podniza_poveke_ja_ima(Niza, Podniza1, Podniza2, Resenie) :-
    Resenie = Podniza2.


naj_podniza(L1, N, [null]) :-
    br_elementi(L1, BrL1),
    BrL1 < N,
    !.

naj_podniza([X | L1], N, L2) :-
    zemi_prvi_n_el([X | L1], N, Podniza1),
    naj_podniza(L1, N, Podniza2),
    koja_podniza_poveke_ja_ima([X | L1], Podniza1, Podniza2, L2).

