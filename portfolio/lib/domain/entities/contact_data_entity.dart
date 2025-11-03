import 'package:equatable/equatable.dart';

/// Single social link entity
class SocialLinkEntity extends Equatable {
  final String platform;
  final String url;

  const SocialLinkEntity({
    required this.platform,
    required this.url,
  });

  @override
  List<Object?> get props => [platform, url];
}

/// Contact data entity
class ContactDataEntity extends Equatable {
  final String email;
  final String phone;
  final String address;
  final List<SocialLinkEntity> socials;

  const ContactDataEntity({
    required this.email,
    required this.phone,
    required this.address,
    required this.socials,
  });

  @override
  List<Object?> get props => [email, phone, address, socials];
}
