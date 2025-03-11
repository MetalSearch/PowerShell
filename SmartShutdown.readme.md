# SmartShutdown

Ce script fournit une solution pratique pour contrôler l'extinction de l'ordinateur tout en permettant aux utilisateurs connectés d'intervenir si nécessaire.

## Descriptif

Ce script PowerShell permet de fermer l'ordinateur en décomptant un temps fixé en secondes, avec la possibilité d'annuler l'arrêt si nécessaire.

**Fonctionnalités principales :**

1. **Démarrage du décompte :**
   
   - Affichage d’une fenêtre avec un compte à rebours en secondes.
   - Un bouton "Annuler" est proposé pour stopper le processus d'arrêt.

2. **Vérification des sessions utilisateur :**
   
   - Si aucun utilisateur n'est connecté, l'ordinateur s'éteint immédiatement.
   - Si un utilisateur est connecté et non verrouillé, le décompte commence.

3. **Interface graphique :**
   
   - Ce script utilise des éléments Windows Forms pour créer une interface simple.

