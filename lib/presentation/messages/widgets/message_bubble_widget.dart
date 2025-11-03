import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';

/// Message bubble widget
class MessageBubbleWidget extends StatelessWidget {
  final String text;
  final bool isFromMe;
  final DateTime timestamp;
  final String? translationKey;

  const MessageBubbleWidget({
    super.key,
    required this.text,
    required this.isFromMe,
    required this.timestamp,
    this.translationKey,
  });

  @override
  Widget build(BuildContext context) {
    // Use translation if key exists, otherwise use text directly
    final displayText = translationKey != null 
        ? tr(translationKey!)
        : text;
    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isFromMe
              ? AppColors.primary
              : AppColors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isFromMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isFromMe ? Radius.zero : const Radius.circular(16),
          ),
          border: Border.all(
            color: isFromMe
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.divider,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayText,
              style: TextStyle(
                color: isFromMe ? Colors.white : AppColors.textPrimary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(timestamp),
              style: TextStyle(
                color: isFromMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return tr('messages.time.now');
    } else if (difference.inHours < 1) {
      return tr('messages.time.minutesAgo', namedArgs: {'minutes': difference.inMinutes.toString()});
    } else if (difference.inDays < 1) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

