my_concat([], L2, L2).
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).


br_el([], 0).
br_el([_ | L1], N) :-
    br_el(L1, M),
    N is M + 1.


zemi_prv_el([X | _], X).


zemi_posledna_podlista([X], X) :- !.
zemi_posledna_podlista([_ | L1], X) :-
    zemi_posledna_podlista(L1, X).


% permutiraj_so_el(L1, SoFarList, ResultList, X)
permutiraj_so_el([X], SoFarList, [NewAppend], X) :-
    my_concat(SoFarList, [X], NewAppend),
    !.
permutiraj_so_el([X, Y | L1], [], ResultList, X) :-
    permutiraj_so_el([Y, X | L1], [], ResultList, X),
    !.
permutiraj_so_el([X, Y | L1], SoFarList, [NewAppend | ResultList], X) :-
    my_concat(SoFarList, [X, Y | L1], NewAppend),
    permutiraj_so_el([Y, X | L1], SoFarList, ResultList, X),
    !.
permutiraj_so_el([Y | L1], SoFarList, ResultList, X) :-
    my_concat(SoFarList, [Y], NewSoFarList),
    permutiraj_so_el(L1, NewSoFarList, ResultList, X).


flat_list([], []).
flat_list([X | L1], L2) :-
    my_concat(X, Rest, L2),
    flat_list(L1, Rest).

flatten_one_level([], []).
flatten_one_level([X | XS], Result) :-
    append(X, Rest, Result),
    flatten_one_level(XS, Rest).


permutacii_inner(L1, [ResultSoPrv | L2], N) :-
    br_el(L1, BrL1),
    N =< BrL1,
    !,
    zemi_prv_el(L1, PrvVoL1),
    permutiraj_so_el(L1, [], ResultSoPrv, PrvVoL1),
    zemi_posledna_podlista(ResultSoPrv, PoslednaPodlistaOdResultSoPrv),
    NewN is N + 1,
    permutacii_inner(PoslednaPodlistaOdResultSoPrv, L2, NewN).

permutacii_inner(L1, [], N).

permutacii(L1, AllPermutations) :-
    permutacii_inner(L1, L2, 1),
    flat_list(L2, AllPermutations).
