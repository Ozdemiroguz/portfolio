import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'phone_state.dart';

/// Phone cubit - handles phone call logic
class PhoneCubit extends Cubit<PhoneState> {
  PhoneCubit() : super(const PhoneState());

  /// Add digit to dialed number
  void addDigit(String digit) {
    if (state.dialedNumber.length < 15) {
      emit(state.copyWith(dialedNumber: state.dialedNumber + digit));
    }
  }

  /// Delete last digit
  void deleteDigit() {
    if (state.dialedNumber.isNotEmpty) {
      emit(state.copyWith(
        dialedNumber: state.dialedNumber.substring(0, state.dialedNumber.length - 1),
      ));
    }
  }

  /// Clear dialed number
  void clearNumber() {
    emit(state.copyWith(dialedNumber: ''));
  }

  /// Start dialing
  Future<void> startCall() async {
    if (state.dialedNumber.isEmpty) return;

    emit(state.copyWith(
      callStatus: PhoneCallStatus.dialing,
      isLoading: true,
    ));

    // Simulate dialing delay
    await Future.delayed(const Duration(milliseconds: 1500));

    emit(state.copyWith(
      callStatus: PhoneCallStatus.connecting,
    ));

    // Simulate connecting delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Add to call history
    final updatedHistory = [state.dialedNumber, ...state.callHistory];
    
    emit(state.copyWith(
      callStatus: PhoneCallStatus.connected,
      isLoading: false,
      callHistory: updatedHistory,
    ));

    // Call stays connected until user manually ends it
  }

  /// End call
  void endCall() {
    emit(state.copyWith(
      callStatus: PhoneCallStatus.ended,
      dialedNumber: '',
    ));

    // Reset to idle after a moment
    Timer(const Duration(milliseconds: 500), () {
      emit(state.copyWith(callStatus: PhoneCallStatus.idle));
    });
  }

  /// Call from history
  void callFromHistory(String number) {
    emit(state.copyWith(dialedNumber: number));
    startCall();
  }
}

