import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recycle_mania/screens/login_screen.dart';
import 'package:recycle_mania/screens/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');

  runApp(RecycleManiaApp(isLoggedIn: username != null));
}

class RecycleManiaApp extends StatelessWidget {
  final bool isLoggedIn;

  const RecycleManiaApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle Mania',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? const MenuScreen() : const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
