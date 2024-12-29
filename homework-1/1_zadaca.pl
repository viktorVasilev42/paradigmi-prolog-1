neparen_broj_el([_]) :- !.
neparen_broj_el([_, _ | L1]) :-
    neparen_broj_el(L1).

zemi_posleden([X], X) :- !.
zemi_posleden([_ | L1], P) :-
    zemi_posleden(L1, P).

trgni_posleden([_], []) :- !.
trgni_posleden([X | L1], [X | L2]) :-
    trgni_posleden(L1, L2).

palindrom([]) :- !.
palindrom([_]) :- !.
palindrom([X | L1]) :-
    zemi_posleden(L1, PosledenVoL1),
    X = PosledenVoL1,
    trgni_posleden(L1, L1BezPosleden),
    palindrom(L1BezPosleden).

neparen_palindrom(L1) :-
    neparen_broj_el(L1),
    palindrom(L1).
