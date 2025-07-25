import 'package:flutter/material.dart';

class DateSectionWidget extends StatelessWidget {
  final String? startedDate;
  final String? endedDate;

  const DateSectionWidget({super.key, this.startedDate, this.endedDate});

  @override
  Widget build(BuildContext context) {
    if (startedDate == null && endedDate == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.grey.withOpacity(0.6), size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (startedDate != null) ...[
                    _buildDateContainer(
                      'Started: $startedDate',
                      Icons.play_arrow,
                      Colors.green,
                    ),
                  ],
                  if (startedDate != null && endedDate != null)
                    const SizedBox(width: 8),
                  if (endedDate != null) ...[
                    _buildDateContainer(
                      'Ended: $endedDate',
                      Icons.stop,
                      Colors.red,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateContainer(String text, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor.withOpacity(0.8), size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
