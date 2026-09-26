import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/translation_helpers.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/entities/contact_data_entity.dart';
import '../achievement/widgets/achievement_list_widget.dart';
import '../career/widgets/career_timeline_widget.dart';
import '../contact/widgets/contact_info_widget.dart';
import '../contact/widgets/contact_social_links_widget.dart';
import '../home/cubit/home_state.dart';
import 'classic_apps.dart';
import 'widgets/classic_footer_widget.dart';
import 'widgets/classic_hero_widget.dart';
import 'widgets/classic_nav_bar_widget.dart';
import 'widgets/classic_project_card_widget.dart';
import 'widgets/classic_project_detail_dialog.dart';
import 'widgets/classic_section_widget.dart';

/// Conventional single-page portfolio built from the same data as the
/// phone experience.
class ClassicPortfolioScreen extends StatefulWidget {
  final HomeLoaded state;

  const ClassicPortfolioScreen({super.key, required this.state});

  @override
  State<ClassicPortfolioScreen> createState() => _ClassicPortfolioScreenState();
}

class _ClassicPortfolioScreenState extends State<ClassicPortfolioScreen> {
  final _scrollController = ScrollController();
  final _projectsKey = GlobalKey();
  final _careerKey = GlobalKey();
  final _achievementsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final apps = ClassicApps(widget.state.allApps);
    final about = apps.about;
    final ownerName = about == null
        ? tr('app.title')
        : TranslationHelpers.tryTranslate(about.fullNameKey, about.fullName);

    final career = apps.career;
    final achievements = apps.achievements;
    final contact = apps.contact;
    final projects = apps.projects;

    final navItems = [
      if (projects.isNotEmpty)
        ClassicNavItem(
          label: tr('classic.nav.projects'),
          onTap: () => _scrollTo(_projectsKey),
        ),
      if (career != null)
        ClassicNavItem(
          label: tr('classic.nav.career'),
          onTap: () => _scrollTo(_careerKey),
        ),
      if (achievements != null)
        ClassicNavItem(
          label: tr('classic.nav.achievements'),
          onTap: () => _scrollTo(_achievementsKey),
        ),
      if (contact != null)
        ClassicNavItem(
          label: tr('classic.nav.contact'),
          onTap: () => _scrollTo(_contactKey),
        ),
    ];

    return Stack(
      children: [
        Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: ClassicNavBarWidget.height),
                ClassicHeroWidget(
                  apps: apps,
                  onViewProjects: () => _scrollTo(_projectsKey),
                ),
                if (projects.isNotEmpty)
                  ClassicSectionWidget(
                    key: _projectsKey,
                    title: tr('classic.nav.projects'),
                    subtitle: tr('classic.projectsSubtitle'),
                    child: _ProjectsGrid(projects: projects),
                  ),
                if (career != null)
                  ClassicSectionWidget(
                    key: _careerKey,
                    title: tr('classic.nav.career'),
                    subtitle: tr('classic.careerSubtitle'),
                    child: CareerTimelineWidget(data: career),
                  ),
                if (achievements != null)
                  ClassicSectionWidget(
                    key: _achievementsKey,
                    title: tr('classic.nav.achievements'),
                    subtitle: tr('classic.achievementsSubtitle'),
                    child: AchievementListWidget(data: achievements),
                  ),
                if (contact != null)
                  ClassicSectionWidget(
                    key: _contactKey,
                    title: tr('classic.nav.contact'),
                    subtitle: tr('classic.contactSubtitle'),
                    child: _ContactBlock(contact: contact),
                  ),
                ClassicFooterWidget(ownerName: ownerName),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: _scrollToTop,
            child: ClassicNavBarWidget(brand: ownerName, items: navItems),
          ),
        ),
      ],
    );
  }
}

/// Responsive card grid: three columns on desktop, two on tablet, one on
/// phones.
class _ProjectsGrid extends StatelessWidget {
  final List<AppEntity> projects;

  const _ProjectsGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 900 ? 3 : (width >= 600 ? 2 : 1);
        const gap = AppSizes.spacingLg;
        final cardWidth = (width - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final app in projects)
              SizedBox(
                width: cardWidth,
                child: ClassicProjectCardWidget(
                  app: app,
                  onTap: () => showClassicProjectDetail(context, app),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ContactBlock extends StatelessWidget {
  final ContactDataEntity contact;

  const _ContactBlock({required this.contact});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 760;
        final info = ContactInfoWidget(data: contact);
        final socials = ContactSocialLinksWidget(data: contact);

        if (stacked) {
          return Column(
            children: [
              info,
              const SizedBox(height: AppSizes.spacingLg),
              socials,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: info),
            const SizedBox(width: AppSizes.spacingLg),
            Expanded(child: socials),
          ],
        );
      },
    );
  }
}
