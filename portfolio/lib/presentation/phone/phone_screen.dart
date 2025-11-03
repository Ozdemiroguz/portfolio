import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_entity.dart';
import 'cubit/phone_cubit.dart';
import 'cubit/phone_state.dart';
import 'widgets/phone_display_widget.dart';
import 'widgets/phone_dial_pad_widget.dart';
import 'widgets/phone_call_widget.dart';

/// Phone screen - Phone call interface
class PhoneScreen extends StatelessWidget {
  final AppEntity app;

  const PhoneScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneCubit(),
      child: BlocBuilder<PhoneCubit, PhoneState>(
        builder: (context, state) {
          // Show call interface when call is active
          if (state.callStatus != PhoneCallStatus.idle &&
              state.callStatus != PhoneCallStatus.ended) {
            return PhoneCallWidget(
              number: state.dialedNumber,
              callStatus: state.callStatus,
              onEndCall: () => context.read<PhoneCubit>().endCall(),
            );
          }

          // Show dial pad interface - fully scrollable
          return SafeArea(
            child: SingleChildScrollView(
              //top padding
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  // Display widget
                  PhoneDisplayWidget(
                    dialedNumber: state.dialedNumber,
                    status: _getStatusText(state.callStatus),
                  ),
                  // Dial pad - all in scrollable
                  PhoneDialPadWidget(
                    onDigitPressed: (digit) {
                      context.read<PhoneCubit>().addDigit(digit);
                    },
                    onDeletePressed: () {
                      context.read<PhoneCubit>().deleteDigit();
                    },
                    onCallPressed: () {
                      context.read<PhoneCubit>().startCall();
                    },
                    isCalling:
                        state.callStatus != PhoneCallStatus.idle &&
                        state.callStatus != PhoneCallStatus.ended,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getStatusText(PhoneCallStatus status) {
    switch (status) {
      case PhoneCallStatus.idle:
      case PhoneCallStatus.ended:
        return '';
      default:
        return '';
    }
  }
}
