import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@lazySingleton
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Resim yükleme - modüler path yapısı
  Future<String> uploadImage({
    required String userId,
    required String portfolioId,
    required String appId,
    required String category, // 'apps', 'projects', 'education', etc.
    required PlatformFile file,
  }) async {
    try {
      // Dosya doğrulama
      if (file.bytes == null && file.path == null) {
        throw Exception('File data not available');
      }

      // Resim formatı kontrolü
      if (!_isValidImageFormat(file.extension)) {
        throw Exception('Desteklenmeyen resim formatı: ${file.extension}');
      }

      // Dosya boyutu kontrolü (10MB limit)
      if (file.size > 10 * 1024 * 1024) {
        throw Exception('Dosya boyutu 10MB\'dan büyük olamaz');
      }

      print(
        'Uploading image: ${file.name}, size: ${file.size} bytes, type: ${file.extension}',
      );

      // Modüler path oluştur
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final String path =
          'users/$userId/portfolios/$portfolioId/$category/$appId/images/$fileName';

      final Reference ref = _storage.ref().child(path);

      UploadTask uploadTask;
      if (file.bytes != null) {
        // Web için - bytes kontrolü
        print('Uploading from bytes, length: ${file.bytes!.length}');

        uploadTask = ref.putData(
          file.bytes!,
          SettableMetadata(
            contentType: _getContentType(file.extension),
            customMetadata: {
              'originalName': file.name,
              'uploadedAt': DateTime.now().toIso8601String(),
              'category': category,
              'appId': appId,
              'fileSize': file.size.toString(),
            },
          ),
        );
      } else if (file.path != null) {
        // Mobile için
        print('Uploading from file path: ${file.path}');

        uploadTask = ref.putFile(
          File(file.path!),
          SettableMetadata(
            contentType: _getContentType(file.extension),
            customMetadata: {
              'originalName': file.name,
              'uploadedAt': DateTime.now().toIso8601String(),
              'category': category,
              'appId': appId,
              'fileSize': file.size.toString(),
            },
          ),
        );
      } else {
        throw Exception('File data not available');
      }

      // Upload progress takibi
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      print('Upload completed successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Upload error details: $e');
      throw Exception('Resim yükleme hatası: $e');
    }
  }

  // Çoklu resim yükleme
  Future<List<String>> uploadMultipleImages({
    required String userId,
    required String portfolioId,
    required String appId,
    required String category,
    required List<PlatformFile> files,
  }) async {
    final List<String> downloadUrls = [];

    for (final file in files) {
      try {
        final url = await uploadImage(
          userId: userId,
          portfolioId: portfolioId,
          appId: appId,
          category: category,
          file: file,
        );
        downloadUrls.add(url);
      } catch (e) {
        print('Resim yükleme hatası: ${file.name} - $e');
        // Hata durumunda bu dosyayı atla, diğerlerini yüklemeye devam et
      }
    }

    return downloadUrls;
  }

  // Resim silme - path'den otomatik kategori bulma
  Future<void> deleteImage(String downloadUrl) async {
    try {
      final Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Resim silme hatası: $e');
    }
  }

  // Bir app'in tüm resimlerini silme
  Future<void> deleteAppImages({
    required String userId,
    required String portfolioId,
    required String appId,
    required String category,
  }) async {
    try {
      final String path =
          'users/$userId/portfolios/$portfolioId/$category/$appId/images/';
      final Reference ref = _storage.ref().child(path);

      final ListResult result = await ref.listAll();

      // Tüm resimleri sil
      for (final Reference fileRef in result.items) {
        await fileRef.delete();
      }
    } catch (e) {
      throw Exception('App resimleri silme hatası: $e');
    }
  }

  // Bir app'in tüm resimlerini listeleme
  Future<List<String>> getAppImages({
    required String userId,
    required String portfolioId,
    required String appId,
    required String category,
  }) async {
    try {
      final String path =
          'users/$userId/portfolios/$portfolioId/$category/$appId/images/';
      final Reference ref = _storage.ref().child(path);

      final ListResult result = await ref.listAll();
      final List<String> downloadUrls = [];

      for (final Reference fileRef in result.items) {
        final String downloadUrl = await fileRef.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      throw Exception('App resimleri listeleme hatası: $e');
    }
  }

  // Resim seçici - Düzeltilmiş
  Future<List<PlatformFile>> pickImages({int maxFiles = 10}) async {
    try {
      // Basit resim seçici - allowedExtensions'ı kaldır
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        // Maksimum dosya sayısını kontrol et
        final files = result.files.take(maxFiles).toList();

        // Detaylı filtreleme
        final validFiles = <PlatformFile>[];
        final invalidFiles = <String>[];

        for (final file in files) {
          print(
            'Processing file: ${file.name}, size: ${file.size}, extension: ${file.extension}',
          );

          // Dosya boyutu kontrolü (10MB limit)
          if (file.size <= 10 * 1024 * 1024) {
            // Web için bytes kontrolü
            if (kIsWeb) {
              if (file.bytes != null && file.bytes!.isNotEmpty) {
                validFiles.add(file);
                print(
                  'Valid image added: ${file.name} (${file.bytes!.length} bytes)',
                );
              } else {
                invalidFiles.add('${file.name} (dosya verisi yok)');
                print('Invalid: ${file.name} - no bytes data');
              }
            } else {
              // Mobile için path kontrolü
              if (file.path != null) {
                validFiles.add(file);
                print('Valid image added: ${file.name}');
              } else {
                invalidFiles.add('${file.name} (dosya yolu yok)');
                print('Invalid: ${file.name} - no path');
              }
            }
          } else {
            invalidFiles.add('${file.name} (10MB\'dan büyük)');
            print('Invalid: ${file.name} - too large (${file.size} bytes)');
          }
        }

        // Debug bilgisi
        if (invalidFiles.isNotEmpty) {
          print('Geçersiz dosyalar atlandı: ${invalidFiles.join(', ')}');
        }

        print('Valid files selected: ${validFiles.length}');
        return validFiles;
      }

      return [];
    } catch (e) {
      print('File picker error: $e');
      throw Exception('Resim seçme hatası: $e');
    }
  }

  // Tek resim seçici - Basitleştirilmiş
  Future<PlatformFile?> pickSingleImage() async {
    try {
      // Tüm dosya türlerini kabul et, sonra manuel filtrele
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Dosya boyutu kontrolü (5MB limit)
        if (file.size <= 5 * 1024 * 1024) {
          // Resim formatı kontrolü
          if (_isValidImageFormat(file.extension) ||
              _isValidImageMimeType(file.name)) {
            return file;
          } else {
            throw Exception('Desteklenmeyen resim formatı: ${file.extension}');
          }
        } else {
          throw Exception('Dosya boyutu 5MB\'dan büyük olamaz');
        }
      }

      return null;
    } catch (e) {
      throw Exception('Resim seçme hatası: $e');
    }
  }

  // Content type belirleme
  String _getContentType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  // Geçerli resim formatı kontrolü
  bool _isValidImageFormat(String? extension) {
    if (extension == null) return false;
    final validExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'bmp',
      'tiff',
    ];
    return validExtensions.contains(extension.toLowerCase());
  }

  // Dosya adından resim formatı kontrolü
  bool _isValidImageMimeType(String fileName) {
    final lowerName = fileName.toLowerCase();
    return lowerName.contains('.jpg') ||
        lowerName.contains('.jpeg') ||
        lowerName.contains('.png') ||
        lowerName.contains('.gif') ||
        lowerName.contains('.webp') ||
        lowerName.contains('.bmp') ||
        lowerName.contains('.tiff');
  }

  // Bytes'dan resim formatı kontrolü (magic numbers)
  bool _isValidImageBytes(Uint8List bytes) {
    if (bytes.length < 4) return false;

    // JPEG magic numbers
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return true;
    }

    // PNG magic numbers
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return true;
    }

    // GIF magic numbers
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
      return true;
    }

    // WEBP magic numbers
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return true;
    }

    // BMP magic numbers
    if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
      return true;
    }

    return false;
  }

  // URL'den kategori çıkarma (silme işlemleri için)
  String? getCategoryFromUrl(String downloadUrl) {
    try {
      final uri = Uri.parse(downloadUrl);
      final path = uri.path;

      // Path: /v0/b/bucket/o/users%2F{userId}%2Fportfolios%2F{portfolioId}%2F{category}%2F{appId}%2Fimages%2F{fileName}
      final decodedPath = Uri.decodeComponent(path);
      final parts = decodedPath.split('/');

      // 'users', userId, 'portfolios', portfolioId, category, appId, 'images', fileName
      if (parts.length >= 8) {
        return parts[5]; // category
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // URL'den app ID çıkarma
  String? getAppIdFromUrl(String downloadUrl) {
    try {
      final uri = Uri.parse(downloadUrl);
      final path = uri.path;

      final decodedPath = Uri.decodeComponent(path);
      final parts = decodedPath.split('/');

      // 'users', userId, 'portfolios', portfolioId, category, appId, 'images', fileName
      if (parts.length >= 8) {
        return parts[6]; // appId
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
