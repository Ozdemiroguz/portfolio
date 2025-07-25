import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/extensions/localization_extension.dart';
import '../../../../../core/di/injection.dart';
import '../../../shared/domain/models/app_model.dart';
import '../../domain/repositories/app_repository.dart';
import '../../../shared/data/services/storage_service.dart';
import '../../../shared/presentation/widgets/web_image_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/app_provider.dart';
import 'forms/project_form_dialog.dart';
import 'forms/education_form_dialog.dart';
import 'forms/career_form_dialog.dart';
import 'forms/reference_form_dialog.dart';
import 'forms/contact_form_dialog.dart';
import 'forms/achievement_form_dialog.dart';
import 'forms/about_form_dialog.dart';

class CreateAppDialog extends ConsumerStatefulWidget {
  final String portfolioId;
  final String location; // 'home', 'bottom', or folderId for folder apps
  final AppModel? existingApp;

  const CreateAppDialog({
    super.key,
    required this.portfolioId,
    required this.location,
    this.existingApp,
  });

  @override
  ConsumerState<CreateAppDialog> createState() => _CreateAppDialogState();
}

class _CreateAppDialogState extends ConsumerState<CreateAppDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _iconController = TextEditingController();

  String _selectedType = 'project';
  bool _isActive = true;
  int _order = 0;
  List<String> _images = [];
  final StorageService _storageService = getIt<StorageService>();
  bool _isUploadingImages = false;

  bool get _isEditing => widget.existingApp != null;
  bool _isLoading = false;

  final List<String> _appTypes = [
    'project',
    'education',
    'career',
    'contact',
    'achievement',
    'about',
    'reference',
    'camera',
    'phone',
    'messages',
    'game1',
    'game2',
    'game3',
    'custom1',
    'custom2',
    'custom3',
  ];

  final Map<String, String> _typeNames = {
    'project': 'Proje',
    'education': 'Eğitim',
    'career': 'Kariyer',
    'contact': 'İletişim',
    'achievement': 'Başarı',
    'about': 'Hakkımda',
    'reference': 'Referans',
    'camera': 'Kamera',
    'phone': 'Telefon',
    'messages': 'Mesajlar',
    'game1': 'Oyun 1',
    'game2': 'Oyun 2',
    'game3': 'Oyun 3',
    'custom1': 'Özel 1',
    'custom2': 'Özel 2',
    'custom3': 'Özel 3',
  };

  final Map<String, IconData> _typeIcons = {
    'project': Icons.work,
    'education': Icons.school,
    'career': Icons.business_center,
    'contact': Icons.contact_mail,
    'achievement': Icons.emoji_events,
    'about': Icons.person,
    'reference': Icons.recommend,
    'camera': Icons.camera_alt,
    'phone': Icons.phone,
    'messages': Icons.message,
    'game1': Icons.sports_esports,
    'game2': Icons.gamepad,
    'game3': Icons.casino,
    'custom1': Icons.extension,
    'custom2': Icons.apps,
    'custom3': Icons.widgets,
  };

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeFromExisting();
    }
  }

  void _initializeFromExisting() {
    final app = widget.existingApp!;
    _titleController.text = app.title;
    _descriptionController.text = app.description;
    _iconController.text = app.icon;
    _selectedType = app.type;
    _isActive = app.isActive;
    _order = app.order;
    _images = List.from(app.images);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(),
                      const SizedBox(height: 24),
                      _buildTypeSelection(),
                      const SizedBox(height: 24),
                      _buildSettingsSection(),
                      const SizedBox(height: 24),
                      _buildImagesSection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isEditing ? Icons.edit : Icons.add,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditing
                  ? 'edit_app_title'.tr(ref)
                  : 'create_app_title'.tr(ref),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temel Bilgiler',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'app_title'.tr(ref),
            hintText: 'Uygulama adını girin',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Uygulama adı gerekli';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'app_description'.tr(ref),
            hintText: 'Uygulama açıklamasını girin',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.description),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _iconController,
          decoration: InputDecoration(
            labelText: 'app_icon'.tr(ref),
            hintText: 'İkon adı veya URL (opsiyonel)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.image),
            suffixIcon: IconButton(
              onPressed: _showIconPicker,
              icon: const Icon(Icons.palette),
              tooltip: 'İkon Seç',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'app_type'.tr(ref),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _appTypes.map((type) {
                final isSelected = type == _selectedType;
                final isDisabled = _isTypeDisabled(type);

                return FilterChip(
                  selected: isSelected,
                  onSelected:
                      _isEditing || isDisabled
                          ? null
                          : (selected) {
                            setState(() {
                              _selectedType = type;
                            });
                          },
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _typeIcons[type],
                        size: 16,
                        color:
                            isSelected
                                ? Colors.white
                                : isDisabled
                                ? Colors.grey
                                : null,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _typeNames[type] ?? type,
                        style: TextStyle(
                          color: isDisabled ? Colors.grey : null,
                        ),
                      ),
                      if (isDisabled) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.check_circle, size: 14, color: Colors.green),
                      ],
                    ],
                  ),
                  backgroundColor:
                      isSelected
                          ? Theme.of(context).primaryColor
                          : isDisabled
                          ? Colors.grey[200]
                          : null,
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? Colors.white
                            : isDisabled
                            ? Colors.grey
                            : null,
                  ),
                );
              }).toList(),
        ),
        if (_hasDisabledTypes())
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Yeşil işaretli türler zaten mevcut (sadece proje türü birden fazla eklenebilir)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ayarlar',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Text('app_is_active'.tr(ref)),
          subtitle: Text(
            _isActive ? 'Uygulama aktif ve görünür' : 'Uygulama pasif',
          ),
          value: _isActive,
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _order.toString(),
          decoration: InputDecoration(
            labelText: 'app_order'.tr(ref),
            hintText: 'Sıralama numarası (0-999)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.reorder),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _order = int.tryParse(value) ?? 0;
          },
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'app_images'.tr(ref),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (_images.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _images.clear();
                  });
                },
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Temizle', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _isUploadingImages ? null : _addImage,
              icon:
                  _isUploadingImages
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.add),
              label: Text(_isUploadingImages ? 'Yükleniyor...' : 'Resim Ekle'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_images.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(Icons.image, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Henüz resim eklenmedi',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  'JPG, PNG, GIF veya WEBP formatında resim ekleyebilirsiniz',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Column(
            children: [
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
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  imageUrl.startsWith('http')
                                      ? WebImageWidget(
                                        imageUrl: imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorWidget: Container(
                                          color: Colors.grey[200],
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Hata',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        loadingWidget: Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                      : Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image),
                                      ),
                            ),
                          ),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: IconButton(
                              onPressed: () => _removeImage(index),
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              iconSize: 20,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
              if (_images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${_images.length} resim yüklendi',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text('cancel'.tr(ref)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isLoading ? null : _openTypeSpecificForm,
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(_getNextButtonText()),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    if (_isEditing) {
      return 'Düzenle';
    }

    switch (_selectedType) {
      case 'project':
      case 'education':
      case 'career':
      case 'reference':
      case 'contact':
      case 'achievement':
      case 'about':
        return 'Devam Et';
      case 'camera':
      case 'phone':
      case 'messages':
      case 'game1':
      case 'game2':
      case 'game3':
      case 'custom1':
      case 'custom2':
      case 'custom3':
        return 'Oluştur';
      default:
        return 'Oluştur';
    }
  }

  AppModel _createBasicApp() {
    return AppModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      icon:
          _iconController.text.trim().isEmpty
              ? _selectedType
              : _iconController.text.trim(),
      images: _images,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: _isActive,
      order: _order,
      data: {},
    );
  }

  void _openTypeSpecificForm() {
    if (!_formKey.currentState!.validate()) return;

    // For types that need detailed forms, open specific dialog
    switch (_selectedType) {
      case 'project':
        _openProjectForm();
        break;
      case 'education':
        _openEducationForm();
        break;
      case 'career':
        _openCareerForm();
        break;
      case 'reference':
        _openReferenceForm();
        break;
      case 'contact':
        _openContactForm();
        break;
      case 'achievement':
        _openAchievementForm();
        break;
      case 'about':
        _openAboutForm();
        break;
      default:
        // For other types, use simple creation
        _saveApp();
        break;
    }
  }

  void _openProjectForm() {
    // Create a basic app model with the current form data
    final basicApp = _isEditing ? widget.existingApp : _createBasicApp();

    showDialog(
      context: context,
      builder:
          (context) =>
              ProjectFormDialog(portfolioId: widget.portfolioId, app: basicApp),
    ).then((result) {
      if (mounted && result != null && result is AppModel) {
        Navigator.of(context).pop(); // Close main dialog after form is saved
        _saveAppWithData(result);
      }
    });
  }

  void _openEducationForm() {
    final basicApp = _isEditing ? widget.existingApp : _createBasicApp();

    showDialog(
      context: context,
      builder:
          (context) => EducationFormDialog(
            portfolioId: widget.portfolioId,
            app: basicApp,
          ),
    ).then((result) {
      if (mounted && result != null && result is AppModel) {
        Navigator.of(context).pop(); // Close main dialog after form is saved
        _saveAppWithData(result);
      }
    });
  }

  void _openReferenceForm() {
    final basicApp = _isEditing ? widget.existingApp : _createBasicApp();

    showDialog(
      context: context,
      builder:
          (context) => ReferenceFormDialog(
            portfolioId: widget.portfolioId,
            app: basicApp,
          ),
    ).then((result) {
      if (mounted && result != null && result is AppModel) {
        Navigator.of(context).pop(); // Close main dialog after form is saved
        _saveAppWithData(result);
      }
    });
  }

  void _openContactForm() {
    final basicApp = _isEditing ? widget.existingApp : _createBasicApp();

    showDialog(
      context: context,
      builder:
          (context) =>
              ContactFormDialog(portfolioId: widget.portfolioId, app: basicApp),
    ).then((result) {
      if (mounted && result != null && result is AppModel) {
        Navigator.of(context).pop(); // Close main dialog after form is saved
        _saveAppWithData(result);
      }
    });
  }

  void _openCareerForm() {
    final basicApp = _isEditing ? widget.existingApp : _createBasicApp();

    showDialog(
      context: context,
      builder:
          (context) =>
              CareerFormDialog(portfolioId: widget.portfolioId, app: basicApp),
    ).then((result) {
      if (mounted && result != null && result is AppModel) {
        Navigator.of(context).pop(); // Close main dialog after form is saved
        _saveAppWithData(result);
      }
    });
  }

  void _openAchievementForm() {
    final basicApp = _isEditing ? widget.existingApp : _createBasicApp();

    showDialog(
      context: context,
      builder:
          (context) => AchievementFormDialog(
            portfolioId: widget.portfolioId,
            app: basicApp,
          ),
    ).then((result) {
      if (mounted && result != null && result is AppModel) {
        Navigator.of(context).pop(); // Close main dialog after form is saved
        _saveAppWithData(result);
      }
    });
  }

  void _openAboutForm() {
    final basicApp = _isEditing ? widget.existingApp : _createBasicApp();

    showDialog(
      context: context,
      builder:
          (context) =>
              AboutFormDialog(portfolioId: widget.portfolioId, app: basicApp),
    ).then((result) {
      if (mounted && result != null && result is AppModel) {
        Navigator.of(context).pop(); // Close main dialog after form is saved
        _saveAppWithData(result);
      }
    });
  }

  Future<void> _saveAppWithData(AppModel formResult) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Update app with form data and basic info
      final app = formResult.copyWith(
        id:
            _isEditing
                ? widget.existingApp!.id
                : DateTime.now().millisecondsSinceEpoch.toString(),
        order: _order,
        isActive: _isActive,
        images: _images,
        createdAt: _isEditing ? widget.existingApp!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = ref.read(appNotifierProvider.notifier);

      if (_isEditing) {
        if (widget.location == 'home') {
          await notifier.updateHomeApp(widget.portfolioId, app);
        } else if (widget.location == 'bottom') {
          await notifier.updateBottomApp(widget.portfolioId, app);
        } else {
          await notifier.updateFolderApp(
            widget.portfolioId,
            widget.location,
            app,
          );
        }
      } else {
        if (widget.location == 'home') {
          await notifier.createHomeApp(widget.portfolioId, app);
        } else if (widget.location == 'bottom') {
          await notifier.createBottomApp(widget.portfolioId, app);
        } else {
          await notifier.createFolderApp(
            widget.portfolioId,
            widget.location,
            app,
          );
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'App güncellendi!' : 'App oluşturuldu!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $error'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showIconPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('İkon Seç'),
            content: SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: _typeIcons.length,
                itemBuilder: (context, index) {
                  final entry = _typeIcons.entries.elementAt(index);
                  return InkWell(
                    onTap: () {
                      _iconController.text = entry.key;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(entry.value, size: 32),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('İptal'),
              ),
            ],
          ),
    );
  }

  Future<void> _addImage() async {
    await _pickImages();
  }

  Future<void> _pickImages() async {
    if (_isUploadingImages) return;

    try {
      setState(() {
        _isUploadingImages = true;
      });

      // Maksimum 10 resim seçilebilir
      final remainingSlots = 10 - _images.length;
      if (remainingSlots <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maksimum 10 resim ekleyebilirsiniz')),
        );
        return;
      }

      final files = await _storageService.pickImages(maxFiles: remainingSlots);
      if (files.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Resim seçilmedi')));
        return;
      }

      // Auth provider'dan user bilgisini al
      final authState = ref.read(authStateProvider);
      final user = authState.value;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı oturumu bulunamadı')),
        );
        return;
      }

      // Temporary app ID oluştur (gerçek ID save sırasında oluşturulacak)
      final tempAppId = DateTime.now().millisecondsSinceEpoch.toString();

      // Kategori belirle (app type'a göre)
      final category = _getCategoryFromType(_selectedType);

      // Resimleri yükle
      final uploadedUrls = await _storageService.uploadMultipleImages(
        userId: user.uid,
        portfolioId: widget.portfolioId,
        appId: tempAppId,
        category: category,
        files: files,
      );

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Resim yükleme hatası: $e')));
    } finally {
      setState(() {
        _isUploadingImages = false;
      });
    }
  }

  String _getCategoryFromType(String type) {
    switch (type) {
      case 'project':
        return 'projects';
      case 'education':
        return 'education';
      case 'career':
        return 'career';
      case 'contact':
        return 'contact';
      case 'achievement':
        return 'achievements';
      case 'about':
        return 'about';
      case 'reference':
        return 'references';
      default:
        return 'apps';
    }
  }

  void _removeImage(int index) {
    if (!mounted) return;
    setState(() {
      _images.removeAt(index);
    });
  }

  bool _isTypeDisabled(String type) {
    // Proje türü her zaman eklenebilir (birden fazla proje olabilir)
    if (type == 'project') {
      return false;
    }

    // Edit modunda mevcut app'in türü seçilebilir
    if (_isEditing && widget.existingApp?.type == type) {
      return false;
    }

    // Diğer türler için mevcut app'leri kontrol et
    return _getExistingApps().any((app) => app.type == type);
  }

  bool _hasDisabledTypes() {
    return _appTypes.any((type) => _isTypeDisabled(type));
  }

  List<AppModel> _getExistingApps() {
    final List<AppModel> allApps = [];

    // Home apps
    final homeAppsAsync = ref.watch(homeAppsProvider(widget.portfolioId));
    homeAppsAsync.whenData((apps) => allApps.addAll(apps));

    // Bottom apps
    final bottomAppsAsync = ref.watch(bottomAppsProvider(widget.portfolioId));
    bottomAppsAsync.whenData((apps) => allApps.addAll(apps));

    // Folder apps - önce folder'ları al, sonra her folder'ın app'lerini
    final foldersAsync = ref.watch(foldersProvider(widget.portfolioId));
    foldersAsync.whenData((folders) {
      for (final folder in folders) {
        final folderAppsAsync = ref.watch(
          folderAppsProvider((widget.portfolioId, folder.id)),
        );
        folderAppsAsync.whenData((apps) => allApps.addAll(apps));
      }
    });

    return allApps;
  }

  Future<void> _saveApp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final appData = <String, dynamic>{};
      // Type-specific data will be implemented for each app type

      final app = AppModel(
        id:
            _isEditing
                ? widget.existingApp!.id
                : DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: _iconController.text.trim(),
        images: _images,
        createdAt: _isEditing ? widget.existingApp!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: _isActive,
        order: _order,
        data: appData,
      );

      final notifier = ref.read(appNotifierProvider.notifier);

      if (_isEditing) {
        if (widget.location == 'home') {
          await notifier.updateHomeApp(widget.portfolioId, app);
        } else if (widget.location == 'bottom') {
          await notifier.updateBottomApp(widget.portfolioId, app);
        } else {
          // Folder app
          await notifier.updateFolderApp(
            widget.portfolioId,
            widget.location,
            app,
          );
        }
      } else {
        if (widget.location == 'home') {
          await notifier.createHomeApp(widget.portfolioId, app);
        } else if (widget.location == 'bottom') {
          await notifier.createBottomApp(widget.portfolioId, app);
        } else {
          // Folder app
          await notifier.createFolderApp(
            widget.portfolioId,
            widget.location,
            app,
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'app_updated'.tr(ref) : 'app_created'.tr(ref),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $error'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
