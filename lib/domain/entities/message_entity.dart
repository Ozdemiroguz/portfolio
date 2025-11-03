import 'package:equatable/equatable.dart';

/// Single message entity
class MessageEntity extends Equatable {
  final String id;
  final String text;
  final bool isFromMe;
  final DateTime timestamp;
  final String? translationKey; // Translation key for localization

  const MessageEntity({
    required this.id,
    required this.text,
    required this.isFromMe,
    required this.timestamp,
    this.translationKey,
  });

  @override
  List<Object?> get props => [id, text, isFromMe, timestamp, translationKey];
}

