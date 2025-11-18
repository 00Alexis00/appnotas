import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {

  final FirebaseAuth auth = FirebaseAuth.instance;

  createAcount(String correo, String password, String nombre, String apellido, String edad)async{

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: correo, password: password);

      if(userCredential.user?.uid != null){

      }
    } catch (e) {
      print(e);
    }
  }
}