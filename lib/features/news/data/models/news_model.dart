import 'package:hive/hive.dart';
import '../../domain/entities/news.dart';

part 'news_model.g.dart';

@HiveType(typeId: 0)
class NewsModel extends News {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final String content;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String image;
  
  @HiveField(4)
  final String sourceName;
  
  @HiveField(5)
  final String publishedAt;

  const NewsModel({
    required this.title,
    required this.content,
    required this.description,
    required this.image,
    required this.sourceName,
    required this.publishedAt,
  }) : super(
          title: title,
          content: content,
          description: description,
          image: image,
          sourceName: sourceName,
          publishedAt: publishedAt,
        );

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      sourceName: json['source']?['name'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'description': description,
      'image': image,
      'source': {'name': sourceName},
      'publishedAt': publishedAt,
    };
  }

  News toEntity() {
    return News(
      title: title,
      content: content,
      description: description,
      image: image,
      sourceName: sourceName,
      publishedAt: publishedAt,
    );
  }
}