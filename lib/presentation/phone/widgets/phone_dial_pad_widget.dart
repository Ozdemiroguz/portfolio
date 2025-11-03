import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Phone dial pad widget
class PhoneDialPadWidget extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onCallPressed;
  final bool isCalling;

  const PhoneDialPadWidget({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    required this.onCallPressed,
    required this.isCalling,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768; // Mobile UI detection
    final isSmallScreen = screenHeight < 700 || screenWidth < 400;
    final isVerySmallScreen = screenHeight < 500 || screenWidth < 350;

    // Fixed button size based on screen width - much smaller buttons
    final spacing = isVerySmallScreen ? 4.0 : (isSmallScreen ? 5.0 : 6.0);
    final padding = isVerySmallScreen ? 8.0 : (isSmallScreen ? 10.0 : 12.0);

    // Calculate fixed button size - make it much smaller
    final availableWidth = screenWidth - (padding * 2);
    final calculatedSize = (availableWidth - (spacing * 4)) / 3;
    // Make buttons much smaller
    final buttonSize = calculatedSize * 0.65; // 35% smaller

    return Container(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
        top:
            isVerySmallScreen
                ? 16
                : (isSmallScreen ? 20 : 24), // Increased top padding
        bottom: isVerySmallScreen ? 12 : (isSmallScreen ? 16 : 20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dial pad grid - fixed size, always scrollable
          GridView.builder(
            //simetrik padding
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1.1,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              if (index == 9) {
                // Asterisk button
                return _DialButton(
                  label: '*',
                  onPressed: () => onDigitPressed('*'),
                  buttonSize: buttonSize,
                );
              } else if (index == 10) {
                // Zero button
                return _DialButton(
                  label: '0',
                  subLabel: '+',
                  onPressed: () => onDigitPressed('0'),
                  buttonSize: buttonSize,
                );
              } else if (index == 11) {
                // Hash button
                return _DialButton(
                  label: '#',
                  onPressed: () => onDigitPressed('#'),
                  buttonSize: buttonSize,
                );
              } else {
                // Number buttons 1-9
                final number = (index + 1).toString();
                final letters = _getLettersForNumber(index + 1);
                return _DialButton(
                  label: number,
                  subLabel: letters,
                  onPressed: () => onDigitPressed(number),
                  buttonSize: buttonSize,
                );
              }
            },
          ),
          SizedBox(height: isVerySmallScreen ? 10 : (isSmallScreen ? 12 : 16)),
          // Call and Delete buttons - larger for mobile UI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Call button - much bigger for mobile UI
              _ActionButton(
                icon: Icons.call,
                color: AppColors.success,
                onPressed: isCalling ? null : onCallPressed,
                size:
                    isMobile
                        ? (isVerySmallScreen ? 64 : (isSmallScreen ? 68 : 72))
                        : (isVerySmallScreen ? 56 : (isSmallScreen ? 60 : 64)),
              ),
              SizedBox(
                width: isVerySmallScreen ? 20 : (isSmallScreen ? 24 : 28),
              ),
              // Delete button - much bigger for mobile UI
              _ActionButton(
                icon: Icons.backspace_outlined,
                color: AppColors.textSecondary,
                onPressed: onDeletePressed,
                size:
                    isMobile
                        ? (isVerySmallScreen ? 58 : (isSmallScreen ? 62 : 66))
                        : (isVerySmallScreen ? 50 : (isSmallScreen ? 54 : 58)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLettersForNumber(int number) {
    switch (number) {
      case 1:
        return '';
      case 2:
        return 'ABC';
      case 3:
        return 'DEF';
      case 4:
        return 'GHI';
      case 5:
        return 'JKL';
      case 6:
        return 'MNO';
      case 7:
        return 'PQRS';
      case 8:
        return 'TUV';
      case 9:
        return 'WXYZ';
      default:
        return '';
    }
  }
}

class _DialButton extends StatelessWidget {
  final String label;
  final String? subLabel;
  final VoidCallback onPressed;
  final double buttonSize;

  const _DialButton({
    required this.label,
    this.subLabel,
    required this.onPressed,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate font size based on button size
    final fontSize = (buttonSize * 0.4).clamp(16.0, 24.0);
    final subLabelSize = (buttonSize * 0.15).clamp(6.0, 9.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundDark2,
            border: Border.all(
              color: AppColors.divider.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w300,
                ),
              ),
              if (subLabel != null && subLabel!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subLabel!,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: subLabelSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final double size;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: onPressed == null ? 0.3 : 1.0),
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.4),
        ),
      ),
    );
  }
}
