import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/domain/models/portfolio_model.dart';
import '../providers/portfolio_provider.dart';
import '../../../../core/extensions/localization_extension.dart';

class EditThemeDialog extends ConsumerStatefulWidget {
  final PortfolioModel portfolio;

  const EditThemeDialog({super.key, required this.portfolio});

  @override
  ConsumerState<EditThemeDialog> createState() => _EditThemeDialogState();
}

class _EditThemeDialogState extends ConsumerState<EditThemeDialog> {
  late String _mode;
  late String _primaryColor;
  late String _backgroundColor;
  late String _textColor;
  late String _accentColor;
  bool _isLoading = false;

  // Önceden tanımlı renk paletleri
  final List<Map<String, dynamic>> _presetColors = [
    {
      'name': 'Mavi',
      'primary': '#1E88E5',
      'accent': '#FF4081',
      'lightBg': '#F5F5F5',
      'darkBg': '#121212',
      'lightText': '#212121',
      'darkText': '#FFFFFF',
    },
    {
      'name': 'Yeşil',
      'primary': '#4CAF50',
      'accent': '#FF9800',
      'lightBg': '#F1F8E9',
      'darkBg': '#1B5E20',
      'lightText': '#2E7D32',
      'darkText': '#C8E6C9',
    },
    {
      'name': 'Mor',
      'primary': '#9C27B0',
      'accent': '#FFEB3B',
      'lightBg': '#F3E5F5',
      'darkBg': '#4A148C',
      'lightText': '#6A1B9A',
      'darkText': '#E1BEE7',
    },
    {
      'name': 'Turuncu',
      'primary': '#FF5722',
      'accent': '#00BCD4',
      'lightBg': '#FFF3E0',
      'darkBg': '#BF360C',
      'lightText': '#D84315',
      'darkText': '#FFCCBC',
    },
  ];

  @override
  void initState() {
    super.initState();
    _mode = widget.portfolio.theme.mode;
    _primaryColor = widget.portfolio.theme.primaryColor;
    _backgroundColor = widget.portfolio.theme.backgroundColor;
    _textColor = widget.portfolio.theme.textColor;
    _accentColor = widget.portfolio.theme.accentColor;
  }

  void _applyPreset(Map<String, dynamic> preset) {
    setState(() {
      _primaryColor = preset['primary'];
      _accentColor = preset['accent'];
      if (_mode == 'light') {
        _backgroundColor = preset['lightBg'];
        _textColor = preset['lightText'];
      } else {
        _backgroundColor = preset['darkBg'];
        _textColor = preset['darkText'];
      }
    });
  }

  void _switchMode(String newMode) {
    setState(() {
      _mode = newMode;
      // Mod değiştiğinde uygun arka plan ve metin renklerini ayarla
      if (newMode == 'light') {
        _backgroundColor = '#F5F5F5';
        _textColor = '#212121';
      } else {
        _backgroundColor = '#121212';
        _textColor = '#FFFFFF';
      }
    });
  }

  Future<void> _showColorPicker(String colorType, String currentColor) async {
    Color? selectedColor = await showDialog<Color>(
      context: context,
      builder:
          (context) => _ColorPickerDialog(
            initialColor: _hexToColor(currentColor),
            title: _getColorTypeTitle(colorType),
          ),
    );

    if (selectedColor != null) {
      setState(() {
        final hexColor = _colorToHex(selectedColor);
        switch (colorType) {
          case 'primary':
            _primaryColor = hexColor;
            break;
          case 'accent':
            _accentColor = hexColor;
            break;
          case 'background':
            _backgroundColor = hexColor;
            break;
          case 'text':
            _textColor = hexColor;
            break;
        }
      });
    }
  }

  String _getColorTypeTitle(String type) {
    switch (type) {
      case 'primary':
        return 'Ana Renk';
      case 'accent':
        return 'Vurgu Rengi';
      case 'background':
        return 'Arka Plan Rengi';
      case 'text':
        return 'Metin Rengi';
      default:
        return 'Renk';
    }
  }

  Color _hexToColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  Future<void> _updateTheme() async {
    setState(() => _isLoading = true);

    try {
      final updatedTheme = ThemeConfig(
        mode: _mode,
        primaryColor: _primaryColor,
        backgroundColor: _backgroundColor,
        textColor: _textColor,
        accentColor: _accentColor,
      );

      final updatedPortfolio = widget.portfolio.copyWith(theme: updatedTheme);
      await ref
          .read(portfolioNotifierProvider.notifier)
          .updatePortfolio(updatedPortfolio);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tema ayarları güncellendi'.tr(ref)),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tema Ayarları'.tr(ref)),
      content: SizedBox(
        width: 600,
        height: 700,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mod Seçimi
              Text(
                'Tema Modu',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Açık Tema'),
                      value: 'light',
                      groupValue: _mode,
                      onChanged: (value) => _switchMode(value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Koyu Tema'),
                      value: 'dark',
                      groupValue: _mode,
                      onChanged: (value) => _switchMode(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Önceden Tanımlı Paletler
              Text(
                'Hazır Renk Paletleri',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _presetColors.length,
                itemBuilder: (context, index) {
                  final preset = _presetColors[index];
                  return InkWell(
                    onTap: () => _applyPreset(preset),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: _hexToColor(preset['primary']),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                            height: double.infinity,
                            color: _hexToColor(preset['accent']),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                preset['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Özel Renk Seçimi
              Text(
                'Özel Renk Ayarları',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildColorRow('Ana Renk', 'primary', _primaryColor),
              _buildColorRow('Vurgu Rengi', 'accent', _accentColor),
              _buildColorRow('Arka Plan Rengi', 'background', _backgroundColor),
              _buildColorRow('Metin Rengi', 'text', _textColor),

              const SizedBox(height: 24),

              // Önizleme
              Text(
                'Önizleme',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPreview(),
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
          onPressed: _isLoading ? null : _updateTheme,
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

  Widget _buildColorRow(String title, String type, String colorHex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(title)),
          GestureDetector(
            onTap: () => _showColorPicker(type, colorHex),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _hexToColor(colorHex),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            colorHex,
            style: TextStyle(fontFamily: 'monospace', color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _hexToColor(_backgroundColor),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Önizleme',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _hexToColor(_textColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu, seçtiğiniz tema ile nasıl görüneceğinin önizlemesidir.',
            style: TextStyle(color: _hexToColor(_textColor)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _hexToColor(_primaryColor),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Ana Renk',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _hexToColor(_accentColor),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Vurgu',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final String title;

  const _ColorPickerDialog({required this.initialColor, required this.title});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;

  // Önceden tanımlı renkler
  final List<Color> _predefinedColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Seçili renk önizlemesi
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Text(
                  '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                  style: TextStyle(
                    color:
                        _selectedColor.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Renk seçici grid
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _predefinedColors.length,
              itemBuilder: (context, index) {
                final color = _predefinedColors[index];
                final isSelected = color.value == _selectedColor.value;

                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child:
                        isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedColor),
          child: const Text('Seç'),
        ),
      ],
    );
  }
}
