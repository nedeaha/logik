% Genererar alla konesktutiva sublists från F
partstring(List, L, F) :-
    con_sublist(F, List),           % Skapa konsekutiva listan.
    F \= [],                        % Checka så inte 0.
    length(F, L).                   % Räkna ut längedn av F
    % L > 0.

% con_sublist(+Sub, +List)
% Hjälppredikat för att hitta konsekutiva listor.
con_sublist(Sub, List) :-
    append(_, Suffix, List),       % Hitta en suffix av List, alltså ändelse, typ [1,2,3] -> [2,3]
    append(Sub, _, Suffix),        % Hitta en prefix av Suffix, alltså början, typ [1,2,3] -> [1,2]
    consecutive(Sub).              % Kolla om Sub är konsekutivt.

% consecutive(+List)
% Succeeds if all elements of List are consecutive.
consecutive([]).                   % Empty list is trivially consecutive. 
consecutive([_]).                  % A single element is trivially consecutive.
consecutive([X, Y | Rest]) :-      % For two or more elements, ensure they are consecutive
    Y is X + 1,                    % Ensure X and Y are consecutive
    consecutive([Y | Rest]).       % Recursively check the rest of the list

% partstring([1,2,3,4], L, F).