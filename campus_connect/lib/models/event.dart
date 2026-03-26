class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String imageUrl;
  final double? latitude;
  final double? longitude;
  final String createdBy;
  final List<String> likes;
  final List<Comment> comments;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl = '',
    this.latitude,
    this.longitude,
    required this.createdBy,
    this.likes = const [],
    this.comments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
      imageUrl: map['imageUrl'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      createdBy: map['createdBy'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      comments: (map['comments'] as List<dynamic>? ?? [])
          .map((comment) => Comment.fromMap(Map<String, dynamic>.from(comment)))
          .toList(),
    );
  }
}

class Comment {
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['userId']?.toString() ?? '',
      userName: map['userName']?.toString() ?? 'User',
      text: map['text']?.toString() ?? '',
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
