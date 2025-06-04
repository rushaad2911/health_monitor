import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './screens/login.dart';
import './screens/dashboard.dart';
import './screens/device_connect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://your-project-id.supabase.co', // Replace with your Supabase project URL
    anonKey: 'your-anon-key', // Replace with your Supabase anon key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Health Monitoring',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/dashboard',
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/device-connect': (context) => DeviceConnectScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
