# SmartShutdown

Ce script fournit une solution pratique pour contrôler l'extinction de l'ordinateur tout en permettant aux utilisateurs connectés d'intervenir si nécessaire.

## Descriptif

**Fonctionnalités principales :**

1. **Démarrage du décompte :**
   
   - Affichage d’une fenêtre avec un compte à rebours en secondes.
   - Un bouton "Annuler" est proposé pour stopper le processus d'arrêt.

2. **Vérification des sessions utilisateur :**
   
   - Si aucun utilisateur n'est connecté, l'ordinateur s'éteint immédiatement.
   - Si un utilisateur est connecté et non verrouillé, le décompte commence.
   - Si la session est verrouillée (écran de verrouillage), l'arrêt est annulé.

3. **Interface graphique :**
   
   - Ce script utilise des éléments Windows Forms pour créer une interface simple.

4. **Gestion du temps :**
   
   - Un timer démarre le compte à rebours toutes les secondes.
   - Si l'utilisateur clique sur "Annuler", l'arrêt est annulé ou alors exécuté si le compteur arrive à zéro.
