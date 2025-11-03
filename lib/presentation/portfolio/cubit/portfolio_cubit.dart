import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_portfolio.dart';
import 'portfolio_state.dart';

/// Portfolio cubit
/// Manages portfolio data
class PortfolioCubit extends Cubit<PortfolioState> {
  final GetPortfolio getPortfolio;

  PortfolioCubit({
    required this.getPortfolio,
  }) : super(const PortfolioInitial());

  /// Load portfolio
  Future<void> loadPortfolio(String domain) async {
    emit(const PortfolioLoading());

    try {
      final portfolio = await getPortfolio(domain);

      if (portfolio == null) {
        emit(const PortfolioError('Portfolio not found'));
        return;
      }

      emit(PortfolioLoaded(portfolio));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }
}
