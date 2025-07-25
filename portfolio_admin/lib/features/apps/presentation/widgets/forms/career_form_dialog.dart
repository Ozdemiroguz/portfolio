import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/domain/models/app_model.dart';

class CareerFormDialog extends ConsumerStatefulWidget {
  final AppModel? app;
  final String portfolioId;

  const CareerFormDialog({super.key, this.app, required this.portfolioId});

  @override
  ConsumerState<CareerFormDialog> createState() => _CareerFormDialogState();
}

class _CareerFormDialogState extends ConsumerState<CareerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late List<CareerItemController> _careerControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.app?.data != null &&
        widget.app!.data is Map<String, dynamic> &&
        (widget.app!.data as Map<String, dynamic>).containsKey('careers')) {
      final data = widget.app!.data as Map<String, dynamic>;
      final careers = data['careers'] as List<dynamic>? ?? [];
      _careerControllers =
          careers
              .map(
                (career) => CareerItemController.fromMap(
                  career as Map<String, dynamic>,
                ),
              )
              .toList();
    } else {
      _careerControllers = [CareerItemController()];
    }
  }

  void _addCareer() {
    setState(() {
      _careerControllers.add(CareerItemController());
    });
  }

  void _removeCareer(int index) {
    if (_careerControllers.length > 1) {
      setState(() {
        _careerControllers.removeAt(index);
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
                      ..._careerControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final controller = entry.value;
                        return _buildCareerItem(controller, index);
                      }),
                      _buildAddCareerButton(),
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
            Icons.work_history_outlined,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            widget.app == null ? 'Kariyer Oluştur' : 'Kariyer Düzenle',
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

  Widget _buildCareerItem(CareerItemController controller, int index) {
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
                'İş Deneyimi ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (_careerControllers.length > 1)
                IconButton(
                  onPressed: () => _removeCareer(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Company & Position
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.companyController,
                  decoration: const InputDecoration(
                    labelText: 'Şirket Adı',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
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
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  validator:
                      (value) =>
                          value?.isEmpty == true ? 'Bu alan zorunlu' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Department & Location
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Departman',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.groups),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.locationController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasyon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Employment Type & Status
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.employmentType,
                  decoration: const InputDecoration(
                    labelText: 'Çalışma Türü',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      [
                            'full-time',
                            'part-time',
                            'contract',
                            'internship',
                            'freelance',
                          ]
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(_getEmploymentTypeText(type)),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) =>
                          setState(() => controller.employmentType = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Halen Çalışıyor'),
                  value: controller.isCurrent,
                  onChanged: (value) {
                    setState(() {
                      controller.isCurrent = value ?? false;
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
                  onTap:
                      controller.isCurrent
                          ? null
                          : () => _selectDate(context, false, controller),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Bitiş Tarihi',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                      enabled: !controller.isCurrent,
                    ),
                    child: Text(
                      controller.isCurrent
                          ? 'Devam Ediyor'
                          : controller.endDate != null
                          ? DateFormat('dd/MM/yyyy').format(controller.endDate!)
                          : 'Tarih Seç',
                    ),
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
              labelText: 'İş Tanımı',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          // Skills & Achievements
          _buildChipInput(
            'Kullanılan Teknolojiler/Beceriler',
            controller.skills,
            Icons.build_outlined,
            'Flutter, React, Python ekleyin...',
          ),
          const SizedBox(height: 16),

          _buildChipInput(
            'Başarılar',
            controller.achievements,
            Icons.star_outline,
            'Proje liderliği, %20 performans artışı ekleyin...',
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

  Widget _buildAddCareerButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: OutlinedButton.icon(
        onPressed: _addCareer,
        icon: const Icon(Icons.add),
        label: const Text('İş Deneyimi Ekle'),
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
            onPressed: _saveCareer,
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
    CareerItemController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
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

  String _getEmploymentTypeText(String type) {
    switch (type) {
      case 'full-time':
        return 'Tam Zamanlı';
      case 'part-time':
        return 'Yarı Zamanlı';
      case 'contract':
        return 'Sözleşmeli';
      case 'internship':
        return 'Staj';
      case 'freelance':
        return 'Serbest';
      default:
        return type;
    }
  }

  void _saveCareer() {
    if (_formKey.currentState!.validate()) {
      final careers =
          _careerControllers.map((controller) => controller.toMap()).toList();

      final app = AppModel(
        id: widget.app?.id ?? '',
        title: widget.app?.title ?? 'Kariyer',
        description: widget.app?.description ?? '',
        type: 'career',
        icon: 'work_history_outlined',
        order: widget.app?.order ?? 0,
        isActive: widget.app?.isActive ?? true,
        images: [],
        data: {'careers': careers},
        createdAt: widget.app?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(app);
    }
  }

  @override
  void dispose() {
    for (final controller in _careerControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class CareerItemController {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> skills = [];
  final List<String> achievements = [];
  String employmentType = 'full-time';
  bool isCurrent = false;
  DateTime? startDate;
  DateTime? endDate;

  CareerItemController();

  CareerItemController.fromMap(Map<String, dynamic> map) {
    companyController.text = map['company'] ?? '';
    positionController.text = map['position'] ?? '';
    departmentController.text = map['department'] ?? '';
    locationController.text = map['location'] ?? '';
    descriptionController.text = map['description'] ?? '';
    skills.addAll(List<String>.from(map['skills'] ?? []));
    achievements.addAll(List<String>.from(map['achievements'] ?? []));
    employmentType = map['employmentType'] ?? 'full-time';
    isCurrent = map['isCurrent'] ?? false;
    if (map['startDate'] != null) {
      startDate = DateTime.parse(map['startDate']);
    }
    if (map['endDate'] != null) {
      endDate = DateTime.parse(map['endDate']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'company': companyController.text,
      'position': positionController.text,
      'department':
          departmentController.text.isEmpty ? null : departmentController.text,
      'location':
          locationController.text.isEmpty ? null : locationController.text,
      'description':
          descriptionController.text.isEmpty
              ? null
              : descriptionController.text,
      'skills': skills,
      'achievements': achievements,
      'employmentType': employmentType,
      'isCurrent': isCurrent,
      'startDate': startDate?.toIso8601String(),
      'endDate': isCurrent ? null : endDate?.toIso8601String(),
    };
  }

  void dispose() {
    companyController.dispose();
    positionController.dispose();
    departmentController.dispose();
    locationController.dispose();
    descriptionController.dispose();
  }
}
