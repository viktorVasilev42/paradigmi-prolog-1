my_concat([], L2, L2) :- !.
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).

br_el([], 0).
br_el([_ | L1], N) :-
    br_el(L1, M),
    N is M + 1.

soberi_basic([], [], []) :- !.

soberi_basic(L1, [Y | L2], [Y | L3]) :-
    br_el(L1, BrL1),
    br_el([Y | L2], BrL2),
    BrL1 < BrL2,
    !,
    soberi_basic(L1, L2, L3).

soberi_basic([X | L1], L2, [X | L3]) :-
    br_el([X | L1], BrL1),
    br_el(L2, BrL2),
    BrL1 > BrL2,
    !,
    soberi_basic(L1, L2, L3).

soberi_basic([X | L1], [Y | L2], [Z | L3]) :-
    Z is X + Y,
    soberi_basic(L1, L2, L3).


index_na_posledna_2_ili_3(List, Index) :-
    reverse(List, Reversed),
    nth0(ReverseIndex, Reversed, Element),
    (Element = 2; Element = 3), !,
    length(List, Length),
    Index is Length - ReverseIndex - 1.

reshi_2_ili_3(2, 0).
reshi_2_ili_3(3, 1).


reshi_na_indeks([X | L1], 0, SoFarList, Result) :-
    !,
    reshi_2_ili_3(X, NewX),
    my_concat([1, NewX], L1, Result).

reshi_na_indeks([X, Y | L1], 1, SoFarList, Result) :-
    !,
    reshi_2_ili_3(Y, NewY),
    NewX is X + 1,
    my_concat(SoFarList, [NewX, NewY | L1], Result).

reshi_na_indeks([X | L1], N, SoFarList, Result) :-
    NewN is N - 1,
    my_concat(SoFarList, [X], NewSoFarList),
    reshi_na_indeks(L1, NewN, NewSoFarList, Result).


reshi_result(L1, ResultList) :-
    index_na_posledna_2_ili_3(L1, IndexDvaTriL1),
    !,
    reshi_na_indeks(L1, IndexDvaTriL1, [], PodreshenaL1),
    reshi_result(PodreshenaL1, ResultList).

% ako nema veke 2ki i 3ki
reshi_result(L1, L1).


sobiranje(L1, L2, FinalSum) :-
    soberi_basic(L1, L2, BasicSum),
    reshi_result(BasicSum, FinalSum).
