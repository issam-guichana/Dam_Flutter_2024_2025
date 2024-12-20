import 'package:flutter/material.dart';
import '../../Models/recipe.dart';
import 'add_recipe_screen.dart';
import 'api_service.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Recipe>> recipes;
  List<Recipe> _filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    recipes = apiService.getRecipes();
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRecipes() async {
    final recipeList = await apiService.getRecipes();
    setState(() {
      _filteredRecipes = recipeList;
    });
  }

  void _refreshRecipes() {
    setState(() {
      recipes = apiService.getRecipes();
      _loadRecipes();
    });
  }

  void _filterRecipes(String query) {
    recipes.then((recipeList) {
      setState(() {
        _filteredRecipes = recipeList
            .where((recipe) =>
            recipe.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _loadRecipes();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Rechercher une recette...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: TextStyle(color: Colors.black87, fontSize: 18),
          onChanged: _filterRecipes,
        ),
      );
    }

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Mes Recettes',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.black87),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.black87),
          onPressed: _refreshRecipes,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: FutureBuilder<List<Recipe>>(
        future: recipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  SizedBox(height: 16),
                  Text(
                    'Erreur : ${snapshot.error}',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || _filteredRecipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    _isSearching
                        ? 'Aucune recette trouvée'
                        : 'Aucune recette disponible',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _filteredRecipes[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      child: Text(
                        recipe.title[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[300],
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmer la suppression'),
                              content: Text('Voulez-vous vraiment supprimer cette recette ?'),
                              actions: [
                                TextButton(
                                  child: Text('Annuler'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  child: Text(
                                    'Supprimer',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    await apiService.deleteRecipe(recipe.id!);
                                    _refreshRecipes();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipeScreen()),
          ).then((_) => _refreshRecipes());
        },
        label: Text('Ajouter une recette'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}