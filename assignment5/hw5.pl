
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
meet(A, B) :- enroll(A, Z), enroll(B, Z), where(Z, L), 

/* Exercise 2 */


