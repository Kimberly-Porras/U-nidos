import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ConversationListState extends Equatable {
  const ConversationListState();

  @override
  List<Object?> get props => [];
}

class ConversationListInitial extends ConversationListState {}

class ConversationListLoading extends ConversationListState {}

class ConversationListLoaded extends ConversationListState {
  final List<QueryDocumentSnapshot> conversations;

  const ConversationListLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ConversationListError extends ConversationListState {
  final String error;

  const ConversationListError(this.error);

  @override
  List<Object?> get props => [error];
}
