# MQTT Home Control - Application Flutter

Application mobile Android pour contrôler les prises intelligentes et monitorer les températures via MQTT, synchronisée avec votre flux Node-RED.

## Fonctionnalités

- 🔌 **Contrôle des prises** : Allumer/éteindre les prises intelligentes en temps réel
- 🌡️ **Affichage des températures** : Monitorer les capteurs de température de vos pièces
- ⏰ **Programmation horaire** : Programmer l'activation des prises à des heures spécifiques
- 📡 **Synchronisation MQTT** : Connexion directe au broker MQTT pour une synchronisation parfaite
- 📱 **Interface responsive** : Design moderne et intuitif adapté aux appareils mobiles

## Prérequis

Avant de commencer, assurez-vous d'avoir installé :

1. **Flutter SDK** : [Télécharger Flutter](https://flutter.dev/docs/get-started/install)
2. **Android Studio** : [Télécharger Android Studio](https://developer.android.com/studio)
3. **Java Development Kit (JDK)** : Version 11 ou supérieure
4. **Un appareil Android ou un émulateur** pour tester l'application

## Installation

### 1. Cloner ou télécharger le projet

```bash
cd mqtt_home_control_flutter
```

### 2. Installer les dépendances Flutter

```bash
flutter pub get
```

### 3. Configurer l'adresse du broker MQTT

Ouvrez le fichier `lib/providers/mqtt_provider.dart` et modifiez les constantes MQTT selon votre configuration :

```dart
static const String _brokerAddress = '10.31.252.78';  // Remplacer par votre adresse IP
static const int _brokerPort = 1883;                   // Port MQTT (par défaut 1883)
```

### 4. Compiler et déployer sur Android

#### Option A : Via USB (Appareil physique)

1. Connectez votre téléphone Android via USB
2. Activez le mode débogage USB sur votre téléphone
3. Exécutez :

```bash
flutter run
```

#### Option B : Via émulateur

1. Ouvrez Android Studio
2. Créez un nouvel appareil virtuel (AVD)
3. Lancez l'émulateur
4. Exécutez :

```bash
flutter run
```

#### Option C : Générer un APK pour installation manuelle

```bash
flutter build apk --release
```

L'APK sera généré dans : `build/app/outputs/flutter-apk/app-release.apk`

Vous pouvez ensuite transférer ce fichier sur votre téléphone et l'installer.

## Configuration MQTT

### Adresse du broker

Par défaut, l'application se connecte à `10.31.252.78:1883`. Si votre broker MQTT est sur une adresse différente :

1. Ouvrez `lib/providers/mqtt_provider.dart`
2. Modifiez les constantes :

```dart
static const String _brokerAddress = 'VOTRE_ADRESSE_IP';
static const int _brokerPort = VOTRE_PORT;
```

### Topics MQTT utilisés

L'application s'abonne et publie sur les topics suivants :

| Topic | Direction | Description |
|-------|-----------|-------------|
| `plug/state1` | Réception | État de la Prise 1 (ON/OFF) |
| `plug/state2` | Réception | État de la Prise 2 (ON/OFF) |
| `temp/room1` | Réception | Température de la Pièce 1 |
| `temp/room2` | Réception | Température de la Pièce 2 |
| `plug/cmd` | Envoi | Commande pour la Prise 1 |
| `plug/cmd2` | Envoi | Commande pour la Prise 2 |
| `time/activ` | Envoi | Heure d'activation programmée |

## Architecture du projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── providers/
│   └── mqtt_provider.dart   # Gestion de la connexion MQTT
├── screens/
│   └── home_screen.dart     # Écran principal
└── widgets/
    ├── plug_control_card.dart      # Widget de contrôle des prises
    ├── temperature_card.dart       # Widget d'affichage des températures
    ├── scheduling_card.dart        # Widget de programmation
    └── connection_status.dart      # Widget de statut de connexion
```

## Utilisation

### Contrôler les prises

1. Lancez l'application
2. Attendez la connexion au broker MQTT (voyant vert)
3. Cliquez sur les boutons ON/OFF pour contrôler les prises

### Voir les températures

Les températures s'affichent automatiquement une fois la connexion établie. Les codes couleur indiquent :

- 🔵 **Bleu** : Température trop basse (< 18°C)
- 🟢 **Vert** : Température idéale (18-26°C)
- 🔴 **Rouge** : Température trop haute (> 26°C)

### Programmer l'activation

1. Sélectionnez la prise à programmer
2. Choisissez l'heure d'activation
3. Cliquez sur "Programmer"

## Dépannage

### L'application ne se connecte pas au broker MQTT

1. Vérifiez que votre téléphone est connecté au même réseau que le broker
2. Vérifiez l'adresse IP et le port du broker dans `mqtt_provider.dart`
3. Assurez-vous que le broker MQTT est en cours d'exécution
4. Vérifiez les logs dans la console Flutter

### Les données de température ne s'affichent pas

1. Vérifiez que les capteurs de température publient sur les topics corrects
2. Vérifiez que l'application est connectée au broker (voyant vert)
3. Consultez les logs pour voir si des messages MQTT sont reçus

### Erreur de compilation

1. Mettez à jour Flutter : `flutter upgrade`
2. Nettoyez le projet : `flutter clean`
3. Réinstallez les dépendances : `flutter pub get`

## Dépendances principales

- **mqtt5_client** : Client MQTT pour la communication
- **provider** : Gestion d'état
- **logger** : Logging pour le débogage

## Support

Pour toute question ou problème, consultez :

- [Documentation Flutter](https://flutter.dev/docs)
- [Documentation MQTT.js](https://github.com/mqttjs/MQTT.js)
- [Node-RED Documentation](https://nodered.org/docs/)

## Licence

Ce projet est fourni à titre d'exemple. Utilisez-le librement pour vos besoins personnels.
