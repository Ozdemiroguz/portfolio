import 'package:equatable/equatable.dart';

/// Single work experience entity
class ExperienceEntity extends Equatable {
  final String company;
  final String position;
  final String startDate;
  final String? endDate;
  final String description;
  final List<String> technologies;

  const ExperienceEntity({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.technologies,
  });

  @override
  List<Object?> get props => [
        company,
        position,
        startDate,
        endDate,
        description,
        technologies,
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
