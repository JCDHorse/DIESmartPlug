import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mqtt_provider.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MqttProvider>(
      builder: (context, mqttProvider, _) {
        final isConnected = mqttProvider.isConnected;
        final status = mqttProvider.connectionStatus;
        final error = mqttProvider.errorMessage;
        
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isConnected
                  ? [Colors.green[50]!, Colors.green[100]!]
                  : [Colors.red[50]!, Colors.red[100]!],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isConnected ? Colors.green : Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: (isConnected ? Colors.green : Colors.red).withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statut de connexion',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isConnected ? Colors.green[900] : Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700], size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
