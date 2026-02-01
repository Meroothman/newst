import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubit/bookmark_cubit.dart';
import '../../../news/presentation/widgets/custom_news_card.dart';
import '../../../news/presentation/pages/details_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookmarkCubit>().loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookmarkError) {
            return Center(child: Text(state.message));
          }

          if (state is BookmarkLoaded) {
            if (state.bookmarks.isEmpty) {
              return const Center(
                child: Text(
                  "No Bookmarks",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: state.bookmarks.length,
                itemBuilder: (context, index) {
                  final news = state.bookmarks[index];
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

          return const Center(child: Text("No Bookmarks"));
        },
      ),
    );
  }
}