import 'package:appnotas/config/preferencias/preferencias.dart';
import 'package:appnotas/config/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var prefs = PreferenciasUsuario();
  Future<int> createAcount(
    String correo,
    String password,
    String nombre,
    String apellido,
    String edad,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: correo.trim(),
        password: password,
      );
      if (userCredential.user?.uid != null) {
        final uid = userCredential.user!.uid;
        prefs.uid = uid;
        int e = 0;
        try {
          e = int.parse(edad);
        } catch (_) {
          e = 0;
        }
        bool response = await DatabaseServices().addUsuario(
          uid,
          nombre,
          apellido,
          e,
          correo,
        );
        if (!response) {
          return 2;
        }
        try {
          final user = userCredential.user;
          if (user != null && !user.emailVerified) {
            await user.sendEmailVerification();
          }
        } catch (e) {
          print('No se pudo enviar email verification: $e');
        }
        return 3;
      } else {
        return 0;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 1;
      } else if (e.code == 'email-already-in-use') {
        return 2;
      } else {
        print(
          'FirebaseAuthException en createAcount: ${e.code} - ${e.message}',
        );
        return 0;
      }
    } catch (e, st) {
      print('Error inesperado en createAcount: $e\n$st');
      return 0;
    }
  }
  Future<int> singInEmailAndPassword(String correo, String password) async {
    try {
      correo = correo.trim();
      print(
        'DEBUG: singInEmailAndPassword llamado con correo="$correo" password length=${password.length}',
      );
      if (correo.isEmpty || password.isEmpty) {
        print('DEBUG: correo o password vacíos, abortando login');
        return 1;
      }
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: correo,
        password: password,
      );
      print(
        'DEBUG: signInWithEmailAndPassword completado: ${userCredential.user}',
      );
      if (userCredential.user?.uid != null) {
        prefs.uid = userCredential.user!.uid;
        try {
          await auth.currentUser?.reload();
          print('DEBUG: currentUser recargado: ${auth.currentUser}');
        } catch (e) {
          print('DEBUG: No se pudo recargar currentUser: $e');
        }
        return 3;
      } else {
        print('DEBUG: userCredential.user es null despues del signIn');
        return 0;
      }
    } on FirebaseAuthException catch (e) {
      print(
        'Auth signIn FirebaseAuthException: code=${e.code}, message=${e.message}',
      );
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return 1;
      }
      return 0;
    } catch (e, st) {
      print('Auth signIn error (catch todo): $e\n$st');
      return 0;
    }
  }
}