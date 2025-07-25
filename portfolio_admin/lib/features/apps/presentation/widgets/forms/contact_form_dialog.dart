import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/models/app_model.dart';

class ContactFormDialog extends ConsumerStatefulWidget {
  final AppModel? app;
  final String portfolioId;

  const ContactFormDialog({super.key, this.app, required this.portfolioId});

  @override
  ConsumerState<ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends ConsumerState<ContactFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // General Contact Info Controllers
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _timezoneController = TextEditingController();

  // Contact Persons
  late List<ContactPersonController> _contactPersons;

  // Social Links
  late List<SocialLinkController> _socialLinks;

  // Settings
  bool _enableContactForm = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.app?.data != null && widget.app!.data is Map<String, dynamic>) {
      final data = widget.app!.data as Map<String, dynamic>;

      // General info
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['address'] ?? '';
      _workingHoursController.text = data['workingHours'] ?? '';
      _timezoneController.text = data['timezone'] ?? '';
      _enableContactForm = data['enableContactForm'] ?? true;

      // Contact persons
      final personsData = data['contactPersons'] as List<dynamic>? ?? [];
      _contactPersons =
          personsData
              .map(
                (person) => ContactPersonController.fromMap(
                  person as Map<String, dynamic>,
                ),
              )
              .toList();

      // Social links
      final linksData = data['socialLinks'] as List<dynamic>? ?? [];
      _socialLinks =
          linksData
              .map(
                (link) =>
                    SocialLinkController.fromMap(link as Map<String, dynamic>),
              )
              .toList();
    } else {
      _contactPersons = [ContactPersonController()];
      _socialLinks = [SocialLinkController()];
    }

    if (_contactPersons.isEmpty) {
      _contactPersons.add(ContactPersonController());
    }
    if (_socialLinks.isEmpty) {
      _socialLinks.add(SocialLinkController());
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
                      _buildGeneralInfo(),
                      const SizedBox(height: 32),
                      _buildContactPersonsSection(),
                      const SizedBox(height: 32),
                      _buildSocialLinksSection(),
                      const SizedBox(height: 32),
                      _buildSettings(),
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
            Icons.contact_page_outlined,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            widget.app == null ? 'İletişim Oluştur' : 'İletişim Düzenle',
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

  Widget _buildGeneralInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genel İletişim Bilgileri',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // Email & Phone
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Bu alan zorunlu' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
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

        // Address
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Adres',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // Working Hours & Timezone
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _workingHoursController,
                decoration: const InputDecoration(
                  labelText: 'Çalışma Saatleri',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                  hintText: 'Örn: 09:00 - 18:00',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _timezoneController,
                decoration: const InputDecoration(
                  labelText: 'Saat Dilimi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.schedule),
                  hintText: 'Örn: GMT+3',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactPersonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'İletişim Kişileri',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: _addContactPerson,
              icon: const Icon(Icons.add),
              label: const Text('Kişi Ekle'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ..._contactPersons.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return _buildContactPersonItem(controller, index);
        }),
      ],
    );
  }

  Widget _buildContactPersonItem(
    ContactPersonController controller,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Kişi ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (_contactPersons.length > 1)
                IconButton(
                  onPressed: () => _removeContactPerson(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Name & Position
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
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
                  controller: controller.positionController,
                  decoration: const InputDecoration(
                    labelText: 'Pozisyon',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Email & Phone
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
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
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Department & LinkedIn
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Departman',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.linkedInController,
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Sosyal Medya Linkleri',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: _addSocialLink,
              icon: const Icon(Icons.add),
              label: const Text('Link Ekle'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ..._socialLinks.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return _buildSocialLinkItem(controller, index);
        }),
      ],
    );
  }

  Widget _buildSocialLinkItem(SocialLinkController controller, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: controller.platform,
              decoration: const InputDecoration(
                labelText: 'Platform',
                border: OutlineInputBorder(),
              ),
              items:
                  [
                        'linkedin',
                        'twitter',
                        'instagram',
                        'facebook',
                        'github',
                        'youtube',
                        'website',
                        'other',
                      ]
                      .map(
                        (platform) => DropdownMenuItem(
                          value: platform,
                          child: Text(_getPlatformText(platform)),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => setState(() => controller.platform = value!),
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
              ),
              validator:
                  (value) => value?.isEmpty == true ? 'Bu alan zorunlu' : null,
            ),
          ),
          const SizedBox(width: 8),
          if (_socialLinks.length > 1)
            IconButton(
              onPressed: () => _removeSocialLink(index),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ayarlar',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        SwitchListTile(
          title: const Text('İletişim Formu'),
          subtitle: const Text(
            'Ziyaretçilerin size mesaj gönderebilmesini sağlar',
          ),
          value: _enableContactForm,
          onChanged: (value) {
            setState(() {
              _enableContactForm = value;
            });
          },
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
            onPressed: _saveContact,
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

  void _addContactPerson() {
    setState(() {
      _contactPersons.add(ContactPersonController());
    });
  }

  void _removeContactPerson(int index) {
    if (_contactPersons.length > 1) {
      setState(() {
        _contactPersons.removeAt(index);
      });
    }
  }

  void _addSocialLink() {
    setState(() {
      _socialLinks.add(SocialLinkController());
    });
  }

  void _removeSocialLink(int index) {
    if (_socialLinks.length > 1) {
      setState(() {
        _socialLinks.removeAt(index);
      });
    }
  }

  String _getPlatformText(String platform) {
    switch (platform) {
      case 'linkedin':
        return 'LinkedIn';
      case 'twitter':
        return 'Twitter';
      case 'instagram':
        return 'Instagram';
      case 'facebook':
        return 'Facebook';
      case 'github':
        return 'GitHub';
      case 'youtube':
        return 'YouTube';
      case 'website':
        return 'Website';
      case 'other':
        return 'Diğer';
      default:
        return platform;
    }
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contactPersons =
          _contactPersons.map((controller) => controller.toMap()).toList();

      final socialLinks =
          _socialLinks
              .where((controller) => controller.urlController.text.isNotEmpty)
              .map((controller) => controller.toMap())
              .toList();

      final contactData = {
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'workingHours': _workingHoursController.text,
        'timezone': _timezoneController.text,
        'contactPersons': contactPersons,
        'socialLinks': socialLinks,
        'enableContactForm': _enableContactForm,
      };

      final app = AppModel(
        id: widget.app?.id ?? '',
        title: 'İletişim',
        description: 'İletişim Bilgileri',
        type: 'contact',
        icon: 'contact_page_outlined',
        order: widget.app?.order ?? 0,
        isActive: widget.app?.isActive ?? true,
        images: [],
        data: contactData,
        createdAt: widget.app?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.of(context).pop(app);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _workingHoursController.dispose();
    _timezoneController.dispose();

    for (final controller in _contactPersons) {
      controller.dispose();
    }
    for (final controller in _socialLinks) {
      controller.dispose();
    }
    super.dispose();
  }
}

class ContactPersonController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();

  ContactPersonController();

  ContactPersonController.fromMap(Map<String, dynamic> map) {
    nameController.text = map['name'] ?? '';
    positionController.text = map['position'] ?? '';
    emailController.text = map['email'] ?? '';
    phoneController.text = map['phone'] ?? '';
    departmentController.text = map['department'] ?? '';
    linkedInController.text = map['linkedIn'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': nameController.text,
      'position': positionController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'department': departmentController.text,
      'linkedIn': linkedInController.text,
    };
  }

  void dispose() {
    nameController.dispose();
    positionController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    linkedInController.dispose();
  }
}

class SocialLinkController {
  final TextEditingController urlController = TextEditingController();
  String platform = 'linkedin';

  SocialLinkController();

  SocialLinkController.fromMap(Map<String, dynamic> map) {
    urlController.text = map['url'] ?? '';
    platform = map['platform'] ?? 'linkedin';
  }

  Map<String, dynamic> toMap() {
    return {'platform': platform, 'url': urlController.text};
  }

  void dispose() {
    urlController.dispose();
  }
}
