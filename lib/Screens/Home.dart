import 'package:flutter/material.dart';
import 'package:flutter_application_dam/Screens/Recettes/recipe_list_screen.dart';
import 'package:flutter_application_dam/Screens/User/UsersListPage.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Tableau de Bord Admin',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade800,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              onPressed: () {
                // logout logic here
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: <Widget>[
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Text(
                  "Choisissez la section à gérer",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2.0,
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const AdminTile(
              sectionName: "Gestion Utilisateur",
              color: Color(0xFF1E88E5),
              iconName: Icons.people,
              destinationPage: GestionUtilisateur(),
            ),
            AdminTile(
              sectionName: "Gestion Recette",
              color: const Color(0xFF43A047),
              iconName: Icons.restaurant_menu,
              destinationPage: RecipeListScreen(),
            ),
            const AdminTile(
              sectionName: "Gestion Publication",
              color: Color(0xFFF57C00),
              iconName: Icons.publish,
              destinationPage: GestionUtilisateur(),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminTile extends StatefulWidget {
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
  State<AdminTile> createState() => _AdminTileState();
}

class _AdminTileState extends State<AdminTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.destinationPage),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutQuad,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_isPressed ? 0.3 : 0.4),
              spreadRadius: _isPressed ? 1 : 2,
              blurRadius: _isPressed ? 8 : 12,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              widget.color.withOpacity(0.9),
              widget.color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 2.0 : 0.0, 0.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.iconName,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                widget.sectionName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}