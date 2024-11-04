films(starwars, 6).
films(lotr, 3).
films(twilight, 5).
films(hungergames, 5).
films(godfather, 3).

same_number(X, Y) :- films(X, N), films(Y, N). 