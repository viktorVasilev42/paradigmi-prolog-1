ime(teo).
ime(mira).
ime(bruno).
ime(igor).

hrana(sendvich).
hrana(pita).
hrana(hamburger).
hrana(pica).

hobi(krstozbori).
hobi(pishuvanje).
hobi(chitanje).
hobi(fotografija).

maica(bela).
maica(zolta).
maica(sina).
maica(crvena).

devojka(mira).


se_sosedi(X, Y, [X, Y | _]).
se_sosedi(X, Y, [Y, X | _]).
se_sosedi(X, Y, [_ | L1]) :-
    se_sosedi(X, Y, L1).

predikat1([(teo, sendvich, _, _) | _]).
predikat2(L1) :- member((mira, pita, krstozbori, _), L1).
predikat3(L1) :- devojka(Ime), member((Ime, _, _, bela), L1).
predikat4(L1) :- member((bruno, _, _, zolta), L1).
predikat5(L1) :- member((_, hamburger, pishuvanje, _), L1).
predikat6(L1) :- se_sosedi((teo, _, _, _), (_, pita, _, _), L1).
predikat7(L1) :- se_sosedi((bruno, _, _, _), (_, pica, _, _), L1).
predikat8(L1) :- se_sosedi((_, _, _, bela), (_, pica, _, _), L1).
predikat9(L1) :- member((igor, _, chitanje, _), L1).
predikat10(L1) :- devojka(Ime), se_sosedi((Ime, _, _, _), (_, _, _, sina), L1).

% kombiniraj chetiri tuples chii elementi
% se site razlicni megjusebno.
% ova zaedno so predikatite ni pomaga
% da gi najdeme resenijata
site_kombinacii(L) :-
    findall((Ime, Hrana, Hobi, Maica), (
        ime(Ime),
        hrana(Hrana),
        hobi(Hobi),
        maica(Maica)
    ), AllPossible),
    pick_unique(AllPossible, 4, L).

% najdi N posebni kombinacii od Possible listata
% i proveri deka ni eden od atributite Ime, Hrana,
% Hobi, Maica ne se povtoruva
pick_unique(_, 0, []).
pick_unique(Possible, N, [(Ime, Hrana, Hobi, Maica) | Rest]) :-
    N > 0,
    select((Ime, Hrana, Hobi, Maica), Possible, Remaining),
    exclude_conflicts((Ime, Hrana, Hobi, Maica), Remaining, Filtered),
    N1 is N - 1,
    pick_unique(Filtered, N1, Rest).

% dokolku ima konflikt so momentalniot tuple
% filtriraj od Candidates
exclude_conflicts((Ime, Hrana, Hobi, Maica), Candidates, Filtered) :-
    exclude(conflict((Ime, Hrana, Hobi, Maica)), Candidates, Filtered).

% proverka za konflikt
conflict((Ime1, Hrana1, Hobi1, Maica1), (Ime2, Hrana2, Hobi2, Maica2)) :-
    Ime1 = Ime2;
    Hrana1 = Hrana2;
    Hobi1 = Hobi2;
    Maica1 = Maica2.

reshenie(L) :-
    site_kombinacii(L),
    predikat1(L),
    predikat2(L),
    predikat3(L),
    predikat4(L),
    predikat5(L),
    predikat6(L),
    predikat7(L),
    predikat8(L),
    predikat9(L),
    predikat10(L).
