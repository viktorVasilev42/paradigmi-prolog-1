klient(1,petko,petkov,[usluga(a,b,50,datum(12,12,2015),23),usluga(c,a,50,datum(7,12,2015),34),usluga(c,f,40,datum(7,11,2015),23)]).
klient(2,vasil,vasilev,[usluga(a,e,50,datum(25,12,2015),12),usluga(c,g,40,datum(17,11,2015),56),usluga(g,d,50,datum(17,12,2015),45),usluga(e,a,40,datum(24,12,2015),34)]).
klient(3,krste,krstev,[usluga(c,b,60,datum(31,12,2015),56),usluga(e,f,60,datum(31,12,2015),34)]).
klient(4,petar,petrov,[usluga(a,f,50,datum(25,12,2015),23),usluga(f,d,50,datum(25,12,2015),34)]).
klient(5,ivan,ivanov,[usluga(d,g,50,datum(7,12,2015),56),usluga(g,e,40,datum(25,12,2015),34)]).
klient(6,jovan,jovanov,[usluga(c,f,50,datum(5,12,2015),12),usluga(f,d,50,datum(27,12,2015),45)]).
klient(7,ana,aneva,[usluga(e,d,50,datum(11,12,2015),12),usluga(d,g,50,datum(11,12,2015),12)]).
klient(8,lidija,lideva,[usluga(e,g,50,datum(29,12,2015),45),usluga(f,b,50,datum(29,12,2015),34)]).

rastojanie(a,b,4).
rastojanie(a,c,7).
rastojanie(b,c,5).
rastojanie(b,d,3).
rastojanie(c,d,4).
rastojanie(b,e,6).
rastojanie(c,e,2).
rastojanie(b,f,8).
rastojanie(e,f,5).
rastojanie(f,g,3).


distance(X, Y, D) :- rastojanie(X, Y, D).
distance(X, Y, D) :- rastojanie(Y, X, D).

shortest_path(From, To, Distance) :-
    findall(D, path_length(From, To, [From], D), Distances),
    min_list(Distances, Distance).

path_length(From, To, Visited, Distance) :-
    distance(From, Next, D1),
    \+ member(Next, Visited),
    (To = Next -> Distance = D1;
     path_length(Next, To, [Next | Visited], D2),
     Distance is D1 + D2).


presmetaj_cena_voznja(From, To, NaKilometar, Result) :-
    shortest_path(From, To, Dist),
    Result is NaKilometar * Dist.

cena_za_taksi_broj(Broj, Result) :-
    klient(_, _, _, Uslugi),
    member(usluga(F, T, NaKilometar, datum(_, 12, 2015), Broj), Uslugi),
    presmetaj_cena_voznja(F, T, NaKilometar, Result).

dali_e_iskoristen(Broj) :-
    klient(_, _, _, Uslugi), member(usluga(_, _, _, _, Broj), Uslugi).

total_cena(Broj, Result) :-
    findall(Cena, cena_za_taksi_broj(Broj, Cena), Ceni), sum_list(Ceni, Result).

generate_total_cena(Vkupno) :-
    dali_e_iskoristen(Broj),
    total_cena(Broj, Vkupno).

najmnogu_zarabotil(Broj) :-
    findall(Vkupno, generate_total_cena(Vkupno), VkupnoCena),
    max_list(VkupnoCena, MaxVkupnoCena),
    dali_e_iskoristen(Broj),
    total_cena(Broj, MaxVkupnoCena),
    !.
