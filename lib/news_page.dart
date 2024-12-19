import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsItem> _newsList = [];
  bool _isLoading = true;
  String? _error;
  Set<String> _acceptedPosts = {};  // Changed to String to store unique identifiers
  Set<String> _refusedPosts = {};   // Changed to String to store unique identifiers

  // Keys for SharedPreferences
  static const String _acceptedPostsKey = 'accepted_posts';
  static const String _refusedPostsKey = 'refused_posts';

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
    _fetchNews();
  }

  // Load saved preferences
  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _acceptedPosts = Set<String>.from(prefs.getStringList(_acceptedPostsKey) ?? []);
      _refusedPosts = Set<String>.from(prefs.getStringList(_refusedPostsKey) ?? []);
    });
  }

  // Save preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_acceptedPostsKey, _acceptedPosts.toList());
    await prefs.setStringList(_refusedPostsKey, _refusedPosts.toList());
  }

  // Generate unique identifier for a post
  String _generatePostId(NewsItem item, int index) {
    return '${item.title}_$index';  // Using title and index as unique identifier
  }

  Future<void> _fetchNews() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      List<NewsItem> allNews = [];

      final feeds = [
        'https://feeds.bbci.co.uk/food/rss.xml',
        'https://www.themealdb.com/api/json/v1/1/search.php?s=',
      ];

      for (final feed in feeds) {
        try {
          final response = await http.get(Uri.parse(feed));

          if (response.statusCode == 200) {
            if (feed.contains('themealdb')) {
              final Map<String, dynamic> data = json.decode(response.body);
              final meals = data['meals'] as List<dynamic>? ?? [];

              allNews.addAll(
                  meals.map((meal) => NewsItem(
                    title: meal['strMeal'] ?? 'No Title',
                    description: meal['strInstructions'] ?? 'No Description',
                    imageUrl: meal['strMealThumb'],
                  ))
              );
            } else {
              final document = xml.XmlDocument.parse(response.body);
              final items = document.findAllElements('item');

              allNews.addAll(
                  items.map((item) => NewsItem(
                    title: item.findElements('title').firstOrNull?.innerText ?? 'No Title',
                    description: item.findElements('description').firstOrNull?.innerText ?? 'No Description',
                    imageUrl: item.findElements('media:content').firstOrNull?.getAttribute('url'),
                  ))
              );
            }
          }
        } catch (e) {
          print('Error fetching from $feed: $e');
        }
      }

      setState(() {
        _newsList = allNews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load news: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildNewsCard(NewsItem newsItem, int index) {
    final postId = _generatePostId(newsItem, index);

    // If the post is refused, don't show it
    if (_refusedPosts.contains(postId)) {
      return Container();
    }

    final bool isAccepted = _acceptedPosts.contains(postId);

    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      color: isAccepted ? Colors.green[200] : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (newsItem.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    newsItem.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        newsItem.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (newsItem.imageUrl == null)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                newsItem.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsItem.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                _buildCommentSection(postId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(String postId) {
    final bool isAccepted = _acceptedPosts.contains(postId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Leave a Comment (pas obligatoire)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your comment...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _acceptedPosts.add(postId);
                _savePreferences();  // Save changes
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Publication acceptée avec succès'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: Text('Accepter Publication',
              style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _refusedPosts.add(postId);
                _savePreferences();  // Save changes
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('message refusé et commentaire soumis avec succès'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: Text('Refuser et commenter',
              style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (isAccepted) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[400]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Cette publication a été acceptée',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            SizedBox(height: 16),
            Text('Loading recipes...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchNews,
              child: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      );
    }

    if (_newsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_meals, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No recipes found'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        final newsItem = _newsList[index];
        return _buildNewsCard(newsItem, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Recipe Feed',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87),
            onPressed: _fetchNews,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}

class NewsItem {
  final String title;
  final String description;
  final String? imageUrl;

  NewsItem({
    required this.title,
    required this.description,
    this.imageUrl,
  });
}