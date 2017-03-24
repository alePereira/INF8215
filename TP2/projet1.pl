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

ask(four,X) :-
format('~w est un four ?',[X]),
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

ask(toaster,X) :-
format('~w est un grille pain ?',[X]),
read(Reponse),
Reponse = 'oui'.


% parcours de l'arbre : baser sur des choix "dichtomique" on essaie a
% chaque question de diminuer l'espace de recherche par 2.
personne(X) :- genre(X).

genre(X):-
ask(homme,X),!,
homme(X),
homme_fact(X).

genre(X) :-
%c est une femme
!,femme(X),
\+ homme_fact(X)
.

femme(X) :-
ask(fiction,X),!,
fiction(X)
.

femme(X) :-
ask(artiste,X),!,
artiste(X).

femme(X) :-
ask(sportif,X),!,
sportif(X).

femme(X) :-
ask(gouverne,un_pays),!,
politicien(X).

femme(X) :-
presentateur(X).


homme(X) :-
ask(artiste,X),!,
artiste(X)
.

homme(X) :-
ask(fiction,X),!,
fiction(X)
.

homme(X) :-
ask(christiannisme,X),!,
christiannisme(X).

homme(X) :-
ask(professeur,X),!,
professeur(X).

homme(X) :-
ask(sportif,X),!,
sportif(X).


homme(X) :- politicien(X).

%sous arbre des sportifs
sportif(X) :-
ask(tennis,X),!,
tennis(X).

sportif(X) :-
pilote(X).


%sous arbre des professeurs

professeur(X):-
ask(ia,X),!,
professeur_fact(X,ia).

professeur(X) :-
professeur_fact(X,sip).



%sous arbre du christiannisme
christiannisme(X) :-
ask(pape,X),!,
pape(X).

christiannisme(X) :-
ask(ressusciter,X),!,
jesus(X).

christiannisme(X) :-
moise(X).

%sous arbre des artistes
artiste(X) :-
ask(musicien,X),!,
musicien(X).

artiste(X) :-
ask(auteur,X),!,
auteur(X).

artiste(X) :-
acteur(X).

musicien(X) :-
ask(chanteur,X),!,
chanteur(X).

musicien(X) :-
ask(jazzman,X),!,
jazz(X).

musicien(X) :-
compos(X).

%sous arbre des personnages de fiction
fiction(X) :-
ask(cinema,X),!,
cinema(X).

fiction(X) :-
jeuxVideo(X).

cinema(X) :-
ask(humain,X),!,
personnageFilm(X).

cinema(X) :-
lasagna(X).

%sous arbres des politiciens
politicien(X) :-
!,gouverne(X,Y),
pays(Y),
ask(gouverne,Y),!.


%%%%%%%%%%%%%%%%%%parcours de l'arbre pour les objets %%%%%%%%%%%%%%%%%%
objet(X) :- cuisine(X).

cuisine(X) :-
ask(cuisine,X),!,
dansLaCuisine(X),
cuisine_fact(X).

cuisine(X) :-
ask(bureau,X),!,
bureau(X).

cuisine(X) :-
ask(surSoi,X),!,
objet_surSoi(X).

cuisine(X) :-
ask(nettoyer,X),!,
nettoyer(X),
\+ cuisine_fact(X)
.

cuisine(X) :-
ask(plante,X),!,
plante(X).

cuisine(X) :-
ask(instrument,X),!,
instrument(X)
.

cuisine(X) :-
chambre(X),meuble(X).


%sous arbre des elements de la cuisine
dansLaCuisine(X) :-
ask(electromenager,X),!,
electromenager(X)
.

dansLaCuisine(X) :-
ask(ustensil,X),!,
ustensil(X).

dansLaCuisine(X) :-
ask(nettoyer,X),!,
nettoyant(X).

dansLaCuisine(X) :- meuble(X).

%sous arbre de l'electromenager
electromenager(aspirateur) :- electromenager_fact(aspirateur).

electromenager(X) :-
ask(dejeuner,X),!,
dejeuner(X)
.

electromenager(X) :-
ask(four,X),!,
four(X).

electromenager(X) :- plaque_cuisson(X).


