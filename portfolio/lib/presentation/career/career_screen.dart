import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import 'widgets/career_timeline_widget.dart';

/// Career screen
/// Displays work experience timeline
class CareerScreen extends StatelessWidget {
  final AppEntity app;

  const CareerScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    final careerData = app.careerData;

    if (careerData == null) {
      return Center(
        child: Text(tr('career.noData')),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 100), // Top spacing

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CareerTimelineWidget(data: careerData),
          ),

          const SizedBox(height: 100), // Bottom spacing
        ],
      ),
    );
  }
}
