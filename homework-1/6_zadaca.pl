transpose([], []).
transpose([[]|_], []) :- !.
transpose(Matrix, [Column|Rest]) :-
    extract_column(Matrix, Column, RemainingMatrix),
    transpose(RemainingMatrix, Rest).

extract_column([], [], []).
extract_column([[Element|RestRow]|Rows], [Element|Column], [RestRow|RemainingMatrix]) :-
    extract_column(Rows, Column, RemainingMatrix).



matrix_multiply(A, B, Result) :-
    transpose(B, BTransposed),
    multiply_rows(A, BTransposed, Result).

multiply_rows([], _, []).
multiply_rows([Row|RestRows], BTransposed, [ResultRow|RestResultRows]) :-
    multiply_row(Row, BTransposed, ResultRow),
    multiply_rows(RestRows, BTransposed, RestResultRows), !.
multiply_row(_, [], []).
multiply_row(Row, [Column|RestColumns], [Product|RestProducts]) :-
    dot_product(Row, Column, Product),
    multiply_row(Row, RestColumns, RestProducts), !.

dot_product([], [], 0).
dot_product([X|Xs], [Y|Ys], Product) :-
    dot_product(Xs, Ys, RestProduct),
    Product is X * Y + RestProduct.


presmetaj(L1, L2) :-
    transpose(L1, TransposedL1),
    matrix_multiply(L1, TransposedL1, L2).

