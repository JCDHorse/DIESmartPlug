import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mqtt_provider.dart';
import '../widgets/plug_control_card.dart';
import '../widgets/temperature_card.dart';
import '../widgets/scheduling_card.dart';
import '../widgets/connection_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Connexion au broker MQTT au démarrage
    Future.microtask(() {
      context.read<MqttProvider>().connect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MQTT Home Control',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statut de connexion
              const ConnectionStatus(),
              const SizedBox(height: 24),
              
              // Section Prises Intelligentes
              Text(
                'Prises Intelligentes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: PlugControlCard(
                      plugNumber: 1,
                      plugName: 'Prise 1',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PlugControlCard(
                      plugNumber: 2,
                      plugName: 'Prise 2',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Section Capteurs de Température
              Text(
                'Capteurs de Température',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TemperatureCard(
                      roomNumber: 1,
                      roomName: 'Pièce 1',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TemperatureCard(
                      roomNumber: 2,
                      roomName: 'Pièce 2',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Section Programmation
              Text(
                'Programmation',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const SchedulingCard(),
            ],
          ),
        ),
      ),
    );
  }
}
