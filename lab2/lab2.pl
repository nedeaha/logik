verify(InputFileName) :- 
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof, Proof).

valid_proof(Prems, Goal, Proof, [H]) :-
    proof_goal_match(Goal, H),
    apply_rule(H, Prems, Proof).

valid_proof(Prems, Goal, Proof, [H|T]) :-
    valid_proof(Prems, Goal, Proof, T),
    apply_rule(H, Prems, Proof).

proof_goal_match(Goal, [_, Goal, M]) :- \+(M==assumption).

apply_rule([H1, H2, H3|_], Prems, Proof) :-
    (H3==premise, premise(H2, Prems));
    (H3==assumption, assumption(Proof));
    (H3=copy(X), H1>X, copy(X, H2, Proof));
    (H3=andint(X, Y), H1>X, H1>Y, andint(X, Y, H2, Proof));
    (H3=andel1(X), H1>X, andel1(X, H2, Proof));
    (H3=andel2(X), H1>X, andel2(X, H2, Proof));
    (H3=orint1(X), H1>X, orint1(X, H2, Proof));
    (H3=orint2(X), H1>X, orint2(X, H2, Proof));
    %(H3=orel(X, Y, U, V, W))
    (H3=impint(X, Y), H1>X, H1>Y, impint(X, Y, H2, Proof));
    (H3=impel(X, Y), H1>X, H1>Y, impel(X, Y, H2, Proof));
    (H3=negint(X, Y), H1>X, H1>Y, negint(X, Y, H2, Proof));
    (H3=negel(X, Y), H1>X, H1>Y, negel(X, Y, Proof));
    (H3=contel(X), H1>X, contel(X, Proof));
    (H3=negnegint(X), H1>X, negnegint(X, H2, Proof));
    (H3=negnegel(X), H1>X, negnegel(X, H2, Proof));
    (H3=mt(X, Y), H1>X, H1>Y, mt(X, Y, H2, Proof));
    (H3=pbc(X, Y), H1>X, H1>Y, pbc(X, Y, H2, Proof));
    (H3==lem, lem(H2)).

%idk om detta funkar
apply_rule(Box, Prems, Proof) :-

    last(Box, [_, Goal, _]),
    valid_proof(Goal, Prems, New_proof, Box).

% Helper function to constuct a proof.
append_n_elements(0, _, Target, Target). % if n=0, return target
append_n_elements()

%Alla regler
premise(H2, Prems) :- 
    member(H2, Prems).

assumption(Proof) :-
    nth1(1, Proof, [_, _, assumption]).

copy(X, P, Proof) :- 
    member([X, P, _], Proof).

andint(X, Y, and(P, Q), Proof) :- 
    member([X, P, _], Proof), 
    member([Y, Q, _], Proof).

andel1(X, P, Proof) :- 
    member([X, and(P, _), _], Proof).

andel2(X, Q, Proof) :- 
    member([X, and(_, Q), _], Proof).

orint1(X, or(P, _), Proof) :- 
    member([X, P, _], Proof). 

orint2(X, or(_, Q), Proof) :- 
    member([X, Q, _], Proof). 

%orel(X, Y, U, V, W) :-

%kanske inte klar
impint(X, Y, imp(P, Q), Proof) :- 
    nth1(X, Proof, Box),
    member([X, P, assumption], Box),
    member([Y, Q, _], Box).


impel(X, Y, Q, Proof) :- 
    member([Y, imp(P, Q), _], Proof), 
    member([X, P, _], Proof).

%kanske inte klar
negint(X, Y, neg(P), Proof) :-
    nth1(X, Proof, Box), 
    member([X, P, assumption], Box),
    member([Y, cont, _], Box).

negel(X, Y, Proof) :- 
    member([X, P, _], Proof), 
    member([Y, neg(P), _], Proof).

contel(X, Proof) :- 
    member([X, cont, _], Proof).

negnegint(X, neg(neg(P)), Proof) :- 
    member([X, P, _], Proof).

negnegel(X, P, Proof) :- 
    member([X, neg(neg(P)), _], Proof). 

mt(X, Y, neg(P), Proof) :- 
    member([Y, or(P, Q), _], Proof), 
    member([X, neg(Q), _], Proof).

%kanske inte klar
pbc(X, Y, P, Proof) :-
    nth1(X, Proof, Box),
    member([X, neq(P), assumption], Box),
    member([Y, cont, _], Box).

lem(or(P, neg(P))).

%Alla formler
and(P, Q) :- P, Q.
or(P, Q) :- P; Q.
imp(P, Q) :- or(neg(P), Q).
neg(P) :- \+P.