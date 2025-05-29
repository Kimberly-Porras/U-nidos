import 'package:equatable/equatable.dart';
import '../models/message.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends MessageEvent {
  final String currentUserId;
  final String otherUserId;

  const LoadMessages({required this.currentUserId, required this.otherUserId});

  @override
  List<Object> get props => [currentUserId, otherUserId];
}

class SendMessage extends MessageEvent {
  final String senderId;
  final String receiverId;
  final String content;

  const SendMessage({
    required this.senderId,
    required this.receiverId,
    required this.content,
  });

  @override
  List<Object> get props => [senderId, receiverId, content];
}

class MessagesUpdated extends MessageEvent {
  final List<Message> messages;

  const MessagesUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}
