import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/domain/models/portfolio_model.dart';
import '../providers/portfolio_provider.dart';
import '../../../../core/extensions/localization_extension.dart';

class EditBasicInfoDialog extends ConsumerStatefulWidget {
  final PortfolioModel portfolio;

  const EditBasicInfoDialog({super.key, required this.portfolio});

  @override
  ConsumerState<EditBasicInfoDialog> createState() =>
      _EditBasicInfoDialogState();
}

class _EditBasicInfoDialogState extends ConsumerState<EditBasicInfoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.portfolio.title);
    _descriptionController = TextEditingController(
      text: widget.portfolio.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updatePortfolio() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedPortfolio = widget.portfolio.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      await ref
          .read(portfolioNotifierProvider.notifier)
          .updatePortfolio(updatedPortfolio);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Temel bilgiler güncellendi'.tr(ref)),
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
      title: Text('Temel Bilgileri Düzenle'.tr(ref)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık'.tr(ref),
                  border: const OutlineInputBorder(),
                  hintText: 'Portfolio başlığını girin',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Başlık gereklidir';
                  }
                  return null;
                },
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Açıklama'.tr(ref),
                  border: const OutlineInputBorder(),
                  hintText: 'Portfolio açıklamasını girin',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Açıklama gereklidir';
                  }
                  return null;
                },
                maxLines: 3,
              ),
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
          onPressed: _isLoading ? null : _updatePortfolio,
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
