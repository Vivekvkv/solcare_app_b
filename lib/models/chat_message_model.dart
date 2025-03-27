import 'package:flutter/material.dart';

enum MessageType {
  user,
  ai,
  error,
  loading,
}

class ChatMessageModel {
  final String message;
  final MessageType type;
  final DateTime timestamp;
  
  ChatMessageModel({
    required this.message,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  bool get isUser => type == MessageType.user;
  bool get isAi => type == MessageType.ai;
  bool get isError => type == MessageType.error;
  bool get isLoading => type == MessageType.loading;
}
