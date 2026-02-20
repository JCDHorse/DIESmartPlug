# Guide d'Installation Détaillé - MQTT Home Control

Ce guide vous aidera à installer et configurer l'application Flutter MQTT Home Control sur votre téléphone Android.

## Étape 1 : Préparer votre environnement de développement

### Sur Windows

1. **Télécharger Flutter**
   - Allez sur [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
   - Téléchargez le ZIP de Flutter
   - Extrayez-le dans un dossier (ex: `C:\flutter`)

2. **Ajouter Flutter au PATH**
   - Ouvrez les variables d'environnement (Recherchez "Variables d'environnement")
   - Cliquez sur "Variables d'environnement"
   - Sous "Variables utilisateur", cliquez sur "Nouveau"
   - Nom : `PATH`
   - Valeur : `C:\flutter\bin` (ou votre chemin d'installation)
   - Cliquez OK

3. **Installer Android Studio**
   - Téléchargez [Android Studio](https://developer.android.com/studio)
   - Installez-le
   - Lancez-le et complétez la configuration initiale

4. **Vérifier l'installation**
   - Ouvrez une invite de commande
   - Tapez : `flutter doctor`
   - Résolvez les problèmes affichés

### Sur macOS

```bash
# Installer Homebrew si ce n'est pas fait
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Installer Flutter
brew install flutter

# Vérifier l'installation
flutter doctor
```

### Sur Linux

```bash
# Télécharger Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Ajouter au PATH (dans ~/.bashrc ou ~/.zshrc)
export PATH="$PATH:$HOME/flutter/bin"

# Vérifier l'installation
flutter doctor
```

## Étape 2 : Configurer un appareil Android

### Option A : Utiliser un téléphone physique

1. Activez le mode débogage USB
   - Allez dans Paramètres > À propos du téléphone
   - Appuyez 7 fois sur "Numéro de build"
   - Retournez à Paramètres > Options pour développeurs
   - Activez "Débogage USB"

2. Connectez votre téléphone via USB

3. Vérifiez la connexion
   ```bash
   flutter devices
   ```

### Option B : Utiliser un émulateur Android

1. Ouvrez Android Studio
2. Cliquez sur "AVD Manager"
3. Cliquez sur "Create Virtual Device"
4. Sélectionnez un appareil (ex: Pixel 4)
5. Sélectionnez une image système (ex: Android 12)
6. Terminez la création
7. Cliquez sur le bouton "Play" pour lancer l'émulateur

## Étape 3 : Télécharger et configurer le projet

1. **Télécharger le projet**
   ```bash
   # Clonez le projet ou téléchargez-le
   git clone <URL_DU_PROJET>
   cd mqtt_home_control_flutter
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configurer l'adresse du broker MQTT**
   - Ouvrez le fichier `lib/providers/mqtt_provider.dart`
   - Trouvez les lignes :
   ```dart
   static const String _brokerAddress = '10.31.252.78';
   static const int _brokerPort = 1883;
   ```
   - Remplacez `10.31.252.78` par l'adresse IP de votre Raspberry Pi
   - Remplacez `1883` par le port de votre broker MQTT (par défaut 1883)

## Étape 4 : Lancer l'application

### Option A : Via la ligne de commande

```bash
# Lancer sur l'appareil connecté
flutter run

# Lancer en mode release (plus rapide)
flutter run --release
```

### Option B : Via VS Code

1. Installez l'extension "Flutter"
2. Ouvrez le projet dans VS Code
3. Appuyez sur `F5` ou cliquez sur "Run"

### Option C : Via Android Studio

1. Ouvrez le projet dans Android Studio
2. Sélectionnez votre appareil/émulateur
3. Cliquez sur le bouton "Run"

## Étape 5 : Générer un APK pour installation manuelle

Si vous voulez installer l'application sans avoir besoin de Flutter sur votre ordinateur :

```bash
# Générer un APK en mode release
flutter build apk --release

# Le fichier APK sera généré dans :
# build/app/outputs/flutter-apk/app-release.apk
```

Vous pouvez ensuite :
1. Transférer le fichier APK sur votre téléphone
2. Ouvrir le gestionnaire de fichiers
3. Appuyer sur le fichier APK
4. Cliquer sur "Installer"

## Dépannage

### Erreur : "Flutter not found"

**Solution** : Vérifiez que Flutter est correctement ajouté au PATH
```bash
# Vérifier le chemin
echo $PATH

# Ou sur Windows, vérifiez les variables d'environnement
```

### Erreur : "No devices found"

**Solution** : 
- Vérifiez que votre téléphone est connecté via USB
- Activez le débogage USB
- Ou lancez un émulateur Android

### Erreur : "ANDROID_HOME not set"

**Solution** : 
```bash
# Sur Windows
set ANDROID_HOME=C:\Users\VOTRE_NOM\AppData\Local\Android\sdk

# Sur macOS/Linux
export ANDROID_HOME=$HOME/Library/Android/sdk
```

### L'application ne se connecte pas au broker MQTT

**Solution** :
1. Vérifiez que votre téléphone est sur le même réseau que le Raspberry Pi
2. Vérifiez l'adresse IP du Raspberry Pi
3. Vérifiez que le broker MQTT est en cours d'exécution sur le Raspberry Pi
4. Consultez les logs : `flutter logs`

## Configuration avancée

### Modifier le port MQTT

Si votre broker MQTT utilise un port différent de 1883 :

1. Ouvrez `lib/providers/mqtt_provider.dart`
2. Modifiez :
```dart
static const int _brokerPort = 1883;  // Changez 1883 par votre port
```

### Modifier les topics MQTT

Si vos topics MQTT sont différents, modifiez la méthode `_subscribeToTopics()` dans `mqtt_provider.dart` :

```dart
void _subscribeToTopics() {
  final topics = [
    'votre/topic1',
    'votre/topic2',
    // Ajoutez vos topics ici
  ];
  // ...
}
```

## Support

Si vous rencontrez des problèmes :

1. Consultez les logs : `flutter logs`
2. Nettoyez le projet : `flutter clean`
3. Réinstallez les dépendances : `flutter pub get`
4. Consultez la [documentation Flutter](https://flutter.dev/docs)

## Prochaines étapes

Une fois l'application installée et fonctionnelle :

1. Testez le contrôle des prises
2. Vérifiez l'affichage des températures
3. Testez la programmation horaire
4. Explorez les paramètres et options

Bon contrôle ! 🎉
