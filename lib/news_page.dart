
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> _newsList = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() async {
    List<dynamic> allNews = [];

    // Appel à la première API
    final response1 = await http.get(Uri.parse('https://www.euronews.com/tag/recipes'));
    if (response1.statusCode == 200) {
      allNews.addAll(json.decode(response1.body));
    }

    // Appel à la deuxième API
    final response2 = await http.get(Uri.parse('https://www.bbc.co.uk/food/recipes'));
    if (response2.statusCode == 200) {
      allNews.addAll(json.decode(response2.body));
    }

    // Appel à la troisième API
    final response3 = await http.get(Uri.parse('https://www.today.com/food'));
    if (response3.statusCode == 200) {
      allNews.addAll(json.decode(response3.body));
    }

    setState(() {
      _newsList = allNews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualités'),
      ),
      body: ListView.builder(
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final newsItem = _newsList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    newsItem['title'] ?? 'Titre indisponible',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(newsItem['description'] ?? 'Description indisponible'),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Nom'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Commentaire'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Gérer l'envoi du commentaire
                    },
                    child: Text('Envoyer'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}