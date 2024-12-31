% baza na znaenje za zadaca 1
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


% shared utils

my_concat([], L2, L2).
my_concat([X | L1], L2, [X | L3]) :-
    my_concat(L1, L2, L3).

lista_sodrzi([X | _], X) :- !.
lista_sodrzi([_ | L1], X) :-
    lista_sodrzi(L1, X).

br_el([], 0).
br_el([_ | L1], N) :-
    br_el(L1, M),
    N is M + 1.


% najdi tatko i majka na lice
najdi_roditeli(Dete, Tatko, Majka) :-
    familija(Tatko, Majka, DecaVoFamilija),
    lista_sodrzi(DecaVoFamilija, Dete),
    !.

kolku_pati_vo_lista(_, [], 0) :- !.
kolku_pati_vo_lista(X, [X | L1], N) :-
    !,
    kolku_pati_vo_lista(X, L1, M),
    N is M + 1.
kolku_pati_vo_lista(X, [_ | L1], N) :-
    kolku_pati_vo_lista(X, L1, N).

zemi_prv([X | _], X).


% ===========================================
% zadaca 1a

% najdi grad na raganje na lice
zemi_grad_raganje(Sifra, Grad) :-
    lice(Sifra, _, _, _, _, Grad, _).

% ispolnuvanje uslovi za liceto
% da ne e roden vo isti grad
% so negovite roditeli
reshenie(Sifra) :-
    lice(Sifra, _, _, _, _, GradRaganje, _),
    najdi_roditeli(Sifra, Tatko, Majka),
    zemi_grad_raganje(Tatko, TatkoGrad),
    zemi_grad_raganje(Majka, MajkaGrad),
    TatkoGrad \= GradRaganje,
    MajkaGrad \= GradRaganje.

% finalen predikat za koristenje
rodeni_razlicen_grad(Kolku) :-
    findall(X, reshenie(X), ListaSifri),
    br_el(ListaSifri, Kolku).

% ===========================================
% zadaca 1b

% najdi reden broj na den vo godinata
% (sekoj mesec ima 30 dena)
% pr: 25ti fevruari e: 30*1 + 25 = 55
den_vo_godina(Den, Mesec, Result) :-
    MesecIndex is Mesec - 1,
    TotalFromMesec is MesecIndex * 30,
    Result is TotalFromMesec + Den.

% absolutna razlika megju dva dena
razlika_denovi(X, Y, Result) :-
    X >= Y,
    !,
    Result is X - Y.
razlika_denovi(X, Y, Result) :-
    Result is Y - X.

% baranje na predci koi se isti rod kako liceto
% i razlikata na rodendenot im e pomalku od
% nedela dena
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


% finalen predikat za koristenje
predci(Sifra, ListaPredci) :-
    predci_basic(Sifra, ListaPredci, Sifra).


% baza na znaenje za zadaca 2
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

% ===========================================
% zadaca 2a

% najdi ime i prezime za daden telefonski broj
zemi_ime_i_prezime_na_broj(Broj, Ime, Prezime) :-
    telefon(Broj, Ime, Prezime, _).

% najdi broj na povici kade sto caller e daden broj
broj_povici_od_mene(Broj, N) :-
    telefon(Broj, _, _, ListaPovici),
    br_el(ListaPovici, N).

% najdi gi site broevi koi se vo listite na povici,
% odnosno broevi na koj sto nekoj im se javil
site_broevi_na_koi_im_e_zvoneto(SiteBroevi) :-
    findall(Number, (telefon(_, _, _, Poviks), member(povik(Number, _), Poviks)), SiteBroevi).

% najdi broj na povici vo koi ucestvuval daden broj
% (toj e ili caller ili callee)
vkupno_povici_na_broj(Broj, Vkupno) :-
    broj_povici_od_mene(Broj, BrOdMene),
    site_broevi_na_koi_im_e_zvoneto(SiteBroevi),
    kolku_pati_vo_lista(Broj, SiteBroevi, BrOdDrugi),
    Vkupno is BrOdMene + BrOdDrugi.

