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

% Clause case pleine
% Si le premier élément de la liste est noir, on compte s'il est suivi de FirstConstraint-1 case noires.
% Fais appel à la clause count.
% Si count est vraie (ie. on a bien vérifié la contrainte donnée), on relance valid_seq avec les contraintes
% restantes et les éléments de la séquence restante. 
valid_seq([FirstConstraint|NextConstraint], [FirstElem|NextSeq]):-
    isBlack(FirstElem),
    count(FirstConstraint, [FirstElem|NextSeq], Remaining),
    valid_seq(NextConstraint, Remaining).

% Clause case vide
% Si le premier élément de la liste est blanc, on continue avec NextSeq et les mêmes contraintes
% (Consiste à sauter les cases blanches)
valid_seq(CONSTRAINTS, [FirstElem|NextSeq]):-
    isWhite(FirstElem), 
    valid_seq(CONSTRAINTS, NextSeq).

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

var_matrix_bis(0, _, Last):-
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
    preprocess(LinesConstraints, CollumnsConstraints, M),
    valid_lines(LinesConstraints, M),
    valid_collumns(CollumnsConstraints, M),
    write('Résultat :'),nl,
    print_nonogram(M),nl.

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


%%%%%%%%%%%%%%%%% Picross preprocessing section %%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcule le nombre de contraintes avec espace
% Il s'agit de la somme de chaque contrainte + un 1 entre chaque contrainte (à cause de la case blanche après chaque bloc noir)
% Exemple : [3] donne 3
%           [1,1] donne 3
sumConstraintsWithSpace([Elem|[]], Sum):-
    !, Sum is Elem.

sumConstraintsWithSpace([Elem|Tail], Sum):-
    sumConstraintsWithSpace(Tail, Aux),
    Sum is Elem + Aux + 1.

% Calcule le nombre de contraintes sans espace
% Il s'agit de la somme de chaque contrainte.
% Exemple : [3] donne 3
%           [1,1] donne 2
sumConstraintsWithoutSpace([Elem|[]], Sum):-
    !, Sum is Elem.

sumConstraintsWithoutSpace([Elem|Tail], Sum):-
    sumConstraintsWithoutSpace(Tail, Aux),
    Sum is Elem + Aux.

% Calcule le nombre de cases noires dans une séquence
sumBlackCells([], Sum):-
    !, Sum is 0.

sumBlackCells([Head|Tail], Sum):-
    var(Head), !,
    sumBlackCells(Tail, Sum).

sumBlackCells([Head|Tail], Sum):-
    isWhite(Head), !,
    sumBlackCells(Tail, Sum).

sumBlackCells([Head|Tail], Sum):-
    isBlack(Head), !,
    sumBlackCells(Tail, Aux),
    Sum is Aux + 1.

% Rempli une séquence de blanc là où les variables sont non unifiées
fillSeqWithWhite([]).

fillSeqWithWhite([Head|Tail]):-
    var(Head),!,
    isWhite(Head),!,
    fillSeqWithWhite(Tail).

fillSeqWithWhite([Head|Tail]):-
    fillSeqWithWhite(Tail).


% Fonctions de préprocessing, qui permettent de remplir la grille avec les lignes/Colonnes dont on est sûr
% C'est à dire que le nombre de contraintes est identique à la taille de la ligne.
% Pour les colonnes même combat, on utilise la transposée.
preprocessLines([], []).

preprocessLines([Constraint|NextConstraints], [Line|NextLines]):-
    sumConstraintsWithSpace(Constraint, SumConstraints),
    length(Line, SizeLine),
    SumConstraints =:= SizeLine,
    valid_seq(Constraint, Line),
    preprocessLines(NextConstraints, NextLines).

preprocessLines([Constraint|NextConstraints], [Line|NextLines]):-
    preprocessLines(NextConstraints, NextLines).

preprocessCollumns(Constraints, Grid):-
    transposed(Grid, TransposedGrid),
    preprocessLines(Constraints, TransposedGrid),
    transposed(TransposedGrid, Grid).

