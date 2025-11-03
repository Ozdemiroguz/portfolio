import '../repositories/portfolio_repository.dart';

/// Use case: Send contact message
/// Single responsibility: Send message
class SendContactMessage {
  final PortfolioRepository repository;

  const SendContactMessage({required this.repository});

  Future<bool> call({
    required String portfolioId,
    required String email,
    required String title,
    required String message,
  }) async {
    return await repository.sendContactMessage(
      portfolioId,
      email,
      title,
      message,
    );
  }
}
