% --- FAITS : Catégories des déchets ---
categorie(bouteille_plastique, plastique).
categorie(sac_plastique, plastique).
categorie(journal, papier).
categorie(carton, papier).
categorie(bocal_verre, verre).
categorie(pomme, organique).
categorie(coquille_oeuf, organique).
categorie(canette, metal).
categorie(pile, dangereux).

% --- FAITS : Bacs de tri ---
bac(plastique, jaune).
bac(papier, bleu).
bac(verre, vert).
bac(organique, marron).
bac(metal, jaune).
bac(dangereux, rouge).

% --- FAITS : Actions écologiques ---
action(plastique, recycler).
action(papier, recycler).
action(verre, recycler).
action(organique, composter).
action(metal, recycler).
action(dangereux, deposer_dechetterie).

% --- RÈGLES LOGIQUES ---
% R1: ∀x∀y∀z [categorie(x, y) ∧ bac(y, z) → trier(x, z)]
trier(X, Z) :- categorie(X, Y), bac(Y, Z).

% R2: ∀x∀y∀a [categorie(x, y) ∧ action(y, a) → action_ecolo(x, a)]
action_ecolo(X, A) :- categorie(X, Y), action(Y, A).

% R3: ∀x∀z∀a [trier(x, z) ∧ action_ecolo(x, a) → conseil(x, z, a)]
conseil(X, Z, A) :- trier(X, Z), action_ecolo(X, A).
