import 'package:equatable/equatable.dart';
import '../../../domain/entities/portfolio_entity.dart';

/// Portfolio state
abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

/// Loading state
class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

/// Loaded state
class PortfolioLoaded extends PortfolioState {
  final PortfolioEntity portfolio;

  const PortfolioLoaded(this.portfolio);

  @override
  List<Object?> get props => [portfolio];
}

/// Error state
class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
