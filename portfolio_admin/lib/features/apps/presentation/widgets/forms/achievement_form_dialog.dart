import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/domain/models/app_model.dart';

class AchievementFormDialog extends ConsumerStatefulWidget {
  final AppModel? app;
  final String portfolioId;

  const AchievementFormDialog({super.key, this.app, required this.portfolioId});

  @override
  ConsumerState<AchievementFormDialog> createState() =>
      _AchievementFormDialogState();
}

class _AchievementFormDialogState extends ConsumerState<AchievementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late List<AchievementItemController> _achievementControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.app?.data != null &&
        widget.app!.data is Map<String, dynamic> &&
        (widget.app!.data as Map<String, dynamic>).containsKey(
          'achievements',
        )) {
      final data = widget.app!.data as Map<String, dynamic>;
      final achievements = data['achievements'] as List<dynamic>? ?? [];
      _achievementControllers =
          achievements
              .map(
                (achievement) => AchievementItemController.fromMap(
                  achievement as Map<String, dynamic>,
                ),
              )
              .toList();
    } else {
      _achievementControllers = [AchievementItemController()];
    }
  }

  void _addAchievement() {
    setState(() {
      _achievementControllers.add(AchievementItemController());
    });
  }

  void _removeAchievement(int index) {
    if (_achievementControllers.length > 1) {
      setState(() {
        _achievementControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._achievementControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final controller = entry.value;
                        return _buildAchievementItem(controller, index);
                      }),
                      _buildAddAchievementButton(),
                    ],
                  ),
                ),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            widget.app == null ? 'Başarı Oluştur' : 'Başarı Düzenle',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    AchievementItemController controller,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Başarı ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (_achievementControllers.length > 1)
                IconButton(
                  onPressed: () => _removeAchievement(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Title & Organization
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    labelText: 'Başarı Başlığı',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.emoji_events),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty == true ? 'Bu alan zorunlu' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.organizationController,
                  decoration: const InputDecoration(
                    labelText: 'Kurum/Organizasyon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category & Level
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.category,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      [
                            'award',
                            'certification',
                            'competition',
                            'recognition',
                            'scholarship',
                            'publication',
                            'other',
                          ]
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(_getCategoryText(category)),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => controller.category = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.level,
                  decoration: const InputDecoration(
                    labelText: 'Seviye',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      [
                            'international',
                            'national',
                            'regional',
                            'local',
                            'company',
                            'personal',
                          ]
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(_getLevelText(level)),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => controller.level = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date & URL
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, controller),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tarih',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      controller.date != null
                          ? DateFormat('dd/MM/yyyy').format(controller.date!)
                          : 'Tarih Seç',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.urlController,
                  decoration: const InputDecoration(
                    labelText: 'Sertifika/Belge URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          TextFormField(
            controller: controller.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Açıklama',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Skills & Tags
          _buildChipInput(
            'İlgili Beceriler',
            controller.skills,
            Icons.build_outlined,
            'Flutter, Leadership, Problem Solving ekleyin...',
          ),
          const SizedBox(height: 16),

          _buildChipInput(
            'Etiketler',
            controller.tags,
            Icons.tag,
            'Hackathon, Open Source, Innovation ekleyin...',
          ),
        ],
      ),
    );
  }

  Widget _buildChipInput(
    String label,
    List<String> items,
    IconData icon,
    String hint,
  ) {
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                items
                    .map(
                      (item) => Chip(
                        label: Text(item),
                        onDeleted: () {
                          setState(() {
                            items.remove(item);
                          });
                        },
                      ),
                    )
                    .toList(),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      items.add(value.trim());
                      controller.clear();
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    items.add(controller.text.trim());
                    controller.clear();
                  });
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddAchievementButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: OutlinedButton.icon(
        onPressed: _addAchievement,
        icon: const Icon(Icons.add),
        label: const Text('Başarı Ekle'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          side: BorderSide(color: Theme.of(context).primaryColor),
          foregroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _saveAchievement,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    AchievementItemController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        controller.date = date;
      });
    }
  }

  String _getCategoryText(String category) {
    switch (category) {
      case 'award':
        return 'Ödül';
      case 'certification':
        return 'Sertifika';
      case 'competition':
        return 'Yarışma';
      case 'recognition':
        return 'Takdir';
      case 'scholarship':
        return 'Burs';
      case 'publication':
        return 'Yayın';
      case 'other':
        return 'Diğer';
      default:
        return category;
    }
  }

  String _getLevelText(String level) {
    switch (level) {
      case 'international':
        return 'Uluslararası';
      case 'national':
        return 'Ulusal';
      case 'regional':
        return 'Bölgesel';
      case 'local':
        return 'Yerel';
      case 'company':
        return 'Şirket';
      case 'personal':
        return 'Kişisel';
      default:
        return level;
    }
  }

  void _saveAchievement() {
    if (_formKey.currentState!.validate()) {
      final achievements =
          _achievementControllers
              .map((controller) => controller.toMap())
              .toList();

      final app = AppModel(
        id: widget.app?.id ?? '',
        title: widget.app?.title ?? 'Başarılar',
        description: widget.app?.description ?? '',
        type: 'achievement',
        icon: 'emoji_events_outlined',
        order: widget.app?.order ?? 0,
        isActive: widget.app?.isActive ?? true,
        images: [],
        data: {'achievements': achievements},
        createdAt: widget.app?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(app);
    }
  }

  @override
  void dispose() {
    for (final controller in _achievementControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class AchievementItemController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  final List<String> skills = [];
  final List<String> tags = [];
  String category = 'award';
  String level = 'personal';
  DateTime? date;

  AchievementItemController();

  AchievementItemController.fromMap(Map<String, dynamic> map) {
    titleController.text = map['title'] ?? '';
    organizationController.text = map['organization'] ?? '';
    descriptionController.text = map['description'] ?? '';
    urlController.text = map['url'] ?? '';
    skills.addAll(List<String>.from(map['skills'] ?? []));
    tags.addAll(List<String>.from(map['tags'] ?? []));
    category = map['category'] ?? 'award';
    level = map['level'] ?? 'personal';
    if (map['date'] != null) {
      date = DateTime.parse(map['date']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': titleController.text,
      'organization':
          organizationController.text.isEmpty
              ? null
              : organizationController.text,
      'description':
          descriptionController.text.isEmpty
              ? null
              : descriptionController.text,
      'url': urlController.text.isEmpty ? null : urlController.text,
      'skills': skills,
      'tags': tags,
      'category': category,
      'level': level,
      'date': date?.toIso8601String(),
    };
  }

  void dispose() {
    titleController.dispose();
    organizationController.dispose();
    descriptionController.dispose();
    urlController.dispose();
  }
}
