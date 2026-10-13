% 1-a) Propositional formulas R1: F ∧ T ∧ M → G, R2: F ∧ T ∧ ¬M → B, R3: B → ¬G, facts: F, T, ¬M

% 2-b) Prolog translation

% :- dynamic douleurs_musculaires/0.

% --- Facts: the patient's symptoms ---
fievre.
toux.
douleurs_musculaires.
%--- Rule 2 ---
infection_bacterienne :- fievre, toux, \+ douleurs_musculaires.

%--- Rule 3 ---
grippe:- infection_bacterienne, !, fail.

%--- Rule 1 ---
grippe :- fievre, toux , douleurs_musculaires.

% 3-c) Logical deduction 	F, T, ¬M → R2 fires → B → R3 gives ¬G. Conclusion: bacterial infection, no flu