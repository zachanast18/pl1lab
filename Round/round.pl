/*read input*/
read_input(File, N, K, L) :-
  open(File, read, Stream),
  read_line(Stream, [N,K]),
  read_line(Stream, L).

read_line(Stream, L) :-
  read_line_to_codes(Stream, Line),
  atom_codes(Atom, Line),
  atomic_list_concat(Atoms, ' ', Atom),
  maplist(atom_number, Atoms, L).
/**/


count([], _, Acc, [], Acc):- !.
count([Ind|T], Ind, Acc, Tail, Sum):-
  NewAcc is Acc+1,
  count(T, Ind, NewAcc, Tail, Sum),
  !.
count(L, _, Acc, L, Acc).

count_cars(_,[],N,N):-!.
count_cars([], Cities, Ind, N):-
  NewInd is Ind+1,
  count_cars([], NextCities, NewInd, N),
  Cities = [0|NextCities],
  !.
count_cars(Cars, Cities, Ind, N):-
  NewInd is Ind+1,
  (\+(member(Ind,Cars))->
    count_cars(Cars, NextCities, NewInd, N),
    Cities = [0|NextCities]
  ;
    count(Cars, Ind, 0, Tail, Sum),
    count_cars(Tail, NextCities, NewInd, N),
    Cities = [Sum|NextCities]
  ),
  !.

non_empty([], [], _).
non_empty([0|T], Full, Ind):-
  NewInd is Ind+1,
  non_empty(T, Full, NewInd),
  !.
non_empty([_|T], Full, Ind):-
  NewInd is Ind+1,
  non_empty(T, NewFull, NewInd),
  Full = [Ind|NewFull].

distance([], _, _, Acc, Acc).
distance([H|T], N, Ind, Acc, Dist):-
  NewInd is Ind+1,
  NewAcc is Acc + (N-Ind)*H,
  distance(T, N, NewInd, NewAcc, Dist).

solve(_,_,_, [], _, _, _, (Moves, Town), (Moves, Town)):- !.
solve(First, K, N, [H|T], [_], PrevDist, Ind, (BM, BT), (Moves, Town)):-
  Dist is PrevDist+K-N*H,
  Max is Ind-First,
  Check is Dist-Max+1,
  NewInd is Ind+1,
  (Max > Check->
    solve(First, K, N, T, [], Dist, NewInd, (BM, BT), (Moves, Town))
  ;Dist < BM->
    solve(First, K, N, T, [], Dist, NewInd, (Dist, Ind), (Moves, Town))
  ;
    solve(First, K, N, T, [], Dist, NewInd, (BM, BT), (Moves, Town))
  ),
  !.
solve(First, K, N, [H|T], [Ind|Rest], PrevDist, Ind, (BM, BT), (Moves, Town)):-
  solve(First, K, N, [H|T], Rest, PrevDist, Ind, (BM, BT), (Moves, Town)),
  !.
solve(First, K, N, [H|T], [Next|Rest], PrevDist, Ind, (BM, BT), (Moves, Town)):-
  Dist is PrevDist+K-N*H,
  Max is N-abs(Next-Ind),
  Check is Dist-Max+1,
  NewInd is Ind+1,
  (Max > Check->
    solve(First, K, N, T, [Next|Rest], Dist, NewInd, (BM, BT), (Moves, Town))
  ;Dist < BM->
    solve(First, K, N, T, [Next|Rest], Dist, NewInd, (Dist, Ind), (Moves, Town))
  ;
    solve(First, K, N, T, [Next|Rest], Dist, NewInd, (BM, BT), (Moves, Town))
  ),
  !.

help([H|T], Ret):-
  append(T, [H], Ret).

round(Filename, C, M):-
  read_input(Filename, N, K, Cars),
  sort(0, @=<, Cars, Sorted),
  count_cars(Sorted, Cities, 0, N), /*cities is the list of cities with the corresponding #cars*/
  non_empty(Cities, Full, 0), /*Full is the list of non empty cities*/
  Cities = [_|CT],
  Full = [First|_],
  distance(CT, N, 1, 0, InitDist),
  help(Full, L),
  solve(First, K, N, CT, L, InitDist, 1, (InitDist, 0), (C, M)).
