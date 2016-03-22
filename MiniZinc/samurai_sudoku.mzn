% Modélisation Sudoku.

% Librairie pour la définition du prédicat alldifferent
include "alldifferent.mzn";

int: n = 21;

% Domaine est un ensemble de int
% Taille est la taille du Sudoku
set of int: taille = 1..n;
set of int: domaine = 1..9;

% grille est un tableau à deux dimension de case, indexé par le numéro de ligne et colonne, avec des variables de type integer
array [taille, taille] of int: grille;

% Grille du Sudoku, les 0 correspondent aux cases vides à remplir  
grille =
[| 0, 0, 0, 9, 0, 0, 0, 3, 0,10,10,10, 0, 0, 0, 8, 0, 0, 0, 2, 0
|  9, 0, 0, 1, 0, 0, 5, 0, 0,10,10,10, 6, 0, 0, 5, 0, 0, 3, 0, 0
|  0, 8, 0, 0, 7, 6, 0, 0, 0,10,10,10, 0, 4, 0, 0, 6, 7, 0, 0, 0
|  0, 0, 1, 0, 0, 0, 0, 8, 5,10,10,10, 0, 0, 4, 0, 0, 0, 0, 9, 8
|  0, 0, 6, 0, 0, 0, 4, 0, 0,10,10,10, 0, 0, 9, 0, 0, 0, 2, 0, 0
|  2, 5, 0, 0, 0, 0, 3, 0, 0,10,10,10, 3, 2, 0, 0, 0, 0, 6, 0, 0
|  0, 0, 0, 4, 6, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 3, 7, 0, 0, 5, 0
|  0, 0, 3, 0, 0, 2, 0, 0, 8, 0, 0, 0, 0, 0, 6, 0, 0, 2, 0, 0, 7
|  0, 7, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 5, 0, 0, 0, 1, 0, 0, 0
| 10,10,10,10,10,10, 0, 0, 0, 0, 6, 0, 2, 0, 0,10,10,10,10,10,10
| 10,10,10,10,10,10, 0, 0, 0, 9, 0, 8, 0, 0, 0,10,10,10,10,10,10
| 10,10,10,10,10,10, 0, 0, 6, 0, 7, 0, 0, 0, 0,10,10,10,10,10,10
|  0, 0, 0, 8, 0, 0, 0, 9, 0, 0, 0, 5, 0, 0, 0, 7, 0, 0, 0, 6, 0
|  1, 0, 0, 2, 0, 0, 4, 0, 0, 0, 0, 0, 6, 0, 0, 8, 0, 0, 1, 0, 0
|  0, 4, 0, 0, 1, 6, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 9, 3, 0, 0, 0
|  0, 0, 6, 0, 0, 0, 0, 5, 4,10,10,10, 0, 0, 3, 0, 0, 0, 0, 7, 9
|  0, 0, 5, 0, 0, 0, 7, 0, 0,10,10,10, 0, 0, 7, 0, 0, 0, 2, 0, 0
|  8, 9, 0, 0, 0, 0, 2, 0, 0,10,10,10, 8, 6, 0, 0, 0, 0, 5, 0, 0
|  0, 0, 0, 6, 2, 0, 0, 3, 0,10,10,10, 0, 0, 0, 4, 7, 0, 0, 2, 0
|  0, 0, 2, 0, 0, 5, 0, 0, 8,10,10,10, 0, 0, 2, 0, 0, 6, 0, 0, 7
|  0, 1, 0, 0, 0, 3, 0, 0, 0,10,10,10, 0, 3, 0, 0, 0, 8, 0, 0, 0
|];

% puzzle : variable de decision
% 1..9 : domaine d'association
array[taille,taille] of var domaine: puzzle;
 

% copie grille dans un tableau de variables si la valeur est supérieur à 0 et inférieur à 10
% Dans notre cas, 10 correspond à vide
constraint forall(i,j in taille)(
    if grille[i,j] > 0 /\ grille[i,j] < 10 then puzzle[i,j] = grille[i,j] else true endif );


% ligne_diff(ligne) contraint les cases de la ligne ligne à être distinctes.
predicate ligne_diff(int: ligne, int: colonne) =
	alldifferent (j in 0..8) (puzzle[ligne, colonne + j]);

% colonne_diff(colonne) contraint les cases de la colonne colonne à être distinctes.
predicate colonne_diff(int: ligne, int: colonne) =
	alldifferent (i in 0..8) (puzzle[ligne + i, colonne]);

% region_diff(ligne) de même pour les régions à être différentes.
predicate region_diff(int: ligne, int: colonne) =
	alldifferent (i, j in 0..2) (puzzle[ligne + i, colonne + j]);

% Utilisation des prédicats pour contraindre les valeurs de la grille.
constraint forall (ligne in taille, colonne in {1, 7, 13})
	(if grille[ligne, colonne + 3] < 10 then 
		ligne_diff(ligne, colonne)
	else
		true
	endif);

constraint forall (colonne in taille, ligne in {1, 7, 13})
	(if grille[ligne + 3, colonne] < 10 then 
		colonne_diff(ligne, colonne)
	else
		true
	endif);

constraint forall (ligne, colonne in {1, 4, 7, 10, 13, 16, 19})
	(if grille[ligne, colonne] < 10 then 
		region_diff(ligne, colonne)
	else
		true
	endif); 

% Problème de satisfaction : trouver les valeurs pour les variables de décisions pour satisfaire les contraintes. 
solve satisfy;

% Affichage
% Pas réussi à faire un meilleur affichage: Les cases vides sont affichées avec des 1: rectangles 3x6 ou 6x3 de 1 correspondent à vide.
output [if j = 1 then "\n" else " " endif ++
    show(puzzle[i,j]) | i,j in taille] ++ ["\n"];


% > time mzn-g12fd samurai_sudoku.mzn
% real: 0m3.074s
% user: 0m0.016s
% sys:  0m0.004s
