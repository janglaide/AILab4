main(D):-
    start_state(State),
    bfs([s(State,[])],[],[],D),
    writeln(D).

start_state([0,0,[10,10]]).
end_state([3,_,_]). end_state([_,3,_]).

new_state([L5,L9,_],[5,L9,[L5,L9]]):-
    L5 = 0.
new_state([L5,L9,_],[L5,9,[L5,L9]]):-
    L9 = 0.
new_state([L5,L9,_],[0,L9,[L5,L9]]):-
    not(L5 = 0).
new_state([L5,L9,_],[L5,9,[L5,L9]]):-
    not(L9 = 0).
new_state([L5,L9,_],[X,9,[L5,L9]]):-
    not(L5 = 0), not(L9 = 9), L5 + L9 > 9, X is L5 + L9 - 9.
new_state([L5,L9,_],[0,X,[L5,L9]]):-
    not(L5 = 0), not(L9 = 9), X is L5 + L9.
new_state([L5,L9,_],[5,X,[L5,L9]]):-
    not(L5 = 5), not(L9 = 0), L5 + L9 > 5, X is L5 + L9 - 5.
new_state([L5,L9,_],[X,0,[L5,L9]]):-
    not(L5 = 5), not(L9 = 0), X is L5 + L9.

bfs([s(State,Path)|_],_,_,Path):-
    end_state(State).
bfs([s(State,Path|Front)],NextFront,History,EndPath):-
    findall(State1,(new_state(State,State1)),NextStates),
    next_front(NextStates,NextFront,NextF1,History,Path),
    history(State,History,NewHistory),
    bfs(Front,NextF1,NewHistory,EndPath).

bfs([],[],_,_):-
    !, fail.

bfs([],NextFront,History,Path):-
    bfs(NextFront,[],History,Path).

next_front([State|NextStates],NextFront,[s(State,[Path])|NextF1],History,Path):-
    not(member(State,History)),
    !,
    next_front(NextStates,NextFront,NextF1,History,Path).

next_front([_|NextStates],NextFront,NextF1,History,Path):-
    next_front(NextStates,NextFront,NextF1,History,Path).

next_front([],NextFront,NextFront,_,_).

history(State,History,History):-
    end_state(State),
    !.

history(State,History,[State|History]).
