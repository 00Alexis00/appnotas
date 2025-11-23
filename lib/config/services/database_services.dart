import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('user');

  Future<bool> addUsuario(String nombre, String apellido, int edad, String email)async{
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

}