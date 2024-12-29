lice(1,petko,petkovski,m,datum(1,3,1950),kratovo,skopje).
lice(2,marija,petkovska,z,datum(30,5,1954),kumanovo,skopje).
lice(3,ljubica,petkovska,z,datum(29,11,1965),skopje,skopje).
lice(4,vasil,vasilev,m,datum(8,4,1954),bitola,bitola).
lice(5,elena,vasileva,z,datum(19,6,1958),resen,bitola).
lice(6,krste,krstev,m,datum(9,8,1948),veles,veles).
lice(7,biljana,krsteva,z,datum(13,8,1949),veles,veles).
lice(8,igor,krstev,m,datum(26,10,1971),veles,skopje).
lice(9,kristina,krsteva,z,datum(30,5,1974),kumanovo,skopje).
lice(10,julija,petrova,z,datum(30,5,1978),skopje,skopje).
lice(11,bosko,petkovski,m,datum(13,11,1981),skopje,skopje).
lice(12,gjorgji,vasilev,m,datum(15,7,1978),bitola,bitola).
lice(13,katerina,petkovska,z,datum(11,12,1979),bitola,skopje).
lice(14,petar,vasilev,m,datum(21,2,1982),skopje,skopje).
lice(15,andrej,krstev,m,datum(3,8,1998),skopje,skopje).
lice(16,martina,petkovska,z,datum(5,12,2005),skopje,skopje).

familija(1,2,[9,10]).
familija(1,3,[11]).
familija(4,5,[12,13,14]).
familija(6,7,[8]).
familija(8,9,[15]).
familija(11,13,[16]).


lista_sodrzi([X | _], X) :- !.
lista_sodrzi([_ | L1], X) :-
    lista_sodrzi(L1, X).

my_concat([], L2, L2).
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).

den_vo_godina(Den, Mesec, Result) :-
    MesecIndex is Mesec - 1,
    TotalFromMesec is MesecIndex * 30,
    Result is TotalFromMesec + Den.

razlika_denovi(X, Y, Result) :-
    X >= Y,
    !,
    Result is X - Y.

razlika_denovi(X, Y, Result) :-
    Result is Y - X.


najdi_roditeli(Dete, Tatko, Majka) :-
    familija(Tatko, Majka, DecaVoFamilija),
    lista_sodrzi(DecaVoFamilija, Dete),
    !.


predci_basic(Sifra, [], _) :-
    \+ najdi_roditeli(Sifra, _, _),
    !.

predci_basic(Sifra, [Tatko | ListaPredci], Pocheten) :-
    lice(Pocheten, _, _, Rod, datum(Den, Mesec, _), _, _),
    najdi_roditeli(Sifra, Tatko, Majka),
    Rod = m,
    lice(Tatko, _, _, _, datum(TatkoDen, TatkoMesec, _), _, _),
    den_vo_godina(Den, Mesec, AbsDen),
    den_vo_godina(TatkoDen, TatkoMesec, TatkoAbsDen),
    razlika_denovi(AbsDen, TatkoAbsDen, Razlika),
    Razlika =< 7,
    !,
    predci_basic(Tatko, ListaPredciTatko, Pocheten),
    predci_basic(Majka, ListaPredciMajka, Pocheten),
    my_concat(ListaPredciTatko, ListaPredciMajka, ListaPredci).

predci_basic(Sifra, ListaPredci, Pocheten) :-
    lice(Pocheten, _, _, Rod, _, _, _),
    najdi_roditeli(Sifra, Tatko, Majka),
    Rod = m,
    !,
    predci_basic(Tatko, ListaPredciTatko, Pocheten),
    predci_basic(Majka, ListaPredciMajka, Pocheten),
    my_concat(ListaPredciTatko, ListaPredciMajka, ListaPredci).

predci_basic(Sifra, [Majka | ListaPredci], Pocheten) :-
    lice(Pocheten, _, _, Rod, datum(Den, Mesec, _), _, _),
    najdi_roditeli(Sifra, Tatko, Majka),
    Rod = z,
    lice(Majka, _, _, _, datum(MajkaDen, MajkaMesec, _), _, _),
    den_vo_godina(Den, Mesec, AbsDen),
    den_vo_godina(MajkaDen, MajkaMesec, MajkaAbsDen),
    razlika_denovi(AbsDen, MajkaAbsDen, Razlika),
    Razlika =< 7,
    !,
    predci_basic(Majka, ListaPredciMajka, Pocheten),
    predci_basic(Tatko, ListaPredciTatko, Pocheten),
    my_concat(ListaPredciMajka, ListaPredciTatko, ListaPredci).

predci_basic(Sifra, ListaPredci, Pocheten) :-
    lice(Pocheten, _, _, Rod, _, _, _),
    najdi_roditeli(Sifra, Tatko, Majka),
    Rod = z,
    !,
    predci_basic(Majka, ListaPredciMajka, Pocheten),
    predci_basic(Tatko, ListaPredciTatko, Pocheten),
    my_concat(ListaPredciMajka, ListaPredciTatko, ListaPredci).

predci(Sifra, ListaPredci) :-
    predci_basic(Sifra, ListaPredci, Sifra).
