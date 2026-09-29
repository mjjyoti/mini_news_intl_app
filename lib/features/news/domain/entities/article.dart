import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? content;
  final String? url;
  final String? imageUrl;
  final String? sourceName;
  final String? author;
  final DateTime? publishedAt;

  const Article({
    required this.id,
    required this.title,
    this.description,
    this.content,
    this.url,
    this.imageUrl,
    this.sourceName,
    this.author,
    this.publishedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    content,
    url,
    imageUrl,
    sourceName,
    author,
    publishedAt,
  ];
}
