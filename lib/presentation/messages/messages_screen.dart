import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_entity.dart';
import '../../core/constants/app_colors.dart';
import 'cubit/messages_cubit.dart';
import 'cubit/messages_state.dart';
import 'widgets/messages_header_widget.dart';
import 'widgets/messages_list_widget.dart';
import 'widgets/message_input_widget.dart';

/// Messages screen - Chat interface
class MessagesScreen extends StatelessWidget {
  final AppEntity app;

  const MessagesScreen({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesCubit(),
      child: Container(
        color: AppColors.backgroundDark1,
        child: Column(
          children: [
            const MessagesHeaderWidget(),
            Expanded(
              child: BlocBuilder<MessagesCubit, MessagesState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state.error != null) {
                    return Center(
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return MessagesListWidget(messages: state.messages);
                },
              ),
            ),
            BlocBuilder<MessagesCubit, MessagesState>(
              builder: (context, state) {
                return MessageInputWidget(
                  onSendMessage: (text) {
                    context.read<MessagesCubit>().sendMessage(text);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
