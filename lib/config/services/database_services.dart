// appnotas/lib/config/services/database_services.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices {
  final auth = FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('user');
  final CollectionReference notasCollection = FirebaseFirestore.instance
      .collection('notas');

  Future<bool> addUsuario(
    String uid,
    String nombre,
    String apellido,
    int edad,
    String email,
  ) async {
    try {
      await usersCollection.doc(uid).set({
        'uid': uid,
        'nombre': nombre,
        'apellido': apellido,
        'edad': edad,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error al crear usuario en Firestore: $e');
      return false;
    }
  }

  Future<void> agregarNota(String nota) async {
    final currentUid = auth.currentUser?.uid;
    if (currentUid == null) {
      throw Exception('Usuario no autenticado');
    }
    await notasCollection.add({
      'uidcreador': currentUid,
      'texto': nota,
      'fecha': FieldValue.serverTimestamp(),
    });
  }

  /// Nuevo: lista notas recibiendo explicitamente el uid.
  Stream<QuerySnapshot> listarNotasForUid(String uid) {
    return notasCollection
        .where('uidcreador', isEqualTo: uid)
        .orderBy('fecha')
        .snapshots();
  }

  // Deprecated: mantener compatibilidad si otras partes llaman listarNotas()
  Stream<QuerySnapshot> listarNotas() {
    final uid = auth.currentUser?.uid ?? '';
    return listarNotasForUid(uid);
  }

  Future<void> borrarNota(String idNota) async {
    await notasCollection.doc(idNota).delete();
  }

  Future<void> editarNota(String idNota, String texto) async {
    await notasCollection.doc(idNota).set({
      'texto': texto,
    }, SetOptions(merge: true));
  }
}
