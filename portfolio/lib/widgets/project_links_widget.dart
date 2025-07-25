import 'package:flutter/material.dart';
import 'glassmorphism_link_widget.dart';

class ProjectLinksWidget extends StatelessWidget {
  final List<dynamic> links;

  const ProjectLinksWidget({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    // Artık global GlassmorphismLinkWidget kullanıyoruz
    return GlassmorphismLinkWidget(links: links, title: 'LINKS');
  }
}
