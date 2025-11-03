import 'package:equatable/equatable.dart';
import '../../../domain/entities/message_entity.dart';

/// Messages state
class MessagesState extends Equatable {
  final List<MessageEntity> messages;
  final bool isLoading;
  final String? error;

  const MessagesState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  MessagesState copyWith({
    List<MessageEntity>? messages,
    bool? isLoading,
    String? error,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error];
}


