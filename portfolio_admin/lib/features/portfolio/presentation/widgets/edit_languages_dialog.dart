import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/domain/models/portfolio_model.dart';
import '../providers/portfolio_provider.dart';
import '../../../../core/extensions/localization_extension.dart';

class EditLanguagesDialog extends ConsumerStatefulWidget {
  final PortfolioModel portfolio;

  const EditLanguagesDialog({super.key, required this.portfolio});

  @override
  ConsumerState<EditLanguagesDialog> createState() =>
      _EditLanguagesDialogState();
}

class _EditLanguagesDialogState extends ConsumerState<EditLanguagesDialog> {
  late List<String> _supportedLanguages;
  late String _defaultLocale;
  bool _isLoading = false;

  // Desteklenen dil listesi
  final Map<String, Map<String, String>> _availableLanguages = {
    'tr': {'name': 'Türkçe', 'nativeName': 'Türkçe', 'flag': '🇹🇷'},
    'en': {'name': 'İngilizce', 'nativeName': 'English', 'flag': '🇺🇸'},
    'de': {'name': 'Almanca', 'nativeName': 'Deutsch', 'flag': '🇩🇪'},
    'fr': {'name': 'Fransızca', 'nativeName': 'Français', 'flag': '🇫🇷'},
    'es': {'name': 'İspanyolca', 'nativeName': 'Español', 'flag': '🇪🇸'},
    'it': {'name': 'İtalyanca', 'nativeName': 'Italiano', 'flag': '🇮🇹'},
    'pt': {'name': 'Portekizce', 'nativeName': 'Português', 'flag': '🇵🇹'},
    'ru': {'name': 'Rusça', 'nativeName': 'Русский', 'flag': '🇷🇺'},
    'ja': {'name': 'Japonca', 'nativeName': '日本語', 'flag': '🇯🇵'},
    'ko': {'name': 'Korece', 'nativeName': '한국어', 'flag': '🇰🇷'},
    'zh': {'name': 'Çince', 'nativeName': '中文', 'flag': '🇨🇳'},
    'ar': {'name': 'Arapça', 'nativeName': 'العربية', 'flag': '🇸🇦'},
  };

  @override
  void initState() {
    super.initState();
    _supportedLanguages = List<String>.from(widget.portfolio.languages);
    _defaultLocale = widget.portfolio.defaultLocale;

    // Varsayılan dil desteklenen diller arasında değilse ekle
    if (!_supportedLanguages.contains(_defaultLocale)) {
      _supportedLanguages.add(_defaultLocale);
    }
  }

  void _toggleLanguage(String languageCode) {
    setState(() {
      if (_supportedLanguages.contains(languageCode)) {
        // Dil zaten destekleniyor, kaldır (ama varsayılan dil değilse)
        if (languageCode != _defaultLocale && _supportedLanguages.length > 1) {
          _supportedLanguages.remove(languageCode);
        }
      } else {
        // Dil desteklenmiyor, ekle
        _supportedLanguages.add(languageCode);
      }
    });
  }

  void _setDefaultLanguage(String languageCode) {
    setState(() {
      _defaultLocale = languageCode;
      // Varsayılan dil otomatik olarak desteklenen diller arasına eklenir
      if (!_supportedLanguages.contains(languageCode)) {
        _supportedLanguages.add(languageCode);
      }
    });
  }

  Future<void> _updateLanguages() async {
    if (_supportedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('En az bir dil seçmelisiniz'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_supportedLanguages.contains(_defaultLocale)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Varsayılan dil, desteklenen diller arasında olmalıdır',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedPortfolio = widget.portfolio.copyWith(
        languages: _supportedLanguages,
        defaultLocale: _defaultLocale,
      );

      await ref
          .read(portfolioNotifierProvider.notifier)
          .updatePortfolio(updatedPortfolio);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dil ayarları güncellendi'.tr(ref)),
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

  String _getLanguageDisplayName(String code) {
    final lang = _availableLanguages[code];
    if (lang != null) {
      return '${lang['flag']} ${lang['name']} (${lang['nativeName']})';
    }
    return code.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Dil Ayarları'.tr(ref)),
      content: SizedBox(
        width: 500,
        height: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Açıklama
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dil Ayarları Hakkında',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Desteklenen diller: Portfolio\'nuzun hangi dillerde görüntülenebileceğini belirler\n'
                      '• Varsayılan dil: Ziyaretçiler için ilk açılışta gösterilecek dil\n'
                      '• En az bir dil seçmelisiniz',
                      style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Varsayılan Dil Seçimi
              Text(
                'Varsayılan Dil',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  value: _defaultLocale,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items:
                      _availableLanguages.keys.map((code) {
                        final lang = _availableLanguages[code]!;
                        return DropdownMenuItem(
                          value: code,
                          child: Text(
                            '${lang['flag']} ${lang['name']} (${lang['nativeName']})',
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _setDefaultLanguage(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Desteklenen Diller
              Text(
                'Desteklenen Diller',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Portfolio\'nuzun hangi dillerde görüntülenebileceğini seçin:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),

              // Dil Listesi
              ..._availableLanguages.entries.map((entry) {
                final code = entry.key;
                final lang = entry.value;
                final isSupported = _supportedLanguages.contains(code);
                final isDefault = _defaultLocale == code;

                return Card(
                  elevation: isSupported ? 2 : 0,
                  color:
                      isDefault
                          ? Colors.blue[50]
                          : isSupported
                          ? null
                          : Colors.grey[50],
                  child: CheckboxListTile(
                    title: Text(
                      '${lang['flag']} ${lang['name']}',
                      style: TextStyle(
                        fontWeight:
                            isDefault ? FontWeight.bold : FontWeight.normal,
                        color: isDefault ? Colors.blue[700] : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang['nativeName']!,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (isDefault)
                          Text(
                            'Varsayılan Dil',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    value: isSupported,
                    onChanged:
                        isDefault
                            ? null // Varsayılan dil kaldırılamaz
                            : (value) => _toggleLanguage(code),
                    secondary:
                        isDefault
                            ? Icon(Icons.star, color: Colors.blue[600])
                            : null,
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),

              // Seçilen Diller Özeti
              if (_supportedLanguages.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seçilen Diller (${_supportedLanguages.length}):',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            _supportedLanguages.map((code) {
                              final lang = _availableLanguages[code];
                              final isDefault = _defaultLocale == code;
                              return Chip(
                                label: Text(
                                  lang != null
                                      ? '${lang['flag']} ${lang['name']}'
                                      : code.toUpperCase(),
                                ),
                                backgroundColor:
                                    isDefault
                                        ? Colors.blue[100]
                                        : Colors.green[100],
                                side: BorderSide(
                                  color:
                                      isDefault
                                          ? Colors.blue[300]!
                                          : Colors.green[300]!,
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('İptal'.tr(ref)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateLanguages,
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
}
