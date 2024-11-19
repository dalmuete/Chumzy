import 'package:flutter/foundation.dart' show immutable;

@immutable
class Message {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isMine;

  const Message({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isMine,
  });

  // Factory constructor for creating a Message from a JSON map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      message: map['message'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      isMine: map['isMine'] as bool,
    );
  }

  // Method for converting a Message to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isMine': isMine,
    };
  }

  // Message copyWith({
  //   String?
  // })
}
