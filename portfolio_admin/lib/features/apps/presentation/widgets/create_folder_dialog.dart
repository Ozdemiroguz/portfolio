import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../shared/domain/models/app_model.dart';
import '../providers/app_provider.dart';

class CreateFolderDialog extends ConsumerStatefulWidget {
  final String portfolioId;
  final FolderModel? existingFolder;

  const CreateFolderDialog({
    super.key,
    required this.portfolioId,
    this.existingFolder,
  });

  @override
  ConsumerState<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends ConsumerState<CreateFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _iconController = TextEditingController();

  String _selectedColor = '#2196F3';
  bool _isActive = true;
  int _order = 0;

  bool get _isEditing => widget.existingFolder != null;
  bool _isLoading = false;

  final List<String> _predefinedColors = [
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#FF9800', // Orange
    '#9C27B0', // Purple
    '#F44336', // Red
    '#795548', // Brown
    '#607D8B', // Blue Grey
    '#E91E63', // Pink
    '#00BCD4', // Cyan
    '#FFC107', // Amber
    '#8BC34A', // Light Green
    '#FF5722', // Deep Orange
  ];

  final Map<String, IconData> _folderIcons = {
    'folder': Icons.folder,
    'work': Icons.work,
    'school': Icons.school,
    'business': Icons.business_center,
    'code': Icons.code,
    'design': Icons.design_services,
    'photo': Icons.photo,
    'music': Icons.music_note,
    'video': Icons.video_camera_back,
    'game': Icons.games,
    'book': Icons.book,
    'star': Icons.star,
  };

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeFromExisting();
    }
  }

  void _initializeFromExisting() {
    final folder = widget.existingFolder!;
    _titleController.text = folder.title;
    _descriptionController.text = folder.description;
    _iconController.text = folder.icon;
    _selectedColor = folder.color;
    _isActive = folder.isActive;
    _order = folder.order;
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
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
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
                      _buildAppearanceSection(),
                      const SizedBox(height: 24),
                      _buildSettingsSection(),
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
            _isEditing ? Icons.edit : Icons.create_new_folder,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditing ? 'Klasörü Düzenle' : 'Yeni Klasör Oluştur',
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
          decoration: const InputDecoration(
            labelText: 'Klasör Adı',
            hintText: 'Klasör adını girin',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Klasör adı gerekli';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Açıklama',
            hintText: 'Klasör açıklamasını girin (opsiyonel)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Görünüm',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Icon Selection
        TextFormField(
          controller: _iconController,
          decoration: InputDecoration(
            labelText: 'İkon',
            hintText: 'İkon adı (opsiyonel)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.image),
            suffixIcon: IconButton(
              onPressed: _showIconPicker,
              icon: const Icon(Icons.palette),
              tooltip: 'İkon Seç',
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Color Selection
        Text(
          'Renk',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              _predefinedColors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(int.parse(color.replaceAll('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child:
                        isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 16),

        // Preview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(
                  int.parse(_selectedColor.replaceAll('#', '0xFF')),
                ),
                child:
                    _iconController.text.isNotEmpty
                        ? Icon(
                          _folderIcons[_iconController.text] ?? Icons.folder,
                          color: Colors.white,
                          size: 20,
                        )
                        : const Icon(
                          Icons.folder,
                          color: Colors.white,
                          size: 20,
                        ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleController.text.isNotEmpty
                        ? _titleController.text
                        : 'Klasör Adı',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_descriptionController.text.isNotEmpty)
                    Text(
                      _descriptionController.text,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                ],
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
          title: const Text('Aktif'),
          subtitle: Text(
            _isActive ? 'Klasör aktif ve görünür' : 'Klasör pasif',
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
          decoration: const InputDecoration(
            labelText: 'Sıralama',
            hintText: 'Sıralama numarası (0-999)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.reorder),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _order = int.tryParse(value) ?? 0;
          },
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
            onPressed: _isLoading ? null : _saveFolder,
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(_isEditing ? 'Güncelle' : 'Oluştur'),
          ),
        ],
      ),
    );
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
                itemCount: _folderIcons.length,
                itemBuilder: (context, index) {
                  final entry = _folderIcons.entries.elementAt(index);
                  return InkWell(
                    onTap: () {
                      _iconController.text = entry.key;
                      Navigator.of(context).pop();
                      setState(() {}); // Refresh preview
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

  Future<void> _saveFolder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final folder = FolderModel(
        id:
            _isEditing
                ? widget.existingFolder!.id
                : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: _iconController.text.trim(),
        color: _selectedColor,
        appIds: _isEditing ? widget.existingFolder!.appIds : [],
        order: _order,
        isActive: _isActive,
        createdAt:
            _isEditing ? widget.existingFolder!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final notifier = ref.read(appNotifierProvider.notifier);

      if (_isEditing) {
        await notifier.updateFolder(widget.portfolioId, folder);
      } else {
        await notifier.createFolder(widget.portfolioId, folder);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'folder_updated'.tr(ref) : 'folder_created'.tr(ref),
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
