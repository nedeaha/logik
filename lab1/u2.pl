%Basfall
remove_duplicates([], []).

%Head är inte med i tailen och vi lägger till den i resultat listan.
remove_duplicates([H|T], [H|R]) :-
    \+ member(H, T), %Kollar om H finns i T
    remove_duplicates(T, R). %Rekursivt går vidare genom hela listan.

%Head är med i tailen.
remove_duplicates([H|T], R) :-
    remove_duplicates(T, R). %Rekursivt går vidare genom hela listan.

% remove_duplicates([1,2,3,2,4,1,3,4], E).