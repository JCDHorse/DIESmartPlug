import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/mqtt_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: MaterialApp(
        title: 'MQTT Home Control',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
