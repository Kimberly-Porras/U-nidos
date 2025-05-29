import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'message_event.dart';
import 'message_state.dart';
import '../repository/chat_repository.dart';
import '../models/message.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository repository;
  StreamSubscription<List<Message>>? _subscription;

  MessageBloc({required this.repository}) : super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessagesUpdated>(_onMessagesUpdated); // ✅ nuevo evento público
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());

    _subscription?.cancel();
    _subscription = repository
        .getMessages(event.currentUserId, event.otherUserId)
        .listen((messages) {
          add(MessagesUpdated(messages)); // ✅ evento público
        });
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      await repository.sendMessage(
        senderId: event.senderId,
        receiverId: event.receiverId,
        message: event.content,
      );
    } catch (e) {
      emit(MessageError('Error al enviar el mensaje'));
    }
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<MessageState> emit) {
    emit(MessageLoaded(event.messages));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
