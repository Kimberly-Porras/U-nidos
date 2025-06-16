import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_nidos/list_publication/model/publications_model.dart';

class PublicacionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Publicacion>> obtenerPublicacionesPorCampus(
    String campus,
    String currentUserId,
  ) async {
    try {
      print('📥 Consultando publicaciones para el campus: $campus');

      final query =
          await _firestore
              .collection('publicaciones')
              .where('campus', isEqualTo: campus)
              .orderBy('timestamp', descending: true)
              .get();

      // 🔽 Filtro local: excluir las del usuario actual
      final docsFiltrados =
          query.docs.where((doc) => doc['uid'] != currentUserId).toList();

      print(
        '📄 Documentos encontrados (excluyendo los del usuario): ${docsFiltrados.length}',
      );

      return docsFiltrados.map((doc) => Publicacion.fromDocument(doc)).toList();
    } catch (e) {
      print('🔥 Error en obtenerPublicacionesPorCampus: $e');
      rethrow;
    }
  }
}
