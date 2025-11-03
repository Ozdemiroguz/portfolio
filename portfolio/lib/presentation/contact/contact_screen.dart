import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import 'widgets/contact_info_header_widget.dart';
import 'widgets/contact_info_widget.dart';
import 'widgets/contact_social_links_widget.dart';

/// Contact screen
/// Displays contact information and social links
class ContactScreen extends StatelessWidget {
  final AppEntity app;

  const ContactScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final contactData = app.contactData;

    if (contactData == null) {
      return Center(child: Text(tr('contact.noData')));
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 100),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const ContactInfoHeaderWidget(),
                const SizedBox(height: 20),
                ContactInfoWidget(data: contactData),
                const SizedBox(height: 20),
                ContactSocialLinksWidget(data: contactData),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
