verify(InputFileName) :- 
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof).

valid_proof(Prems, Goal, []).

valid_proof(Prems, Goal, [H|T]) :-
    proof(H),
    valid_proof(Prems, Goal, T).

proof([H1, H2, H3|_]) :-
    line(H1, H2, H3),
    H3,
    H2.

line(H1, H2, H3).

%Alla regler
premise :- member(H2, Prems).
%assumption :- 
andint(X, Y) :- line(X, R1, _), line(Y, R2, _), and(R1, R2).
%andel1(X) :-
%andel2(X) :- 

%Alla formler
and(P, Q) :- P, Q.


%wwsssss