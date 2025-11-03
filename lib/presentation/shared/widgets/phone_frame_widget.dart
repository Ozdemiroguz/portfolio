import 'package:flutter/material.dart';

/// Phone frame widget
/// Displays content in a phone-like frame with status bar and home indicator
class PhoneFrameWidget extends StatelessWidget {
  final Widget child;
  final bool showFrame;

  const PhoneFrameWidget({
    super.key,
    required this.child,
    this.showFrame = true,
  });

  @override
  Widget build(BuildContext context) {
    // Always show phone UI with status bar and home indicator
    final phoneUI = Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          // Status bar
          _buildStatusBar(),
          // Main content - with explicit height for scrolling
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: child,
                );
              },
            ),
          ),
          // Home indicator
          _buildHomeIndicator(),
        ],
      ),
    );

    // If showFrame is false, return phone UI without frame
    if (!showFrame) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: phoneUI,
      );
    }

    // Return phone UI with frame
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: phoneUI,
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Left side - Time
          Text(
            _getCurrentTime(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Right side - Status icons
          Row(
            children: [
              const Icon(
                Icons.signal_cellular_4_bar,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Container(
                width: 24,
                height: 12,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 18,
                    height: 8,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Container(
      height: 34,
      alignment: Alignment.center,
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
