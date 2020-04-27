initial_state([0,0]). %start state -- empty buckets

final_state([3,_]). %goals
final_state([_,3]).

main():- %program start
    initial_state(State),
    bfs(State-[],[],[]).

bfs(State-[],History,[]):- %for start state - empty queue for further bfs
    append_cor(History,State,NewHistory),
    findall(X-[State], (search_states(State,X),not(member(X,NewHistory))),[NextState-P|T]),
    bfs(NextState-[P],NewHistory,T).
bfs(State-Path,_,[_]):-   %goal is found in bfs
    final_state(State),
    append_cor(Path,State,FinalPath),
    write(FinalPath).
bfs(State-Path,History,[Queue-PQ|Tail]):- %bfs (1 path length of the next state)
    length(PQ,0), %brackets output problem solver
    append_cor(History,State,NewHistory),
    findall(X-P1, (search_states(State,X),not(member(X,NewHistory)),append(Path,[State],P1)),[NextStates-P|T]),
    append(Tail,[NextStates-P|T],NewQueue),
    bfs(Queue-[PQ],NewHistory,NewQueue).
bfs(State-Path,History,[Queue-PQ|Tail]):- %bfs (more than 1 path length of the next state)
    append_cor(History,State,NewHistory),
    findall(X-P1, (search_states(State,X),not(member(X,NewHistory)),append(Path,[State],P1)),[NextStates-P|T]),
    append(Tail,[NextStates-P|T],NewQueue),
    bfs(Queue-PQ,NewHistory,NewQueue).
bfs(State-_,History,[Queue-PQ|Tail]):- %there is no any next state
    append_cor(History,State,NewHistory),
    bfs(Queue-PQ,NewHistory,Tail).


append_cor(Queue,[L5,L9],Q):- %helper for correct append of states
    append(Queue,[[L5,L9]],Q).

search_states([L5,L9],[NL5,NL9]):- %get next states
    state([L5,L9],[NL5,NL9]).

state([L5,L9],[5,L9]):- %fill up L5
    L5 = 0.
state([L5,L9],[L5,9]):- %fill up L9
    L9 = 0.
state([L5,L9],[0,L9]):- %pour out L5
    not(L5 = 0).
state([L5,L9],[L5,0]):- %pour out L9
    not(L9 = 0).
state([L5,L9],[NL5,9]):- %pour from L5 to L9, L9 is filled up
    not(L5 = 0),
    not(L9 = 9),
    L5 + L9 > 9,
    NL5 is L5 + L9 - 9.
state([L5,L9],[0,NL9]):- %pour from L5 to L9, L5 is empty
    not(L5 = 0),
    not(L9 = 9),
    L5 + L9 =< 9,
    NL9 is L5 + L9.
state([L5,L9],[5,NL9]):-  %pour from L9 to L5, L5 is filled up
    not(L5 = 5),
    not(L9 = 0),
    L5 + L9 > 5,
    NL9 is L5 + L9 - 5.
state([L5,L9],[NL5,0]):- %pour from L9 to L5, L9 is empty
    not(L5 = 5),
    not(L9 = 0),
    L5 + L9 =< 5,
    NL5 is L5 + L9.