% Après une première passe, on peut assigner en blanc toutes les cases non unifiées si sur la ligne toutes
% les contraintes sont respectées
preprocessLinesSecondPass([],[]).

preprocessLinesSecondPass([Constraint|NextConstraints], [Line|NextLines]):-
    sumConstraintsWithoutSpace(Constraint, SumConstraints),
    sumBlackCells(Line, SizeLine),
    SumConstraints =:= SizeLine,
    fillSeqWithWhite(Line),
    preprocessLinesSecondPass(NextConstraints, NextLines).

preprocessLinesSecondPass([Constraint|NextConstraints], [Line|NextLines]):-
    preprocessLinesSecondPass(NextConstraints, NextLines).

preprocessCollumnsSecondPass(Constraints, Grid):-
    transposed(Grid, TransposedGrid),
    preprocessLinesSecondPass(Constraints, TransposedGrid),
    transposed(TransposedGrid, Grid).

% La troisième passe consiste à compléter les blocs noirs si ils sont définis aux extrémités de la grille
% On rajoute aussi une case blanche après un bloc noir.

preprocessLinesThirdPass([], []).

preprocessLinesThirdPass([Constraint|NextConstraints], [Line|NextLines]):-
    checkFirstCell(Constraint, Line),
    checkLastCell(Constraint, Line, _),
    preprocessLinesThirdPass(NextConstraints, NextLines).

preprocessCollumnsThirdPass(Constraints, Grid):-
    transposed(Grid, TransposedGrid),
    preprocessLinesThirdPass(Constraints, TransposedGrid),
    transposed(TransposedGrid, Grid).

% Ces clauses vérifient si la première case est noire. Si oui, on rempli toute la
% suite avec le nombre de cases noires correspondant à la première contrainte.
checkFirstCell([FirstConstraint|_], [FirstElem|Next]):-
    nonvar(FirstElem),
    isBlack(FirstElem),
    Count is FirstConstraint - 1,
    fillWithBlack(Next, Count).

% Si jamais nonvar(FirstElem) ou isBlack(FirstElem) échoue (aka. la première case
% est indéterminée ou blanche), on sort avec la clause toujours vraie.
checkFirstCell(_, _).

% Clauses pour remplir de noir.
% Celle ci vérifie si on a atteint le nombre de cases noires à remplir.
% On rajoute alors une case blanche.
fillWithBlack([Elem|_], Count):-
    Count =:= 0,
    isWhite(Elem).

% Dans le cas où il reste à remplir, on remplit.
fillWithBlack([Elem|Next], Count):-
    Count > 0,
    isBlack(Elem),
    Aux is Count - 1,
    fillWithBlack(Next, Aux).

% Clauses vérifiant si la dernière case est noire. Si oui on rempli
% toutes les cases précédent correspondant à la dernière contrainte.

checkLastCell([LastConstraint|[]], [LastElem|[]], Count):-
    nonvar(LastElem),
    isBlack(LastElem),
    Count is LastConstraint.

checkLastCell([_|[]], [_|[]], Count):-
    Count is 0.

% S'il reste des contraintes, on relance la clause pour n'avoir que la dernière contrainte
checkLastCell([_|NextConstraints], [LastElem|[]], Count):-
    checkLastCell(NextConstraints, [LastElem|[]], Aux),
    Count is Aux.

checkLastCell(Constraints, [Elem|Next], Count):-
    checkLastCell(Constraints, Next, Aux),
    cutCheckLastCell(Elem, Aux),
    Count is Aux - 1.

% Clauses pour arrêter la remontée des clauses.
cutCheckLastCell(_, Count):-
    var(Count).

cutCheckLastCell(_, Count):-
    nonvar(Count),
    Count < 1.

cutCheckLastCell(Elem, Count):-
    nonvar(Count),
    Count =:= 1,
    isWhite(Elem).

cutCheckLastCell(Elem, Count):-
    nonvar(Count),
    Count > 1,    
    isBlack(Elem).

