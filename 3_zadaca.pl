br_elementi([], 0).
br_elementi([X | L1], N) :-
    br_elementi(L1, M),
    N is M + 1.

dva_ili_poveke_el(L1) :-
    br_elementi(L1, BrL1),
    L1 >= 2.
