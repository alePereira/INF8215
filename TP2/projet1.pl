%Question pouvant etre posées

ask(gouverne,Y):-
format('Gouverne ~w ? ',[Y]),
read(Reponse),
Reponse = 'oui'.

ask(homme,X):-
format('~w est de genre masculin? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(fiction,X) :-
format('~w est un personnage de fiction ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(artiste,X):-
format('~w est un artiste? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(musicien,X):-
format('~w est un musicien? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(auteur,X) :-
format('~w est un auteur ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(chanteur,X):-
format('~w est un chanteur? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(jazzman,X):-
format('~w est un jazzman ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(cinema,X) :-
format('~w est un personnage ici d cinema ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(humain,X) :-
format('~w est humain ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(christiannisme,X) :-
format('~w est une personne ayant un rapport avec le christiannisme ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(pape,X) :-
format('~w est un pape ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(ressusciter,X) :-
format('~w a-t-il ressuscité ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(professeur,X) :-
format('~w est il professeur ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(ia,X) :-
format('~w est il professeur d ia ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(tennis,X) :-
format('~w joue au tennis ? ',[X]),
read(Reponse),
Reponse = 'oui'.


%%%%% question pour les objets %%%%%%
ask(cuisine,X) :-
format('~w se trouve dans la cuisine ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(bureau,X) :-
format('~w se trouve sur le bureau ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(surSoi,X) :-
format('~w se porte sur soi? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(nettoyer,X) :-
format('~w sert a nettoyer? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(instrument,X) :-
format('~w est un unstrument de musique ? ',[X]),
read(Reponse),
Reponse = 'oui'.

ask(plante,X) :-
format('~w est une plante ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(electromenager,X) :-
format('~w est un appareil electromenager ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(ustensil,X) :-
format('~w est un ustensil de cuisine ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(dejeuner,X) :-
format('~w sert pour le petit dejeuner ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(onde,X) :-
format('~w utilise des micro-ondes ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(manger,X) :-
format('~w sert a manger ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(dedans,X) :-
format('~w sert a manger dedans ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(electronique,X) :-
format('~w est electronique ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(appeler,X) :-
format('~w sert a telephoner ?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(porter,X) :-
format('~w se porte?',[X]),
read(Reponse),
Reponse = 'oui'.

ask(ouvrir,X) :-
format('~w sert a ouvrir un porte?',[X]),
read(Reponse),
Reponse = 'oui'.


ask(sol,X) :-
format('~w sert a laver le sol ?',[X]),
read(Reponse),
Reponse = 'oui'.


% parcours de l'arbre : baser sur des choix "dichtomique" on essaie a
% chaque question de diminuer l'espace de recherche par 2.
% La premiere question est le genre car separe le mieux les items
% (16 hommes et 6 femmes)
personne(X) :- genre(X).

genre(X):-
ask(homme,X),!,
homme(X)
.

genre(X) :-
%c est une femme
femme(X),!.

femme(X) :-
ask(fiction,X),!,
fiction(X,femme)
.

femme(X) :-
ask(artiste,X),!,
artiste(X,femme).

femme(X) :-
ask(sportif,X),!,
sportif(X,femme).

femme(X) :-
politicien(X,femme).

femme(X) :-
presentatrice(X).


homme(X) :-
ask(artiste,X),!,
artiste(X,homme)
.

homme(X) :-
ask(fiction,X),!,
fiction(X,homme)
.

homme(X) :-
ask(christiannisme,X),!,
christiannisme(X,homme).

homme(X) :-
ask(professeur,X),!,
professeur(X,homme).

homme(X) :-
ask(sportif,X),!,
sportif(X,homme).


homme(X) :- politicien(X,homme).

%sous arbre des sportifs
sportif(X,Y) :-
ask(tennis,X),!,
tennis(X,homme).

sportif(X,Y) :-
pilote(X,homme).


%sous arbre des professeurs

professeur(X,homme):-
ask(ia,X),!,
professeur_fact(X,ia).

professeur(X,homme) :-
professeur_fact(X,sip).



%sous arbre du christiannisme
christiannisme(X,Y) :-
ask(pape,X),!,
pape(X).

christiannisme(X,Y) :-
ask(ressusciter,X),!,
jesus(X).

christiannisme(X,Y) :-
moise(X).

%sous arbre des artistes
artiste(X,Y) :-
ask(musicien,X),!,
musicien(X,Y).

artiste(X,Y) :-
ask(auteur,X),!,
auteur(X,Y).

artiste(X,Y) :-
acteur(X,Y).

musicien(X,Y) :-
ask(chanteur,X),!,
chanteur(X,Y).

musicien(X,Y) :-
ask(jazzman,X),!,
jazz(X).

musicien(X,Y) :-
compos(X).

%sous arbre des personnages de fiction
fiction(X,Y) :-
ask(cinema,X),!,
cinema(X,Y).

fiction(X,Y) :-
jeuxVideo(X,Y).

cinema(X,Y) :-
ask(humain,X),!,
personnageFilm(X,Y).

cinema(X,Y) :-
lasagna(X,Y).

%sous arbres des politiciens
politicien(X,Z) :-
!,gouverne(X,Y,Z),
pays(Y),
ask(gouverne,Y).


%%%%%%%%%%%%%%%%%%parcours de l'arbre pour les objets %%%%%%%%%%%%%%%%%%
objet(X) :- cuisine(X).

cuisine(X) :-
ask(cuisine,X),!,
dansLaCuisine(X).

cuisine(X) :-
ask(bureau,X),!,
bureau(X).

cuisine(X) :-
ask(surSoi,X),!,
surSoi(X).

surSoi(X) :-
ask(porter,X),!,
porter(X).

surSoi(X):-
ask(ouvrir,X),!,
ouvrir(X).

surSoi(X) :- argent(X).


cuisine(X) :-
ask(nettoyer, X),!,
nettoyer(X).

nettoyer(X) :-
ask(sol,X),!,
sol(X).


sol(X) :-
ask(electromenager,X),!,
nettoyant(X),
electromenager_fact(X).

sol(X) :- nettoyant(X), \+ cuisine_fact(X), \+ electromenager_fact(X).

nettoyer(X) :- savon(X).


bureau(X) :-
ask(electronique,X),!,
electronique(X).

electronique(X) :-
ask(appeler,X),!,
appeler(X).

electronique(X) :-
ordinateur(X).

bureau(X) :-
ask(ecrire,X),!,
ecrire(X).

bureau(X) :- eclaire(X).



cuisine(X) :-
ask(plante,X),!,
plante(X).

cuisine(X) :-
ask(instrument,X),!,
instrument(X).

cuisine(X) :- dormir(X).

dansLaCuisine(X) :-
ask(electromenager,X),!,
electromenager(X).

electromenager(X) :-
ask(dejeuner,X),!,
dejeuner(X).

electromenager(X) :-
ask(onde,X),!,
microOnde(X).

electromenager(X) :- cuisiniere(X).

dejeuner(X) :-
ask(pain,X),!,
pain(X).

dejeuner(X) :- cafetiere(X).

dansLaCuisine(X) :-
ask(ustensil,X),!,
ustensil(X).


ustensil(X) :-
ask(manger,X),!,
manger(X).

manger(X) :-
ask(dedans,X),!,
plat(X).

manger(X) :-
couvert(X).

ustensil(X) :- casserole(X).

dansLaCuisine(X) :-
ask(nettoyer,X),!,
nettoyant(X),
cuisine_fact(X).

dansLaCuisine(X) :- desk(X).


%%%%%%%%%%%%%%%%%%%%base de connaissance%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%* base de connaissance pour les personnes
chanteur(michael_jackson,homme).
chanteur(celine_dion,femme).
jazz(john_lewis).
compos(mozart).
jeuxVideo(mario,homme).
jeuxVideo(lara_croft,femme).
personnageFilm(james_bond,homme).
personnageFilm(blanche_neige,femme).
lasagna(garfield,homme).
auteur(victor_hugo,homme).
auteur(jk_rowling,femme).
acteur(brad_pitt,homme).
pape(pape_francois).
jesus(jesus).
moise(moise).
professeur_fact(michel_dagenais,sip).
professeur_fact(michel_gagnon,ia).
tennis(rafael_nadal,homme).
tennis(eugenie_bouchard,femme).
pilote(jacques_villeneuve,homme).
presentatrice(julie_snyder).
gouverne(stephen_harper,canada,homme).
gouverne(barack_obama,usa,homme).
gouverne(cleopatre,egypte,femme).
pays(canada).
pays(usa).
pays(egypte).

%*base de connaissance pour les objets:

instrument(piano).
plante(cactus).
dormir(lit).
cuisine_fact(detergent).
nettoyant(detergent).
desk(table).
microOnde(four_micro_onde).
cuisiniere(cuisiniere).
pain(grille_pain).
cafetiere(cafetiere).
casserole(casserole).
plat(assiette).
couvert(fourchette).
eclaire(lampe).
ecrire(papier).
appeler(telephone).
ordinateur(ordinateur).
ouvrir(cle).
argent(porte_feuille).
porter(sac_a_dos).
savon(shampoing).
electromenager_fact(aspirateur).
nettoyant(aspirateur).
nettoyant(balais).
