import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mqtt_provider.dart';

class SchedulingCard extends StatefulWidget {
  const SchedulingCard({Key? key}) : super(key: key);

  @override
  State<SchedulingCard> createState() => _SchedulingCardState();
}

class _SchedulingCardState extends State<SchedulingCard> {
  String _selectedPlug = 'plug1';
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Programmer l\'activation',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Sélection de la prise
            Text(
              'Sélectionner une prise',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedPlug,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: 'plug1',
                  child: const Text('Prise 1'),
                ),
                DropdownMenuItem(
                  value: 'plug2',
                  child: const Text('Prise 2'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPlug = value ?? 'plug1';
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Sélection de l'heure
            Text(
              'Heure d\'activation (HH:MM)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime != null
                        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                        : 'Sélectionner une heure',
                      style: TextStyle(
                        color: _selectedTime != null ? Colors.black87 : Colors.grey[400],
                      ),
                    ),
                    Icon(
                      Icons.access_time,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Bouton de programmation
            Consumer<MqttProvider>(
              builder: (context, mqttProvider, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedTime == null || !mqttProvider.isConnected
                      ? null
                      : () {
                          final time = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
                          mqttProvider.publishMessage('time/activ', time);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Activation programmée à $time'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          
                          setState(() {
                            _selectedTime = null;
                          });
                        },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Programmer'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            
            // Info box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Programmez l\'activation de vos prises à une heure spécifique',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
