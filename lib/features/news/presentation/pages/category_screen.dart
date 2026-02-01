import 'package:flutter/material.dart';
import '../../domain/entities/news.dart';
import '../widgets/custom_news_card.dart';
import 'details_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String title;
  final List<News> newsList;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.newsList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return CustomNewsCard(
            news: news,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(news: news),
                ),
              );
            },
          );
        },
      ),
    );
  }
}