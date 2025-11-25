// appnotas/lib/config/services/database_services.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices {
  final auth = FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('user'); // mantuve 'user' como tenías
  final CollectionReference notasCollection = FirebaseFirestore.instance
      .collection('notas');

  // Ahora recibimos uid y creamos el documento con ese uid (doc(uid).set(...))
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
    try {
      final currentUid = auth.currentUser?.uid;
      if (currentUid == null) {
        throw Exception('Usuario no autenticado');
      }
      await notasCollection.add({
        'uidcreador': currentUid,
        'texto': nota,
        'fecha': Timestamp.now(),
      });
    } catch (e) {
      print('Error agregarNota: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> listarNotas() {
    final currentUid = auth.currentUser?.uid ?? '';
    return notasCollection
        .where('uidcreador', isEqualTo: currentUid)
        .orderBy('fecha')
        .snapshots();
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
