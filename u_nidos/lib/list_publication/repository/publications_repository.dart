import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_nidos/list_publication/model/publications_model.dart';

class PublicacionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Publicacion>> obtenerPublicacionesPorCampus(String campus) async {
    try {
      print('📥 Consultando publicaciones para el campus: $campus');

      final query =
          await _firestore
              .collection('publicaciones')
              .where('campus', isEqualTo: campus)
              .orderBy('timestamp', descending: true)
              .get();

      print('📄 Documentos encontrados: ${query.docs.length}');

      return query.docs.map((doc) => Publicacion.fromMap(doc.data())).toList();
    } catch (e) {
      print('🔥 Error en obtenerPublicacionesPorCampus: $e');
      rethrow; // Propaga el error al BLoC para que se dispare PublicacionError
    }
  }
}
