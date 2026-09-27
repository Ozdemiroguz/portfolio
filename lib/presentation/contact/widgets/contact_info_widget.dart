import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/contact_data_entity.dart';

/// Contact info widget
/// Large CTA buttons for Email + WhatsApp, then info rows
class ContactInfoWidget extends StatelessWidget {
  final ContactDataEntity data;

  static const String _whatsappNumber = '905454542532'; // +90 545 454 25 32
  static const String _phoneDisplay = '+90 545 454 25 32';

  const ContactInfoWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(Colors.white, 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.withOpacity(Colors.white, 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('contact.contactInfo'),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spacingMd),

          // ===== PRIMARY CTA BUTTONS =====
          Row(
            children: [
              // Email button
              if (data.email.isNotEmpty)
                Expanded(
                  child: _buildCtaButton(
                    icon: Icons.email_rounded,
                    label: tr('contact.emailMe'),
                    color: AppColors.primary,
                    onTap: () => _launchEmail(data.email),
                  ),
                ),
              if (data.email.isNotEmpty)
                const SizedBox(width: AppSizes.spacingSm),
              // WhatsApp button
              Expanded(
                child: _buildCtaButton(
                  icon: Icons.chat_rounded,
                  label: tr('contact.whatsapp'),
                  color: const Color(0xFF25D366), // WhatsApp green
                  onTap: _launchWhatsApp,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // ===== INFO ROWS =====
          if (data.email.isNotEmpty)
            _buildClickableRow(
              icon: Icons.alternate_email,
              label: tr('contact.email'),
              value: data.email,
              onTap: () => _launchEmail(data.email),
            ),

          _buildClickableRow(
            icon: Icons.phone,
            label: tr('contact.phone'),
            value: _phoneDisplay,
            onTap: _launchWhatsApp,
          ),

          if (data.address.isNotEmpty)
            _buildInfoRow(
              icon: Icons.location_on,
              label: tr('contact.address'),
              value: data.address,
            ),
        ],
      ),
    );
  }

  Widget _buildCtaButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.paddingMd,
            horizontal: AppSizes.paddingMd,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: AppSizes.spacingXs),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.spacingXs,
              horizontal: AppSizes.spacingXs,
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: AppSizes.iconSm),
                const SizedBox(width: AppSizes.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: AppSizes.iconSm),
          const SizedBox(width: AppSizes.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final subject = Uri.encodeComponent('Portfolio inquiry');
    final uri = Uri.parse('mailto:$email?subject=$subject');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final message = Uri.encodeComponent(
      "Hi Oğuzhan, I found your portfolio and would like to chat.",
    );
    final uri = Uri.parse('https://wa.me/$_whatsappNumber?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
