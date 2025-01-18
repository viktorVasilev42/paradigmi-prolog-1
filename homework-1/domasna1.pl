% shared utils

my_concat([], L2, L2) :- !.
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).

br_el([], 0).
br_el([_ | L1], N) :-
    br_el(L1, M),
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


% ===========================================
% 1 zadaca

% proveri dali lista ima neparen broj elementi
neparen_broj_el([_]) :- !.
neparen_broj_el([_, _ | L1]) :-
    neparen_broj_el(L1).

% zemi posleden element na lista
zemi_posleden([X], X) :- !.
zemi_posleden([_ | L1], P) :-
    zemi_posleden(L1, P).

% izbrishi posleden element na lista
trgni_posleden([_], []) :- !.
trgni_posleden([X | L1], [X | L2]) :-
    trgni_posleden(L1, L2).

% proveri dali listata e palindrom
palindrom([]) :- !.
palindrom([_]) :- !.
palindrom([X | L1]) :-
    zemi_posleden(L1, PosledenVoL1),
    X = PosledenVoL1,
    trgni_posleden(L1, L1BezPosleden),
    palindrom(L1BezPosleden).

% proveri dali listata e palindrom i ima
% neparen broj na elementi
neparen_palindrom(L1) :-
    neparen_broj_el(L1),
    palindrom(L1).


% ===========================================
% 2 zadaca

% proveri dali vtorata lista e prefiks na prvata
prefiks(_, []) :- !.
prefiks([X | L1], [X | L2]) :-
    prefiks(L1, L2).


% kolku pati vtorata lista se pojavuva kako
% podlista an prvata lista
kolku_pati_podniza([], _, 0) :- !.
kolku_pati_podniza([X | L1], L2, N) :-
    prefiks([X | L1], L2),
    !,
    kolku_pati_podniza(L1, L2, M),
    N is M + 1.
kolku_pati_podniza([_ | L1], L2, N) :-
    kolku_pati_podniza(L1, L2, N).

% zemi prvi n elementi od lista
zemi_prvi_n_el(_, 0, []) :- !.
zemi_prvi_n_el([X | L1], N, [X | L2]) :-
    M is N - 1,
    zemi_prvi_n_el(L1, M, L2).

% koja podlista (vtor ili tret parametar) se pojavuva
% poveke pati vo prvata lista (prv parametar)
% kako Resenie se vraka celata lista sto ja ima poveke
koja_podniza_poveke_ja_ima(Niza, Podniza1, Podniza2, Resenie) :-
    kolku_pati_podniza(Niza, Podniza1, N1),
    kolku_pati_podniza(Niza, Podniza2, N2),
    N1 >= N2,
    !,
    Resenie = Podniza1.
koja_podniza_poveke_ja_ima(_, _, Podniza2, Resenie) :-
    Resenie = Podniza2.


% naoganje podlista so dolzina N koja se pojavuva najmnogu
% pati vo vleznata lista
naj_podniza(L1, N, [null]) :-
    br_el(L1, BrL1),
    BrL1 < N,
    !.

naj_podniza([X | L1], N, L2) :-
    zemi_prvi_n_el([X | L1], N, Podniza1),
    naj_podniza(L1, N, Podniza2),
    koja_podniza_poveke_ja_ima([X | L1], Podniza1, Podniza2, L2).


% ===========================================
% 3 zadaca

% dali lista ima dva ili poveke elementi
dva_ili_poveke_el(L1) :-
    br_el(L1, BrL1),
    BrL1 >= 2.

% proveruvanje na svojstvoto za naizmenicnost po golemina
% primer: za lista [1,5,2,4] deka vazi
% 5 > 1; 2 < 5; 4 > 2; ... itn...
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


% glavna proverka za brojot na clenovi i
% za naizmenicnosta
proveri(L1) :-
    br_el(L1, BrL1),
    BrL1 >= 2,
    naizmenicnost(L1, 1).


% ===========================================
% 4 zadaca


permutacii_inner([], []).
permutacii_inner([X | L1], L2) :-
    permutacii_inner(L1, PermL1),
    my_insert(X, PermL1, L2).

my_insert(X, L1, [X | L1]).
my_insert(X, [Y | L1], [Y | L2]) :-
    my_insert(X, L1, L2).

permutacii(L1, L2) :-
    findall(X, permutacii_inner(L1, X), L2).


% ===========================================
% 5 zadaca

% sobiranje site cifri kako vo dekaden sistem
% primer:
% 101101
% 110101
% -------
% 211202
%
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

% najdi go indexot na poslednata dvojka (2)
% ili trojka (3) vo listata
index_na_posledna_2_ili_3(List, Index) :-
    reverse(List, Reversed),
    nth0(ReverseIndex, Reversed, Element),
    (Element = 2; Element = 3), !,
    length(List, Length),
    Index is Length - ReverseIndex - 1.

