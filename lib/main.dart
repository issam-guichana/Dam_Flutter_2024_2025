import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Screens/Auth/ForgetPassword.dart';
import 'package:flutter_application_dam/Screens/Auth/SplashScreen.dart';
import 'package:flutter_application_dam/Screens/Auth/signin.dart';
import 'package:flutter_application_dam/Screens/Auth/singup.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signup': (context) =>
            const Signup(),
        '/forgetPassword': (context) =>
            const ForgetPassword(),
      },
    );
  }
}
