import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    super.description,
    super.content,
    super.url,
    super.imageUrl,
    super.sourceName,
    super.author,
    super.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;
    final url = json['url'] as String? ?? '';
    final publishedAtStr = json['publishedAt'] as String?;

    return ArticleModel(
      id: url.isNotEmpty
          ? url
          : (json['title'] as String? ?? '').hashCode.toString(),
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String?,
      content: json['content'] as String?,
      url: url.isNotEmpty ? url : null,
      imageUrl: json['urlToImage'] as String?,
      sourceName: source?['name'] as String?,
      author: json['author'] as String?,
      publishedAt: publishedAtStr != null
          ? DateTime.tryParse(publishedAtStr)
          : null,
    );
  }

  factory ArticleModel.fromEntity(Article article) {
    return ArticleModel(
      id: article.id,
      title: article.title,
      description: article.description,
      content: article.content,
      url: article.url,
      imageUrl: article.imageUrl,
      sourceName: article.sourceName,
      author: article.author,
      publishedAt: article.publishedAt,
    );
  }

  factory ArticleModel.fromHiveMap(Map<dynamic, dynamic> map) {
    return ArticleModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      content: map['content'] as String?,
      url: map['url'] as String?,
      imageUrl: map['imageUrl'] as String?,
      sourceName: map['sourceName'] as String?,
      author: map['author'] as String?,
      publishedAt: map['publishedAt'] != null
          ? DateTime.tryParse(map['publishedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'imageUrl': imageUrl,
      'sourceName': sourceName,
      'author': author,
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }
}
