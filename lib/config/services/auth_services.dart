import 'package:appnotas/config/preferencias/preferencias.dart';
import 'package:appnotas/config/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {

  final FirebaseAuth auth = FirebaseAuth.instance;
  var prefs = PreferenciasUsuario();

  createAcount(String correo, String password, String nombre, String apellido, String edad)async{

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: correo, password: password);

      if(userCredential.user?.uid != null){
        int e = int.parse(edad);
        prefs.uid = userCredential.user!.uid;
        bool response = await DatabaseServices().addUsuario(nombre, apellido, e, correo);
        if (!response) {
          return 2;
        }
        return 3;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak_password') {
        return 1;
      } else if (e.code == 'email.-already-in-use') {
        return 2;
      }
    }
  }

  singInEmailAndPassword(
    String correo,
    String password,
  ) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: correo,
        password: password,
      );

      if (userCredential.user?.uid != null) {
        prefs.uid = userCredential.user!.uid;
        return 3;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
        return 1;
    }
  }
}