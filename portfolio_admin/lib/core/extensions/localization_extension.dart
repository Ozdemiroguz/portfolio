import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension LocalizationExtension on String {
  String tr(WidgetRef ref) {
    // Şimdilik sadece string'i döndürüyoruz
    // Gelecekte LocalizationService entegrasyonu yapılabilir
    return this;
  }
}

extension BuildContextLocalization on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

// Temporary implementation for form localization
class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations();
  }

  // Forms
  String get createProject => 'Proje Oluştur';
  String get editProject => 'Proje Düzenle';
  String get createEducation => 'Eğitim Oluştur';
  String get editEducation => 'Eğitim Düzenle';
  String get createReference => 'Referans Oluştur';
  String get editReference => 'Referans Düzenle';
  String get createContact => 'İletişim Oluştur';
  String get editContact => 'İletişim Düzenle';

  String get project => 'Proje';
  String get education => 'Eğitim';
  String get reference => 'Referans';
  String get references => 'Referanslar';
  String get contact => 'İletişim';
  String get contactInfo => 'İletişim Bilgileri';
  String get contactPersons => 'İletişim Kişileri';
  String get contactForm => 'İletişim Formu';

  String get projectTitle => 'Proje Başlığı';
  String get description => 'Açıklama';
  String get technologies => 'Teknolojiler';
  String get features => 'Özellikler';
  String get status => 'Durum';
  String get ownProject => 'Kendi Projesi';
  String get startDate => 'Başlangıç Tarihi';
  String get endDate => 'Bitiş Tarihi';
  String get selectDate => 'Tarih Seç';
  String get teamSize => 'Takım Büyüklüğü';
  String get role => 'Rol';
  String get clientName => 'Müşteri Adı';
  String get addProject => 'Proje Ekle';
  String get add => 'Ekle';
  String get fieldRequired => 'Bu alan zorunlu';

  String get institution => 'Kurum';
  String get degree => 'Derece';
  String get field => 'Alan';
  String get location => 'Konum';
  String get website => 'Web Sitesi';
  String get scale => 'Ölçek';
  String get courses => 'Dersler';
  String get achievements => 'Başarılar';
  String get addEducation => 'Eğitim Ekle';

  String get name => 'Ad';
  String get position => 'Pozisyon';
  String get company => 'Şirket';
  String get relationship => 'İlişki';
  String get email => 'E-posta';
  String get phone => 'Telefon';
  String get workTogetherDate => 'Birlikte Çalışma Tarihi';
  String get canContact => 'İletişime Geçilebilir';
  String get canContactSubtitle => 'Bu kişiyle iletişime geçilebilir mi?';
  String get recommendation => 'Tavsiye';
  String get addReference => 'Referans Ekle';

  String get generalInfo => 'Genel Bilgiler';
  String get address => 'Adres';
  String get socialLinks => 'Sosyal Linkler';
  String get workingHours => 'Çalışma Saatleri';
  String get timezone => 'Zaman Dilimi';
  String get platform => 'Platform';
  String get addSocialLink => 'Sosyal Link Ekle';
  String get person => 'Kişi';
  String get department => 'Departman';
  String get addContactPerson => 'İletişim Kişisi Ekle';
  String get enableContactForm => 'İletişim Formunu Etkinleştir';
  String get enableContactFormSubtitle =>
      'Ziyaretçiler size mesaj gönderebilir';

  String get save => 'Kaydet';
  String get cancel => 'İptal';
}
