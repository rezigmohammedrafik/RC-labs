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