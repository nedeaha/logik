
%Delar upp listan i subsets
partstring([H|T], L, F) :-
    append(F, _, [H|T]),
    length(F, L), %gGer längden på det nya subset
    L > 0. %Ett subset kan inte vara tomma listan

%Tar bort listans head och vi får resterande subsets
partstring([H|T], L, F) :-
    partstring(T, L, F).