% 2kite ke se zamenuvaat so nuli
% 3kite ke se zamenuvaat so edinici
%
% ova se sluchuva i se "prefrla" edinica
% na cifrata kon levo
reshi_2_ili_3(2, 0).
reshi_2_ili_3(3, 1).

% reshi ja 2kata ili 3kata sto se naoga na daden
% indeks taka sto ke se zameni so 0 ili 1, a
% edinica ke se prefrli (dodade) na cifrata kon levo
reshi_na_indeks([X | L1], 0, _, Result) :-
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

% reshi go celiot broj koj go dobivame kako rezultat
% na soberi_basic/3
reshi_result(L1, ResultList) :-
    index_na_posledna_2_ili_3(L1, IndexDvaTriL1),
    !,
    reshi_na_indeks(L1, IndexDvaTriL1, [], PodreshenaL1),
    reshi_result(PodreshenaL1, ResultList).
% ako nema veke 2ki i 3ki
reshi_result(L1, L1).

% finalniot predikat za koristenje
sobiranje(L1, L2, FinalSum) :-
    soberi_basic(L1, L2, BasicSum),
    reshi_result(BasicSum, FinalSum).


% ===========================================
% 6 zadaca

% transpose na matrica
transpose([], []).
transpose([[] | _], []) :- !.
transpose(Matrix, [Column | Rest]) :-
    extract_column(Matrix, Column, RemainingMatrix),
    transpose(RemainingMatrix, Rest).

% vadenje edincna kolona od matrica koja
% ke se pretvori vo red, za potoa da moze
% da se povika transpose rekurzivno
extract_column([], [], []).
extract_column([[Element | RestRow] | Rows], [Element | Column], [RestRow | RemainingMatrix]) :-
    extract_column(Rows, Column, RemainingMatrix).

% mnozenje na matrici
matrix_multiply(A, B, Result) :-
    transpose(B, BTransposed),
    multiply_rows(A, BTransposed, Result).

% mnozenje redici na ednata matrica so kolonite na drugata
multiply_rows([], _, []).
multiply_rows([Row | RestRows], BTransposed, [ResultRow | RestResultRows]) :-
    multiply_row(Row, BTransposed, ResultRow),
    multiply_rows(RestRows, BTransposed, RestResultRows), !.

% mnozenje edna redica na ednata matrica so kolona od drugata
multiply_row(_, [], []).
multiply_row(Row, [Column | RestColumns], [Product | RestProducts]) :-
    dot_product(Row, Column, Product),
    multiply_row(Row, RestColumns, RestProducts), !.

% najdi dot product na dve listi
dot_product([], [], 0).
dot_product([X | Xs], [Y | Ys], Product) :-
    dot_product(Xs, Ys, RestProduct),
    Product is X * Y + RestProduct.

% finalen predikat za koristenje
presmetaj(L1, L2) :-
    transpose(L1, TransposedL1),
    matrix_multiply(L1, TransposedL1, L2).


% ===========================================
% 7 zadaca

% najdi koja lista ima prednost koga dve listi (param 1 i param 2)
% imaat ista golemina.
najdi_prednost_koga_ista_golemina([X | L1], [X | L2], Result, OgL1, OgL2) :-
    !,
    najdi_prednost_koga_ista_golemina(L1, L2, Result, OgL1, OgL2).
najdi_prednost_koga_ista_golemina([X | _], [Y | _], OgL1, OgL1, _) :-
    X > Y,
    !.
najdi_prednost_koga_ista_golemina([_ | _], [_ | _], OgL2, _, OgL2).

% izbrisi podlista (lista chlen) od
% parent lista (lista od listi)
izbrishi_podlista([], _, []).
izbrishi_podlista([X | L1], ToDelete, Result) :-
    X = ToDelete,
    !,
    izbrishi_podlista(L1, ToDelete, Result).
izbrishi_podlista([X | L1], ToDelete, [X | Result]) :-
    izbrishi_podlista(L1, ToDelete, Result).

% najdi podlista so najgolema dolzina vo parent lista
najdi_najgolema_podlista([], CurrMax, CurrMax) :- !.
najdi_najgolema_podlista([X | L1], CurrMax, Result) :-
    br_el(X, BrX),
    br_el(CurrMax, BrCurrMax),
    BrX > BrCurrMax,
    !,
    najdi_najgolema_podlista(L1, X, Result).
najdi_najgolema_podlista([_ | L1], CurrMax, Result) :-
    najdi_najgolema_podlista(L1, CurrMax, Result).


% finalen predikat za koristenje
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
    

