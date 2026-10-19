# RC-labs
# TP1: Logical reasoning and knowledge base in SWI-Prolog

**University:** Université Oran1, Faculté FSEA
**Course:** RC (Raisonnement et Connaissances), Master 1 IA

## Objective

Represent a small medical knowledge base (KB) and automate a simple diagnostic reasoning in Prolog: facts, rules, negation as failure (`\+`), and the `fail` predicate.

## Problem

A doctor wants to determine whether a patient may have **flu** or a **bacterial infection** from their symptoms.

Rules:
1. Fever, cough and muscle pains → flu.
2. Fever, cough and no muscle pains → probably a bacterial infection.
3. Bacterial infection → no flu.

Patient: fever and cough, no muscle pains.

## a) Propositional formulas

| Symbol | Meaning | Prolog name |
|---|---|---|
| F | fever | `fievre` |
| T | cough | `toux` |
| M | muscle pains | `douleurs_musculaires` |
| G | flu | `grippe` |
| B | bacterial infection | `infection_bacterienne` |

Rules:
- R1: F ∧ T ∧ M → G
- R2: F ∧ T ∧ ¬M → B
- R3: B → ¬G

Facts: F, T, ¬M

## b) Prolog translation

File: [`tp1_diagnostic.pl`](tp1_diagnostic.pl)

```prolog
:- dynamic douleurs_musculaires/0.

% Facts: the patient's symptoms
fievre.
toux.

% Rule 2
infection_bacterienne :- fievre, toux, \+ douleurs_musculaires.

% Rule 3 (must come before rule 1)
grippe :- infection_bacterienne, !, fail.

% Rule 1
grippe :- fievre, toux, douleurs_musculaires.
```

Notes:
- `douleurs_musculaires` has no fact (closed-world assumption), so `\+ douleurs_musculaires` succeeds. The `dynamic` declaration avoids an unknown-procedure error.
- Rule 3 uses cut and `fail`: if a bacterial infection is proven, `grippe` fails. It must be placed before rule 1.

## c) Deduction

1. Facts: F and T are true, M is false.
2. R1: M is false, so the premise is false and the rule does not fire.
3. R2: F, T and ¬M are true, so we deduce B.
4. R3: B is true, so we deduce ¬G.

**Conclusion:** the patient probably has a bacterial infection and does not have flu.

## Run

```bash
swipl TP1/tp1_diagnostic.pl
```

```prolog
?- infection_bacterienne.
true.

?- grippe.
false.
```

Extra test: adding the fact `douleurs_musculaires.` gives `infection_bacterienne` → `false` and `grippe` → `true`.

# TP2 : Logique des prédicats et programmation en Prolog
**Gestion écologique des déchets**

* **Université :** Université Oran 1 — Faculté FSEA
* **Formation :** Master 1 Intelligence Artificielle (M1 IA)
* **Matière :** Représentation des Connaissances (RC)

---

## 1. Objectif du TP
Ce TP vise à relier la logique du premier ordre (logique des prédicats) et son implémentation en Prolog. Il modélise un système d'aide au tri sélectif permettant de déterminer la catégorie d'un déchet, le bac dans lequel il doit être jeté et l'action écologique recommandée.

---

## 2. Code Source (`tri_dechets.pl`)

```prolog
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
```

---

## 3. Exécution du Programme

Lancer directement le fichier avec **SWI-Prolog** depuis le terminal :

```bash
swipl tri_dechets.pl
```

Ou charger le fichier depuis l'interpréteur interactif :

```prolog
?- [tri_dechets].
```

---

## 4. Tests et Résultats des Requêtes

| # | Question | Requête Prolog | Résultat obtenu |
| :- | :--- | :--- | :--- |
| **1** | Dans quel bac faut-il jeter une bouteille plastique ? | `?- trier(bouteille_plastique, Bac).` | `Bac = jaune.` |
| **2** | Quelle action écologique faut-il réaliser pour une pile ? | `?- action_ecolo(pile, Action).` | `Action = deposer_dechetterie.` |
| **3** | Quel bac et quelle action pour une pomme ? | `?- conseil(pomme, Bac, Action).` | `Bac = marron, Action = composter.` |
| **4** | Quels sont tous les déchets qui vont dans le bac jaune ? | `?- trier(Dechet, jaune).` | `Dechet = bouteille_plastique ;`<br>`Dechet = sac_plastique ;`<br>`Dechet = canette.` |
| **5** | Quels sont les déchets recyclables ? | `?- action_ecolo(Dechet, recycler).` | `Dechet = bouteille_plastique ;`<br>`Dechet = sac_plastique ;`<br>`Dechet = journal ;`<br>`Dechet = carton ;`<br>`Dechet = bocal_verre ;`<br>`Dechet = canette.` |

---

## 5. Raisonnement suivi par Prolog pour `?- conseil(pomme, Bac, Action).`

Prolog utilise l'**unification** et le **chaînage arrière (résolution SLD)** en résolvant les sous-buts de gauche à droite :

1. **Unification avec la règle R3 :**
   * La requête `conseil(pomme, Bac, Action)` s'unifie avec la tête de la règle `conseil(X, Z, A) :- trier(X, Z), action_ecolo(X, A).` en liant `X = pomme`, `Z = Bac` et `A = Action`.
   * Le but principal est remplacé par deux sous-buts : `trier(pomme, Bac)` et `action_ecolo(pomme, Action)`.

2. **Résolution du sous-but 1 (`trier(pomme, Bac)`) via la règle R1 :**
   * `trier(pomme, Bac)` s'unifie avec `trier(X, Z) :- categorie(X, Y), bac(Y, Z).`
   * Prolog cherche `categorie(pomme, Y)` dans les faits et trouve `categorie(pomme, organique).`, ce qui lie `Y = organique`.
   * Il cherche ensuite `bac(organique, Bac)` et l'unifie avec le fait `bac(organique, marron).`, ce qui instancie **`Bac = marron`**.

3. **Résolution du sous-but 2 (`action_ecolo(pomme, Action)`) via la règle R2 :**
   * `action_ecolo(pomme, Action)` s'unifie avec `action_ecolo(X, A) :- categorie(X, Y), action(Y, A).`
   * Prolog vérifie `categorie(pomme, Y)` dans les faits et lie à nouveau `Y = organique`.
   * Il cherche ensuite `action(organique, Action)` et l'unifie avec le fait `action(organique, composter).`, ce qui instancie **`Action = composter`**.

4. **Conclusion :**
   * Les deux sous-buts étant résolus avec succès, Prolog retourne : `Bac = marron, Action = composter`.

---

## 6. Variables libres et liées dans la règle R3

Formule logique de la règle **R3** :

```text
∀x ∀z ∀a [trier(x, z) ∧ action_ecolo(x, a) → conseil(x, z, a)]
```

* **Variables liées :** **`x`, `z` et `a`** sont toutes des variables liées car chacune est sous la portée d'un quantificateur universel (`∀x`, `∀z`, `∀a`).
* **Variables libres :** **Aucune (`∅`)**. Toutes les variables de la formule étant quantifiées, R3 est une **formule fermée**.