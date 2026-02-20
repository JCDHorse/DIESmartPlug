import 'package:flutter/foundation.dart';
import 'package:mqtt5_client/mqtt_client.dart';
import 'package:mqtt5_client/mqtt_server_client.dart';
import 'package:logger/logger.dart';

class MqttProvider extends ChangeNotifier {
  late MqttServerClient _client;
  bool _isConnected = false;
  String _connectionStatus = 'Déconnecté';
  
  // États des prises
  String _plug1State = 'unknown';
  String _plug2State = 'unknown';
  
  // Températures
  double? _temp1;
  double? _temp2;
  
  // Messages d'erreur
  String? _errorMessage;
  
  final Logger _logger = Logger();
  
  // Configuration MQTT
  static const String _brokerAddress = '10.31.252.78';
  static const int _brokerPort = 1884;
  
  // Getters
  bool get isConnected => _isConnected;
  String get connectionStatus => _connectionStatus;
  String get plug1State => _plug1State;
  String get plug2State => _plug2State;
  double? get temp1 => _temp1;
  double? get temp2 => _temp2;
  String? get errorMessage => _errorMessage;
  
  MqttProvider() {
    _initializeMqttClient();
  }
  
  void _initializeMqttClient() {
    _client = MqttServerClient(_brokerAddress, '');
    _client.port = _brokerPort;
    _client.keepAlivePeriod = 20;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;
    _client.onUnsubscribed = _onUnsubscribed;
    _client.onSubscribeFail = _onSubscribeFail;
    _client.onBadCertificate = _onBadCertificate;
    _client.logging(on: true);
  }
  
  Future<void> connect() async {
    _connectionStatus = 'Connexion en cours...';
    notifyListeners();
    
    try {
      _logger.i('Tentative de connexion au broker MQTT...');
      await _client.connect();
      
      // S'abonner aux topics
      _subscribeToTopics();
      
      _isConnected = true;
      _connectionStatus = 'Connecté';
      _errorMessage = null;
      notifyListeners();
      
      _logger.i('Connecté au broker MQTT');
    } catch (e) {
      _isConnected = false;
      _connectionStatus = 'Erreur de connexion';
      _errorMessage = e.toString();
      _logger.e('Erreur de connexion: $e');
      notifyListeners();
    }
  }
  
  void _subscribeToTopics() {
    final topics = [
      'plug/state1',
      'plug/state2',
      'temp/room1',
      'temp/room2',
    ];
    
    for (String topic in topics) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
    }
    
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      for (var msg in c) {
        final MqttPublishMessage recMess = msg.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsUTF8(recMess.payload.message);
        
        _logger.i('Message reçu - Topic: ${msg.topic}, Payload: $payload');
        _handleMessage(msg.topic, payload);
      }
    });
  }
  
  void _handleMessage(String topic, String payload) {
    switch (topic) {
      case 'plug/state1':
        _plug1State = payload;
        break;
      case 'plug/state2':
        _plug2State = payload;
        break;
      case 'temp/room1':
        _temp1 = double.tryParse(payload);
        break;
      case 'temp/room2':
        _temp2 = double.tryParse(payload);
        break;
    }
    notifyListeners();
  }
  
  Future<void> publishMessage(String topic, String payload) async {
    if (!_isConnected) {
      _errorMessage = 'Non connecté au broker MQTT';
      notifyListeners();
      return;
    }
    
    try {
      _logger.i('Publication - Topic: $topic, Payload: $payload');
      _client.publishMessage(topic, MqttQos.atLeastOnce, utf8.encode(payload));
    } catch (e) {
      _errorMessage = 'Erreur lors de la publication: $e';
      _logger.e('Erreur de publication: $e');
      notifyListeners();
    }
  }
  
  void togglePlug(int plugNumber, String newState) {
    final topic = plugNumber == 1 ? 'plug/cmd' : 'plug/cmd2';
    publishMessage(topic, newState);
  }
  
  void _onConnected() {
    _logger.i('Connecté au broker');
  }
  
  void _onDisconnected() {
    _isConnected = false;
    _connectionStatus = 'Déconnecté';
    _logger.w('Déconnecté du broker');
    notifyListeners();
  }
  
  void _onSubscribed(String topic) {
    _logger.i('Abonné au topic: $topic');
  }
  
  void _onUnsubscribed(String? topic) {
    _logger.i('Désabonné du topic: $topic');
  }
  
  void _onSubscribeFail(String topic) {
    _logger.e('Échec de l\'abonnement au topic: $topic');
  }
  
  bool _onBadCertificate(dynamic certificate) {
    return true;
  }
  
  Future<void> disconnect() async {
    try {
      _client.disconnect();
      _isConnected = false;
      _connectionStatus = 'Déconnecté';
      _logger.i('Déconnexion du broker');
      notifyListeners();
    } catch (e) {
      _logger.e('Erreur lors de la déconnexion: $e');
    }
  }
  
  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

// Importer utf8 depuis dart:convert
import 'dart:convert';
