%%%%%%%%%%%%%%%%% Picross algorithm section %%%%%%%%%%%%%%%%%%%%%%%%%%

% Clauses valid_seq
% Sert à vérifier si une séquence donnée en entrée respecte les contraintes.
% Proto:
%   valid_seq(+CONSTRAINTS, +SEQ)
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
isWhite(0).
isBlack(1).

% Clauses count.
% Sert à vérifier que les cases noires successives respectent la contrainte donnée.
% De plus, il faut, si la sequence restante n'est pas vide, vérifier que la case suivante est blanche
% Proto:
%   count(+Constraint, +Seq, -Remaining)
%   Constraint : La contrainte courante à vérifier. Sera décrémentée jusqu'à arriver zero
%   Seq : La séquence à analyser
%   Remaining : Variable de sortie, donne la séquence restante à analyser.

% Cas plancher(Séquence vide)
count(0, [], Remaining):-
    Remaining = [].

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

% Clauses valid_lines
% Parcours la matrice X pour vérifier que les lignes respectent les contraintes
% Proto:
%   valid_lines(+LinesConstraints, -X)
%   ConstraintsLines : Liste des contraintes pour chaque lignes
%   X : La matrice

% Cas plancher, on a plus rien à vérifier
valid_lines([], []).

% Cas echec, si jamais on a des dimensions de listes de listes différentes
% valid_lines(_, []):- !,fail.
% valid_lines([], _):- !,fail.

% Cas récursif
% On set de manière que les variables sont soit 0 soit 1. Et on vérifie la ligne avec valid_seq.
% On relance alors avec la suite.
valid_lines([FirstConstraint|NextConstraints], [FirstLine|NextLines]):-
    valid_seq(FirstConstraint, FirstLine),
    valid_lines(NextConstraints, NextLines).

% Clause valid_collumns
% Parcours la matrice X pour vérifier que les collones respectent les contraintes
% Identique à valid_lines mais sur la transposée
% Proto:
%   valid_collumns(+Constraints, -Grid)
%   Constraints : Liste des contraintes pour chaque lignes
%   Grid : La matrice
valid_collumns(Constraints, Grid):-
    transposed(Grid, TransposedGrid),
    valid_lines(Constraints, TransposedGrid).

% Aide fonctions pour générer des matrices de variables non-unifiées.
var_list(N,L) :- 
    length(L,N).

% Matrice carrée Size*Size
var_matrix(Size, M):-
    var_matrix_bis(Size, Size, M).

% Matrice rectangulaire Lines*Collumns
var_matrix(Lines, Collumns, M):-
    var_matrix_bis(Lines, Collumns, M).

var_matrix_bis(0, Collumns, Last):-
    Last = [].

var_matrix_bis(Count, Collumns, [First|Tail]):-
    var_list(Collumns, First),
    CountBis is Count - 1,
    var_matrix_bis(CountBis, Collumns, Tail).

% Clause qui résout un problème sur une série de contraintes (matrice carrée).
resolve(Size, LinesConstraints, CollumnsConstraints):-
    resolve(Size, Size, LinesConstraints, CollumnsConstraints).

% Clause qui résout un problème sur une série de contraintes (matrice rectangulaire).
resolve(SizeLines, SizeCollumns, LinesConstraints, CollumnsConstraints):-
    var_matrix(SizeLines, SizeCollumns, M),
    valid_lines(LinesConstraints, M),
    valid_collumns(CollumnsConstraints, M),
    print_nonogram(M).

% Fonctions transposée. Pour une raison inconnue, la fonction
% standard ne fonctionnait pas (renvoyait toujours false)
transposed([], []).
transposed([F|Fs], Ts) :-
    transposed(F, [F|Fs], Ts).

transposed([], _, []).
transposed([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transposed(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).

%%%%%%%%%%%%%%% Print Section %%%%%%%%%%%%%

print_nonogram(N) :-
    nl,write('Found nonogram:'),nl,
    print_nonogram1(N).

print_nonogram1([]).

print_nonogram1([Line | Lines]) :-
    print_line(Line),nl,
    print_nonogram1(Lines).

print_line([]).
print_line([Head | Tail]) :-
    Head = 1,
    write('# '),
    print_line(Tail).

print_line([Head | Tail]) :-
    Head = 0,
    write('. '),
    print_line(Tail).

%%%%%%%%%%%%%% Test Section %%%%%%%%%%%%%%

% Exemples de test:

% Test1:
test1():-
    Test1_Size is 5,
    Test1_Lines = [[5],[1],[5],[1],[5]],
    Test1_Collumns = [[3,1], [1,1,1], [1,1,1], [1,1,1], [1,3]],

    resolve(Test1_Size, Test1_Lines, Test1_Collumns).

% Res :
%     #####
%     #....
%     #####
%     ....#
%     #####

% Test2:
test2():-
    Test2_Size is 5,
    Test2_Lines = [[1,1,1], [5], [3], [1,1], [3]],
    Test2_Collumns = [[2], [4], [3,1], [4], [2]],

    resolve(Test2_Size, Test2_Lines, Test2_Collumns).

% Res :
%     #.#.#
%     #####
%     .###.
%     .#.#.
%     .###.

% Test3:
test3():-
    Test3_Size is 10,
    Test3_Lines = [[2,2], [2,4,2], [1,3,2,1], [4,3], [4,3], [3,4], [2,5], [6], [4], [2,2]],
    Test3_Collumns = [[2], [2,4], [1,6,1], [5,3], [4,3], [1,4], [9], [1,6,1], [2,4], [2]],

    resolve(Test3_Size, Test3_Lines, Test3_Collumns).

% Res :
%     .##....##.
%     ##.####.##
%     #.###.##.#
%     .####.###.
%     .####.###.
%     .###.####.
%     .##.#####.
%     ..######..
%     ...####...
%     ..##..##..

% Test4:
test4():-
    Test4_Size is 15,
    Test4_Lines = [[10,2], [9,1], [9,4], [9,5], [2,5,4], [1,1,2,4], [2,2,2,3], [2,1,2,2,2], [3,2,1,2,1], [3,2,1,1,1], [3,2,1,1,1], [2,2,1,1,1], [1,1,1], [2,2], [15]],
    Test4_Collumns = [[4,6,3], [5,6,2], [5,4,1], [4,1,1,1], [4,1,1,1,1], [5,1,1,1,1], [5,1,1,1,1], [5,1,1,1,1], [6,1,1,1], [1,4,1,1,1], [1,3,1], [4,1,1], [5,4,1], [1,6,2], [15]],

    resolve(Test4_Size, Test4_Lines, Test4_Collumns).

% Res :
%     ##########...##
%     #########.....#
%     #########..####
%     .##..#####.####
%     #..#....##.####
%     ##..##...##.###
%     ##.#..##.##..##
%     ###.##..#.##..#
%     ###...##.#..#.#
%     ###.##..#...#.#
%     .##...#..#..#.#
%     #...........#.#
%     ##...........##
%     ###############

