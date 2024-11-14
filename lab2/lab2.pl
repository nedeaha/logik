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

proof_goal_match(Goal, [_, Goal, _]).

apply_rule([H1, H2, Line_Rule|_], Prems, Proof) :-
    (Line_Rule==premise, premise(H2, Prems));
    (Line_Rule==assumption, assumption(H2, Proof, Prems));
    (Line_Rule=copy(X), H1>X, copy(X, H2, Proof));
    (Line_Rule=andint(X, Y), H1>X, H1>Y, andint(X, Y, H2, Proof));
    (Line_Rule=andel1(X), H1>X, andel1(X, H2, Proof));
    (Line_Rule=andel2(X), H1>X, andel2(X, H2, Proof));
    (Line_Rule=orint1(X), H1>X, orint1(X, H2, Proof));
    (Line_Rule=orint2(X), H1>X, orint2(X, H2, Proof));
    (Line_Rule=orel(X, Y, U, V, W), H1>X, H1>Y, H1>U, H1>V, H1>W, orel(X, Y, U, V, W, H2, Proof));
    (Line_Rule=impint(X, Y), H1>X, H1>Y, impint(X, Y, H2, Proof));
    (Line_Rule=impel(X, Y), H1>X, H1>Y, impel(X, Y, H2, Proof));
    (Line_Rule=negint(X, Y), H1>X, H1>Y, negint(X, Y, H2, Proof));
    (Line_Rule=negel(X, Y), H1>X, H1>Y, negel(X, Y, Proof));
    (Line_Rule=contel(X), H1>X, contel(X, Proof));
    (Line_Rule=negnegint(X), H1>X, negnegint(X, H2, Proof));
    (Line_Rule=negnegel(X), H1>X, negnegel(X, H2, Proof));
    (Line_Rule=mt(X, Y), H1>X, H1>Y, mt(X, Y, H2, Proof));
    (Line_Rule=pbc(X, Y), H1>X, H1>Y, pbc(X, Y, H2, Proof));
    (Line_Rule==lem, lem(H2)).

%idk om detta funkar
apply_rule(Box, Prems, Proof) :-
    nth1(1, Box, [Line, P, _]),
    append_previous_lines(Line, Proof, Box, New_proof),
    last(Box, [_, Goal, _]),
    % apply the assumption as a premise
    append(Prems, [P], New_prems),
    valid_proof(New_prems, Goal, New_proof, Box).
    

% Helper function to constuct a proof.
append_previous_lines(1, _, Box, Box).
append_previous_lines(Line, Proof, Box, New_proof) :-
    New_line is Line - 1,
    nth1(New_line, Proof, Line_to_add),
    append([Line_to_add], Box, New_box),
    append_previous_lines(New_line, Proof, New_box, New_proof).


%Alla regler
premise(H2, Prems) :- 
    member(H2, Prems).

assumption(H2, Proof, Prems) :-
    \+ length(Proof, 1),
    member(H2, Prems).

copy(X, P, Proof) :- 
    member([X, P, Q], Proof),
    \+ Q==assumption.

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

orel(X, Y, U, V, W, Slay, Proof) :-
    member([X, or(P, Q), _], Proof),
    member([[Y, P, assumption]|T1], Proof),
    append([[Y, P, assumption]], T1, Box1),
    member([U, Slay, _], Box1),
    member([[V, Q, assumption]|T2], Proof),
    append([[V, Q, assumption]], T2, Box2),
    member([W, Slay, _], Box2).


%kanske inte klar
impint(X, Y, imp(P, Q), Proof) :- 
    member([[X, P, assumption]|T], Proof),
    append([[X, P, assumption]], T, Box),
    member([Y, Q, _], Box).

impel(X, Y, Q, Proof) :- 
    member([Y, imp(P, Q), _], Proof), 
    member([X, P, _], Proof).

%kanske inte klar
negint(X, Y, neg(P), Proof) :-
    member([[X, P, assumption]|T], Proof),
    append([[X, P, assumption]], T, Box),
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
    member([X, imp(P, Q), _], Proof), 
    member([Y, neg(Q), _], Proof).

%kanske inte klar
pbc(X, Y, P, Proof) :-
    member([[X, neg(P), assumption]|T], Proof),
    append([[X, neg(P), assumption]], T, Box),
    member([Y, cont, _], Box).

lem(or(P, neg(P))).

%Alla formler
and(P, Q) :- P, Q.
or(P, Q) :- P; Q.
imp(P, Q) :- or(neg(P), Q).
neg(P) :- \+P.