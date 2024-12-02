import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Screens/Auth/signin.dart';
import 'package:flutter_application_dam/Screens/Auth/singup.dart';
import 'package:flutter_application_dam/Screens/Home.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({super.key});

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  final List<Widget> interfaces = [
    const Signin(), // Page de connexion
    const Signup(), // Page d'inscription
    const Home() // Page d'accueil
  ];

  late int current_index = 0;

  List<String> titles = ["Sign In", "Sign Up"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[current_index]), // Affichage du titre correspondant
      ),
      body: interfaces[current_index],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: "Sign In"), // Item pour la connexion
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: "Sign Up"), // Item pour l'inscription
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        ],
        currentIndex: current_index,
        onTap: (value) {
          setState(() {
            current_index = value;
          });
        },
      ),
    );
  }
}
