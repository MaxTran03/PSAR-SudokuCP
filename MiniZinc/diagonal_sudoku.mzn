% Modélisation Sudoku.

% Librairie pour la définition du prédicat alldifferent
include "alldifferent.mzn";

int: n = 9;

% Domaine est un ensemble de int
set of int: domaine = 1..n;

% grille est un tableau à deux dimension de case, indexé par le numéro de ligne et colonne, avec des variables de type integer
array [domaine, domaine] of int: grille;

% Grille du Sudoku, les 0 correspondent aux cases vides à remplir  
grille =
[| 0, 0, 0, 0, 0, 2, 0, 7, 0
| 0, 0, 5, 0, 0, 0, 0, 0, 1
| 0, 1, 0, 0, 0, 6, 0, 0, 0
| 0, 0, 0, 0, 2, 0, 8, 0, 6
| 0, 0, 0, 8, 0, 5, 0, 0, 0
| 6, 0, 8, 0, 3, 0, 0, 0, 0
| 0, 0, 0, 4, 0, 0, 0, 3, 0
| 7, 0, 0, 0, 0, 0, 1, 0, 0
| 0, 8, 0, 2, 0, 0, 0, 0, 0
|];

% puzzle : variable de decision
% 1..9 : domaine d'association
array[domaine,domaine] of var domaine: puzzle;
 

% copie grille dans un tableau de variables
constraint forall(i,j in domaine)(
    if grille[i,j] > 0 then puzzle[i,j] = grille[i,j] else true endif );


% ligne_diff(ligne) contraint les cases de la ligne ligne à être distinctes.
predicate ligne_diff(int: ligne) =
	alldifferent (colonne in domaine) (puzzle[ligne, colonne]);

% colonne_diff(colonne) contraint les cases de la colonne colonne à être distinctes.
predicate colonne_diff(int: colonne) =
	alldifferent (ligne in domaine) (puzzle[ligne, colonne]);

% region_diff(ligne) de même pour les régions à être différentes.
predicate region_diff(int: ligne, int: colonne) =
	alldifferent (i, j in 0..2) (puzzle[ligne + i, colonne + j]);

% Utilisation des prédicats pour contraindre les valeurs de la grille.
constraint forall (ligne in domaine)
	   (ligne_diff(ligne));
constraint forall (colonne in domaine)
	   (colonne_diff(colonne));
constraint forall (ligne, colonne in {1, 4, 7})
	   (region_diff(ligne, colonne)); 

% Contraintes sur les diagonales montante et descendante
constraint (alldifferent ([ puzzle[ligne, ligne] | ligne in domaine]));
constraint (alldifferent ([ puzzle[10-ligne, ligne] | ligne in domaine]));

% Problème de satisfaction : trouver les valeurs pour les variables de décisions pour satisfaire les contraintes. 
solve satisfy;

% Affichage
output [if j = 1 then "\n" else " " endif ++
    show(puzzle[i,j]) | i,j in domaine] ++ ["\n"];


