% Modélisation Sudoku.

% Librairie pour la définition du prédicat alldifferent
include "alldifferent.mzn";
include "globals.mzn";

int: n = 9;

% Domaine est un ensemble de int
set of int: domaine = 1..n;

% grille est un tableau à deux dimension de case, indexé par le numéro de ligne et colonne, avec des variables de type integer
array [domaine, domaine] of int: grille;

array [domaine, domaine] of int: region;

% Grille du Sudoku, les 0 correspondent aux cases vides à remplir  
grille =
[| 3, 0, 0, 0, 0, 0, 0, 0, 4
| 0, 0, 2, 0, 6, 0, 1, 0, 0
| 0, 1, 0, 9, 0, 8, 0, 2, 0
| 0, 0, 5, 0, 0, 0, 6, 0, 0
| 0, 2, 0, 0, 0, 0, 0, 1, 0
| 0, 0, 9, 0, 0, 0, 8, 0, 0
| 0, 8, 0, 3, 0, 4, 0, 6, 0
| 0, 0, 4, 0, 1, 0, 9, 0, 0
| 5, 0, 0, 0, 0, 0, 0, 0, 7
|];

region =
[| 1, 1, 1, 2, 3, 3, 3, 3, 3
| 1, 1, 1, 2, 2, 2, 3, 3, 3
| 1, 4, 4, 4, 4, 2, 2, 2, 3
| 1, 1, 4, 5, 5, 5, 5, 2, 2
| 4, 4, 4, 4, 5, 6, 6, 6, 6
| 7, 7, 5, 5, 5, 5, 6, 9, 9
| 8, 7, 7, 7, 6, 6, 6, 6, 9
| 8, 8, 8, 7, 7, 7, 9, 9, 9
| 8, 8, 8, 8, 8, 7, 9, 9, 9
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

% region_chaos(r) contraint les régions aux formes irrégulières d'être distinctes.
predicate region_chaos (int: r) = 
	(alldifferent([ puzzle[ligne,colonne] | ligne,colonne in domaine where region[ligne,colonne]==r ]));

% Utilisation des prédicats pour contraindre les valeurs de la grille.
constraint forall (ligne in domaine)
	   (ligne_diff(ligne));

constraint forall (colonne in domaine)
	   (colonne_diff(colonne));

constraint forall (r in domaine)
	(region_chaos (r));

	
% Problème de satisfaction : trouver les valeurs pour les variables de décisions pour satisfaire les contraintes. 
solve satisfy;

% Affichage
output [if j = 1 then "\n" else " " endif ++
    show(puzzle[i,j]) | i,j in domaine] ++ ["\n"];


% > time mzn-g12fd chaos_sudoku.mzn
% real: 0m0.531s
% user: 0m0.024s
% sys:  0m0.008s
