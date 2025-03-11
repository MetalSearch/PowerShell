# SmartShutdown

## Descriptif

Ce script fournit une solution pratique pour contrôler l'extinction de l'ordinateur tout en permettant aux utilisateurs connectés d'intervenir si nécessaire.

Ce script PowerShell permet de fermer l'ordinateur en décomptant un temps fixé en secondes, avec la possibilité d'annuler l'arrêt si nécessaire.

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
   - Si l'utilisateur clique sur "Annuler", l'arrêt est annulé ou alors exécuté si le compteur arrive à zéro sans interaction de l’utilisateur.



# 

### Résumé des fonctionnalités :

- **Vérification de connexion** : Si personne n'est connecté, il arrête immédiatement.

- **Interface utilisateur** : Affiche un formulaire avec un compteur et un bouton d'annulation.

- **Démarrage du décompte** : 30 secondes pour permettre aux utilisateurs de se déconnecter ou sauvegarder.

Ce script est utile pour une fermeture contrôlée, évitant la perte de données non-sauvegardées.
