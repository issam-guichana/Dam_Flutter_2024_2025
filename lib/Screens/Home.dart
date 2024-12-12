import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Screens/User/UsersListPage.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tableau de Bord Admin',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // logout logic here
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children:const <Widget>[
           Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Choisissez la section à gérer",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AdminTile(
            sectionName: "Gestion Utilisateur",
            color: Colors.blue,
            iconName: Icons.people,
            destinationPage: GestionUtilisateur(),
          ),
          AdminTile(
            sectionName: "Gestion Recette",
            color: Colors.green,
            iconName: Icons.restaurant_menu,
           destinationPage: GestionUtilisateur(),
          ),
          AdminTile(
            sectionName: "Gestion Publication",
            color: Colors.orange,
            iconName: Icons.publish,
            destinationPage: GestionUtilisateur(),
          ),
        ],
      ),
    );
  }
}

class AdminTile extends StatelessWidget {
  final String sectionName;
  final IconData iconName;
  final Color color;
  final Widget destinationPage;

  const AdminTile({
    super.key,
    required this.sectionName,
    required this.iconName,
    required this.color,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the respective page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => destinationPage
            )
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(iconName, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sectionName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}