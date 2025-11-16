import 'package:flutter/material.dart';
import 'package:quinta_code/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quinta_code/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          labelStyle: TextStyle(color: Constants.text_color),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Constants.accent_color,
          selectionColor: Constants.accent_color,
          selectionHandleColor: Constants.accent_color,
        ),
      ),
      title: 'Quinta Code',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: AuthWrapper()
    );
  }
}
