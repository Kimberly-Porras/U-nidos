import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtener el ID único para una conversación entre dos usuarios
  String getConversationId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

  /// Enviar un mensaje
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final conversationId = getConversationId(senderId, receiverId);

    final messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(), // ✅ Tiempo desde el servidor
      'type': 'text',
    };

    // Guardar mensaje
    await _firestore
        .collection('chats')
        .doc(conversationId)
        .collection('mensajes')
        .add(messageData);

    // Actualizar resumen de conversación
    await _firestore.collection('chats').doc(conversationId).set({
      'participants': [senderId, receiverId],
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(), // ✅ Tiempo desde el servidor
      'senderId': senderId,
    }, SetOptions(merge: true));
  }

  /// Obtener mensajes entre dos usuarios en tiempo real
  Stream<List<Message>> getMessages(String uid1, String uid2) {
    final conversationId = getConversationId(uid1, uid2);
    return _firestore
        .collection('chats')
        .doc(conversationId)
        .collection('mensajes')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Obtener la lista de conversaciones activas del usuario
  Stream<QuerySnapshot> getUserConversations(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
