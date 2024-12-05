% En finess ¨ar att vi beh¨over ta hand om slingor i modellen f¨or att garantera att beviss¨okningen terminerar. Observera att om man
% st¨oter p˚a en slinga n¨ar en G-formel utv¨arderas betyder det “success”, men
% f¨or en F-formel “failure”!

% Uppt¨ackandet av slingor (f¨or G- och F-formler) g¨ors
% med hj¨alp av en lista U som registrerar vid vilka tillst˚and formeln redan har
% utv¨arderats.


% 1. Verktygsutveckling. Skriv en modellprovare f¨or CTL i Prolog

% 2. Modellering. T¨ank p˚a n˚agot system med datalogisk relevans som
% har ett icke-trivialt beteende. 
    % rimligen fem eller fler tillst˚and.
    % Ge en intuitiv f¨orklaring till beteendet som modelleras och ditt val av atomer.
    % Skapa en Prolog-kompatibel representation

%   swipl
%   [lab3].
%   verify('./tests/valid000.txt').

%   ['run_all_tests.pl'].
%   run_all_tests('../lab3.pl').

%   trace
%   notrace

% NOTE: Program

% For SICStus, uncomment line below: (needed for member/2)
:- use_module(library(lists)).
% Load model, initial state and formula from file.
verify(Input) :-
    see(Input),
    read(T), read(L), read(S), read(F),
    seen,
    check(T, L, S, [], F).

% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.

check(_, L, S, _, X) :-
    member([S, Z], L),                 % Check if [S, Z] is in L
    member(X, Z).

check(T, L, S, [], neg(X)) :-
    \+ check(T, L, S, [], X).

% And
check(T, L, S, [], and(F, G)) :-
    check(T, L, S, [], F),
    check(T, L, S, [], G).

% Or
check(T, L, S, [], or(F, G)) :-
    check(T, L, S, [], F);
    check(T, L, S, [], G).

% AX = not(EX not X)
check(T, L, S, [], ax(F)) :-
    check(T, L, S, [], neg(ex(neg(F)))).

% AG = not(EF not X)
check(T, L, S, U, ag(F)) :-
    check(T, L, S, U, neg(ef(neg(F)))).

% AF = not(EG not X)
check(T, L, S, U, af(F)) :-
    check(T, L, S, U, neg(eg(neg(F)))).

% EG: om i någon väg från S så gäller F
check(T, L, S, U, eg(F)) :-
    member(S, U).

check(T, L, S, U, eg(F)) :-
    \+ member(S, U),
    check(T, L, S, [], F),
    member([S, NextStates], T),
    member(NewState, NextStates),
    check(T, L, NewState, [S|U], eg(F)).

% EF: 
check(T, L, S, U, ef(F)) :-
    \+ member(S, U),
    check(T, L, S, [], F).

check(T, L, S, U, ef(F)) :-
    \+ member(S, U),
    member([S, NextStates], T),
    member(NewState, NextStates),
    check(T, L, NewState, [S|U], ef(F)).

% EX: there exists a next state satisfying F
check(T, L, S, [], ex(F)) :-
    member([S, NextStates], T),
    member(NewState, NextStates),
    check(T, L, NewState, [], F).
