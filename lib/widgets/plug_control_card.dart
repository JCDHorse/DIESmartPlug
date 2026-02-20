import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mqtt_provider.dart';

class PlugControlCard extends StatelessWidget {
  final int plugNumber;
  final String plugName;

  const PlugControlCard({
    Key? key,
    required this.plugNumber,
    required this.plugName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MqttProvider>(
      builder: (context, mqttProvider, _) {
        final state = plugNumber == 1 
          ? mqttProvider.plug1State 
          : mqttProvider.plug2State;
        
        final isOn = state == 'ON';
        final isUnknown = state == 'unknown';
        
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
                colors: isUnknown
                  ? [Colors.grey[100]!, Colors.grey[50]!]
                  : isOn
                    ? [Colors.green[50]!, Colors.green[100]!]
                    : [Colors.grey[50]!, Colors.grey[100]!],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plugName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isUnknown
                          ? Colors.grey[300]
                          : isOn
                            ? Colors.green[300]
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<MqttProvider>().togglePlug(plugNumber, 'ON');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOn ? Colors.green : Colors.grey[300],
                          foregroundColor: isOn ? Colors.white : Colors.black87,
                          elevation: isOn ? 4 : 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('ON'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<MqttProvider>().togglePlug(plugNumber, 'OFF');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !isOn ? Colors.red : Colors.grey[300],
                          foregroundColor: !isOn ? Colors.white : Colors.black87,
                          elevation: !isOn ? 4 : 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('OFF'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
