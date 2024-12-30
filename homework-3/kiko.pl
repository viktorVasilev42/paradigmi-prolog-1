%% 1 Constraint satisfaction integra

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

% 1.1 Тео седи најлево и јаде сендвич.
constraint1([(teo, sendvich, _, _) | _]).

% 1.2 Мира сака да решава крстозбори и ужива во јадењето пита.
constraint2(L) :-
    member((mira, pita, krstozbori, _), L).

% 1.3  Девојката има бела маица.
constraint3(L) :-
    devojka(Ime),
    member((Ime, _, _, bela), L).

% 1.4 Бруно има жолта маица.
constraint4(L) :-
    member((bruno, _, _, zolta), L).

% 1.5 Оној што сака да пишува јаде хамбургер.
constraint5(L) :-
    member((_, hamburger, pishuvanje, _), L).

% 1.6  Личноста која јаде пита седи покрај Тео.
constraint6(L) :-
    next_to((teo, _, _, _), (_, pita, _, _), L).

% 1.7 Бруно седи покрај оној што јаде пица.
constraint7(L) :-
    next_to((bruno, _, _, _), (_, pica, _, _), L).

% 1.8 Личноста која седи покрај онаа во бела маица сака пица
constraint8(L) :-
    next_to((_, _, _, bela), (_, pica, _, _), L).

% 1.9 Игор сака да чита.
constraint9(L) :-
    member((igor, _, chitanje, _), L).

% 1.10  Сина маица има личноста која седи десно од девојката.
constraint10(L) :-
    devojka(Ime),
    next_to((Ime, _, _, _), (_, _, _, sina), L).

% next_to/3 checks if two elements are next to each other in the list.
next_to(X, Y, [X, Y | _]).
next_to(X, Y, [Y, X | _]).
next_to(X, Y, [_ | T]) :- next_to(X, Y, T).

combinations(L) :-
   findall((Ime,Hrana,Hobi,Maica), (
       ime(Ime), 
       hrana(Hrana), 
       hobi(Hobi), 
       maica(Maica)
   ), AllPossible),
   select((Ime1,Hrana1,Hobi1,Maica1), AllPossible, Rest1),
   select((Ime2,Hrana2,Hobi2,Maica2), Rest1, Rest2),
   Ime1 \= Ime2, Hrana1 \= Hrana2, Hobi1 \= Hobi2, Maica1 \= Maica2,
   select((Ime3,Hrana3,Hobi3,Maica3), Rest2, Rest3),
   Ime3 \= Ime1, Ime3 \= Ime2, 
   Hrana3 \= Hrana1, Hrana3 \= Hrana2,
   Hobi3 \= Hobi1, Hobi3 \= Hobi2,
   Maica3 \= Maica1, Maica3 \= Maica2,
   select((Ime4,Hrana4,Hobi4,Maica4), Rest3, _),
   Ime4 \= Ime1, Ime4 \= Ime2, Ime4 \= Ime3,
   Hrana4 \= Hrana1, Hrana4 \= Hrana2, Hrana4 \= Hrana3,
   Hobi4 \= Hobi1, Hobi4 \= Hobi2, Hobi4 \= Hobi3,
   Maica4 \= Maica1, Maica4 \= Maica2, Maica4 \= Maica3,
   L = [(Ime1,Hrana1,Hobi1,Maica1),
        (Ime2,Hrana2,Hobi2,Maica2),
        (Ime3,Hrana3,Hobi3,Maica3),
        (Ime4,Hrana4,Hobi4,Maica4)].

reshenie(L) :-
    combinations(L),
    constraint1(L),
    constraint2(L),
    constraint3(L),
    constraint4(L),
    constraint5(L),
    constraint6(L),
    constraint7(L),
    constraint8(L),
    constraint9(L),
    constraint10(L).
