import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/domain/models/app_model.dart';

class ReferenceFormDialog extends ConsumerStatefulWidget {
  final AppModel? app;
  final String portfolioId;

  const ReferenceFormDialog({super.key, this.app, required this.portfolioId});

  @override
  ConsumerState<ReferenceFormDialog> createState() =>
      _ReferenceFormDialogState();
}

class _ReferenceFormDialogState extends ConsumerState<ReferenceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late List<ReferenceItemController> _referenceControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.app?.data != null &&
        widget.app!.data is Map<String, dynamic> &&
        (widget.app!.data as Map<String, dynamic>).containsKey('references')) {
      final data = widget.app!.data as Map<String, dynamic>;
      final references = data['references'] as List<dynamic>? ?? [];
      _referenceControllers =
          references
              .map(
                (ref) => ReferenceItemController.fromMap(
                  ref as Map<String, dynamic>,
                ),
              )
              .toList();
    } else {
      _referenceControllers = [ReferenceItemController()];
    }
  }

  void _addReference() {
    setState(() {
      _referenceControllers.add(ReferenceItemController());
    });
  }

  void _removeReference(int index) {
    if (_referenceControllers.length > 1) {
      setState(() {
        _referenceControllers.removeAt(index);
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
                      ..._referenceControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final controller = entry.value;
                        return _buildReferenceItem(controller, index);
                      }),
                      _buildAddReferenceButton(),
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
            Icons.people_outline,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            widget.app == null ? 'Referans Oluştur' : 'Referans Düzenle',
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

  Widget _buildReferenceItem(ReferenceItemController controller, int index) {
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
                'Referans ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (_referenceControllers.length > 1)
                IconButton(
                  onPressed: () => _removeReference(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Name & Position
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty == true ? 'Bu alan zorunlu' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.positionController,
                  decoration: const InputDecoration(
                    labelText: 'Pozisyon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty == true ? 'Bu alan zorunlu' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Company & Relationship
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.companyController,
                  decoration: const InputDecoration(
                    labelText: 'Şirket',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.relationshipType,
                  decoration: const InputDecoration(
                    labelText: 'İlişki Türü',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['colleague', 'manager', 'client', 'mentor']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(_getRelationshipText(type)),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) =>
                          setState(() => controller.relationshipType = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Info
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // LinkedIn & Work Together Date
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.linkedInController,
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, controller),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Birlikte Çalışma Tarihi',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      controller.workTogetherDate != null
                          ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(controller.workTogetherDate!)
                          : 'Tarih Seç',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Permission
          CheckboxListTile(
            title: const Text('İletişim İzni'),
            subtitle: const Text('Bu kişi ile iletişim kurulabilir'),
            value: controller.canContact,
            onChanged: (value) {
              setState(() {
                controller.canContact = value ?? false;
              });
            },
          ),
          const SizedBox(height: 16),

          // Recommendation
          TextFormField(
            controller: controller.recommendationController,
            decoration: const InputDecoration(
              labelText: 'Tavsiye Metni',
              border: OutlineInputBorder(),
              hintText: 'Referansın sizin hakkınızda söyledikleri...',
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildAddReferenceButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: OutlinedButton.icon(
        onPressed: _addReference,
        icon: const Icon(Icons.add),
        label: const Text('Referans Ekle'),
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
            onPressed: _saveReference,
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
    ReferenceItemController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        controller.workTogetherDate = date;
      });
    }
  }

  String _getRelationshipText(String type) {
    switch (type) {
      case 'colleague':
        return 'İş Arkadaşı';
      case 'manager':
        return 'Yönetici';
      case 'client':
        return 'Müşteri';
      case 'mentor':
        return 'Mentor';
      default:
        return type;
    }
  }

  void _saveReference() {
    if (_formKey.currentState!.validate()) {
      final references =
          _referenceControllers
              .map((controller) => controller.toMap())
              .toList();

      final app = AppModel(
        id: widget.app?.id ?? '',
        title: 'Referanslar',
        description: 'Referans Bilgileri',
        type: 'reference',
        icon: 'people_outline',
        order: widget.app?.order ?? 0,
        isActive: widget.app?.isActive ?? true,
        images: [],
        data: {'references': references},
        createdAt: widget.app?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(app);
    }
  }

  @override
  void dispose() {
    for (final controller in _referenceControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class ReferenceItemController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();
  final TextEditingController recommendationController =
      TextEditingController();

  String relationshipType = 'colleague';
  bool canContact = true;
  DateTime? workTogetherDate;

  ReferenceItemController();

  ReferenceItemController.fromMap(Map<String, dynamic> map) {
    nameController.text = map['name'] ?? '';
    positionController.text = map['position'] ?? '';
    companyController.text = map['company'] ?? '';
    emailController.text = map['email'] ?? '';
    phoneController.text = map['phone'] ?? '';
    linkedInController.text = map['linkedIn'] ?? '';
    recommendationController.text = map['recommendation'] ?? '';
    relationshipType = map['relationshipType'] ?? 'colleague';
    canContact = map['canContact'] ?? true;
    if (map['workTogetherDate'] != null) {
      workTogetherDate = DateTime.parse(map['workTogetherDate']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': nameController.text,
      'position': positionController.text,
      'company': companyController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'linkedIn': linkedInController.text,
      'recommendation': recommendationController.text,
      'relationshipType': relationshipType,
      'canContact': canContact,
      'workTogetherDate': workTogetherDate?.toIso8601String(),
    };
  }

  void dispose() {
    nameController.dispose();
    positionController.dispose();
    companyController.dispose();
    emailController.dispose();
    phoneController.dispose();
    linkedInController.dispose();
    recommendationController.dispose();
  }
}
