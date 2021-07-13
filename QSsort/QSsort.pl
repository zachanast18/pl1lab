:- dynamic
    x/2.

assert_x(Term) :-
    term_hash(Term, Hash),
    asserta(x(Hash, Term)),
    ( true
    ; retract(x(Hash, Term)),
      fail).

  x(Term) :-
      term_hash(Term, Hash),
      x(Hash, Term).

/*read input*/
read_input(File, N, C) :-
  open(File, read, Stream),
  read_line(Stream, [N]),
  read_line(Stream, C).

read_line(Stream, L) :-
  read_line_to_codes(Stream, Line),
  atom_codes(Atom, Line),
  atomic_list_concat(Atoms, ' ', Atom),
  maplist(atom_number, Atoms, L).
/**/

is_Sorted([],_).
is_Sorted([H|T],Prev) :-
  H >= Prev,
  is_Sorted(T,H).

counter([],Qs,Ss) :- Ss =:= Qs, !.
counter([81|Rest], Qs, Ss) :-
  NewQs is 1+Qs,
  counter(Rest, NewQs, Ss).
counter([83|Rest], Qs, Ss) :-
  NewSs is 1+Ss,
  counter(Rest, Qs, NewSs).

/* config(Queue,Stack) */
final(config(Q,[])) :-
  is_Sorted(Q,-1).

/* move(Conf1, Move, NextConf) */
move(config([QH|QT],[]), 81, config(QT,[QH]), L, Qs) :-
  Qs < L//2,
  !.
move(config([],[SH|ST]), 83, config([SH],ST),_,_) :- !.
/*move(config([QH,QH|QT],S), 81, config([QH|QT],[QH|S]), L, Qs) :-
  Qs < L//2,
  !.*/
move(config([QH|QT],[QH|ST]), 81, config(QT,[QH,QH|ST]), L, Qs) :-
  Qs < L//2,
  !.
move(config([QH|QT],S), 81, config(QT,[QH|S]), L, Qs) :-
  Qs < L//2.
move(config(Q,[SH|ST]), 83, config(NewQ,ST), _, _) :-
  append(Q,[SH],NewQ).

safe(config(Q,S),Seen,[Code|Seen]) :-
  term_hash((Q,S),Code),
  \+(member(Code, Seen)).
  /*\+(x((Qstring,Sstring))),
  assert_x((Qstring,Sstring)).*/

/* solve(+Conf, ?Moves) */
solve(Conf, [], _, _) :-
  final(Conf),
  !.
solve(Conf, [Move|Moves], L, Qs) :-
  move(Conf, Move, NextConf, L, Qs),
  /*safe(NextConf, Seen, NewSeen),*/
  (Move =:= 81->
    NewQs is 1+Qs
  ; NewQs is Qs
  ),
  solve(NextConf, Moves, L, NewQs).

/* solve(-Moves) */
qssort(Filename,Answer) :-
  read_input(Filename,_,InitQ),
  (is_Sorted(InitQ,-1)->
    Answer = "empty"
  ; length(Moves,L),
    L mod 2 =:= 0,
    /*counter(Moves, 0, 0),*/
    solve(config(InitQ,[]),Moves,L,0),
    string_to_list(Answer,Moves),
    retractall(x(_,_)),
    !
  ).
