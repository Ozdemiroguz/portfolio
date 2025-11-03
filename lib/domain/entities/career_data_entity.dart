import 'package:equatable/equatable.dart';

/// Single work experience entity
class ExperienceEntity extends Equatable {
  final String company;
  final String position;
  final String startDate;
  final String? endDate;
  final String description;
  final List<String> technologies;
  
  // Translation keys (optional)
  final String? companyKey;
  final String? positionKey;
  final String? descriptionKey;
  final List<String>? technologiesKeys;

  const ExperienceEntity({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.technologies,
    this.companyKey,
    this.positionKey,
    this.descriptionKey,
    this.technologiesKeys,
  });

  @override
  List<Object?> get props => [
        company,
        position,
        startDate,
        endDate,
        description,
        technologies,
        companyKey,
        positionKey,
        descriptionKey,
        technologiesKeys,
      ];
}

/// Career data entity
class CareerDataEntity extends Equatable {
  final List<ExperienceEntity> experiences;

  const CareerDataEntity({
    required this.experiences,
  });

  @override
  List<Object?> get props => [experiences];
}
