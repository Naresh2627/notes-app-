import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String title;
  final String content;
  final String? userId;
  final Timestamp? createdAt;
  final String? youtubeTitle;
  final String? youtubeDescription;
  final String? youtubeThumbnailUrl;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.userId,
    this.createdAt,
    this.youtubeTitle,
    this.youtubeDescription,
    this.youtubeThumbnailUrl,
  });

  factory Note.fromMap(Map<String, dynamic> data, String documentId) {
    return Note(
      id: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'],
      createdAt: data['createdAt'] as Timestamp?,
      youtubeTitle: data['youtubeTitle'],
      youtubeDescription: data['youtubeDescription'],
      youtubeThumbnailUrl: data['youtubeThumbnailUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
    };
    if (userId != null) {
      map['userId'] = userId;
    }
    if (createdAt != null) {
      map['createdAt'] = createdAt;
    }
    if (youtubeTitle != null) {
      map['youtubeTitle'] = youtubeTitle;
    }
    if (youtubeDescription != null) {
      map['youtubeDescription'] = youtubeDescription;
    }
    if (youtubeThumbnailUrl != null) {
      map['youtubeThumbnailUrl'] = youtubeThumbnailUrl;
    }
    return map;
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? userId,
    Timestamp? createdAt,
    String? youtubeTitle,
    String? youtubeDescription,
    String? youtubeThumbnailUrl,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      youtubeTitle: youtubeTitle ?? this.youtubeTitle,
      youtubeDescription: youtubeDescription ?? this.youtubeDescription,
      youtubeThumbnailUrl: youtubeThumbnailUrl ?? this.youtubeThumbnailUrl,
    );
  }
}
