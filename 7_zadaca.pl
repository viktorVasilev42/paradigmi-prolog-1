br_el([], 0).
br_el([_ | L1], N) :-
    br_el(L1, M),
    N is M + 1.

my_concat([], L2, L2).
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).


najdi_prednost_koga_ista_golemina([X | L1], [X | L2], Result, OgL1, OgL2) :-
    !,
    najdi_prednost_koga_ista_golemina(L1, L2, Result, OgL1, OgL2).

najdi_prednost_koga_ista_golemina([X | _], [Y | _], OgL1, OgL1, _) :-
    X > Y,
    !.

najdi_prednost_koga_ista_golemina([_ | _], [_ | _], OgL2, _, OgL2).


izbrishi_podlista([], _, []).
izbrishi_podlista([X | L1], ToDelete, Result) :-
    X = ToDelete,
    !,
    izbrishi_podlista(L1, ToDelete, Result).
izbrishi_podlista([X | L1], ToDelete, [X | Result]) :-
    izbrishi_podlista(L1, ToDelete, Result).


najdi_najgolema_podlista([], CurrMax, CurrMax) :- !.

najdi_najgolema_podlista([X | L1], CurrMax, Result) :-
    br_el(X, BrX),
    br_el(CurrMax, BrCurrMax),
    BrX > BrCurrMax,
    !,
    najdi_najgolema_podlista(L1, X, Result).

najdi_najgolema_podlista([_ | L1], CurrMax, Result) :-
    najdi_najgolema_podlista(L1, CurrMax, Result).

transform([], []) :- !.

transform(L1, [NajgolemaVoL1 | L2]) :-
    najdi_najgolema_podlista(L1, [], NajgolemaVoL1),
    izbrishi_podlista(L1, NajgolemaVoL1, L1BezNajgolema),
    najdi_najgolema_podlista(L1BezNajgolema, [], SlednaNajgolema),
    NajgolemaVoL1 = SlednaNajgolema,
    !,
    izbrishi_podlista(L1BezNajgolema, SlednaNajgolema, L1BezDveteNajgolemi),
    transform(L1BezDveteNajgolemi, L2).

transform(L1, [Pob | L2]) :-
    najdi_najgolema_podlista(L1, [], NajgolemaVoL1),
    izbrishi_podlista(L1, NajgolemaVoL1, L1BezNajgolema),
    najdi_najgolema_podlista(L1BezNajgolema, [], SlednaNajgolema),
    br_el(NajgolemaVoL1, BrNajgolemaVoL1),
    br_el(SlednaNajgolema, BrSlednaNajgolema),
    BrNajgolemaVoL1 = BrSlednaNajgolema,
    !,
    najdi_prednost_koga_ista_golemina(NajgolemaVoL1, SlednaNajgolema, Pob, NajgolemaVoL1, SlednaNajgolema),
    izbrishi_podlista(L1, Pob, L1BezPob),
    transform(L1BezPob, L2).

transform(L1, [NajgolemaVoL1 | L2]) :-
    najdi_najgolema_podlista(L1, [], NajgolemaVoL1),
    izbrishi_podlista(L1, NajgolemaVoL1, L1BezNajgolema),
    transform(L1BezNajgolema, L2).
    
