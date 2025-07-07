% ------------------------------
% Facts
% ------------------------------
supervise(james, franklin).
supervise(franklin, john).
supervise(franklin, ramesh).
supervise(franklin, joyce).
supervise(james, jennifer).
supervise(jennifer, alicia).
supervise(jennifer, ahmed).

% ------------------------------
% Rules
% ------------------------------
superior(X, Y) :- supervise(X, Y).
superior(X, Y) :- supervise(X, Z), superior(Z, Y).
