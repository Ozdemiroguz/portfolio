import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:math';
import '../../../domain/entities/message_entity.dart';
import 'messages_state.dart';

/// Messages cubit - handles chat logic
class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(const MessagesState(messages: [])) {
    _initializeMessages();
  }

  void _initializeMessages() {
    // Initial greeting messages - using translation keys
    final initialMessages = [
      MessageEntity(
        id: '1',
        text: '', // Will be translated in widget
        isFromMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        translationKey: 'messages.initial.greeting1',
      ),
      MessageEntity(
        id: '2',
        text: '', // Will be translated in widget
        isFromMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        translationKey: 'messages.initial.greeting2',
      ),
    ];
    emit(state.copyWith(messages: initialMessages));
  }

  /// Send a new message
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isFromMe: true,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, newMessage];
    emit(state.copyWith(messages: updatedMessages));

    // Generate auto-reply after a short delay
    _generateAutoReply(text);
  }

  void _generateAutoReply(String userMessage) {
    // Delay for realistic chat experience
    Timer(const Duration(milliseconds: 1500), () {
      final replyKey = _getSmartReply(userMessage);
      final replyMessage = MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: '', // Will be translated in widget
        isFromMe: false,
        timestamp: DateTime.now(),
        translationKey: replyKey,
      );

      final updatedMessages = [...state.messages, replyMessage];
      emit(state.copyWith(messages: updatedMessages));
    });
  }

  String _getSmartReply(String userMessage) {
    final random = Random();

    // Always return positive, encouraging messages - using translation keys
    final positiveReplyKeys = [
      'messages.replies.positive1',
      'messages.replies.positive2',
      'messages.replies.positive3',
      'messages.replies.positive4',
      'messages.replies.positive5',
    ];
    
    // Return the key, will be translated in widget
    return positiveReplyKeys[random.nextInt(positiveReplyKeys.length)];
  }
}

