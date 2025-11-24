import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices {

  final auth = FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference notasCollection = FirebaseFirestore.instance.collection('notas');

  Future<bool> addUsuario(String nombre, String apellido, int edad, String email)
  async{
    try {
      await usersCollection.add({
        'nombre': nombre,
        'apellido': apellido,
        'edad': edad,
        'email': email
      });
      return true;
    } catch (e){
      return false;
    }
  }

  agregarNota(String nota){
    notasCollection.add({
      'uidcreador': auth.currentUser!.uid,
      'texto': nota
    });

  }

}