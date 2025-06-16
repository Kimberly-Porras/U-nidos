import 'package:cloud_firestore/cloud_firestore.dart';

class RatingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Promedios agrupados por autor (usado en historial 'Aprendí')
  Future<Map<String, int>> obtenerPromediosPorAutor(String autorId) async {
    final query =
        await _firestore
            .collection('calificaciones')
            .where('autorId', isEqualTo: autorId)
            .get();

    final Map<String, List<int>> agrupados = {};
    for (final doc in query.docs) {
      final data = doc.data();
      final id = data['idPublicacion'];
      final cal = data['calificacion'];
      if (id != null && cal != null) {
        agrupados.putIfAbsent(id, () => []).add(cal);
      }
    }

    final Map<String, int> promedios = {};
    for (final entry in agrupados.entries) {
      final suma = entry.value.reduce((a, b) => a + b);
      final promedio = (suma / entry.value.length).round();
      promedios[entry.key] = promedio;
    }

    return promedios;
  }

  // 🔹 Promedio individual por publicación (usado en perfil_page.dart)
  Future<double> obtenerPromedioCalificacionServicio(
    String idPublicacion,
  ) async {
    final query =
        await _firestore
            .collection('calificaciones')
            .where('idPublicacion', isEqualTo: idPublicacion)
            .get();

    if (query.docs.isEmpty) return 0.0;

    final total = query.docs.fold<double>(
      0.0,
      (sum, doc) => sum + (doc.data()['calificacion'] ?? 0).toDouble(),
    );

    return total / query.docs.length;
  }
}
