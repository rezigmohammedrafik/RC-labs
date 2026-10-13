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