import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/personal_info_screen.dart';
import 'models/form_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormData(),
      child: MaterialApp(
        title: 'Form Validation Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        home: const PersonalInfoScreen(),
      ),
    );
  }
}

