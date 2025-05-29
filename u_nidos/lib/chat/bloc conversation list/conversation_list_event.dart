import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ConversationListEvent extends Equatable {
  const ConversationListEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends ConversationListEvent {
  final String userId;

  const LoadConversations(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ConversationsUpdated extends ConversationListEvent {
  final List<QueryDocumentSnapshot> conversations;

  const ConversationsUpdated(this.conversations);

  @override
  List<Object?> get props => [conversations];
}
