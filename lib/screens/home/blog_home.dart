import 'dart:math';

import 'package:blog_app/screens/home/blog_details.dart';
import 'package:flutter/material.dart';

class BlogHomeScreen extends StatelessWidget {
  const BlogHomeScreen({super.key});

  // Random static blog posts
  final List<Map<String, String>> staticPosts = const [
    {
      'title': 'Top 10 Flutter Tips for Beginners',
      'excerpt':
          'Learn how to build beautiful Flutter apps with these 10 essential tips...',
    },
    {
      'title': 'Understanding Firebase in 2025',
      'excerpt':
          'Firebase has evolved a lot. Here is what you need to know about Firestore and Auth...',
    },
    {
      'title': 'Modern UI Design Trends',
      'excerpt':
          'Discover the latest trends in UI/UX design for mobile and web apps...',
    },
    {
      'title': 'State Management Made Easy',
      'excerpt':
          'A beginner-friendly guide to managing state in Flutter using Riverpod, Provider, and more...',
    },
    {
      'title': 'Why Async/Await Matters',
      'excerpt':
          'Understand asynchronous programming in Dart and how it improves your app performance...',
    },
    {
      'title': 'Building Responsive Layouts in Flutter',
      'excerpt':
          'Tips and tricks to make your Flutter apps look great on any screen size...',
    },
    {
      'title': 'Animations That Wow Users',
      'excerpt':
          'Learn how to create smooth and engaging animations in Flutter apps...',
    },
  ];

  // Shuffle posts to show randomly
  List<Map<String, String>> getRandomPosts() {
    final random = Random();
    final shuffled = List<Map<String, String>>.from(staticPosts);
    shuffled.shuffle(random);
    return shuffled;
  }

  @override
  Widget build(BuildContext context) {
    final posts = getRandomPosts();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final data = posts[index];
        final title = data['title'] ?? 'Untitled';
        final excerpt = data['excerpt'] ?? '—';

        return ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(excerpt, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlogDetailsScreen(
                  title: title,
                  content:
                      '$excerpt\n\nThis is a sample blog body. It expands on the topic and gives the reader meaningful insights about Flutter development and UI/UX. You can replace this with real content later.',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
