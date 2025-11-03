import 'package:equatable/equatable.dart';

/// Phone call state
enum PhoneCallStatus {
  idle,
  dialing,
  connecting,
  connected,
  ended,
}

/// Phone state
class PhoneState extends Equatable {
  final String dialedNumber;
  final PhoneCallStatus callStatus;
  final bool isLoading;
  final String? error;
  final List<String> callHistory;

  const PhoneState({
    this.dialedNumber = '',
    this.callStatus = PhoneCallStatus.idle,
    this.isLoading = false,
    this.error,
    this.callHistory = const [],
  });

  PhoneState copyWith({
    String? dialedNumber,
    PhoneCallStatus? callStatus,
    bool? isLoading,
    String? error,
    List<String>? callHistory,
  }) {
    return PhoneState(
      dialedNumber: dialedNumber ?? this.dialedNumber,
      callStatus: callStatus ?? this.callStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      callHistory: callHistory ?? this.callHistory,
    );
  }

  @override
  List<Object?> get props => [
        dialedNumber,
        callStatus,
        isLoading,
        error,
        callHistory,
      ];
}


