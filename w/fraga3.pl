find_idx(X, [X|_], 0) :- !.
find_idx(X, [_|T], N) :-
    find_idx(X, T, N2),    
    N is N2+1.