%sous arbre du petit dejeuner
dejeuner(X) :-
ask(toaster,X),!,
toaster(X).

dejeuner(X) :- machine_a_cafe(X).


%sous arbre des ustensils
ustensil(X) :-
ask(manger,X),!,
manger(X).

ustensil(X) :- batterie_de_cuisine(X).

manger(X) :-
ask(dedans,X),!,
plat(X).

manger(X) :- couvert(X).


% sous arbre des elements se trouvant au bureau
bureau(X) :-
ask(electronique,X),!,
electronique(X).

bureau(X) :-
ask(ecrire,X),!,
materiel_ecriture(X).

bureau(X) :- eclairage(X).


electronique(X) :-
ask(appeler,X),!,
communication(X).

electronique(X) :- informatique(X).


% sous arbre des objets portés sur soi
objet_surSoi(X) :-
ask(porter,X),!,
sac(X).

objet_surSoi(X) :-
ask(ouvrir,X),
quincaillerie(X).

objet_surSoi(X) :- porte_document(X).

% sous abre des objets servant a nettoyer
nettoyer(X) :-
ask(sol,X),!,
sol(X).

nettoyer(X) :- savon(X).

sol(X) :-
ask(electromenager,X),!,
nettoyant(X),
electromenager_fact(X).

sol(X) :- nettoyant(X), \+ electromenager_fact(X).

%%%%%%%%%%%%%%%%%%%%base de connaissance%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% base de connaissance pour les personnes
homme_fact(michael_jackson).
homme_fact(john_lewis).
homme_fact(mario).
homme_fact(james_bond).
homme_fact(garfield).
homme_fact(victor_hugo).
homme_fact(brad_pitt).
homme_fact(pape_francois).
homme_fact(jesus).
homme_fact(moise).
homme_fact(michel_dagenais).
homme_fact(michel_gagnon).
homme_fact(rafael_nadal).
homme_fact(jacques_villeneuve).
homme_fact(stephen_harper).
homme_fact(barack_obama).

chanteur(michael_jackson).
chanteur(celine_dion).
jazz(john_lewis).
compos(mozart).
jeuxVideo(mario).
jeuxVideo(lara_croft).
personnageFilm(james_bond).
personnageFilm(blanche_neige).
lasagna(garfield).
auteur(victor_hugo).
auteur(jk_rowling).
acteur(brad_pitt).
pape(pape_francois).
jesus(jesus).
moise(moise).
professeur_fact(michel_dagenais,sip).
professeur_fact(michel_gagnon,ia).
tennis(rafael_nadal).
tennis(eugenie_bouchard).
pilote(jacques_villeneuve).
presentateur(julie_snyder).
gouverne(stephen_harper,canada).
gouverne(barack_obama,usa).
gouverne(cleopatre,egypte).
pays(canada).
pays(usa).
pays(egypte).

% base de connaissance pour les objets:

% clean
cuisine_fact(detergent_vaisselle).
cuisine_fact(four_micro_onde).
cuisine_fact(cuisiniere).
cuisine_fact(grille_pain).
cuisine_fact(cafetiere).
cuisine_fact(table).
cuisine_fact(casserole).
cuisine_fact(assiette).
cuisine_fact(fourchette).
cuisine_fact(table).


electromenager_fact(aspirateur).
electromenager_fact(four_micro_onde).
electromenager_fact(cuisiniere).
electromenager_fact(grille_pain).
electromenager_fact(cafetiere).

nettoyant(shampoing).
nettoyant(detergent_vaisselles).
nettoyant(aspirateur).
nettoyant(balais).

meuble(table).
meuble(lit).

instrument(piano).
plante(cactus).
chambre(lit).
savon(shampoing).
couvert(fourchette).
plat(assiette).
materiel_ecriture(papier).
communication(telephone).
informatique(ordinateur).
eclairage(lampe).
batterie_de_cuisine(casserole).
sac(sac_a_dos).
machine_a_cafe(cafetiere).
quincaillerie(cle).
porte_document(porte_feuille).
four(four_micro_onde).
plaque_cuisson(cuisiniere).
toaster(grille_pain).
