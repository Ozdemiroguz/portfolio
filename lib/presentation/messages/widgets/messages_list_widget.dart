import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/message_entity.dart';
import 'message_bubble_widget.dart';

/// Messages list widget
class MessagesListWidget extends StatefulWidget {
  final List<MessageEntity> messages;

  const MessagesListWidget({
    super.key,
    required this.messages,
  });

  @override
  State<MessagesListWidget> createState() => _MessagesListWidgetState();
}

class _MessagesListWidgetState extends State<MessagesListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(MessagesListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return Center(
        child: Text(
          tr('messages.input.empty'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return MessageBubbleWidget(
          text: message.text,
          isFromMe: message.isFromMe,
          timestamp: message.timestamp,
          translationKey: message.translationKey,
        );
      },
    );
  }
}

