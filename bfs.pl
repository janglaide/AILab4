initial_state([0,0]).

final_state([3,_]).
final_state([_,3]).

main(D):-
    initial_state(State),
    bfs(State,D,[]),
    writeln(D).

bfs(State,History,[]):-
    append_cor(History,State,NewHistory),
    findall(X, (search_states(State,X),not(member(X,NewHistory))),[NextState|T]),
    bfs(NextState,NewHistory,T).
bfs(State,History,[_]):-
    final_state(State),
    append_cor(History,State,NewHistory),
    writeln(NewHistory).
bfs(State,History,[Queue|Tail]):-
    append_cor(History,State,NewHistory),
    findall(X, (search_states(State,X),not(member(X,NewHistory))),NextStates),
    append(Tail,NextStates,NewQueue),
    bfs(Queue,NewHistory,NewQueue).


append_cor(Queue,[L5,L9],Q):-
    append(Queue,[[L5,L9]],Q).

next_front([State-Move|NextMoves],NextFront,[s(State,[Move|Path])|NF1],History,Path):-
    not(member(State,History)),
    !,
    next_front(NextMoves,NextFront,NF1,History,Path).
next_front([_|NextMoves],NextFront,NF1,History,Path):-
    next_front(NextMoves,NextFront,NF1,History,Path).
next_front([],NextFront,NextFront,_,_).

history(State,History,History):-
    final_state(State),
    !.
history(State,History,[State|History]).

search_states([L5,L9],[NL5,NL9]):-
    state([L5,L9],[NL5,NL9]).

state([L5,L9],[5,L9]):-
    L5 = 0.
state([L5,L9],[L5,9]):-
    L9 = 0.
state([L5,L9],[0,L9]):-
    not(L5 = 0).
state([L5,L9],[L5,0]):-
    not(L9 = 0).
state([L5,L9],[NL5,9]):-
    not(L5 = 0),
    not(L9 = 9),
    L5 + L9 > 9,
    NL5 is L5 + L9 - 9.
state([L5,L9],[0,NL9]):-
    not(L5 = 0),
    not(L9 = 9),
    L5 + L9 =< 9,
    NL9 is L5 + L9.
state([L5,L9],[5,NL9]):-
    not(L5 = 5),
    not(L9 = 0),
    L5 + L9 > 5,
    NL9 is L5 + L9 - 5.
state([L5,L9],[NL5,0]):-
    not(L5 = 5),
    not(L9 = 0),
    L5 + L9 =< 5,
    NL5 is L5 + L9.