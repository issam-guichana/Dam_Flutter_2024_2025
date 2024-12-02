import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
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
        children: const <Widget>[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Choose the cuisine you want to eat",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          CuisineTile(
            cuisineName: "Tunisian Cuisine",
            color: Colors.pink,
            iconName: Icons.food_bank,
            imagePath: "assets/tunisia.jpg",
          ),
          CuisineTile(
            cuisineName: "Italian Cuisine",
            color: Colors.orange,
            iconName: Icons.local_pizza,
            imagePath: "assets/italienne.jpg",
          ),
          CuisineTile(
            cuisineName: "Japanese Cuisine",
            color: Colors.red,
            iconName: Icons.ramen_dining,
            imagePath: "assets/japonais.jpg",
          ),
        ],
      ),
    );
  }
}

class CuisineTile extends StatelessWidget {
  final String cuisineName;
  final IconData iconName;
  final Color color;
  final String imagePath;

  const CuisineTile({
    super.key,
    required this.cuisineName,
    required this.iconName,
    required this.color,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigating to $cuisineName'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(iconName, color: Colors.white, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      cuisineName,
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
          ],
        ),
      ),
    );
  }
}
