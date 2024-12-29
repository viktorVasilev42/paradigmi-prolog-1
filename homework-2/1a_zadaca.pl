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

br_el([], 0).
br_el([_ | L1], N) :-
    br_el(L1, M),
    N is M + 1.


najdi_roditeli(Dete, Tatko, Majka) :-
    familija(Tatko, Majka, DecaVoFamilija),
    lista_sodrzi(DecaVoFamilija, Dete),
    !.

zemi_grad_raganje(Sifra, Grad) :-
    lice(Sifra, _, _, _, _, Grad, _).


reshenie(Sifra) :-
    lice(Sifra, _, _, _, _, GradRaganje, _),
    najdi_roditeli(Sifra, Tatko, Majka),
    zemi_grad_raganje(Tatko, TatkoGrad),
    zemi_grad_raganje(Majka, MajkaGrad),
    TatkoGrad \= GradRaganje,
    MajkaGrad \= GradRaganje.


rodeni_razlicen_grad(Kolku) :-
    findall(X, reshenie(X), ListaSifri),
    br_el(ListaSifri, Kolku).