% Preprocess général
% Les différentes passes peuvent être exécutées plusieurs fois et 
% dans un ordre différetnt.
% Exemple ici, on effectue la passe 3 deux fois de suite car il est
% possible que la première fois, cette passe rajoute des cases noires aux extrémités
% On peut donc relancer la passe.
% De même on relance la passe 2 si jamais on a rempli des lignes/colonnes avec toutes les contraintes.
preprocess(LinesConstraints, CollumnsConstraints, Grid):-
    preprocessLines(LinesConstraints,Grid),
    preprocessCollumns(CollumnsConstraints,Grid),
    preprocessLinesSecondPass(LinesConstraints,Grid),
    preprocessCollumnsSecondPass(CollumnsConstraints,Grid),
    preprocessLinesThirdPass(LinesConstraints,Grid),
    preprocessCollumnsThirdPass(CollumnsConstraints,Grid),
    preprocessLinesThirdPass(LinesConstraints,Grid),
    preprocessCollumnsThirdPass(CollumnsConstraints,Grid),
    preprocessLinesSecondPass(LinesConstraints,Grid),
    preprocessCollumnsSecondPass(CollumnsConstraints,Grid),
    write('Passes : 1->2->3->3->2 (? = inconnu)'),nl,
    print_nonogram(Grid),nl.
    

%%%%%%%%%%%%%%% Print Section %%%%%%%%%%%%%

print_nonogram(N) :-
    nl,print_nonogram1(N).

print_nonogram1([]).

print_nonogram1([Line | Lines]) :-
    print_line(Line),nl,
    print_nonogram1(Lines).

print_line([]).

print_line([Head | Tail]) :-
    var(Head),
    write('?'),
    print_line(Tail).

print_line([Head | Tail]) :-
    Head = 1,
    write('#'),
    print_line(Tail).

print_line([Head | Tail]) :-
    Head = 0,
    write('.'),
    print_line(Tail).

%%%%%%%%%%%%%% Test Section %%%%%%%%%%%%%%

% Exemples de test:

% Test1:
test1():-
    nl,write('%%%%%%%%%% Test1 %%%%%%%%%%'),nl,
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
    nl,write('%%%%%%%%%% Test2 %%%%%%%%%%'),nl,
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
    nl,write('%%%%%%%%%% Test3 %%%%%%%%%%'),nl,
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
    nl,write('%%%%%%%%%% Test4 %%%%%%%%%%'),nl,
    Test4_Size is 15,
    Test4_Lines = [[10,2], [9,1], [9,4], [9,5], [2,5,4], [1,1,2,4], [2,2,2,3], [2,1,2,2,2], [3,2,1,2,1], [3,2,1,1,1], [3,2,1,1,1], [2,2,1,1,1], [1,1,1], [2,2], [15]],
    Test4_Collumns = [[4,6,3], [5,6,2], [5,4,1], [4,1,1,1], [4,1,1,1,1], [5,1,1,1,1], [5,1,1,1,1], [5,1,1,1,1], [6,1,1,1], [1,4,1,1,1], [1,3,1], [4,1,1], [5,4,1], [1,6,2], [15]],

    resolve(Test4_Size, Test4_Lines, Test4_Collumns).

% Res :
%   ##########...##
%   #########.....#
%   #########..####
%   #########.#####
%   .##..#####.####
%   #..#....##.####
%   ##..##...##.###
%   ##.#..##.##..##
%   ###.##..#.##..#
%   ###...##.#..#.#
%   ###.##..#...#.#
%   .##...##.#..#.#
%   #...........#.#
%   ##...........##
%   ###############

% Exécution de tous les tests
allTests():-
    nl,write('Exécution de tous les tests...'),nl,
    test1(),
    test2(),
    test3(),
    test4().

allTestsWithInfo():-
    nl,write('Exécution de tous les tests avec info... AVEC 5 PASSES DE PREPROCESSING'),nl,
    time(test1()),
    time(test2()),
    time(test3()),
    time(test4()).

