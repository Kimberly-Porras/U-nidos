import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_nidos/list_publication/model/publications_model.dart';

class PublicacionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Publicacion>> obtenerPublicacionesPorCampus(
    String campus,
    String currentUserId, // 👈 nuevo parámetro
  ) async {
    try {
      print('📥 Consultando publicaciones para el campus: $campus (excluyendo UID: $currentUserId)');

      final query = await _firestore
          .collection('publicaciones')
          .where('campus', isEqualTo: campus)
          .where('uid', isNotEqualTo: currentUserId) // 👈 filtro
          .orderBy('uid') // 👈 requerido para usar isNotEqualTo
          .orderBy('timestamp', descending: true)
          .get();

      print('📄 Documentos encontrados (sin los del usuario actual): ${query.docs.length}');

      return query.docs.map((doc) => Publicacion.fromDocument(doc)).toList();
    } catch (e) {
      print('🔥 Error en obtenerPublicacionesPorCampus: $e');
      rethrow;
    }
  }
}
