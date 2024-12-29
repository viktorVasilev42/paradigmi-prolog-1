telefon(111111,petko,petkovski,[povik(222222,250),povik(101010,125)]).
telefon(222222,marija,petkovska,[povik(111111,350),povik(151515,113),povik(171717,122)]).
telefon(333333,ljubica,petkovska,[povik(555555,150),povik(101010,105)]).
telefon(444444,vasil,vasilev,[povik(171717,750)]).
telefon(555555,elena,vasileva,[povik(333333,250),povik(101010,225)]).
telefon(666666,krste,krstev,[povik(888888,75),povik(111111,65),povik(141414,50),povik(161616,111)]).
telefon(777777,biljana,krsteva,[povik(141414,235)]).
telefon(888888,igor,krstev,[povik(121212,160),povik(101010,225)]).
telefon(999999,kristina,krsteva,[povik(666666,110),povik(111111,112),povik(222222,55)]).
telefon(101010,julija,petrova,[]).
telefon(121212,bosko,petkovski,[povik(444444,235)]).
telefon(131313,gjorgji,vasilev,[povik(141414,125),povik(777777,165)]).
telefon(141414,katerina,petkovska,[povik(777777,315),povik(131313,112)]).
telefon(151515,petar,vasilev,[]).
telefon(161616,andrej,krstev,[povik(666666,350),povik(111111,175),povik(222222,65),povik(101010,215)]).
telefon(171717,martina,petkovska,[povik(222222,150)]).

sms(111111,[222222,999999,101010]).
sms(444444,[333333,121212,161616]).
sms(111111,[777777]).
sms(666666,[888888]).
sms(444444,[555555,121212,131313,141414]).
sms(666666,[777777,888888]).
sms(888888,[999999,151515]).
sms(171717,[131313,161616]).


my_concat([], L2, L2).
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).

zemi_prv([X | _], X).

povici_od_mene(Broj, Result) :-
    telefon(Broj, _, _, Poviks),
    findall(povik(Broj, Callee, Duration), member(povik(Callee, Duration), Poviks), Result).

povici_kon_mene(Broj, Result) :-
    findall(povik(Caller, Broj, Duration), 
            (telefon(Caller, _, _, Calls), member(povik(Broj, Duration), Calls)), 
            Result).

smsi_prateni_od(Broj, Poviks) :-
    findall(SentTo, sms(Broj, SentTo), SMSGroups),
    append(SMSGroups, Recipients),
    maplist(transform_to_povik(Broj), Recipients, Poviks).

transform_to_povik(Sender, Receiver, povik(Sender, Receiver, 100)).

smsi_prateni_kon(Broj, Poviks) :-
    findall(povik(Sender, Broj, 100), 
            (sms(Sender, Recipients), member(Broj, Recipients)), 
            Poviks).

site_povici_na(Broj, Result) :-
    povici_od_mene(Broj, R1),
    povici_kon_mene(Broj, R2),
    smsi_prateni_od(Broj, R3),
    smsi_prateni_kon(Broj, R4),
    my_concat(R1, R2, R1R2),
    my_concat(R1R2, R3, R1R2R3),
    my_concat(R1R2R3, R4, Result).


total_time_vo_lista_so_broj([], _, 0) :- !.

total_time_vo_lista_so_broj([povik(Broj2, _, Dur) | L1], Broj2, Total) :-
    !,
    total_time_vo_lista_so_broj(L1, Broj2, PrevTotal),
    Total is PrevTotal + Dur.

total_time_vo_lista_so_broj([povik(_, Broj2, Dur) | L1], Broj2, Total) :-
    !,
    total_time_vo_lista_so_broj(L1, Broj2, PrevTotal),
    Total is PrevTotal + Dur.

total_time_vo_lista_so_broj([_ | L1], Broj2, Total) :-
    total_time_vo_lista_so_broj(L1, Broj2, Total).


total_time_na_broj_so_broj(Broj1, Broj2, Total) :-
    site_povici_na(Broj1, SiteNaBroj1),
    total_time_vo_lista_so_broj(SiteNaBroj1, Broj2, Total).

site_telefoni(SiteTelefoni) :-
    findall(Broj, telefon(Broj, _, _, _), SiteTelefoni).


od_povik_zemi_toj_sto_ne_e_broj(povik(Broj, To, _), Broj, To) :- !.
od_povik_zemi_toj_sto_ne_e_broj(povik(From, _, _), _, From).


omilen_inner(_, [], CurrMax, CurrMax) :- !.
omilen_inner(Broj1, [X | ListaBroevi], CurrMax, Result) :-
    od_povik_zemi_toj_sto_ne_e_broj(X, Broj1, RealX),
    total_time_na_broj_so_broj(Broj1, RealX, TotalEdenDva),
    total_time_na_broj_so_broj(Broj1, CurrMax, TotalEdenCurrMax),
    TotalEdenDva > TotalEdenCurrMax,
    !,
    omilen_inner(Broj1, ListaBroevi, RealX, Result).
omilen_inner(Broj1, [_ | ListaBroevi], CurrMax, Result) :-
    omilen_inner(Broj1, ListaBroevi, CurrMax, Result).


omilen(Broj1, Broj2) :-
    site_povici_na(Broj1, SiteNaBroj1),
    omilen_inner(Broj1, SiteNaBroj1, 0, Broj2).
