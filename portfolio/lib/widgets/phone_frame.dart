import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;
  final bool showFrame;
  final Color frameColor;
  final double aspectRatio;

  const PhoneFrame({
    super.key,
    required this.child,
    this.showFrame = true,
    this.frameColor = Colors.black,
    this.aspectRatio = 9 / 19.5, // iPhone benzeri oran
  });

  @override
  Widget build(BuildContext context) {
    if (!showFrame) {
      return child;
    }

    return Container(
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
          child: Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              children: [
                // Durum çubuğu
                _buildStatusBar(),
                // Ana içerik
                Expanded(child: child),
                // Ana sayfa göstergesi (home indicator)
                _buildHomeIndicator(),
              ],
            ),
          ),
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
          // Sol taraf - Saat
          Text(
            _getCurrentTime(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Sağ taraf - Durum ikonları
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
          color: Colors.white.withOpacity(0.3),
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