% najdi koj broj ucestvuval vo najgolem broj na povici
koj_ima_max_vkupno_povici([], CurrMaxBroj, CurrMaxBroj) :- !.
koj_ima_max_vkupno_povici([X | ListaBroevi], CurrMaxBroj, Result) :-
    vkupno_povici_na_broj(X, VkupnoNaX),
    vkupno_povici_na_broj(CurrMaxBroj, VkupnoNaCurrMax),
    VkupnoNaX > VkupnoNaCurrMax,
    !,
    koj_ima_max_vkupno_povici(ListaBroevi, X, Result).
koj_ima_max_vkupno_povici([_ | ListaBroevi], CurrMaxBroj, Result) :-
    koj_ima_max_vkupno_povici(ListaBroevi, CurrMaxBroj, Result).

% finalen predikat za koristenje
%
% najdi ime i prezime na broj koj ucestvuval vo najgolem
% broj na povici
najbroj(Ime, Prezime) :-
    findall(Broj, telefon(Broj, _, _, _), ListaBroevi),
    zemi_prv(ListaBroevi, Prv),
    koj_ima_max_vkupno_povici(ListaBroevi, Prv, ResultBroj),
    zemi_ime_i_prezime_na_broj(ResultBroj, Ime, Prezime).

% ===========================================
% zadaca 2b

% najdi gi site povici koi poteknuvaat od broj
povici_od_mene(Broj, Result) :-
    telefon(Broj, _, _, Poviks),
    findall(povik(Broj, Callee, Duration), member(povik(Callee, Duration), Poviks), Result).

% najdi gi site povici koi se prateni kon broj
povici_kon_mene(Broj, Result) :-
    findall(povik(Caller, Broj, Duration), 
            (telefon(Caller, _, _, Calls), member(povik(Broj, Duration), Calls)), Result).

% najdi gi site smsi prateni od broj; 
% transformiraj gi vo Povik(Sender, Receiver, 100).
smsi_prateni_od(Broj, Poviks) :-
    findall(SentTo, sms(Broj, SentTo), SMSGroups),
    append(SMSGroups, Recipients),
    maplist(transform_to_povik(Broj), Recipients, Poviks).

% ovoj predikat se koristi vo maplist za transformacija
% na sms vo Povik(Sender, Receiver, 100).
transform_to_povik(Sender, Receiver, povik(Sender, Receiver, 100)).

% najdi gi site smsi prateni od broj;
% transformiraj gi vo Povik(Sender, Receiver, 100).
smsi_prateni_kon(Broj, Poviks) :-
    findall(povik(Sender, Broj, 100), 
            (sms(Sender, Recipients), member(Broj, Recipients)), 
            Poviks).

% najdi gi site povici i smsi vo koi e vklucen
% daden broj
site_povici_na(Broj, Result) :-
    povici_od_mene(Broj, R1),
    povici_kon_mene(Broj, R2),
    smsi_prateni_od(Broj, R3),
    smsi_prateni_kon(Broj, R4),
    my_concat(R1, R2, R1R2),
    my_concat(R1R2, R3, R1R2R3),
    my_concat(R1R2R3, R4, Result).

% najdi go vkupnoto vreme koe daden broj (chija 
% lista na site povici ja davame kako argument) 
% go potroshil so Broj2
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


% zemi gi site telefonski broevi vo edna lista
site_telefoni(SiteTelefoni) :-
    findall(Broj, telefon(Broj, _, _, _), SiteTelefoni).

% od povik(Sender, Receiver, Duration), zemi go brojot
% sto ne e ednakov na brojot daden kako vtor parametar
od_povik_zemi_toj_sto_ne_e_broj(povik(Broj, To, _), Broj, To) :- !.
od_povik_zemi_toj_sto_ne_e_broj(povik(From, _, _), _, From).


% naoganje na brojot so koj daden broj ima najmnogu
% potrosheno vreme
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


