import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/project_data_entity.dart';
import 'project_card_widget.dart';

/// Project list widget
/// Displays all projects
class ProjectListWidget extends StatelessWidget {
  final ProjectDataEntity data;

  const ProjectListWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final projects = data.projects;

    if (projects.isEmpty) {
      return const Center(
        child: Text(
          'No projects available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: projects.map((project) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingLg),
          child: ProjectCardWidget(
            project: project,
          ),
        );
      }).toList(),
    );
  }
}
