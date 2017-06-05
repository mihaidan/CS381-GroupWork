
/* Exercise 1 */

when(275,10).
when(261,12).
when(381,11).
when(398,12).
when(399,12).

where(275,owen102).
where(261,dear118).
where(381,cov216).
where(398,dear118).
where(399,cov216).

enroll(mary,275).
enroll(john,275).
enroll(mary,261).
enroll(john,381).
enroll(jim,399).

/* Part a */

schedule(S, L, T) :- enroll(S, Z), where(Z, L), when(Z, T).

/* Part b */

usage(L, T) :- where(Z, L), when(Z, T).

/* Part c*/

conflict(L, T) :- when(Z, T), where(Z, L), when(W, T), where(W, L), W \= Z. 

/* Part d Work in progress*/
meet(A, B) :- schedule(A, L, T), schedule(B, L, T), A\=B, schedule(A, L, T1), schedule(B, L, T2), T1\==T2+1, A\=B.

/* Exercise 2
Part a*/

rdup(L, M) :- rduop2(L, M).
rdup2([],[]).
rdup2([H|T1], [H|T2]) :- rdup2(T1,T2) not(member(H, T1)).
rdup2([H|T1], T2) :- rdup2(T1, T2), member(H, T1).

/* Part b */
flat(L, F) :- flat(L, [], F).
flat([], F, F).
flat([H|T], L, F) :-
     flat(H, L1, F),
     flat(T, L, L1).
flat(H, F, [H|F]) :- \+ is_list(H).

/* Part c */
project()