% finalen predikat za koristenje
omilen(Broj1, Broj2) :-
    site_povici_na(Broj1, SiteNaBroj1),
    omilen_inner(Broj1, SiteNaBroj1, 0, Broj2).


% baza na znaenje za zadaca 1
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


% ===========================================
% zadaca 3a

% najdi kolku pati dadena lokacija bila pocetna
% ili krajna za nekoja usluga
izbroj_lokacija(Lok, Br) :-
    findall(Lok, (klient(_, _, _, Lista), member(usluga(Lok, _, _, _, _), Lista)), PojavuvanjaOd),
    findall(Lok, (klient(_, _, _, Lista), member(usluga(_, Lok, _, _, _), Lista)), PojavuvanjaDo),
    my_concat(PojavuvanjaOd, PojavuvanjaDo, SitePojavuvanja),
    br_el(SitePojavuvanja, Br).


% ===========================================
% zadaca 3b

% najdi bilo koe rastojanie megju
% dve lokacii
distance(X, Y, D) :- rastojanie(X, Y, D).
distance(X, Y, D) :- rastojanie(Y, X, D).

% najdi najkratok pat megju dve lokacii
shortest_path(From, To, Distance) :-
    findall(D, path_length(From, To, [From], D), Distances),
    min_list(Distances, Distance).

% dijkstra bfs loop
path_length(From, To, Visited, Distance) :-
    distance(From, Next, D1),
    \+ member(Next, Visited),
    (To = Next -> Distance = D1;
     path_length(Next, To, [Next | Visited], D2),
     Distance is D1 + D2).

% za daden klient najdi vkupno rastojanie sto go
% pominal
client_distance(_, _, [], 0).
client_distance(Name, Surname, [usluga(From, To, _, _, _) | Rest], Total) :-
    shortest_path(From, To, Distance),
    client_distance(Name, Surname, Rest, RestDistance),
    Total is Distance + RestDistance.

% najdi koj klient pominal najgolemo rastojanie
% i vrati go negovoto ime i prezime
najmnogu_kilometri(X, Y) :-
    findall(Total-Name-Surname, (klient(_, Name, Surname, Trips), client_distance(Name, Surname, Trips, Total)), Results),
    sort(1, @>=, Results, [_-X-Y | _]).

% ===========================================
% zadaca 3c

% najdi kolku kosta vozenje od edna lokacija do druga
% imajki na um deka taksito sekogash go odbira
% najkratkiot pat
presmetaj_cena_voznja(From, To, NaKilometar, Result) :-
    shortest_path(From, To, Dist),
    Result is NaKilometar * Dist.

% zemi ja cenata za daden taksi broj
cena_za_taksi_broj(Broj, Result) :-
    klient(_, _, _, Uslugi),
    member(usluga(F, T, NaKilometar, datum(_, 12, 2015), Broj), Uslugi),
    presmetaj_cena_voznja(F, T, NaKilometar, Result).

% dali daden broj pripaga na taksi vozilo so koe
% nekoj klient se vozel
dali_e_iskoristen(Broj) :-
    klient(_, _, _, Uslugi), member(usluga(_, _, _, _, Broj), Uslugi).

% vkupna cena koja daden taksi broj ja zarabotil
total_cena(Broj, Result) :-
    findall(Cena, cena_za_taksi_broj(Broj, Cena), Ceni), sum_list(Ceni, Result).

% predikat za generiranje na site vkupni
% zarabotuvacki na sekoe taksi vozilo koe
% e iskoristeno
generate_total_cena(Vkupno) :-
    dali_e_iskoristen(Broj),
    total_cena(Broj, Vkupno).

% najdi koj taksi broj zarabotil najmnogu
najmnogu_zarabotil(Broj) :-
    findall(Vkupno, generate_total_cena(Vkupno), VkupnoCena),
    max_list(VkupnoCena, MaxVkupnoCena),
    dali_e_iskoristen(Broj),
    total_cena(Broj, MaxVkupnoCena),
    !.

