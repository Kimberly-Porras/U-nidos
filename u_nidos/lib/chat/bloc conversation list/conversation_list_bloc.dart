import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'conversation_list_event.dart';
import 'conversation_list_state.dart';
import '../repository/chat_repository.dart';

class ConversationListBloc
    extends Bloc<ConversationListEvent, ConversationListState> {
  final ChatRepository repository;
  StreamSubscription? _subscription;

  ConversationListBloc({required this.repository})
    : super(ConversationListInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<ConversationsUpdated>(_onConversationsUpdated);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationListState> emit,
  ) async {
    emit(ConversationListLoading());
    print('📥 Cargando conversaciones para: ${event.userId}');

    try {
      _subscription?.cancel();
      _subscription = repository.getUserConversations(event.userId).listen((
        snapshot,
      ) {
        print('📦 Conversaciones encontradas: ${snapshot.docs.length}');
        add(ConversationsUpdated(snapshot.docs));
      });
    } catch (e) {
      print('❌ Error al cargar conversaciones: $e');
      emit(ConversationListError('Error al cargar conversaciones'));
    }
  }

  void _onConversationsUpdated(
    ConversationsUpdated event,
    Emitter<ConversationListState> emit,
  ) {
    emit(ConversationListLoaded(event.conversations));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
