import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

import '../../../../shared/domain/models/app_model.dart';
import '../../../../shared/data/services/storage_service.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';

class ProjectFormDialog extends ConsumerStatefulWidget {
  final AppModel? app;
  final String portfolioId;

  const ProjectFormDialog({super.key, this.app, required this.portfolioId});

  @override
  ConsumerState<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends ConsumerState<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Basic Info Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Technology & Features
  final List<String> _technologies = [];
  final List<String> _features = [];

  // Links
  final List<ProjectLinkController> _links = [];

  // Images (up to 10)
  final List<String> _images = [];

  // Project Details
  String _status = 'completed';
  DateTime? _startDate;
  DateTime? _endDate;
  final _teamSizeController = TextEditingController();
  final _roleController = TextEditingController();
  bool _ownProject = true;
  final _clientNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.app?.data != null && widget.app!.data is Map<String, dynamic>) {
      final data = widget.app!.data as Map<String, dynamic>;

      _titleController.text = data['title'] ?? widget.app?.title ?? '';
      _descriptionController.text =
          data['description'] ?? widget.app?.description ?? '';
      _technologies.addAll(List<String>.from(data['technologies'] ?? []));
      _features.addAll(List<String>.from(data['features'] ?? []));
      _images.addAll(List<String>.from(data['images'] ?? []));
      _status = data['status'] ?? 'completed';
      _teamSizeController.text = data['teamSize']?.toString() ?? '';
      _roleController.text = data['role'] ?? '';
      _ownProject = data['ownProject'] ?? true;
      _clientNameController.text = data['clientName'] ?? '';

      if (data['startDate'] != null) {
        _startDate = DateTime.parse(data['startDate']);
      }
      if (data['endDate'] != null) {
        _endDate = DateTime.parse(data['endDate']);
      }

      // Load links
      final linksData = data['links'] as List<dynamic>? ?? [];
      _links.addAll(
        linksData.map(
          (link) => ProjectLinkController.fromMap(link as Map<String, dynamic>),
        ),
      );
    } else {
      // Initialize with basic app data if available
      if (widget.app != null) {
        _titleController.text = widget.app!.title;
        _descriptionController.text = widget.app!.description;
      }
    }

    // Ensure at least one link
    if (_links.isEmpty) {
      _links.add(ProjectLinkController());
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
                      _buildBasicInfo(),
                      const SizedBox(height: 24),
                      _buildTechnologiesAndFeatures(),
                      const SizedBox(height: 24),
                      _buildLinks(),
                      const SizedBox(height: 24),
                      _buildProjectDetails(),
                      const SizedBox(height: 24),
                      _buildImages(),
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
            Icons.work_outline,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            widget.app == null ? 'Proje Oluştur' : 'Proje Düzenle',
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

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temel Bilgiler',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Proje Başlığı',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.title),
          ),
          validator:
              (value) => value?.isEmpty == true ? 'Bu alan zorunlu' : null,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Proje Açıklaması',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 4,
          validator:
              (value) => value?.isEmpty == true ? 'Bu alan zorunlu' : null,
        ),
      ],
    );
  }

  Widget _buildTechnologiesAndFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Teknolojiler ve Özellikler',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        _buildChipInput(
          'Teknolojiler',
          _technologies,
          Icons.build_outlined,
          'Flutter, Firebase, Dart ekleyin...',
        ),
        const SizedBox(height: 16),

        _buildChipInput(
          'Özellikler',
          _features,
          Icons.star_outline,
          'Authentication, Real-time chat ekleyin...',
        ),
      ],
    );
  }

  Widget _buildLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Proje Linkleri',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: _addLink,
              icon: const Icon(Icons.add),
              label: const Text('Link Ekle'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ..._links.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return _buildLinkItem(controller, index);
        }),
      ],
    );
  }

  Widget _buildLinkItem(ProjectLinkController controller, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: controller.type,
              decoration: const InputDecoration(
                labelText: 'Link Türü',
                border: OutlineInputBorder(),
              ),
              items:
                  ['github', 'web', 'playstore', 'appstore', 'demo', 'other']
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_getLinkTypeText(type)),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => controller.type = value!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller.urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              validator:
                  (value) => value?.isEmpty == true ? 'Bu alan zorunlu' : null,
            ),
          ),
          const SizedBox(width: 8),
          if (_links.length > 1)
            IconButton(
              onPressed: () => _removeLink(index),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proje Detayları',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // Status & Own Project
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Durum',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['completed', 'in-progress', 'planned']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(_getStatusText(status)),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Kendi Projesi'),
                value: _ownProject,
                onChanged: (value) {
                  setState(() {
                    _ownProject = value ?? false;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Dates
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Başlangıç Tarihi',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yyyy').format(_startDate!)
                        : 'Tarih Seç',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Bitiş Tarihi',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yyyy').format(_endDate!)
                        : 'Tarih Seç',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Team & Role
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _teamSizeController,
                decoration: const InputDecoration(
                  labelText: 'Takım Büyüklüğü',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Rolünüz',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),

        if (!_ownProject) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _clientNameController,
            decoration: const InputDecoration(
              labelText: 'Müşteri/Şirket Adı',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Proje Resimleri (${_images.length}/10)',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            if (_images.length < 10)
              OutlinedButton.icon(
                onPressed: _addImage,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Resim Ekle'),
              ),
          ],
        ),
        const SizedBox(height: 16),

        if (_images.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final imageUrl = entry.value;
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              imageUrl.startsWith('http')
                                  ? Image.network(imageUrl, fit: BoxFit.cover)
                                  : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image, size: 40),
                                  ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          )
        else
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('Henüz resim eklenmedi'),
                Text('Proje resimlerini buraya ekleyebilirsiniz'),
              ],
            ),
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
            onPressed: _saveProject,
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

  void _addLink() {
    setState(() {
      _links.add(ProjectLinkController());
    });
  }

  void _removeLink(int index) {
    if (_links.length > 1) {
      setState(() {
        _links.removeAt(index);
      });
    }
  }

  Future<void> _addImage() async {
    try {
      // StorageService'i kullanarak resim seç
      final storageService = GetIt.instance<StorageService>();
      final files = await storageService.pickImages(
        maxFiles: 10 - _images.length,
      );

      if (files.isEmpty) {
        return;
      }

      // Loading göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Resimler yükleniyor...'),
                ],
              ),
            ),
      );

      // Auth provider'dan user bilgisini al
      final authState = ref.read(authStateProvider);
      final user = authState.valueOrNull;
      if (user == null) {
        Navigator.of(context).pop(); // Loading dialog'u kapat
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı oturumu bulunamadı')),
        );
        return;
      }

      // Temporary app ID oluştur
      final tempAppId = DateTime.now().millisecondsSinceEpoch.toString();

      // Resimleri yükle
      final uploadedUrls = await storageService.uploadMultipleImages(
        userId: user.uid,
        portfolioId: widget.portfolioId,
        appId: widget.app?.id ?? tempAppId,
        category: 'projects',
        files: files,
      );

      Navigator.of(context).pop(); // Loading dialog'u kapat

      setState(() {
        _images.addAll(uploadedUrls);
      });

      if (uploadedUrls.length < files.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bazı resimler yüklenemedi. ${uploadedUrls.length}/${files.length} resim yüklendi.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${uploadedUrls.length} resim başarıyla yüklendi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Loading dialog'u kapat (varsa)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Resim yükleme hatası: $e')));
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  String _getLinkTypeText(String type) {
    switch (type) {
      case 'github':
        return 'GitHub';
      case 'web':
        return 'Web Site';
      case 'playstore':
        return 'Play Store';
      case 'appstore':
        return 'App Store';
      case 'demo':
        return 'Demo';
      case 'other':
        return 'Diğer';
      default:
        return type;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Tamamlandı';
      case 'in-progress':
        return 'Devam Ediyor';
      case 'planned':
        return 'Planlandı';
      default:
        return status;
    }
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      final links =
          _links
              .where((controller) => controller.urlController.text.isNotEmpty)
              .map((controller) => controller.toMap())
              .toList();

      final projectData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'technologies': _technologies,
        'features': _features,
        'links': links,
        'images': _images,
        'status': _status,
        'startDate': _startDate?.toIso8601String(),
        'endDate': _endDate?.toIso8601String(),
        'teamSize': int.tryParse(_teamSizeController.text),
        'role': _roleController.text,
        'ownProject': _ownProject,
        'clientName':
            _clientNameController.text.isEmpty
                ? null
                : _clientNameController.text,
      };

      final app = AppModel(
        id: widget.app?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        type: 'project',
        icon: 'work_outline',
        order: widget.app?.order ?? 0,
        isActive: widget.app?.isActive ?? true,
        images: _images,
        data: projectData,
        createdAt: widget.app?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(app);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _teamSizeController.dispose();
    _roleController.dispose();
    _clientNameController.dispose();

    for (final controller in _links) {
      controller.dispose();
    }
    super.dispose();
  }
}

class ProjectLinkController {
  final TextEditingController urlController = TextEditingController();
  String type = 'github';

  ProjectLinkController();

  ProjectLinkController.fromMap(Map<String, dynamic> map) {
    urlController.text = map['url'] ?? '';
    type = map['type'] ?? 'github';
  }

  Map<String, dynamic> toMap() {
    return {'type': type, 'url': urlController.text};
  }

  void dispose() {
    urlController.dispose();
  }
}
