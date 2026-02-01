import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String content;
  final String description;
  final String image;
  final String sourceName;
  final String publishedAt;

  const News({
    required this.title,
    required this.content,
    required this.description,
    required this.image,
    required this.sourceName,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [
        title,
        content,
        description,
        image,
        sourceName,
        publishedAt,
      ];
}