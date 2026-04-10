import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String title;
  final String content;
  final String? userId;
  final Timestamp? createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.userId,
    this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> data, String documentId) {
    return Note(
      id: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'],
      createdAt: data['createdAt'] as Timestamp?,
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
    return map;
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? userId,
    Timestamp? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
