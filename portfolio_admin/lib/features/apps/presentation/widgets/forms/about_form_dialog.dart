import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/models/app_model.dart';

class AboutFormDialog extends ConsumerStatefulWidget {
  final AppModel? app;
  final String portfolioId;

  const AboutFormDialog({super.key, this.app, required this.portfolioId});

  @override
  ConsumerState<AboutFormDialog> createState() => _AboutFormDialogState();
}

class _AboutFormDialogState extends ConsumerState<AboutFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _aboutController = TextEditingController();
  final _missionController = TextEditingController();
  final _visionController = TextEditingController();
  final _valuesController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _personalityController = TextEditingController();

  final List<String> _interests = [];
  final List<String> _personalValues = [];
  final List<String> _funFacts = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.app?.data != null && widget.app!.data is Map<String, dynamic>) {
      final data = widget.app!.data as Map<String, dynamic>;

      _aboutController.text = data['about'] ?? widget.app?.description ?? '';
      _missionController.text = data['mission'] ?? '';
      _visionController.text = data['vision'] ?? '';
      _valuesController.text = data['values'] ?? '';
      _hobbiesController.text = data['hobbies'] ?? '';
      _personalityController.text = data['personality'] ?? '';

      _interests.addAll(List<String>.from(data['interests'] ?? []));
      _personalValues.addAll(List<String>.from(data['personalValues'] ?? []));
      _funFacts.addAll(List<String>.from(data['funFacts'] ?? []));
    } else {
      // Initialize with basic app data if available
      if (widget.app != null) {
        _aboutController.text = widget.app!.description;
      }
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
                      _buildMainAbout(),
                      const SizedBox(height: 24),
                      _buildMissionVision(),
                      const SizedBox(height: 24),
                      _buildPersonalInfo(),
                      const SizedBox(height: 24),
                      _buildInterestsAndValues(),
                      const SizedBox(height: 24),
                      _buildFunFacts(),
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
            Icons.person_outline,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            widget.app == null ? 'Hakkımda Oluştur' : 'Hakkımda Düzenle',
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

  Widget _buildMainAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ana Hakkımda Metni',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _aboutController,
          decoration: const InputDecoration(
            labelText: 'Hakkımda',
            hintText:
                'Kendinizi tanıtın, deneyimlerinizi, hedeflerinizi ve tutkularınızı paylaşın...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          maxLines: 8,
          validator:
              (value) => value?.isEmpty == true ? 'Bu alan zorunlu' : null,
        ),
      ],
    );
  }

  Widget _buildMissionVision() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Misyon ve Vizyon',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _missionController,
          decoration: const InputDecoration(
            labelText: 'Misyonum',
            hintText: 'Profesyonel misyonunuzu açıklayın...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.flag_outlined),
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _visionController,
          decoration: const InputDecoration(
            labelText: 'Vizyonum',
            hintText: 'Gelecek hedeflerinizi paylaşın...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.visibility_outlined),
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _valuesController,
          decoration: const InputDecoration(
            labelText: 'Değerlerim',
            hintText: 'Size önemli olan değerleri açıklayın...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.favorite_outline),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kişisel Bilgiler',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _hobbiesController,
                decoration: const InputDecoration(
                  labelText: 'Hobiler',
                  hintText: 'Müzik dinlemek, kitap okumak, spor yapmak...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sports_esports_outlined),
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _personalityController,
                decoration: const InputDecoration(
                  labelText: 'Kişilik',
                  hintText: 'Yaratıcı, analitik, takım oyuncusu...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.psychology_outlined),
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestsAndValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İlgi Alanları ve Değerler',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        _buildChipInput(
          'İlgi Alanları',
          _interests,
          Icons.interests,
          'Teknoloji, Sanat, Spor, Müzik ekleyin...',
        ),
        const SizedBox(height: 16),

        _buildChipInput(
          'Kişisel Değerler',
          _personalValues,
          Icons.favorite_outline,
          'Dürüstlük, Yaratıcılık, Takım Çalışması ekleyin...',
        ),
      ],
    );
  }

  Widget _buildFunFacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eğlenceli Gerçekler',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        _buildChipInput(
          'Eğlenceli Gerçekler',
          _funFacts,
          Icons.lightbulb_outline,
          '5 dil konuşurum, 10 ülke gezdim, kahve bağımlısıyım ekleyin...',
        ),
      ],
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
            onPressed: _saveAbout,
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

  void _saveAbout() {
    if (_formKey.currentState!.validate()) {
      final aboutData = {
        'about': _aboutController.text,
        'mission':
            _missionController.text.isEmpty ? null : _missionController.text,
        'vision':
            _visionController.text.isEmpty ? null : _visionController.text,
        'values':
            _valuesController.text.isEmpty ? null : _valuesController.text,
        'hobbies':
            _hobbiesController.text.isEmpty ? null : _hobbiesController.text,
        'personality':
            _personalityController.text.isEmpty
                ? null
                : _personalityController.text,
        'interests': _interests,
        'personalValues': _personalValues,
        'funFacts': _funFacts,
      };

      final app = AppModel(
        id: widget.app?.id ?? '',
        title: widget.app?.title ?? 'Hakkımda',
        description: _aboutController.text,
        type: 'about',
        icon: 'person_outline',
        order: widget.app?.order ?? 0,
        isActive: widget.app?.isActive ?? true,
        images: [],
        data: aboutData,
        createdAt: widget.app?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(app);
    }
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _missionController.dispose();
    _visionController.dispose();
    _valuesController.dispose();
    _hobbiesController.dispose();
    _personalityController.dispose();
    super.dispose();
  }
}
