import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/recipe.dart';


class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/recipes';

  // Récupérer toutes les recettes
  Future<List<Recipe>> getRecipes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des recettes');
    }
  }

  // Ajouter une recette
  Future<Recipe> addRecipe(Recipe recipe) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(recipe.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Recipe.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l\'ajout de la recette');
    }
  }

  // Mettre à jour une recette
  Future<Recipe> updateRecipe(String id, Recipe recipe) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(recipe.toJson()),
    );
    if (response.statusCode == 200) {
      return Recipe.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour de la recette');
    }
  }

  // Supprimer une recette
  Future<void> deleteRecipe(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression de la recette');
    }
  }
}
