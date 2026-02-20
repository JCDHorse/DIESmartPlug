import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mqtt_provider.dart';

class TemperatureCard extends StatelessWidget {
  final int roomNumber;
  final String roomName;

  const TemperatureCard({
    Key? key,
    required this.roomNumber,
    required this.roomName,
  }) : super(key: key);

  Color _getTemperatureColor(double? temp) {
    if (temp == null) return Colors.grey;
    if (temp < 18) return Colors.blue;
    if (temp > 26) return Colors.red;
    return Colors.green;
  }

  String _getTemperatureStatus(double? temp) {
    if (temp == null) return 'N/A';
    if (temp < 18) return '❄️ Trop froid';
    if (temp > 26) return '🔥 Trop chaud';
    return '✓ Idéal';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MqttProvider>(
      builder: (context, mqttProvider, _) {
        final temp = roomNumber == 1 
          ? mqttProvider.temp1 
          : mqttProvider.temp2;
        
        final color = _getTemperatureColor(temp);
        final status = _getTemperatureStatus(temp);
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      temp != null ? '${temp.toStringAsFixed(1)}°C' : '--',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Icon(
                      temp == null
                        ? Icons.help_outline
                        : temp < 18
                          ? Icons.ac_unit
                          : temp > 26
                            ? Icons.local_fire_department
                            : Icons.check_circle,
                      color: color,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
