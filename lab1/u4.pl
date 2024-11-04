/*
    a - d - e
   / \
  b - c  
*/
% Define edges
edge(a, b).
edge(a, c).
edge(a, d).
edge(b, c).
edge(d, e).

%Ser till att noderna är connected i båda riktningarna
connected(X, Y) :- edge(X, Y); edge(Y, X).

%Kollar om nod X och Y är direkt connected och lägger till Y i listan.
path(X, Y, [Y], Visited) :-
    connected(X, Y),
    \+ member(Y, Visited). %Lägger bara till om vi inte varit där tidigare.

%Kollar istället om X och en annan nod Z är connected.
path(X, Y, [Z|R], Visited) :-
    connected(X, Z),
    \+ member(Z, Visited), %Lägger bara till om vi inte varit där tidigare.
    path(Z, Y, R, [Z|Visited]). %Kollar om Z är connected till Y.

%Hjälp predikat som ser till att X läggs till i visited.
find_path(X, Y, Path) :-
    path(X, Y, Path, [X]).


    % find_path(a, e, Path).

