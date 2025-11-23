import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FsService {
  final _db = FirebaseFirestore.instance;

  // Devuelve los ventos ordenados por fecha y hora
  Stream<QuerySnapshot<Map<String, dynamic>>> eventos() {
    return _db
        .collection('Eventos')
        .orderBy('fechaHora', descending: true)
        .snapshots()
        .cast<QuerySnapshot<Map<String, dynamic>>>();
  }

  // Devuelve las IDs de categoría a ruta de asset
  Future<Map<String, String>> categoriasMap() async {
    final snap = await _db.collection('Categorias').get();
    final Map<String, String> result = {};
    for (final d in snap.docs) {
      final data = d.data();
      final asset = data['asset'] as String?;
      result[d.id] = asset ?? 'assets/images/categorias/coloquio.png';
    }
    return result;
  }

  // Devuelve la lista de categorias
  Future<QuerySnapshot> categorias() {
    return _db
        .collection('Categorias')
        .orderBy('nombre')
        .get();
  }

  // Agrega un nuevo evento
  Future<void> agregarEvento(
    String titulo,
    String lugar,
    DateTime fechaHora,
    String categoriaId,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    // Prioriza el nombre de la cuenta Google, luego el correo electrónico
    final autorNombre = user?.displayName ?? user?.email ?? 'Anónimo';
    return _db.collection('Eventos').add({
      'titulo': titulo,
      'autor': autorNombre,
      'lugar': lugar,
      'fechaHora': fechaHora,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'categoriaId': categoriaId,
      'creadorEmail': user?.email ?? 'Anónimo',
    });
  }

  // Devuelve solo los eventos creados por el usuario según su email
  Stream<QuerySnapshot<Map<String, dynamic>>> misEventos(String? email) {
    if (email == null) {
      // Si no hay email, devuelve stream vacío
      return Stream.empty().cast<QuerySnapshot<Map<String, dynamic>>>();
    }
    return _db
        .collection('Eventos')
        .where('creadorEmail', isEqualTo: email)
        .snapshots()
        .cast<QuerySnapshot<Map<String, dynamic>>>();
  }

  // Borra un evento por su ID
  Future<void> deleteEvento(String docId) {
    return _db.collection('Eventos').doc(docId).delete();
  }
}