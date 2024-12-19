class Recipe {
  final String? id;
  final String title;
  final String description;
  final List<String> ingredients;

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required String instructions,
  });

  // Convertir JSON en objet Recipe
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: '',
    );
  }

  // Convertir objet Recipe en JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
    };
  }
}
