import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bookmark/presentation/cubit/bookmark_cubit.dart';
import '../../domain/entities/news.dart';

class CustomNewsCard extends StatelessWidget {
  final News news;
  final VoidCallback? onTap;

  const CustomNewsCard({
    super.key,
    required this.news,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 90,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          image: DecorationImage(
            image: NetworkImage(news.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        news.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        news.sourceName,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          bool isBookmarked = false;
          if (state is BookmarkLoaded) {
            isBookmarked = state.bookmarks.any((b) => b.title == news.title);
          }

          return IconButton(
            onPressed: () {
              context.read<BookmarkCubit>().toggle(news);
            },
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
              color: isBookmarked ? Colors.red : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}