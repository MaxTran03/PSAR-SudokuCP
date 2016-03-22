% Modélisation Sudoku.

% Librairie pour la définition du prédicat alldifferent
include "alldifferent.mzn";
include "globals.mzn";

int: n = 9;

% Domaine est un ensemble de int
set of int: domaine = 1..n;
set of int: sous_region = 1..29;

% grille est un tableau à deux dimension de case, indexé par le numéro de ligne et colonne, avec des variables de type integer
array [domaine, domaine] of int: grille;
array [sous_region] of int: region_somme;
array [domaine, domaine] of int: sous_grille;

% Grille du Sudoku, les 0 correspondent aux cases vides à remplir  
grille =
[| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
| 0, 0, 0, 0, 0, 0, 0, 0, 0
|];

sous_grille = 
[| 1,  1,  2,  2,  2,  3,  4,  5, 6
|  7,  7,  8,  8,  3,  3,  4,  5, 6
|  7,  7,  9,  9,  3, 10, 11, 11, 6
| 12, 13, 13,  9, 14, 10, 11, 15, 6
| 12, 16, 16, 17, 14, 10, 15, 15, 22
| 18, 16, 19, 17, 14, 20, 21, 21, 22
| 18, 19, 19, 17, 26, 20, 20, 23, 23
| 18, 24, 25, 26, 26, 28, 28, 23, 23
| 18, 24, 25, 26, 27, 27, 27, 29, 29
|];

region_somme = [3,15,22,4,16,15,25,17,9,8,20,6,14,17,17,13,20,27,6,20,6,12,14,8,16,10,13,15,17];


% puzzle : variable de decision
% 1..9 : domaine d'association
array[domaine,domaine] of var domaine: puzzle;
 

% copie grille dans un tableau de variables
constraint forall(i,j in domaine)(
    if grille[i,j] > 0 then puzzle[i,j] = grille[i,j] else true endif );


% Prédicats pour que les valeurs de chaque ligne, colonne et régions soient distinctes.
predicate ligne_diff(int: ligne) =
	alldifferent (colonne in domaine) (puzzle[ligne, colonne]);

predicate colonne_diff(int: colonne) =
	alldifferent (ligne in domaine) (puzzle[ligne, colonne]);

predicate region_diff(int: ligne, int: colonne) =
	alldifferent (i, j in 0..2) (puzzle[ligne + i, colonne + j]);


% Utilisation des prédicats pour contraindre les valeurs de la grille.
constraint forall (ligne in domaine)
	   (ligne_diff(ligne));

constraint forall (colonne in domaine)
	   (colonne_diff(colonne));

constraint forall (ligne, colonne in {1, 4, 7})
	   (region_diff(ligne, colonne)); 

constraint forall (r in sous_region)
	(sum([ puzzle[ligne,colonne] | ligne,colonne in domaine where sous_grille[ligne, colonne] == r ]) == region_somme[r]);


% Problème de satisfaction : trouver les valeurs pour les variables de décisions pour satisfaire les contraintes. 
solve satisfy;

% Affichage
output [if j = 1 then "\n" else " " endif ++
    show(puzzle[i,j]) | i,j in domaine] ++ ["\n"];


% > time mzn-g12fd killer_sudoku.mzn
% real: 0m0.81s
% user: 0m0.020s
% sys:  0m0.000s
