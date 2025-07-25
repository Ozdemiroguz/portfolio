import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/domain/models/portfolio_model.dart';
import '../providers/portfolio_provider.dart';
import '../../../../core/extensions/localization_extension.dart';

class EditSocialLinksDialog extends ConsumerStatefulWidget {
  final PortfolioModel portfolio;

  const EditSocialLinksDialog({super.key, required this.portfolio});

  @override
  ConsumerState<EditSocialLinksDialog> createState() =>
      _EditSocialLinksDialogState();
}

class _EditSocialLinksDialogState extends ConsumerState<EditSocialLinksDialog> {
  late List<SocialLink> _socialLinks;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final List<String> _availableTypes = [
    'github',
    'linkedin',
    'twitter',
    'email',
    'website',
    'instagram',
    'youtube',
    'facebook',
  ];

  @override
  void initState() {
    super.initState();
    _socialLinks = List<SocialLink>.from(widget.portfolio.socialLinks);

    // Eksik tipleri boş olarak ekle
    for (final type in _availableTypes) {
      if (!_socialLinks.any((link) => link.type == type)) {
        _socialLinks.add(SocialLink(type: type, url: null));
      }
    }

    // Tiplere göre sırala
    _socialLinks.sort(
      (a, b) => _availableTypes
          .indexOf(a.type)
          .compareTo(_availableTypes.indexOf(b.type)),
    );
  }

  Future<void> _updateSocialLinks() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Boş olmayan linkleri filtrele
      final validLinks =
          _socialLinks
              .where((link) => link.url != null && link.url!.trim().isNotEmpty)
              .toList();

      final updatedPortfolio = widget.portfolio.copyWith(
        socialLinks: validLinks,
      );

      await ref
          .read(portfolioNotifierProvider.notifier)
          .updatePortfolio(updatedPortfolio);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sosyal bağlantılar güncellendi'.tr(ref)),
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
        setState(() => _isLoading = false);
      }
    }
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'github':
        return 'GitHub';
      case 'linkedin':
        return 'LinkedIn';
      case 'twitter':
        return 'Twitter';
      case 'email':
        return 'E-posta';
      case 'website':
        return 'Website';
      case 'instagram':
        return 'Instagram';
      case 'youtube':
        return 'YouTube';
      case 'facebook':
        return 'Facebook';
      default:
        return type.toUpperCase();
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'github':
        return Icons.code;
      case 'linkedin':
        return Icons.work;
      case 'twitter':
        return Icons.alternate_email;
      case 'email':
        return Icons.email;
      case 'website':
        return Icons.language;
      case 'instagram':
        return Icons.camera_alt;
      case 'youtube':
        return Icons.play_circle;
      case 'facebook':
        return Icons.facebook;
      default:
        return Icons.link;
    }
  }

  String? _validateUrl(String? value, String type) {
    if (value == null || value.trim().isEmpty) {
      return null; // Boş olabilir
    }

    value = value.trim();

    switch (type) {
      case 'email':
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Geçerli bir e-posta adresi girin';
        }
        break;
      case 'github':
        if (!value.startsWith('https://github.com/') &&
            !value.startsWith('github.com/')) {
          return 'GitHub profil URL\'si girin (örn: https://github.com/kullanici)';
        }
        break;
      case 'linkedin':
        if (!value.contains('linkedin.com/')) {
          return 'LinkedIn profil URL\'si girin';
        }
        break;
      default:
        final uri = Uri.tryParse(value);
        if ((uri?.hasAbsolutePath != true) && !value.startsWith('http')) {
          return 'Geçerli bir URL girin (örn: https://example.com)';
        }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sosyal Bağlantıları Düzenle'.tr(ref)),
      content: SizedBox(
        width: 500,
        height: 400,
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: _socialLinks.length,
            itemBuilder: (context, index) {
              final link = _socialLinks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  initialValue: link.url,
                  decoration: InputDecoration(
                    labelText: _getTypeDisplayName(link.type),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(_getTypeIcon(link.type)),
                    hintText: _getHintText(link.type),
                  ),
                  validator: (value) => _validateUrl(value, link.type),
                  onChanged: (value) {
                    _socialLinks[index] = SocialLink(
                      type: link.type,
                      url: value.trim().isEmpty ? null : value.trim(),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('İptal'.tr(ref)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateSocialLinks,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text('Güncelle'.tr(ref)),
        ),
      ],
    );
  }

  String _getHintText(String type) {
    switch (type) {
      case 'github':
        return 'https://github.com/kullaniciadi';
      case 'linkedin':
        return 'https://linkedin.com/in/kullaniciadi';
      case 'twitter':
        return 'https://twitter.com/kullaniciadi';
      case 'email':
        return 'ornek@email.com';
      case 'website':
        return 'https://website.com';
      case 'instagram':
        return 'https://instagram.com/kullaniciadi';
      case 'youtube':
        return 'https://youtube.com/@kullaniciadi';
      case 'facebook':
        return 'https://facebook.com/kullaniciadi';
      default:
        return 'https://example.com';
    }
  }
}
