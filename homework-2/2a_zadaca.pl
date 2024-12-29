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


kolku_pati_vo_lista(_, [], 0) :- !.
kolku_pati_vo_lista(X, [X | L1], N) :-
    !,
    kolku_pati_vo_lista(X, L1, M),
    N is M + 1.
kolku_pati_vo_lista(X, [_ | L1], N) :-
    kolku_pati_vo_lista(X, L1, N).

zemi_prv([X | _], X).


my_concat([], L2, L2).
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).

br_el([], 0).
br_el([_ | L1], N) :-
    br_el(L1, M),
    N is M + 1.

broj_povici_od_mene(Broj, N) :-
    telefon(Broj, _, _, ListaPovici),
    br_el(ListaPovici, N).


zemi_ime_i_prezime_na_broj(Broj, Ime, Prezime) :-
    telefon(Broj, Ime, Prezime, _).

site_broevi_na_koi_im_e_zvoneto(SiteBroevi) :-
    findall(Number, (telefon(_, _, _, Poviks), member(povik(Number, _), Poviks)), SiteBroevi).


vkupno_povici_na_broj(Broj, Vkupno) :-
    broj_povici_od_mene(Broj, BrOdMene),
    site_broevi_na_koi_im_e_zvoneto(SiteBroevi),
    kolku_pati_vo_lista(Broj, SiteBroevi, BrOdDrugi),
    Vkupno is BrOdMene + BrOdDrugi.

koj_ima_max_vkupno_povici([], CurrMaxBroj, CurrMaxBroj) :- !.
koj_ima_max_vkupno_povici([X | ListaBroevi], CurrMaxBroj, Result) :-
    vkupno_povici_na_broj(X, VkupnoNaX),
    vkupno_povici_na_broj(CurrMaxBroj, VkupnoNaCurrMax),
    VkupnoNaX > VkupnoNaCurrMax,
    !,
    koj_ima_max_vkupno_povici(ListaBroevi, X, Result).
koj_ima_max_vkupno_povici([_ | ListaBroevi], CurrMaxBroj, Result) :-
    koj_ima_max_vkupno_povici(ListaBroevi, CurrMaxBroj, Result).


najbroj(Ime, Prezime) :-
    findall(Broj, telefon(Broj, _, _, _), ListaBroevi),
    zemi_prv(ListaBroevi, Prv),
    koj_ima_max_vkupno_povici(ListaBroevi, Prv, ResultBroj),
    zemi_ime_i_prezime_na_broj(ResultBroj, Ime, Prezime).
