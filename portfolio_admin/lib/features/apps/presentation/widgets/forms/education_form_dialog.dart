import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/domain/models/app_model.dart';

class EducationFormDialog extends ConsumerStatefulWidget {
  final AppModel? app;
  final String portfolioId;

  const EducationFormDialog({super.key, this.app, required this.portfolioId});

  @override
  ConsumerState<EducationFormDialog> createState() =>
      _EducationFormDialogState();
}

class _EducationFormDialogState extends ConsumerState<EducationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late List<EducationItemController> _educationControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.app?.data != null &&
        widget.app!.data is Map<String, dynamic> &&
        (widget.app!.data as Map<String, dynamic>).containsKey('educations')) {
      final data = widget.app!.data as Map<String, dynamic>;
      final items = data['educations'] as List<dynamic>? ?? [];
      _educationControllers =
          items
              .map(
                (item) => EducationItemController.fromMap(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
    } else {
      _educationControllers = [EducationItemController()];
    }
  }

  void _addEducation() {
    setState(() {
      _educationControllers.add(EducationItemController());
    });
  }

  void _removeEducation(int index) {
    if (_educationControllers.length > 1) {
      setState(() {
        _educationControllers.removeAt(index);
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
                      ..._educationControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final controller = entry.value;
                        return _buildEducationItem(controller, index);
                      }),
                      _buildAddEducationButton(),
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
            Icons.school_outlined,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            widget.app == null ? 'Eğitim Oluştur' : 'Eğitim Düzenle',
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

  Widget _buildEducationItem(EducationItemController controller, int index) {
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
                'Eğitim ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (_educationControllers.length > 1)
                IconButton(
                  onPressed: () => _removeEducation(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Institution
          TextFormField(
            controller: controller.institutionController,
            decoration: const InputDecoration(
              labelText: 'Kurum',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.school),
            ),
            validator:
                (value) => value?.isEmpty == true ? 'Bu alan zorunlu' : null,
          ),
          const SizedBox(height: 16),

          // Degree & Field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.degreeController,
                  decoration: const InputDecoration(
                    labelText: 'Derece',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty == true ? 'Bu alan zorunlu' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.fieldOfStudyController,
                  decoration: const InputDecoration(
                    labelText: 'Alan',
                    border: OutlineInputBorder(),
                  ),
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
                  onTap: () => _selectDate(context, true, controller),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Başlangıç Tarihi',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      controller.startDate != null
                          ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(controller.startDate!)
                          : 'Tarih Seç',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false, controller),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Bitiş Tarihi',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      controller.endDate != null
                          ? DateFormat('dd/MM/yyyy').format(controller.endDate!)
                          : 'Tarih Seç',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status & GPA
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.status,
                  decoration: const InputDecoration(
                    labelText: 'Durum',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['completed', 'ongoing', 'paused']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(_getStatusText(status)),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => controller.status = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: controller.gpaController,
                        decoration: const InputDecoration(
                          labelText: 'GPA',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: controller.gpaScaleController,
                        decoration: const InputDecoration(
                          labelText: 'Ölçek',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location & Website
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.locationController,
                  decoration: const InputDecoration(
                    labelText: 'Konum',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAddEducationButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: OutlinedButton.icon(
        onPressed: _addEducation,
        icon: const Icon(Icons.add),
        label: const Text('Eğitim Ekle'),
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
            onPressed: _saveEducation,
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
    bool isStartDate,
    EducationItemController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          controller.startDate = date;
        } else {
          controller.endDate = date;
        }
      });
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Tamamlandı';
      case 'ongoing':
        return 'Devam Ediyor';
      case 'paused':
        return 'Durduruldu';
      default:
        return status;
    }
  }

  void _saveEducation() {
    if (_formKey.currentState!.validate()) {
      final educationItems =
          _educationControllers
              .map((controller) => controller.toMap())
              .toList();

      final app = AppModel(
        id: widget.app?.id ?? '',
        title: _educationControllers.first.institutionController.text,
        description: 'Eğitim Bilgileri',
        type: 'education',
        icon: 'school_outlined',
        order: widget.app?.order ?? 0,
        isActive: widget.app?.isActive ?? true,
        images: [],
        data: {'educations': educationItems},
        createdAt: widget.app?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(app);
    }
  }

  @override
  void dispose() {
    for (final controller in _educationControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class EducationItemController {
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController fieldOfStudyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  final TextEditingController gpaScaleController = TextEditingController();

  String status = 'completed';
  DateTime? startDate;
  DateTime? endDate;

  EducationItemController();

  EducationItemController.fromMap(Map<String, dynamic> map) {
    institutionController.text = map['institution'] ?? '';
    degreeController.text = map['degree'] ?? '';
    fieldOfStudyController.text = map['fieldOfStudy'] ?? '';
    locationController.text = map['location'] ?? '';
    websiteController.text = map['website'] ?? '';
    gpaController.text = map['gpa']?.toString() ?? '';
    gpaScaleController.text = map['gpaScale']?.toString() ?? '';

    status = map['status'] ?? 'completed';
    if (map['startDate'] != null) {
      startDate = DateTime.parse(map['startDate']);
    }
    if (map['endDate'] != null) {
      endDate = DateTime.parse(map['endDate']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'institution': institutionController.text,
      'degree': degreeController.text,
      'fieldOfStudy': fieldOfStudyController.text,
      'location': locationController.text,
      'website': websiteController.text,
      'gpa': double.tryParse(gpaController.text),
      'gpaScale': double.tryParse(gpaScaleController.text),

      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  void dispose() {
    institutionController.dispose();
    degreeController.dispose();
    fieldOfStudyController.dispose();
    locationController.dispose();
    websiteController.dispose();
    gpaController.dispose();
    gpaScaleController.dispose();
  }
}
