# Dossier des écrans

Ce dossier contient tous les écrans de l'application Flutter. Chaque écran est représenté par un dossier distinct dans ce dossier, qui contient tous les fichiers spécifiques nécessaires a son fonctionnement.

## Structure

Chaque écran est un widget Flutter qui est utilisé pour représenter une certaine partie de l'application. Par exemple, vous pourriez avoir un écran pour la page d'accueil, un autre pour le profil de l'utilisateur, etc.

## Lien avec le serveur et les services externes



## Comment ajouter un nouvel écran

Pour ajouter un nouvel écran à l'application, créez un nouveau dossier avec le nom de l'ecran et fichier Dart dans ce dossier. Définissez un nouveau widget qui représente l'écran et assurez-vous d'importer tous les packages nécessaires.

## Comment naviguer entre les écrans

La navigation entre les écrans est gérée par le `Navigator` de Flutter. Vous pouvez utiliser `Navigator.push` pour naviguer vers un nouvel écran, et `Navigator.pop` pour revenir à l'écran précédent.

## Note

Assurez-vous de bien tester chaque écran avant de le déployer dans l'application pour éviter tout problème potentiel.