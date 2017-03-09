% Clauses valid_seq
% Sert à vérifier si une séquence donnée en entrée respecte les contraintes.
% Proto:
%   valid_seq(CONSTRAINTS, SEQ)
%   CONSTRAINTS = Une liste de constraintes. Ex : [1,4,5]
%   SEQ = La séquence à analyser. Peut être une ligne ou une colonne.

% Clause finale (cas plancher).
% Si la liste de contraintes est vide ET que la séquence est vide, la clause est vraie
valid_seq([],[]).

% Clause arrêt. 
% Si il reste des contraintes et que la séquence est vide, la clause est fausse
valid_seq(_, []) :- !, fail.

% Clause case vide
% Si le premier élément de la liste est blanc, on continue avec NextSeq et les mêmes contraintes
% (Consiste à sauter les cases blanches)
valid_seq(CONSTRAINTS, [FirstElem|NextSeq]):-
    isWhite(FirstElem), 
    valid_seq(CONSTRAINTS, NextSeq).

% Clause case pleine
% Si le premier élément de la liste est noir, on compte s'il est suivi de FirstConstraint-1 case noires.
% Fais appel à la clause count.
% Si count est vraie (ie. on a bien vérifié la contrainte donnée), on relance valid_seq avec les contraintes
% restantes et les éléments de la séquence restante. 
valid_seq([FirstConstraint|NextConstraint], [FirstElem|NextSeq]):-
    isBlack(FirstElem),
    count(FirstConstraint, [FirstElem|NextSeq], Remaining),
    valid_seq(NextConstraint, Remaining).

% Clauses isWhite/isBlack. Straightforward.
isWhite(X):- X==0.
isBlack(X):- X==1.

% Clauses count.
% Sert à vérifier que les cases noires successives respectent la contrainte donnée.
% De plus, il faut, si la sequence restante n'est pas vide, vérifier que la case suivante est blanche
% Proto:
%   count(Constraint, Seq, Remaining)
%   Constraint : La contrainte courante à vérifier. Sera décrémentée jusqu'à arriver zero
%   Seq : La séquence à analyser
%   Remaining : Variable de sortie, donne la séquence restante à analyser.

% Cas plancher(Séquence vide)
count(0, [], Remaining):-
    Remaining = [].

% Cas plancher(case suivante noire)
% Echoue
count(0, [Head|_], Remaining):-
    isBlack(Head),
    !, fail.

% Cas plancher(case suivante blanche)
% Retourne la sequence qu'il reste à traiter dans Remaining
count(0, [Head|Tail], Remaining):-
    isWhite(Head),
    Remaining = Tail.

% Vérifie que la tête est noire
% Si oui, on diminue la contrainte de 1 et on relance jusqu'à arriver à un cas plancher.
count(Constraint, [Head|Tail], Remaining):-
    isBlack(Head),
    ConstraintNext is Constraint - 1,
    count(ConstraintNext, Tail, Remaining).



